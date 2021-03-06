!--------------------------------------------------------------------------------------------------!
!   CP2K: A general program to perform molecular dynamics simulations                              !
!   Copyright (C) 2000 - 2018  CP2K developers group                                               !
!--------------------------------------------------------------------------------------------------!

! **************************************************************************************************
!> \brief Helper routines to manipulate with matrices.
! **************************************************************************************************

MODULE negf_matrix_utils
   USE cp_fm_basic_linalg,              ONLY: cp_fm_scale_and_add
   USE cp_fm_types,                     ONLY: cp_fm_get_info,&
                                              cp_fm_get_submatrix,&
                                              cp_fm_set_submatrix,&
                                              cp_fm_type
   USE cp_para_types,                   ONLY: cp_para_env_type
   USE dbcsr_api,                       ONLY: dbcsr_add,&
                                              dbcsr_copy,&
                                              dbcsr_deallocate_matrix,&
                                              dbcsr_get_block_p,&
                                              dbcsr_init_p,&
                                              dbcsr_p_type,&
                                              dbcsr_set,&
                                              dbcsr_type
   USE kinds,                           ONLY: dp
   USE message_passing,                 ONLY: mp_sum
   USE particle_methods,                ONLY: get_particle_set
   USE particle_types,                  ONLY: particle_type
   USE qs_kind_types,                   ONLY: qs_kind_type
   USE qs_subsys_types,                 ONLY: qs_subsys_get,&
                                              qs_subsys_type
#include "./base/base_uses.f90"

   IMPLICIT NONE
   PRIVATE

   CHARACTER(len=*), PARAMETER, PRIVATE :: moduleN = 'negf_matrix_utils'
   LOGICAL, PARAMETER, PRIVATE          :: debug_this_module = .TRUE.

   PUBLIC :: number_of_atomic_orbitals, negf_copy_fm_submat_to_dbcsr, negf_copy_sym_dbcsr_to_fm_submat
   PUBLIC :: negf_copy_contact_matrix
   PUBLIC :: invert_cell_to_index, get_index_by_cell

CONTAINS

! **************************************************************************************************
!> \brief Compute the number of atomic orbitals of the given set of atoms.
!> \param subsys    QuickStep subsystem
!> \param atomlist  list of selected atom; when absent all the atoms are taken into account
!> \retval nao      number of atomic orbitals
!> \par History
!>   * 02.2017 created [Sergey Chulkov]
! **************************************************************************************************
   FUNCTION number_of_atomic_orbitals(subsys, atomlist) RESULT(nao)
      TYPE(qs_subsys_type), POINTER                      :: subsys
      INTEGER, DIMENSION(:), INTENT(in), OPTIONAL        :: atomlist
      INTEGER                                            :: nao

      INTEGER                                            :: iatom, natoms
      INTEGER, ALLOCATABLE, DIMENSION(:)                 :: nsgfs
      TYPE(particle_type), DIMENSION(:), POINTER         :: particle_set
      TYPE(qs_kind_type), DIMENSION(:), POINTER          :: qs_kind_set

      CALL qs_subsys_get(subsys, particle_set=particle_set, qs_kind_set=qs_kind_set)
      ALLOCATE (nsgfs(SIZE(particle_set)))
      CALL get_particle_set(particle_set, qs_kind_set, nsgf=nsgfs)

      IF (PRESENT(atomlist)) THEN
         natoms = SIZE(atomlist)
         nao = 0

         DO iatom = 1, natoms
            nao = nao+nsgfs(atomlist(iatom))
         END DO
      ELSE
         nao = SUM(nsgfs)
      END IF

      DEALLOCATE (nsgfs)
   END FUNCTION number_of_atomic_orbitals

! **************************************************************************************************
!> \brief Populate relevant blocks of the DBCSR matrix using data from a ScaLAPACK matrix.
!>        Irrelevant blocks of the DBCSR matrix are kept untouched.
!> \param fm              dense matrix to copy
!> \param matrix          DBCSR matrix (modified on exit)
!> \param atomlist_row    set of atomic indices along the 1st (row) dimension
!> \param atomlist_col    set of atomic indices along the 2nd (column) dimension
!> \param subsys          subsystem environment
!> \par History
!>   * 02.2017 created [Sergey Chulkov]
! **************************************************************************************************
   SUBROUTINE negf_copy_fm_submat_to_dbcsr(fm, matrix, atomlist_row, atomlist_col, subsys)
      TYPE(cp_fm_type), POINTER                          :: fm
      TYPE(dbcsr_type), POINTER                          :: matrix
      INTEGER, DIMENSION(:), INTENT(in)                  :: atomlist_row, atomlist_col
      TYPE(qs_subsys_type), POINTER                      :: subsys

      CHARACTER(LEN=*), PARAMETER :: routineN = 'negf_copy_fm_submat_to_dbcsr', &
         routineP = moduleN//':'//routineN

      INTEGER :: first_sgf_col, first_sgf_row, handle, iatom_col, iatom_row, icol, irow, &
         natoms_col, natoms_row, ncols, nparticles, nrows
      INTEGER, ALLOCATABLE, DIMENSION(:)                 :: nsgfs
      LOGICAL                                            :: found
      REAL(kind=dp), ALLOCATABLE, DIMENSION(:, :)        :: fm_block
      REAL(kind=dp), DIMENSION(:, :), POINTER            :: sm_block
      TYPE(particle_type), DIMENSION(:), POINTER         :: particle_set
      TYPE(qs_kind_type), DIMENSION(:), POINTER          :: qs_kind_set

      CALL timeset(routineN, handle)

      CPASSERT(ASSOCIATED(fm))
      CPASSERT(ASSOCIATED(matrix))
      CPASSERT(ASSOCIATED(subsys))

      CALL cp_fm_get_info(fm, nrow_global=nrows, ncol_global=ncols)

      CALL qs_subsys_get(subsys, particle_set=particle_set, qs_kind_set=qs_kind_set)

      natoms_row = SIZE(atomlist_row)
      natoms_col = SIZE(atomlist_col)
      nparticles = SIZE(particle_set)

      ALLOCATE (nsgfs(nparticles))
      CALL get_particle_set(particle_set, qs_kind_set, nsgf=nsgfs)

      ALLOCATE (fm_block(nrows, ncols))
      CALL cp_fm_get_submatrix(fm, fm_block)

      first_sgf_col = 1
      DO iatom_col = 1, natoms_col
         first_sgf_row = 1
         DO iatom_row = 1, natoms_row
            CALL dbcsr_get_block_p(matrix=matrix, row=atomlist_row(iatom_row), col=atomlist_col(iatom_col), &
                                   block=sm_block, found=found)
            IF (found) THEN
               ! the following LAPACK call violates the coding convention
               !CALL dlacpy('F', nsgfs(atomlist_row(iatom_row)), nsgfs(atomlist_col(iatom_col)), &
               !            fm_block(first_sgf_row, first_sgf_col), SIZE(fm_block, 1), sm_block(1, 1), SIZE(sm_block, 1))
               nrows = nsgfs(atomlist_row(iatom_row))
               ncols = nsgfs(atomlist_col(iatom_col))
               DO icol = 1, ncols
                  DO irow = 1, nrows
                     sm_block(irow, icol) = fm_block(first_sgf_row+irow-1, first_sgf_col+icol-1)
                  END DO
               END DO
            END IF

            first_sgf_row = first_sgf_row+nsgfs(atomlist_row(iatom_row))
         END DO
         first_sgf_col = first_sgf_col+nsgfs(atomlist_col(iatom_col))
      END DO

      DEALLOCATE (fm_block)
      DEALLOCATE (nsgfs)

      CALL timestop(handle)
   END SUBROUTINE negf_copy_fm_submat_to_dbcsr

! **************************************************************************************************
!> \brief Extract part of the DBCSR matrix based on selected atoms and copy it into a dense matrix.
!> \param matrix          DBCSR matrix
!> \param fm              dense matrix (created and initialised on exit)
!> \param atomlist_row    set of atomic indices along the 1st (row) dimension
!> \param atomlist_col    set of atomic indices along the 2nd (column) dimension
!> \param subsys          subsystem environment
!> \param mpi_comm_global MPI communicator which was used to distribute blocks of the DBCSR matrix.
!>                        If missed, assume that both DBCSR and ScaLapack matrices are distributed
!>                        across the same set of processors
!> \param do_upper_diag   initialise upper-triangular part of the dense matrix as well as diagonal elements
!> \param do_lower        initialise lower-triangular part of the dense matrix
!> \par History
!>   * 02.2017 created [Sergey Chulkov]
!> \note A naive implementation that copies relevant local DBCSR blocks into a 2-D matrix,
!>       performs collective summation, and then distributes the result. This approach seems to be
!>       optimal when processors are arranged into several independent MPI subgroups due to the fact
!>       that every subgroup automatically holds the copy of the dense matrix at the end, so
!>       we can avoid the final replication stage.
! **************************************************************************************************
   SUBROUTINE negf_copy_sym_dbcsr_to_fm_submat(matrix, fm, atomlist_row, atomlist_col, subsys, &
                                               mpi_comm_global, do_upper_diag, do_lower)
      TYPE(dbcsr_type), POINTER                          :: matrix
      TYPE(cp_fm_type), POINTER                          :: fm
      INTEGER, DIMENSION(:), INTENT(in)                  :: atomlist_row, atomlist_col
      TYPE(qs_subsys_type), POINTER                      :: subsys
      INTEGER, INTENT(in)                                :: mpi_comm_global
      LOGICAL, INTENT(in)                                :: do_upper_diag, do_lower

      CHARACTER(LEN=*), PARAMETER :: routineN = 'negf_copy_sym_dbcsr_to_fm_submat', &
         routineP = moduleN//':'//routineN

      INTEGER :: handle, iatom_col, iatom_row, icol, irow, natoms_col, natoms_row, ncols_fm, &
         nparticles, nrows_fm, offset_sgf_col, offset_sgf_row
      INTEGER, ALLOCATABLE, DIMENSION(:)                 :: nsgfs
      LOGICAL                                            :: found
      REAL(kind=dp), ALLOCATABLE, DIMENSION(:, :)        :: r2d
      REAL(kind=dp), DIMENSION(:, :), POINTER            :: sm_block
      TYPE(cp_para_env_type), POINTER                    :: para_env
      TYPE(particle_type), DIMENSION(:), POINTER         :: particle_set
      TYPE(qs_kind_type), DIMENSION(:), POINTER          :: qs_kind_set

      CALL timeset(routineN, handle)

      CPASSERT(ASSOCIATED(matrix))
      CPASSERT(ASSOCIATED(fm))
      CPASSERT(ASSOCIATED(subsys))

      CALL qs_subsys_get(subsys, particle_set=particle_set, qs_kind_set=qs_kind_set)

      natoms_row = SIZE(atomlist_row)
      natoms_col = SIZE(atomlist_col)
      nparticles = SIZE(particle_set)

      ALLOCATE (nsgfs(nparticles))
      CALL get_particle_set(particle_set, qs_kind_set, nsgf=nsgfs)

      CALL cp_fm_get_info(fm, nrow_global=nrows_fm, ncol_global=ncols_fm, para_env=para_env)

      IF (debug_this_module) THEN
         CPASSERT(SUM(nsgfs(atomlist_row(:))) == nrows_fm)
         CPASSERT(SUM(nsgfs(atomlist_col(:))) == ncols_fm)
      END IF

      ALLOCATE (r2d(nrows_fm, ncols_fm))
      r2d(:, :) = 0.0_dp

      offset_sgf_col = 0
      DO iatom_col = 1, natoms_col
         offset_sgf_row = 0

         DO iatom_row = 1, natoms_row
            IF (atomlist_row(iatom_row) <= atomlist_col(iatom_col)) THEN
               IF (do_upper_diag) THEN
                  CALL dbcsr_get_block_p(matrix=matrix, row=atomlist_row(iatom_row), col=atomlist_col(iatom_col), &
                                         block=sm_block, found=found)
               END IF
            ELSE
               IF (do_lower) THEN
                  CALL dbcsr_get_block_p(matrix=matrix, row=atomlist_col(iatom_col), col=atomlist_row(iatom_row), &
                                         block=sm_block, found=found)
               END IF
            END IF

            IF (found) THEN
               IF (atomlist_row(iatom_row) <= atomlist_col(iatom_col)) THEN
                  IF (do_upper_diag) THEN
                     DO icol = nsgfs(atomlist_col(iatom_col)), 1, -1
                        DO irow = nsgfs(atomlist_row(iatom_row)), 1, -1
                           r2d(offset_sgf_row+irow, offset_sgf_col+icol) = sm_block(irow, icol)
                        END DO
                     END DO
                  END IF
               ELSE
                  IF (do_lower) THEN
                     DO icol = nsgfs(atomlist_col(iatom_col)), 1, -1
                        DO irow = nsgfs(atomlist_row(iatom_row)), 1, -1
                           r2d(offset_sgf_row+irow, offset_sgf_col+icol) = sm_block(icol, irow)
                        END DO
                     END DO
                  END IF
               END IF
            END IF

            offset_sgf_row = offset_sgf_row+nsgfs(atomlist_row(iatom_row))
         END DO
         offset_sgf_col = offset_sgf_col+nsgfs(atomlist_col(iatom_col))
      END DO

      CALL mp_sum(r2d, mpi_comm_global)

      CALL cp_fm_set_submatrix(fm, r2d)

      DEALLOCATE (r2d)
      DEALLOCATE (nsgfs)

      CALL timestop(handle)
   END SUBROUTINE negf_copy_sym_dbcsr_to_fm_submat

! **************************************************************************************************
!> \brief Driver routine to extract diagonal and off-diagonal blocks from a symmetric DBCSR matrix.
!> \param fm_cell0        extracted diagonal matrix block
!> \param fm_cell1        extracted off-diagonal matrix block
!> \param direction_axis  axis towards the secondary unit cell
!> \param matrix_kp       set of DBCSR matrices
!> \param index_to_cell   inverted mapping between unit cells and DBCSR matrix images
!> \param atom_list       list of atoms to extract
!> \param subsys          QuickStep subsystem
!> \param mpi_comm_global global MPI communicator
!> \par History
!>   * 10.2017 created [Sergey Chulkov]
! **************************************************************************************************
   SUBROUTINE negf_copy_contact_matrix(fm_cell0, fm_cell1, direction_axis, matrix_kp, index_to_cell, &
                                       atom_list, subsys, mpi_comm_global)
      TYPE(cp_fm_type), POINTER                          :: fm_cell0, fm_cell1
      INTEGER, INTENT(in)                                :: direction_axis
      TYPE(dbcsr_p_type), DIMENSION(:), INTENT(in)       :: matrix_kp
      INTEGER, DIMENSION(:, :), INTENT(in)               :: index_to_cell
      INTEGER, DIMENSION(:), INTENT(in)                  :: atom_list
      TYPE(qs_subsys_type), POINTER                      :: subsys
      INTEGER, INTENT(in)                                :: mpi_comm_global

      CHARACTER(LEN=*), PARAMETER :: routineN = 'negf_copy_contact_matrix', &
         routineP = moduleN//':'//routineN

      INTEGER                                            :: handle, image, nimages, rep
      TYPE(dbcsr_type), POINTER                          :: matrix_cell_0, matrix_cell_1, &
                                                            matrix_cell_minus1

      CALL timeset(routineN, handle)

      CPASSERT(ASSOCIATED(fm_cell0))
      CPASSERT(ASSOCIATED(fm_cell1))
      CPASSERT(ASSOCIATED(subsys))

      nimages = SIZE(index_to_cell, 2)

      NULLIFY (matrix_cell_0, matrix_cell_1, matrix_cell_minus1)

      CALL dbcsr_init_p(matrix_cell_0)
      CALL dbcsr_copy(matrix_cell_0, matrix_kp(1)%matrix)
      CALL dbcsr_set(matrix_cell_0, 0.0_dp)

      CALL dbcsr_init_p(matrix_cell_1)
      CALL dbcsr_copy(matrix_cell_1, matrix_kp(1)%matrix)
      CALL dbcsr_set(matrix_cell_1, 0.0_dp)

      CALL dbcsr_init_p(matrix_cell_minus1)
      CALL dbcsr_copy(matrix_cell_minus1, matrix_kp(1)%matrix)
      CALL dbcsr_set(matrix_cell_minus1, 0.0_dp)

      DO image = 1, nimages
         rep = index_to_cell(direction_axis, image)

         IF (rep == 0) THEN
            CALL dbcsr_add(matrix_cell_0, matrix_kp(image)%matrix, 1.0_dp, 1.0_dp)
         ELSE IF (rep == 1) THEN
            CALL dbcsr_add(matrix_cell_1, matrix_kp(image)%matrix, 1.0_dp, 1.0_dp)
         ELSE IF (rep == -1) THEN
            CALL dbcsr_add(matrix_cell_minus1, matrix_kp(image)%matrix, 1.0_dp, 1.0_dp)
         END IF
      END DO

      ! upper-diagonal part of fm_cell1
      CALL negf_copy_sym_dbcsr_to_fm_submat(matrix_cell_1, fm_cell1, atom_list, atom_list, &
                                            subsys, mpi_comm_global, do_upper_diag=.TRUE., do_lower=.FALSE.)
      ! lower-diagonal part of fm_cell1
      CALL negf_copy_sym_dbcsr_to_fm_submat(matrix_cell_minus1, fm_cell0, atom_list, atom_list, &
                                            subsys, mpi_comm_global, do_upper_diag=.FALSE., do_lower=.TRUE.)
      CALL cp_fm_scale_and_add(1.0_dp, fm_cell1, 1.0_dp, fm_cell0)

      ! symmetric matrix fm_cell0
      CALL negf_copy_sym_dbcsr_to_fm_submat(matrix_cell_0, fm_cell0, atom_list, atom_list, &
                                            subsys, mpi_comm_global, do_upper_diag=.TRUE., do_lower=.TRUE.)

      CALL dbcsr_deallocate_matrix(matrix_cell_0)
      CALL dbcsr_deallocate_matrix(matrix_cell_1)
      CALL dbcsr_deallocate_matrix(matrix_cell_minus1)
      CALL timestop(handle)
   END SUBROUTINE negf_copy_contact_matrix

! **************************************************************************************************
!> \brief Invert cell_to_index mapping between unit cells and DBCSR matrix images.
!> \param cell_to_index  mapping: unit_cell -> image_index
!> \param nimages        number of images
!> \param index_to_cell  inverted mapping: image_index -> unit_cell
!> \par History
!>   * 10.2017 created [Sergey Chulkov]
! **************************************************************************************************
   SUBROUTINE invert_cell_to_index(cell_to_index, nimages, index_to_cell)
      INTEGER, DIMENSION(:, :, :), POINTER               :: cell_to_index
      INTEGER, INTENT(in)                                :: nimages
      INTEGER, DIMENSION(3, nimages), INTENT(out)        :: index_to_cell

      CHARACTER(LEN=*), PARAMETER :: routineN = 'invert_cell_to_index', &
         routineP = moduleN//':'//routineN

      INTEGER                                            :: handle, i1, i2, i3, image
      INTEGER, DIMENSION(3)                              :: lbounds, ubounds

      CALL timeset(routineN, handle)

      index_to_cell(:, :) = 0
      lbounds = LBOUND(cell_to_index)
      ubounds = UBOUND(cell_to_index)

      DO i3 = lbounds(3), ubounds(3) ! z
         DO i2 = lbounds(2), ubounds(2) ! y
            DO i1 = lbounds(1), ubounds(1) ! x
               image = cell_to_index(i1, i2, i3)
               IF (image > 0 .AND. image <= nimages) THEN
                  index_to_cell(1, image) = i1
                  index_to_cell(2, image) = i2
                  index_to_cell(3, image) = i3
               END IF
            END DO
         END DO
      END DO

      CALL timestop(handle)
   END SUBROUTINE invert_cell_to_index

! **************************************************************************************************
!> \brief Helper routine to obtain index of a DBCSR matrix image by its unit cell replica.
!>        Can be used with any usin cell.
!> \param cell           indices of the unit cell
!> \param cell_to_index  mapping: unit_cell -> image_index
!> \retval image         DBCSR matrix images
!>                       (0 means there are no non-zero matrix elements in the image)
!> \par History
!>   * 10.2017 created [Sergey Chulkov]
! **************************************************************************************************
   PURE FUNCTION get_index_by_cell(cell, cell_to_index) RESULT(image)
      INTEGER, DIMENSION(3), INTENT(in)                  :: cell
      INTEGER, DIMENSION(:, :, :), POINTER               :: cell_to_index
      INTEGER                                            :: image

      CHARACTER(LEN=*), PARAMETER :: routineN = 'get_index_by_cell', &
         routineP = moduleN//':'//routineN

      IF (LBOUND(cell_to_index, 1) <= cell(1) .AND. UBOUND(cell_to_index, 1) >= cell(1) .AND. &
          LBOUND(cell_to_index, 2) <= cell(2) .AND. UBOUND(cell_to_index, 2) >= cell(2) .AND. &
          LBOUND(cell_to_index, 3) <= cell(3) .AND. UBOUND(cell_to_index, 3) >= cell(3)) THEN

         image = cell_to_index(cell(1), cell(2), cell(3))
      ELSE
         image = 0
      END IF
   END FUNCTION get_index_by_cell
END MODULE negf_matrix_utils
