  SUBROUTINE integrate_core_default(grid,coef_xyz,pol_x,pol_y,pol_z,map,sphere_bounds,lp,cmax,gridbounds)
    USE kinds,                        ONLY: dp
    INTEGER, INTENT(IN)                      :: sphere_bounds(*), lp
    REAL(dp), INTENT(OUT) :: coef_xyz(((lp+1)*(lp+2)*(lp+3))/6)
    INTEGER, INTENT(IN)                      :: cmax
    REAL(dp), INTENT(IN)                     :: pol_x(0:lp,-cmax:cmax), &
                                                pol_y(1:2,0:lp,-cmax:0), &
                                                pol_z(1:2,0:lp,-cmax:0)
    INTEGER, INTENT(IN)                      :: map(-cmax:cmax,1:3), &
                                                gridbounds(2,3)
    REAL(dp), INTENT(IN) :: grid(gridbounds(1,1):gridbounds(2,1), gridbounds(1&
      ,2):gridbounds(2,2), gridbounds(1,3):gridbounds(2,3))

    INTEGER                                  :: i, ig, igmax, igmin, j, j2, &
                                                jg, jg2, jgmin, k, k2, kg, &
                                                kg2, kgmin, lxp, lxy, lxyz, &
                                                lyp, lzp, sci
    REAL(dp)                                 :: coef_x(4,0:lp), &
                                                coef_xy(2,((lp+1)*(lp+2))/2), &
                                                s01, s02, s03, s04

    sci=1

    coef_xyz=0.0_dp

    kgmin=sphere_bounds(sci)
    sci=sci+1
    DO kg=kgmin,0
       kg2=1-kg
       k=map(kg,3)
       k2=map(kg2,3)

       coef_xy=0.0_dp

       jgmin=sphere_bounds(sci)
       sci=sci+1
       DO jg=jgmin,0
          jg2=1-jg
          j=map(jg,2)
          j2=map(jg2,2)
          igmin=sphere_bounds(sci)
          sci=sci+1
          igmax=1-igmin

          coef_x=0.0_dp

          DO ig=igmin,igmax
             i=map(ig,1)
             s01=grid(i,j,k)
             s02=grid(i,j,k2)
             s03=grid(i,j2,k)
             s04=grid(i,j2,k2)
             DO lxp=0,lp
                coef_x(1,lxp)=coef_x(1,lxp)+s01*pol_x(lxp,ig)
                coef_x(2,lxp)=coef_x(2,lxp)+s02*pol_x(lxp,ig)
                coef_x(3,lxp)=coef_x(3,lxp)+s03*pol_x(lxp,ig)
                coef_x(4,lxp)=coef_x(4,lxp)+s04*pol_x(lxp,ig)
             ENDDO
          END DO

          lxy=0
          DO lyp=0,lp
          DO lxp=0,lp-lyp
             lxy=lxy+1
             coef_xy(1,lxy)=coef_xy(1,lxy)+coef_x(1,lxp)*pol_y(1,lyp,jg)
             coef_xy(2,lxy)=coef_xy(2,lxy)+coef_x(2,lxp)*pol_y(1,lyp,jg)
             coef_xy(1,lxy)=coef_xy(1,lxy)+coef_x(3,lxp)*pol_y(2,lyp,jg)
             coef_xy(2,lxy)=coef_xy(2,lxy)+coef_x(4,lxp)*pol_y(2,lyp,jg)
          ENDDO
          ENDDO

       END DO

       lxyz = 0
       DO lzp=0,lp
          lxy=0
          DO lyp=0,lp-lzp
             DO lxp=0,lp-lzp-lyp
                lxyz=lxyz+1 ; lxy=lxy+1
                coef_xyz(lxyz)=coef_xyz(lxyz)+coef_xy(1,lxy)*pol_z(1,lzp,kg)
                coef_xyz(lxyz)=coef_xyz(lxyz)+coef_xy(2,lxy)*pol_z(2,lzp,kg)
             ENDDO
             lxy=lxy+lzp
          ENDDO
       ENDDO

    END DO

  END SUBROUTINE integrate_core_default
  SUBROUTINE integrate_core_0(grid,coef_xyz,pol_x,pol_y,pol_z,map,sphere_bounds,cmax,gridbounds)
    USE kinds,                        ONLY: dp
    INTEGER, INTENT(IN)                      :: sphere_bounds(*), cmax, &
                                                map(-cmax:cmax,1:3), &
                                                gridbounds(2,3)
    REAL(dp), INTENT(IN) :: grid(gridbounds(1,1):gridbounds(2,1), gridbounds(1&
      ,2):gridbounds(2,2), gridbounds(1,3):gridbounds(2,3))
    INTEGER, PARAMETER                       :: lp = 0
    REAL(dp), INTENT(IN)                     :: pol_x(0:lp,-cmax:cmax), &
                                                pol_y(1:2,0:lp,-cmax:0), &
                                                pol_z(1:2,0:lp,-cmax:0)
    REAL(dp), INTENT(OUT) :: coef_xyz(((lp+1)*(lp+2)*(lp+3))/6)

    INTEGER                                  :: i, ig, igmax, igmin, j, j2, &
                                                jg, jg2, jgmin, k, k2, kg, &
                                                kg2, kgmin, lxp, sci
    REAL(dp)                                 :: coef_x(4,0:lp), &
                                                coef_xy(2,((lp+1)*(lp+2))/2), &
                                                s01, s02, s03, s04

    sci=1

    coef_xyz=0.0_dp

    kgmin=sphere_bounds(sci)
    sci=sci+1
    DO kg=kgmin,0
       kg2=1-kg
       k=map(kg,3)
       k2=map(kg2,3)

       coef_xy=0.0_dp

       jgmin=sphere_bounds(sci)
       sci=sci+1
       DO jg=jgmin,0
          jg2=1-jg
          j=map(jg,2)
          j2=map(jg2,2)
          igmin=sphere_bounds(sci)
          sci=sci+1
          igmax=1-igmin

          coef_x=0.0_dp
          DO ig=igmin,igmax
             i=map(ig,1)
             s01=grid(i,j,k)
             s02=grid(i,j,k2)
             s03=grid(i,j2,k)
             s04=grid(i,j2,k2)
             DO lxp=0,lp
                coef_x(1,lxp)=coef_x(1,lxp)+s01*pol_x(lxp,ig)
                coef_x(2,lxp)=coef_x(2,lxp)+s02*pol_x(lxp,ig)
                coef_x(3,lxp)=coef_x(3,lxp)+s03*pol_x(lxp,ig)
                coef_x(4,lxp)=coef_x(4,lxp)+s04*pol_x(lxp,ig)
             ENDDO
          END DO
             coef_xy(:,1)=coef_xy(:,1)+coef_x(1:2,0)*pol_y(1,0,jg)
             coef_xy(:,1)=coef_xy(:,1)+coef_x(3:4,0)*pol_y(2,0,jg)
       END DO
                coef_xyz(1)=coef_xyz(1)+coef_xy(1,1)*pol_z(1,0,kg)
                coef_xyz(1)=coef_xyz(1)+coef_xy(2,1)*pol_z(2,0,kg)
    END DO

  END SUBROUTINE integrate_core_0
  SUBROUTINE integrate_core_1(grid,coef_xyz,pol_x,pol_y,pol_z,map,sphere_bounds,cmax,gridbounds)
    USE kinds,                        ONLY: dp
    INTEGER, INTENT(IN)                      :: sphere_bounds(*), cmax, &
                                                map(-cmax:cmax,1:3), &
                                                gridbounds(2,3)
    REAL(dp), INTENT(IN) :: grid(gridbounds(1,1):gridbounds(2,1), gridbounds(1&
      ,2):gridbounds(2,2), gridbounds(1,3):gridbounds(2,3))
    INTEGER, PARAMETER                       :: lp = 1
    REAL(dp), INTENT(IN)                     :: pol_x(0:lp,-cmax:cmax), &
                                                pol_y(1:2,0:lp,-cmax:0), &
                                                pol_z(1:2,0:lp,-cmax:0)
    REAL(dp), INTENT(OUT) :: coef_xyz(((lp+1)*(lp+2)*(lp+3))/6)

    INTEGER                                  :: i, ig, igmax, igmin, j, j2, &
                                                jg, jg2, jgmin, k, k2, kg, &
                                                kg2, kgmin, lxp, lxy, lxyz, &
                                                lyp, lzp, sci
    REAL(dp)                                 :: coef_x(4,0:lp), &
                                                coef_xy(2,((lp+1)*(lp+2))/2), &
                                                s01, s02, s03, s04

    sci=1

    coef_xyz=0.0_dp

    kgmin=sphere_bounds(sci)
    sci=sci+1
    DO kg=kgmin,0
       kg2=1-kg
       k=map(kg,3)
       k2=map(kg2,3)

       coef_xy=0.0_dp

       jgmin=sphere_bounds(sci)
       sci=sci+1
       DO jg=jgmin,0
          jg2=1-jg
          j=map(jg,2)
          j2=map(jg2,2)
          igmin=sphere_bounds(sci)
          sci=sci+1
          igmax=1-igmin

          coef_x=0.0_dp
          DO ig=igmin,igmax
             i=map(ig,1)
             s01=grid(i,j,k)
             s02=grid(i,j,k2)
             s03=grid(i,j2,k)
             s04=grid(i,j2,k2)
                coef_x(1,0)=coef_x(1,0)+s01*pol_x(0,ig)
                coef_x(2,0)=coef_x(2,0)+s02*pol_x(0,ig)
                coef_x(3,0)=coef_x(3,0)+s03*pol_x(0,ig)
                coef_x(4,0)=coef_x(4,0)+s04*pol_x(0,ig)
                coef_x(1,1)=coef_x(1,1)+s01*pol_x(1,ig)
                coef_x(2,1)=coef_x(2,1)+s02*pol_x(1,ig)
                coef_x(3,1)=coef_x(3,1)+s03*pol_x(1,ig)
                coef_x(4,1)=coef_x(4,1)+s04*pol_x(1,ig)
          END DO
          lxy=0
          DO lyp=0,lp
          DO lxp=0,lp-lyp
             lxy=lxy+1
             coef_xy(:,lxy)=coef_xy(:,lxy)+coef_x(1:2,lxp)*pol_y(1,lyp,jg)
             coef_xy(:,lxy)=coef_xy(:,lxy)+coef_x(3:4,lxp)*pol_y(2,lyp,jg)
          ENDDO
          ENDDO
       END DO
       lxyz = 0
       DO lzp=0,lp
          lxy=0
          DO lyp=0,lp-lzp
             DO lxp=0,lp-lzp-lyp
                lxyz=lxyz+1 ; lxy=lxy+1
                coef_xyz(lxyz)=coef_xyz(lxyz)+SUM(coef_xy(:,lxy)*pol_z(:,lzp,kg))
             ENDDO
             lxy=lxy+lzp
          ENDDO
       ENDDO
    END DO

  END SUBROUTINE integrate_core_1
  SUBROUTINE integrate_core_2(grid,coef_xyz,pol_x,pol_y,pol_z,map,sphere_bounds,cmax,gridbounds)
    USE kinds,                        ONLY: dp
    INTEGER, INTENT(IN)                      :: sphere_bounds(*), cmax, &
                                                map(-cmax:cmax,1:3), &
                                                gridbounds(2,3)
    REAL(dp), INTENT(IN) :: grid(gridbounds(1,1):gridbounds(2,1), gridbounds(1&
      ,2):gridbounds(2,2), gridbounds(1,3):gridbounds(2,3))
    INTEGER, PARAMETER                       :: lp = 2
    REAL(dp), INTENT(IN)                     :: pol_x(0:lp,-cmax:cmax), &
                                                pol_y(1:2,0:lp,-cmax:0), &
                                                pol_z(1:2,0:lp,-cmax:0)
    REAL(dp), INTENT(OUT) :: coef_xyz(((lp+1)*(lp+2)*(lp+3))/6)

    INTEGER                                  :: i, ig, igmax, igmin, j, j2, &
                                                jg, jg2, jgmin, k, k2, kg, &
                                                kg2, kgmin, lxp, lxy, lyp, sci
    REAL(dp)                                 :: coef_x(4,0:lp), &
                                                coef_xy(2,((lp+1)*(lp+2))/2), &
                                                s01, s02, s03, s04

    sci=1

    coef_xyz=0.0_dp

    kgmin=sphere_bounds(sci)
    sci=sci+1
    DO kg=kgmin,0
       kg2=1-kg
       k=map(kg,3)
       k2=map(kg2,3)

       coef_xy=0.0_dp

       jgmin=sphere_bounds(sci)
       sci=sci+1
       DO jg=jgmin,0
          jg2=1-jg
          j=map(jg,2)
          j2=map(jg2,2)
          igmin=sphere_bounds(sci)
          sci=sci+1
          igmax=1-igmin

          coef_x=0.0_dp
          DO ig=igmin,igmax
             i=map(ig,1)
             s01=grid(i,j,k)
             s02=grid(i,j,k2)
             s03=grid(i,j2,k)
             s04=grid(i,j2,k2)
             DO lxp=0,lp
                coef_x(1,lxp)=coef_x(1,lxp)+s01*pol_x(lxp,ig)
                coef_x(2,lxp)=coef_x(2,lxp)+s02*pol_x(lxp,ig)
                coef_x(3,lxp)=coef_x(3,lxp)+s03*pol_x(lxp,ig)
                coef_x(4,lxp)=coef_x(4,lxp)+s04*pol_x(lxp,ig)
             ENDDO
          END DO
          lxy=0
          DO lyp=0,lp
          DO lxp=0,lp-lyp
             lxy=lxy+1
             coef_xy(:,lxy)=coef_xy(:,lxy)+coef_x(1:2,lxp)*pol_y(1,lyp,jg)
             coef_xy(:,lxy)=coef_xy(:,lxy)+coef_x(3:4,lxp)*pol_y(2,lyp,jg)
          ENDDO
          ENDDO
       END DO
                coef_xyz(1)=coef_xyz(1)+SUM(coef_xy(:,1)*pol_z(:,0,kg))
                coef_xyz(2)=coef_xyz(2)+SUM(coef_xy(:,2)*pol_z(:,0,kg))
                coef_xyz(3)=coef_xyz(3)+SUM(coef_xy(:,3)*pol_z(:,0,kg))
                coef_xyz(4)=coef_xyz(4)+SUM(coef_xy(:,4)*pol_z(:,0,kg))
                coef_xyz(5)=coef_xyz(5)+SUM(coef_xy(:,5)*pol_z(:,0,kg))
                coef_xyz(6)=coef_xyz(6)+SUM(coef_xy(:,6)*pol_z(:,0,kg))
                coef_xyz(7)=coef_xyz(7)+SUM(coef_xy(:,1)*pol_z(:,1,kg))
                coef_xyz(8)=coef_xyz(8)+SUM(coef_xy(:,2)*pol_z(:,1,kg))
                coef_xyz(9)=coef_xyz(9)+SUM(coef_xy(:,4)*pol_z(:,1,kg))
                coef_xyz(10)=coef_xyz(10)+SUM(coef_xy(:,1)*pol_z(:,2,kg))
    END DO

  END SUBROUTINE integrate_core_2
  SUBROUTINE integrate_core_3(grid,coef_xyz,pol_x,pol_y,pol_z,map,sphere_bounds,cmax,gridbounds)
    USE kinds,                        ONLY: dp
    INTEGER, INTENT(IN)                      :: sphere_bounds(*), cmax, &
                                                map(-cmax:cmax,1:3), &
                                                gridbounds(2,3)
    REAL(dp), INTENT(IN) :: grid(gridbounds(1,1):gridbounds(2,1), gridbounds(1&
      ,2):gridbounds(2,2), gridbounds(1,3):gridbounds(2,3))
    INTEGER, PARAMETER                       :: lp = 3
    REAL(dp), INTENT(IN)                     :: pol_x(0:lp,-cmax:cmax), &
                                                pol_y(1:2,0:lp,-cmax:0), &
                                                pol_z(1:2,0:lp,-cmax:0)
    REAL(dp), INTENT(OUT) :: coef_xyz(((lp+1)*(lp+2)*(lp+3))/6)

    INTEGER                                  :: i, ig, igmax, igmin, j, j2, &
                                                jg, jg2, jgmin, k, k2, kg, &
                                                kg2, kgmin, sci
    REAL(dp)                                 :: coef_x(4,0:lp), &
                                                coef_xy(2,((lp+1)*(lp+2))/2), &
                                                s(4)

    sci=1

    coef_xyz=0.0_dp

    kgmin=sphere_bounds(sci)
    sci=sci+1
    DO kg=kgmin,0
       kg2=1-kg
       k=map(kg,3)
       k2=map(kg2,3)

       coef_xy=0.0_dp

       jgmin=sphere_bounds(sci)
       sci=sci+1
       DO jg=jgmin,0
          jg2=1-jg
          j=map(jg,2)
          j2=map(jg2,2)
          igmin=sphere_bounds(sci)
          sci=sci+1
          igmax=1-igmin

          coef_x=0.0_dp
          DO ig=igmin,igmax
             i=map(ig,1)
             s(1)=grid(i,j,k)
             s(2)=grid(i,j,k2)
             s(3)=grid(i,j2,k)
             s(4)=grid(i,j2,k2)
                coef_x(:,0)=coef_x(:,0)+s(:)*pol_x(0,ig)
                coef_x(:,1)=coef_x(:,1)+s(:)*pol_x(1,ig)
                coef_x(:,2)=coef_x(:,2)+s(:)*pol_x(2,ig)
                coef_x(:,3)=coef_x(:,3)+s(:)*pol_x(3,ig)
          END DO
             coef_xy(:,1)=coef_xy(:,1)+coef_x(1:2,0)*pol_y(1,0,jg)
             coef_xy(:,1)=coef_xy(:,1)+coef_x(3:4,0)*pol_y(2,0,jg)
             coef_xy(:,2)=coef_xy(:,2)+coef_x(1:2,1)*pol_y(1,0,jg)
             coef_xy(:,2)=coef_xy(:,2)+coef_x(3:4,1)*pol_y(2,0,jg)
             coef_xy(:,3)=coef_xy(:,3)+coef_x(1:2,2)*pol_y(1,0,jg)
             coef_xy(:,3)=coef_xy(:,3)+coef_x(3:4,2)*pol_y(2,0,jg)
             coef_xy(:,4)=coef_xy(:,4)+coef_x(1:2,3)*pol_y(1,0,jg)
             coef_xy(:,4)=coef_xy(:,4)+coef_x(3:4,3)*pol_y(2,0,jg)
             coef_xy(:,5)=coef_xy(:,5)+coef_x(1:2,0)*pol_y(1,1,jg)
             coef_xy(:,5)=coef_xy(:,5)+coef_x(3:4,0)*pol_y(2,1,jg)
             coef_xy(:,6)=coef_xy(:,6)+coef_x(1:2,1)*pol_y(1,1,jg)
             coef_xy(:,6)=coef_xy(:,6)+coef_x(3:4,1)*pol_y(2,1,jg)
             coef_xy(:,7)=coef_xy(:,7)+coef_x(1:2,2)*pol_y(1,1,jg)
             coef_xy(:,7)=coef_xy(:,7)+coef_x(3:4,2)*pol_y(2,1,jg)
             coef_xy(:,8)=coef_xy(:,8)+coef_x(1:2,0)*pol_y(1,2,jg)
             coef_xy(:,8)=coef_xy(:,8)+coef_x(3:4,0)*pol_y(2,2,jg)
             coef_xy(:,9)=coef_xy(:,9)+coef_x(1:2,1)*pol_y(1,2,jg)
             coef_xy(:,9)=coef_xy(:,9)+coef_x(3:4,1)*pol_y(2,2,jg)
             coef_xy(:,10)=coef_xy(:,10)+coef_x(1:2,0)*pol_y(1,3,jg)
             coef_xy(:,10)=coef_xy(:,10)+coef_x(3:4,0)*pol_y(2,3,jg)
       END DO
                coef_xyz(1)=coef_xyz(1)+coef_xy(1,1)*pol_z(1,0,kg)
                coef_xyz(1)=coef_xyz(1)+coef_xy(2,1)*pol_z(2,0,kg)
                coef_xyz(2)=coef_xyz(2)+coef_xy(1,2)*pol_z(1,0,kg)
                coef_xyz(2)=coef_xyz(2)+coef_xy(2,2)*pol_z(2,0,kg)
                coef_xyz(3)=coef_xyz(3)+coef_xy(1,3)*pol_z(1,0,kg)
                coef_xyz(3)=coef_xyz(3)+coef_xy(2,3)*pol_z(2,0,kg)
                coef_xyz(4)=coef_xyz(4)+coef_xy(1,4)*pol_z(1,0,kg)
                coef_xyz(4)=coef_xyz(4)+coef_xy(2,4)*pol_z(2,0,kg)
                coef_xyz(5)=coef_xyz(5)+coef_xy(1,5)*pol_z(1,0,kg)
                coef_xyz(5)=coef_xyz(5)+coef_xy(2,5)*pol_z(2,0,kg)
                coef_xyz(6)=coef_xyz(6)+coef_xy(1,6)*pol_z(1,0,kg)
                coef_xyz(6)=coef_xyz(6)+coef_xy(2,6)*pol_z(2,0,kg)
                coef_xyz(7)=coef_xyz(7)+coef_xy(1,7)*pol_z(1,0,kg)
                coef_xyz(7)=coef_xyz(7)+coef_xy(2,7)*pol_z(2,0,kg)
                coef_xyz(8)=coef_xyz(8)+coef_xy(1,8)*pol_z(1,0,kg)
                coef_xyz(8)=coef_xyz(8)+coef_xy(2,8)*pol_z(2,0,kg)
                coef_xyz(9)=coef_xyz(9)+coef_xy(1,9)*pol_z(1,0,kg)
                coef_xyz(9)=coef_xyz(9)+coef_xy(2,9)*pol_z(2,0,kg)
                coef_xyz(10)=coef_xyz(10)+coef_xy(1,10)*pol_z(1,0,kg)
                coef_xyz(10)=coef_xyz(10)+coef_xy(2,10)*pol_z(2,0,kg)
                coef_xyz(11)=coef_xyz(11)+coef_xy(1,1)*pol_z(1,1,kg)
                coef_xyz(11)=coef_xyz(11)+coef_xy(2,1)*pol_z(2,1,kg)
                coef_xyz(12)=coef_xyz(12)+coef_xy(1,2)*pol_z(1,1,kg)
                coef_xyz(12)=coef_xyz(12)+coef_xy(2,2)*pol_z(2,1,kg)
                coef_xyz(13)=coef_xyz(13)+coef_xy(1,3)*pol_z(1,1,kg)
                coef_xyz(13)=coef_xyz(13)+coef_xy(2,3)*pol_z(2,1,kg)
                coef_xyz(14)=coef_xyz(14)+coef_xy(1,5)*pol_z(1,1,kg)
                coef_xyz(14)=coef_xyz(14)+coef_xy(2,5)*pol_z(2,1,kg)
                coef_xyz(15)=coef_xyz(15)+coef_xy(1,6)*pol_z(1,1,kg)
                coef_xyz(15)=coef_xyz(15)+coef_xy(2,6)*pol_z(2,1,kg)
                coef_xyz(16)=coef_xyz(16)+coef_xy(1,8)*pol_z(1,1,kg)
                coef_xyz(16)=coef_xyz(16)+coef_xy(2,8)*pol_z(2,1,kg)
                coef_xyz(17)=coef_xyz(17)+coef_xy(1,1)*pol_z(1,2,kg)
                coef_xyz(17)=coef_xyz(17)+coef_xy(2,1)*pol_z(2,2,kg)
                coef_xyz(18)=coef_xyz(18)+coef_xy(1,2)*pol_z(1,2,kg)
                coef_xyz(18)=coef_xyz(18)+coef_xy(2,2)*pol_z(2,2,kg)
                coef_xyz(19)=coef_xyz(19)+coef_xy(1,5)*pol_z(1,2,kg)
                coef_xyz(19)=coef_xyz(19)+coef_xy(2,5)*pol_z(2,2,kg)
                coef_xyz(20)=coef_xyz(20)+coef_xy(1,1)*pol_z(1,3,kg)
                coef_xyz(20)=coef_xyz(20)+coef_xy(2,1)*pol_z(2,3,kg)
    END DO

  END SUBROUTINE integrate_core_3
  SUBROUTINE integrate_core_4(grid,coef_xyz,pol_x,pol_y,pol_z,map,sphere_bounds,cmax,gridbounds)
    USE kinds,                        ONLY: dp
    INTEGER, INTENT(IN)                      :: sphere_bounds(*), cmax, &
                                                map(-cmax:cmax,1:3), &
                                                gridbounds(2,3)
    REAL(dp), INTENT(IN) :: grid(gridbounds(1,1):gridbounds(2,1), gridbounds(1&
      ,2):gridbounds(2,2), gridbounds(1,3):gridbounds(2,3))
    INTEGER, PARAMETER                       :: lp = 4
    REAL(dp), INTENT(IN)                     :: pol_x(0:lp,-cmax:cmax), &
                                                pol_y(1:2,0:lp,-cmax:0), &
                                                pol_z(1:2,0:lp,-cmax:0)
    REAL(dp), INTENT(OUT) :: coef_xyz(((lp+1)*(lp+2)*(lp+3))/6)

    INTEGER                                  :: i, ig, igmax, igmin, j, j2, &
                                                jg, jg2, jgmin, k, k2, kg, &
                                                kg2, kgmin, lxp, lxy, lyp, sci
    REAL(dp)                                 :: coef_x(4,0:lp), &
                                                coef_xy(2,((lp+1)*(lp+2))/2), &
                                                s01, s02, s03, s04

    sci=1

    coef_xyz=0.0_dp

    kgmin=sphere_bounds(sci)
    sci=sci+1
    DO kg=kgmin,0
       kg2=1-kg
       k=map(kg,3)
       k2=map(kg2,3)

       coef_xy=0.0_dp

       jgmin=sphere_bounds(sci)
       sci=sci+1
       DO jg=jgmin,0
          jg2=1-jg
          j=map(jg,2)
          j2=map(jg2,2)
          igmin=sphere_bounds(sci)
          sci=sci+1
          igmax=1-igmin

          coef_x=0.0_dp
          DO ig=igmin,igmax
             i=map(ig,1)
             s01=grid(i,j,k)
             s02=grid(i,j,k2)
             s03=grid(i,j2,k)
             s04=grid(i,j2,k2)
             DO lxp=0,lp
                coef_x(1,lxp)=coef_x(1,lxp)+s01*pol_x(lxp,ig)
                coef_x(2,lxp)=coef_x(2,lxp)+s02*pol_x(lxp,ig)
                coef_x(3,lxp)=coef_x(3,lxp)+s03*pol_x(lxp,ig)
                coef_x(4,lxp)=coef_x(4,lxp)+s04*pol_x(lxp,ig)
             ENDDO
          END DO
          lxy=0
          DO lyp=0,lp
          DO lxp=0,lp-lyp
             lxy=lxy+1
             coef_xy(:,lxy)=coef_xy(:,lxy)+coef_x(1:2,lxp)*pol_y(1,lyp,jg)
             coef_xy(:,lxy)=coef_xy(:,lxy)+coef_x(3:4,lxp)*pol_y(2,lyp,jg)
          ENDDO
          ENDDO
       END DO
                coef_xyz(1)=coef_xyz(1)+coef_xy(1,1)*pol_z(1,0,kg)
                coef_xyz(1)=coef_xyz(1)+coef_xy(2,1)*pol_z(2,0,kg)
                coef_xyz(2)=coef_xyz(2)+coef_xy(1,2)*pol_z(1,0,kg)
                coef_xyz(2)=coef_xyz(2)+coef_xy(2,2)*pol_z(2,0,kg)
                coef_xyz(3)=coef_xyz(3)+coef_xy(1,3)*pol_z(1,0,kg)
                coef_xyz(3)=coef_xyz(3)+coef_xy(2,3)*pol_z(2,0,kg)
                coef_xyz(4)=coef_xyz(4)+coef_xy(1,4)*pol_z(1,0,kg)
                coef_xyz(4)=coef_xyz(4)+coef_xy(2,4)*pol_z(2,0,kg)
                coef_xyz(5)=coef_xyz(5)+coef_xy(1,5)*pol_z(1,0,kg)
                coef_xyz(5)=coef_xyz(5)+coef_xy(2,5)*pol_z(2,0,kg)
                coef_xyz(6)=coef_xyz(6)+coef_xy(1,6)*pol_z(1,0,kg)
                coef_xyz(6)=coef_xyz(6)+coef_xy(2,6)*pol_z(2,0,kg)
                coef_xyz(7)=coef_xyz(7)+coef_xy(1,7)*pol_z(1,0,kg)
                coef_xyz(7)=coef_xyz(7)+coef_xy(2,7)*pol_z(2,0,kg)
                coef_xyz(8)=coef_xyz(8)+coef_xy(1,8)*pol_z(1,0,kg)
                coef_xyz(8)=coef_xyz(8)+coef_xy(2,8)*pol_z(2,0,kg)
                coef_xyz(9)=coef_xyz(9)+coef_xy(1,9)*pol_z(1,0,kg)
                coef_xyz(9)=coef_xyz(9)+coef_xy(2,9)*pol_z(2,0,kg)
                coef_xyz(10)=coef_xyz(10)+coef_xy(1,10)*pol_z(1,0,kg)
                coef_xyz(10)=coef_xyz(10)+coef_xy(2,10)*pol_z(2,0,kg)
                coef_xyz(11)=coef_xyz(11)+coef_xy(1,11)*pol_z(1,0,kg)
                coef_xyz(11)=coef_xyz(11)+coef_xy(2,11)*pol_z(2,0,kg)
                coef_xyz(12)=coef_xyz(12)+coef_xy(1,12)*pol_z(1,0,kg)
                coef_xyz(12)=coef_xyz(12)+coef_xy(2,12)*pol_z(2,0,kg)
                coef_xyz(13)=coef_xyz(13)+coef_xy(1,13)*pol_z(1,0,kg)
                coef_xyz(13)=coef_xyz(13)+coef_xy(2,13)*pol_z(2,0,kg)
                coef_xyz(14)=coef_xyz(14)+coef_xy(1,14)*pol_z(1,0,kg)
                coef_xyz(14)=coef_xyz(14)+coef_xy(2,14)*pol_z(2,0,kg)
                coef_xyz(15)=coef_xyz(15)+coef_xy(1,15)*pol_z(1,0,kg)
                coef_xyz(15)=coef_xyz(15)+coef_xy(2,15)*pol_z(2,0,kg)
                coef_xyz(16)=coef_xyz(16)+coef_xy(1,1)*pol_z(1,1,kg)
                coef_xyz(16)=coef_xyz(16)+coef_xy(2,1)*pol_z(2,1,kg)
                coef_xyz(17)=coef_xyz(17)+coef_xy(1,2)*pol_z(1,1,kg)
                coef_xyz(17)=coef_xyz(17)+coef_xy(2,2)*pol_z(2,1,kg)
                coef_xyz(18)=coef_xyz(18)+coef_xy(1,3)*pol_z(1,1,kg)
                coef_xyz(18)=coef_xyz(18)+coef_xy(2,3)*pol_z(2,1,kg)
                coef_xyz(19)=coef_xyz(19)+coef_xy(1,4)*pol_z(1,1,kg)
                coef_xyz(19)=coef_xyz(19)+coef_xy(2,4)*pol_z(2,1,kg)
                coef_xyz(20)=coef_xyz(20)+coef_xy(1,6)*pol_z(1,1,kg)
                coef_xyz(20)=coef_xyz(20)+coef_xy(2,6)*pol_z(2,1,kg)
                coef_xyz(21)=coef_xyz(21)+coef_xy(1,7)*pol_z(1,1,kg)
                coef_xyz(21)=coef_xyz(21)+coef_xy(2,7)*pol_z(2,1,kg)
                coef_xyz(22)=coef_xyz(22)+coef_xy(1,8)*pol_z(1,1,kg)
                coef_xyz(22)=coef_xyz(22)+coef_xy(2,8)*pol_z(2,1,kg)
                coef_xyz(23)=coef_xyz(23)+coef_xy(1,10)*pol_z(1,1,kg)
                coef_xyz(23)=coef_xyz(23)+coef_xy(2,10)*pol_z(2,1,kg)
                coef_xyz(24)=coef_xyz(24)+coef_xy(1,11)*pol_z(1,1,kg)
                coef_xyz(24)=coef_xyz(24)+coef_xy(2,11)*pol_z(2,1,kg)
                coef_xyz(25)=coef_xyz(25)+coef_xy(1,13)*pol_z(1,1,kg)
                coef_xyz(25)=coef_xyz(25)+coef_xy(2,13)*pol_z(2,1,kg)
                coef_xyz(26)=coef_xyz(26)+coef_xy(1,1)*pol_z(1,2,kg)
                coef_xyz(26)=coef_xyz(26)+coef_xy(2,1)*pol_z(2,2,kg)
                coef_xyz(27)=coef_xyz(27)+coef_xy(1,2)*pol_z(1,2,kg)
                coef_xyz(27)=coef_xyz(27)+coef_xy(2,2)*pol_z(2,2,kg)
                coef_xyz(28)=coef_xyz(28)+coef_xy(1,3)*pol_z(1,2,kg)
                coef_xyz(28)=coef_xyz(28)+coef_xy(2,3)*pol_z(2,2,kg)
                coef_xyz(29)=coef_xyz(29)+coef_xy(1,6)*pol_z(1,2,kg)
                coef_xyz(29)=coef_xyz(29)+coef_xy(2,6)*pol_z(2,2,kg)
                coef_xyz(30)=coef_xyz(30)+coef_xy(1,7)*pol_z(1,2,kg)
                coef_xyz(30)=coef_xyz(30)+coef_xy(2,7)*pol_z(2,2,kg)
                coef_xyz(31)=coef_xyz(31)+coef_xy(1,10)*pol_z(1,2,kg)
                coef_xyz(31)=coef_xyz(31)+coef_xy(2,10)*pol_z(2,2,kg)
                coef_xyz(32)=coef_xyz(32)+coef_xy(1,1)*pol_z(1,3,kg)
                coef_xyz(32)=coef_xyz(32)+coef_xy(2,1)*pol_z(2,3,kg)
                coef_xyz(33)=coef_xyz(33)+coef_xy(1,2)*pol_z(1,3,kg)
                coef_xyz(33)=coef_xyz(33)+coef_xy(2,2)*pol_z(2,3,kg)
                coef_xyz(34)=coef_xyz(34)+coef_xy(1,6)*pol_z(1,3,kg)
                coef_xyz(34)=coef_xyz(34)+coef_xy(2,6)*pol_z(2,3,kg)
                coef_xyz(35)=coef_xyz(35)+coef_xy(1,1)*pol_z(1,4,kg)
                coef_xyz(35)=coef_xyz(35)+coef_xy(2,1)*pol_z(2,4,kg)
    END DO

  END SUBROUTINE integrate_core_4
  SUBROUTINE integrate_core_5(grid,coef_xyz,pol_x,pol_y,pol_z,map,sphere_bounds,cmax,gridbounds)
    USE kinds,                        ONLY: dp
    INTEGER, INTENT(IN)                      :: sphere_bounds(*), cmax, &
                                                map(-cmax:cmax,1:3), &
                                                gridbounds(2,3)
    REAL(dp), INTENT(IN) :: grid(gridbounds(1,1):gridbounds(2,1), gridbounds(1&
      ,2):gridbounds(2,2), gridbounds(1,3):gridbounds(2,3))
    INTEGER, PARAMETER                       :: lp = 5
    REAL(dp), INTENT(IN)                     :: pol_x(0:lp,-cmax:cmax), &
                                                pol_y(1:2,0:lp,-cmax:0), &
                                                pol_z(1:2,0:lp,-cmax:0)
    REAL(dp), INTENT(OUT) :: coef_xyz(((lp+1)*(lp+2)*(lp+3))/6)

    INTEGER                                  :: i, ig, igmax, igmin, j, j2, &
                                                jg, jg2, jgmin, k, k2, kg, &
                                                kg2, kgmin, lxp, sci
    REAL(dp)                                 :: coef_x(4,0:lp), &
                                                coef_xy(2,((lp+1)*(lp+2))/2), &
                                                s01, s02, s03, s04

    sci=1

    coef_xyz=0.0_dp

    kgmin=sphere_bounds(sci)
    sci=sci+1
    DO kg=kgmin,0
       kg2=1-kg
       k=map(kg,3)
       k2=map(kg2,3)

       coef_xy=0.0_dp

       jgmin=sphere_bounds(sci)
       sci=sci+1
       DO jg=jgmin,0
          jg2=1-jg
          j=map(jg,2)
          j2=map(jg2,2)
          igmin=sphere_bounds(sci)
          sci=sci+1
          igmax=1-igmin

          coef_x=0.0_dp
          DO ig=igmin,igmax
             i=map(ig,1)
             s01=grid(i,j,k)
             s02=grid(i,j,k2)
             s03=grid(i,j2,k)
             s04=grid(i,j2,k2)
             DO lxp=0,lp
                coef_x(1,lxp)=coef_x(1,lxp)+s01*pol_x(lxp,ig)
                coef_x(2,lxp)=coef_x(2,lxp)+s02*pol_x(lxp,ig)
                coef_x(3,lxp)=coef_x(3,lxp)+s03*pol_x(lxp,ig)
                coef_x(4,lxp)=coef_x(4,lxp)+s04*pol_x(lxp,ig)
             ENDDO
          END DO
             coef_xy(:,1)=coef_xy(:,1)+coef_x(1:2,0)*pol_y(1,0,jg)
             coef_xy(:,1)=coef_xy(:,1)+coef_x(3:4,0)*pol_y(2,0,jg)
             coef_xy(:,2)=coef_xy(:,2)+coef_x(1:2,1)*pol_y(1,0,jg)
             coef_xy(:,2)=coef_xy(:,2)+coef_x(3:4,1)*pol_y(2,0,jg)
             coef_xy(:,3)=coef_xy(:,3)+coef_x(1:2,2)*pol_y(1,0,jg)
             coef_xy(:,3)=coef_xy(:,3)+coef_x(3:4,2)*pol_y(2,0,jg)
             coef_xy(:,4)=coef_xy(:,4)+coef_x(1:2,3)*pol_y(1,0,jg)
             coef_xy(:,4)=coef_xy(:,4)+coef_x(3:4,3)*pol_y(2,0,jg)
             coef_xy(:,5)=coef_xy(:,5)+coef_x(1:2,4)*pol_y(1,0,jg)
             coef_xy(:,5)=coef_xy(:,5)+coef_x(3:4,4)*pol_y(2,0,jg)
             coef_xy(:,6)=coef_xy(:,6)+coef_x(1:2,5)*pol_y(1,0,jg)
             coef_xy(:,6)=coef_xy(:,6)+coef_x(3:4,5)*pol_y(2,0,jg)
             coef_xy(:,7)=coef_xy(:,7)+coef_x(1:2,0)*pol_y(1,1,jg)
             coef_xy(:,7)=coef_xy(:,7)+coef_x(3:4,0)*pol_y(2,1,jg)
             coef_xy(:,8)=coef_xy(:,8)+coef_x(1:2,1)*pol_y(1,1,jg)
             coef_xy(:,8)=coef_xy(:,8)+coef_x(3:4,1)*pol_y(2,1,jg)
             coef_xy(:,9)=coef_xy(:,9)+coef_x(1:2,2)*pol_y(1,1,jg)
             coef_xy(:,9)=coef_xy(:,9)+coef_x(3:4,2)*pol_y(2,1,jg)
             coef_xy(:,10)=coef_xy(:,10)+coef_x(1:2,3)*pol_y(1,1,jg)
             coef_xy(:,10)=coef_xy(:,10)+coef_x(3:4,3)*pol_y(2,1,jg)
             coef_xy(:,11)=coef_xy(:,11)+coef_x(1:2,4)*pol_y(1,1,jg)
             coef_xy(:,11)=coef_xy(:,11)+coef_x(3:4,4)*pol_y(2,1,jg)
             coef_xy(:,12)=coef_xy(:,12)+coef_x(1:2,0)*pol_y(1,2,jg)
             coef_xy(:,12)=coef_xy(:,12)+coef_x(3:4,0)*pol_y(2,2,jg)
             coef_xy(:,13)=coef_xy(:,13)+coef_x(1:2,1)*pol_y(1,2,jg)
             coef_xy(:,13)=coef_xy(:,13)+coef_x(3:4,1)*pol_y(2,2,jg)
             coef_xy(:,14)=coef_xy(:,14)+coef_x(1:2,2)*pol_y(1,2,jg)
             coef_xy(:,14)=coef_xy(:,14)+coef_x(3:4,2)*pol_y(2,2,jg)
             coef_xy(:,15)=coef_xy(:,15)+coef_x(1:2,3)*pol_y(1,2,jg)
             coef_xy(:,15)=coef_xy(:,15)+coef_x(3:4,3)*pol_y(2,2,jg)
             coef_xy(:,16)=coef_xy(:,16)+coef_x(1:2,0)*pol_y(1,3,jg)
             coef_xy(:,16)=coef_xy(:,16)+coef_x(3:4,0)*pol_y(2,3,jg)
             coef_xy(:,17)=coef_xy(:,17)+coef_x(1:2,1)*pol_y(1,3,jg)
             coef_xy(:,17)=coef_xy(:,17)+coef_x(3:4,1)*pol_y(2,3,jg)
             coef_xy(:,18)=coef_xy(:,18)+coef_x(1:2,2)*pol_y(1,3,jg)
             coef_xy(:,18)=coef_xy(:,18)+coef_x(3:4,2)*pol_y(2,3,jg)
             coef_xy(:,19)=coef_xy(:,19)+coef_x(1:2,0)*pol_y(1,4,jg)
             coef_xy(:,19)=coef_xy(:,19)+coef_x(3:4,0)*pol_y(2,4,jg)
             coef_xy(:,20)=coef_xy(:,20)+coef_x(1:2,1)*pol_y(1,4,jg)
             coef_xy(:,20)=coef_xy(:,20)+coef_x(3:4,1)*pol_y(2,4,jg)
             coef_xy(:,21)=coef_xy(:,21)+coef_x(1:2,0)*pol_y(1,5,jg)
             coef_xy(:,21)=coef_xy(:,21)+coef_x(3:4,0)*pol_y(2,5,jg)
       END DO
                coef_xyz(1)=coef_xyz(1)+SUM(coef_xy(:,1)*pol_z(:,0,kg))
                coef_xyz(2)=coef_xyz(2)+SUM(coef_xy(:,2)*pol_z(:,0,kg))
                coef_xyz(3)=coef_xyz(3)+SUM(coef_xy(:,3)*pol_z(:,0,kg))
                coef_xyz(4)=coef_xyz(4)+SUM(coef_xy(:,4)*pol_z(:,0,kg))
                coef_xyz(5)=coef_xyz(5)+SUM(coef_xy(:,5)*pol_z(:,0,kg))
                coef_xyz(6)=coef_xyz(6)+SUM(coef_xy(:,6)*pol_z(:,0,kg))
                coef_xyz(7)=coef_xyz(7)+SUM(coef_xy(:,7)*pol_z(:,0,kg))
                coef_xyz(8)=coef_xyz(8)+SUM(coef_xy(:,8)*pol_z(:,0,kg))
                coef_xyz(9)=coef_xyz(9)+SUM(coef_xy(:,9)*pol_z(:,0,kg))
                coef_xyz(10)=coef_xyz(10)+SUM(coef_xy(:,10)*pol_z(:,0,kg))
                coef_xyz(11)=coef_xyz(11)+SUM(coef_xy(:,11)*pol_z(:,0,kg))
                coef_xyz(12)=coef_xyz(12)+SUM(coef_xy(:,12)*pol_z(:,0,kg))
                coef_xyz(13)=coef_xyz(13)+SUM(coef_xy(:,13)*pol_z(:,0,kg))
                coef_xyz(14)=coef_xyz(14)+SUM(coef_xy(:,14)*pol_z(:,0,kg))
                coef_xyz(15)=coef_xyz(15)+SUM(coef_xy(:,15)*pol_z(:,0,kg))
                coef_xyz(16)=coef_xyz(16)+SUM(coef_xy(:,16)*pol_z(:,0,kg))
                coef_xyz(17)=coef_xyz(17)+SUM(coef_xy(:,17)*pol_z(:,0,kg))
                coef_xyz(18)=coef_xyz(18)+SUM(coef_xy(:,18)*pol_z(:,0,kg))
                coef_xyz(19)=coef_xyz(19)+SUM(coef_xy(:,19)*pol_z(:,0,kg))
                coef_xyz(20)=coef_xyz(20)+SUM(coef_xy(:,20)*pol_z(:,0,kg))
                coef_xyz(21)=coef_xyz(21)+SUM(coef_xy(:,21)*pol_z(:,0,kg))
                coef_xyz(22)=coef_xyz(22)+SUM(coef_xy(:,1)*pol_z(:,1,kg))
                coef_xyz(23)=coef_xyz(23)+SUM(coef_xy(:,2)*pol_z(:,1,kg))
                coef_xyz(24)=coef_xyz(24)+SUM(coef_xy(:,3)*pol_z(:,1,kg))
                coef_xyz(25)=coef_xyz(25)+SUM(coef_xy(:,4)*pol_z(:,1,kg))
                coef_xyz(26)=coef_xyz(26)+SUM(coef_xy(:,5)*pol_z(:,1,kg))
                coef_xyz(27)=coef_xyz(27)+SUM(coef_xy(:,7)*pol_z(:,1,kg))
                coef_xyz(28)=coef_xyz(28)+SUM(coef_xy(:,8)*pol_z(:,1,kg))
                coef_xyz(29)=coef_xyz(29)+SUM(coef_xy(:,9)*pol_z(:,1,kg))
                coef_xyz(30)=coef_xyz(30)+SUM(coef_xy(:,10)*pol_z(:,1,kg))
                coef_xyz(31)=coef_xyz(31)+SUM(coef_xy(:,12)*pol_z(:,1,kg))
                coef_xyz(32)=coef_xyz(32)+SUM(coef_xy(:,13)*pol_z(:,1,kg))
                coef_xyz(33)=coef_xyz(33)+SUM(coef_xy(:,14)*pol_z(:,1,kg))
                coef_xyz(34)=coef_xyz(34)+SUM(coef_xy(:,16)*pol_z(:,1,kg))
                coef_xyz(35)=coef_xyz(35)+SUM(coef_xy(:,17)*pol_z(:,1,kg))
                coef_xyz(36)=coef_xyz(36)+SUM(coef_xy(:,19)*pol_z(:,1,kg))
                coef_xyz(37)=coef_xyz(37)+SUM(coef_xy(:,1)*pol_z(:,2,kg))
                coef_xyz(38)=coef_xyz(38)+SUM(coef_xy(:,2)*pol_z(:,2,kg))
                coef_xyz(39)=coef_xyz(39)+SUM(coef_xy(:,3)*pol_z(:,2,kg))
                coef_xyz(40)=coef_xyz(40)+SUM(coef_xy(:,4)*pol_z(:,2,kg))
                coef_xyz(41)=coef_xyz(41)+SUM(coef_xy(:,7)*pol_z(:,2,kg))
                coef_xyz(42)=coef_xyz(42)+SUM(coef_xy(:,8)*pol_z(:,2,kg))
                coef_xyz(43)=coef_xyz(43)+SUM(coef_xy(:,9)*pol_z(:,2,kg))
                coef_xyz(44)=coef_xyz(44)+SUM(coef_xy(:,12)*pol_z(:,2,kg))
                coef_xyz(45)=coef_xyz(45)+SUM(coef_xy(:,13)*pol_z(:,2,kg))
                coef_xyz(46)=coef_xyz(46)+SUM(coef_xy(:,16)*pol_z(:,2,kg))
                coef_xyz(47)=coef_xyz(47)+SUM(coef_xy(:,1)*pol_z(:,3,kg))
                coef_xyz(48)=coef_xyz(48)+SUM(coef_xy(:,2)*pol_z(:,3,kg))
                coef_xyz(49)=coef_xyz(49)+SUM(coef_xy(:,3)*pol_z(:,3,kg))
                coef_xyz(50)=coef_xyz(50)+SUM(coef_xy(:,7)*pol_z(:,3,kg))
                coef_xyz(51)=coef_xyz(51)+SUM(coef_xy(:,8)*pol_z(:,3,kg))
                coef_xyz(52)=coef_xyz(52)+SUM(coef_xy(:,12)*pol_z(:,3,kg))
                coef_xyz(53)=coef_xyz(53)+SUM(coef_xy(:,1)*pol_z(:,4,kg))
                coef_xyz(54)=coef_xyz(54)+SUM(coef_xy(:,2)*pol_z(:,4,kg))
                coef_xyz(55)=coef_xyz(55)+SUM(coef_xy(:,7)*pol_z(:,4,kg))
                coef_xyz(56)=coef_xyz(56)+SUM(coef_xy(:,1)*pol_z(:,5,kg))
    END DO

  END SUBROUTINE integrate_core_5
  SUBROUTINE integrate_core_6(grid,coef_xyz,pol_x,pol_y,pol_z,map,sphere_bounds,cmax,gridbounds)
    USE kinds,                        ONLY: dp
    INTEGER, INTENT(IN)                      :: sphere_bounds(*), cmax, &
                                                map(-cmax:cmax,1:3), &
                                                gridbounds(2,3)
    REAL(dp), INTENT(IN) :: grid(gridbounds(1,1):gridbounds(2,1), gridbounds(1&
      ,2):gridbounds(2,2), gridbounds(1,3):gridbounds(2,3))
    INTEGER, PARAMETER                       :: lp = 6
    REAL(dp), INTENT(IN)                     :: pol_x(0:lp,-cmax:cmax), &
                                                pol_y(1:2,0:lp,-cmax:0), &
                                                pol_z(1:2,0:lp,-cmax:0)
    REAL(dp), INTENT(OUT) :: coef_xyz(((lp+1)*(lp+2)*(lp+3))/6)

    INTEGER                                  :: i, ig, igmax, igmin, j, j2, &
                                                jg, jg2, jgmin, k, k2, kg, &
                                                kg2, kgmin, lxp, sci
    REAL(dp)                                 :: coef_x(4,0:lp), &
                                                coef_xy(2,((lp+1)*(lp+2))/2), &
                                                s(4)

    sci=1

    coef_xyz=0.0_dp

    kgmin=sphere_bounds(sci)
    sci=sci+1
    DO kg=kgmin,0
       kg2=1-kg
       k=map(kg,3)
       k2=map(kg2,3)

       coef_xy=0.0_dp

       jgmin=sphere_bounds(sci)
       sci=sci+1
       DO jg=jgmin,0
          jg2=1-jg
          j=map(jg,2)
          j2=map(jg2,2)
          igmin=sphere_bounds(sci)
          sci=sci+1
          igmax=1-igmin

          coef_x=0.0_dp
          DO ig=igmin,igmax
             i=map(ig,1)
             s(1)=grid(i,j,k)
             s(2)=grid(i,j,k2)
             s(3)=grid(i,j2,k)
             s(4)=grid(i,j2,k2)
             DO lxp=0,lp
                coef_x(:,lxp)=coef_x(:,lxp)+s(:)*pol_x(lxp,ig)
             ENDDO
          END DO
             coef_xy(1,1)=coef_xy(1,1)+coef_x(1,0)*pol_y(1,0,jg)
             coef_xy(2,1)=coef_xy(2,1)+coef_x(2,0)*pol_y(1,0,jg)
             coef_xy(1,1)=coef_xy(1,1)+coef_x(3,0)*pol_y(2,0,jg)
             coef_xy(2,1)=coef_xy(2,1)+coef_x(4,0)*pol_y(2,0,jg)
             coef_xy(1,2)=coef_xy(1,2)+coef_x(1,1)*pol_y(1,0,jg)
             coef_xy(2,2)=coef_xy(2,2)+coef_x(2,1)*pol_y(1,0,jg)
             coef_xy(1,2)=coef_xy(1,2)+coef_x(3,1)*pol_y(2,0,jg)
             coef_xy(2,2)=coef_xy(2,2)+coef_x(4,1)*pol_y(2,0,jg)
             coef_xy(1,3)=coef_xy(1,3)+coef_x(1,2)*pol_y(1,0,jg)
             coef_xy(2,3)=coef_xy(2,3)+coef_x(2,2)*pol_y(1,0,jg)
             coef_xy(1,3)=coef_xy(1,3)+coef_x(3,2)*pol_y(2,0,jg)
             coef_xy(2,3)=coef_xy(2,3)+coef_x(4,2)*pol_y(2,0,jg)
             coef_xy(1,4)=coef_xy(1,4)+coef_x(1,3)*pol_y(1,0,jg)
             coef_xy(2,4)=coef_xy(2,4)+coef_x(2,3)*pol_y(1,0,jg)
             coef_xy(1,4)=coef_xy(1,4)+coef_x(3,3)*pol_y(2,0,jg)
             coef_xy(2,4)=coef_xy(2,4)+coef_x(4,3)*pol_y(2,0,jg)
             coef_xy(1,5)=coef_xy(1,5)+coef_x(1,4)*pol_y(1,0,jg)
             coef_xy(2,5)=coef_xy(2,5)+coef_x(2,4)*pol_y(1,0,jg)
             coef_xy(1,5)=coef_xy(1,5)+coef_x(3,4)*pol_y(2,0,jg)
             coef_xy(2,5)=coef_xy(2,5)+coef_x(4,4)*pol_y(2,0,jg)
             coef_xy(1,6)=coef_xy(1,6)+coef_x(1,5)*pol_y(1,0,jg)
             coef_xy(2,6)=coef_xy(2,6)+coef_x(2,5)*pol_y(1,0,jg)
             coef_xy(1,6)=coef_xy(1,6)+coef_x(3,5)*pol_y(2,0,jg)
             coef_xy(2,6)=coef_xy(2,6)+coef_x(4,5)*pol_y(2,0,jg)
             coef_xy(1,7)=coef_xy(1,7)+coef_x(1,6)*pol_y(1,0,jg)
             coef_xy(2,7)=coef_xy(2,7)+coef_x(2,6)*pol_y(1,0,jg)
             coef_xy(1,7)=coef_xy(1,7)+coef_x(3,6)*pol_y(2,0,jg)
             coef_xy(2,7)=coef_xy(2,7)+coef_x(4,6)*pol_y(2,0,jg)
             coef_xy(1,8)=coef_xy(1,8)+coef_x(1,0)*pol_y(1,1,jg)
             coef_xy(2,8)=coef_xy(2,8)+coef_x(2,0)*pol_y(1,1,jg)
             coef_xy(1,8)=coef_xy(1,8)+coef_x(3,0)*pol_y(2,1,jg)
             coef_xy(2,8)=coef_xy(2,8)+coef_x(4,0)*pol_y(2,1,jg)
             coef_xy(1,9)=coef_xy(1,9)+coef_x(1,1)*pol_y(1,1,jg)
             coef_xy(2,9)=coef_xy(2,9)+coef_x(2,1)*pol_y(1,1,jg)
             coef_xy(1,9)=coef_xy(1,9)+coef_x(3,1)*pol_y(2,1,jg)
             coef_xy(2,9)=coef_xy(2,9)+coef_x(4,1)*pol_y(2,1,jg)
             coef_xy(1,10)=coef_xy(1,10)+coef_x(1,2)*pol_y(1,1,jg)
             coef_xy(2,10)=coef_xy(2,10)+coef_x(2,2)*pol_y(1,1,jg)
             coef_xy(1,10)=coef_xy(1,10)+coef_x(3,2)*pol_y(2,1,jg)
             coef_xy(2,10)=coef_xy(2,10)+coef_x(4,2)*pol_y(2,1,jg)
             coef_xy(1,11)=coef_xy(1,11)+coef_x(1,3)*pol_y(1,1,jg)
             coef_xy(2,11)=coef_xy(2,11)+coef_x(2,3)*pol_y(1,1,jg)
             coef_xy(1,11)=coef_xy(1,11)+coef_x(3,3)*pol_y(2,1,jg)
             coef_xy(2,11)=coef_xy(2,11)+coef_x(4,3)*pol_y(2,1,jg)
             coef_xy(1,12)=coef_xy(1,12)+coef_x(1,4)*pol_y(1,1,jg)
             coef_xy(2,12)=coef_xy(2,12)+coef_x(2,4)*pol_y(1,1,jg)
             coef_xy(1,12)=coef_xy(1,12)+coef_x(3,4)*pol_y(2,1,jg)
             coef_xy(2,12)=coef_xy(2,12)+coef_x(4,4)*pol_y(2,1,jg)
             coef_xy(1,13)=coef_xy(1,13)+coef_x(1,5)*pol_y(1,1,jg)
             coef_xy(2,13)=coef_xy(2,13)+coef_x(2,5)*pol_y(1,1,jg)
             coef_xy(1,13)=coef_xy(1,13)+coef_x(3,5)*pol_y(2,1,jg)
             coef_xy(2,13)=coef_xy(2,13)+coef_x(4,5)*pol_y(2,1,jg)
             coef_xy(1,14)=coef_xy(1,14)+coef_x(1,0)*pol_y(1,2,jg)
             coef_xy(2,14)=coef_xy(2,14)+coef_x(2,0)*pol_y(1,2,jg)
             coef_xy(1,14)=coef_xy(1,14)+coef_x(3,0)*pol_y(2,2,jg)
             coef_xy(2,14)=coef_xy(2,14)+coef_x(4,0)*pol_y(2,2,jg)
             coef_xy(1,15)=coef_xy(1,15)+coef_x(1,1)*pol_y(1,2,jg)
             coef_xy(2,15)=coef_xy(2,15)+coef_x(2,1)*pol_y(1,2,jg)
             coef_xy(1,15)=coef_xy(1,15)+coef_x(3,1)*pol_y(2,2,jg)
             coef_xy(2,15)=coef_xy(2,15)+coef_x(4,1)*pol_y(2,2,jg)
             coef_xy(1,16)=coef_xy(1,16)+coef_x(1,2)*pol_y(1,2,jg)
             coef_xy(2,16)=coef_xy(2,16)+coef_x(2,2)*pol_y(1,2,jg)
             coef_xy(1,16)=coef_xy(1,16)+coef_x(3,2)*pol_y(2,2,jg)
             coef_xy(2,16)=coef_xy(2,16)+coef_x(4,2)*pol_y(2,2,jg)
             coef_xy(1,17)=coef_xy(1,17)+coef_x(1,3)*pol_y(1,2,jg)
             coef_xy(2,17)=coef_xy(2,17)+coef_x(2,3)*pol_y(1,2,jg)
             coef_xy(1,17)=coef_xy(1,17)+coef_x(3,3)*pol_y(2,2,jg)
             coef_xy(2,17)=coef_xy(2,17)+coef_x(4,3)*pol_y(2,2,jg)
             coef_xy(1,18)=coef_xy(1,18)+coef_x(1,4)*pol_y(1,2,jg)
             coef_xy(2,18)=coef_xy(2,18)+coef_x(2,4)*pol_y(1,2,jg)
             coef_xy(1,18)=coef_xy(1,18)+coef_x(3,4)*pol_y(2,2,jg)
             coef_xy(2,18)=coef_xy(2,18)+coef_x(4,4)*pol_y(2,2,jg)
             coef_xy(1,19)=coef_xy(1,19)+coef_x(1,0)*pol_y(1,3,jg)
             coef_xy(2,19)=coef_xy(2,19)+coef_x(2,0)*pol_y(1,3,jg)
             coef_xy(1,19)=coef_xy(1,19)+coef_x(3,0)*pol_y(2,3,jg)
             coef_xy(2,19)=coef_xy(2,19)+coef_x(4,0)*pol_y(2,3,jg)
             coef_xy(1,20)=coef_xy(1,20)+coef_x(1,1)*pol_y(1,3,jg)
             coef_xy(2,20)=coef_xy(2,20)+coef_x(2,1)*pol_y(1,3,jg)
             coef_xy(1,20)=coef_xy(1,20)+coef_x(3,1)*pol_y(2,3,jg)
             coef_xy(2,20)=coef_xy(2,20)+coef_x(4,1)*pol_y(2,3,jg)
             coef_xy(1,21)=coef_xy(1,21)+coef_x(1,2)*pol_y(1,3,jg)
             coef_xy(2,21)=coef_xy(2,21)+coef_x(2,2)*pol_y(1,3,jg)
             coef_xy(1,21)=coef_xy(1,21)+coef_x(3,2)*pol_y(2,3,jg)
             coef_xy(2,21)=coef_xy(2,21)+coef_x(4,2)*pol_y(2,3,jg)
             coef_xy(1,22)=coef_xy(1,22)+coef_x(1,3)*pol_y(1,3,jg)
             coef_xy(2,22)=coef_xy(2,22)+coef_x(2,3)*pol_y(1,3,jg)
             coef_xy(1,22)=coef_xy(1,22)+coef_x(3,3)*pol_y(2,3,jg)
             coef_xy(2,22)=coef_xy(2,22)+coef_x(4,3)*pol_y(2,3,jg)
             coef_xy(1,23)=coef_xy(1,23)+coef_x(1,0)*pol_y(1,4,jg)
             coef_xy(2,23)=coef_xy(2,23)+coef_x(2,0)*pol_y(1,4,jg)
             coef_xy(1,23)=coef_xy(1,23)+coef_x(3,0)*pol_y(2,4,jg)
             coef_xy(2,23)=coef_xy(2,23)+coef_x(4,0)*pol_y(2,4,jg)
             coef_xy(1,24)=coef_xy(1,24)+coef_x(1,1)*pol_y(1,4,jg)
             coef_xy(2,24)=coef_xy(2,24)+coef_x(2,1)*pol_y(1,4,jg)
             coef_xy(1,24)=coef_xy(1,24)+coef_x(3,1)*pol_y(2,4,jg)
             coef_xy(2,24)=coef_xy(2,24)+coef_x(4,1)*pol_y(2,4,jg)
             coef_xy(1,25)=coef_xy(1,25)+coef_x(1,2)*pol_y(1,4,jg)
             coef_xy(2,25)=coef_xy(2,25)+coef_x(2,2)*pol_y(1,4,jg)
             coef_xy(1,25)=coef_xy(1,25)+coef_x(3,2)*pol_y(2,4,jg)
             coef_xy(2,25)=coef_xy(2,25)+coef_x(4,2)*pol_y(2,4,jg)
             coef_xy(1,26)=coef_xy(1,26)+coef_x(1,0)*pol_y(1,5,jg)
             coef_xy(2,26)=coef_xy(2,26)+coef_x(2,0)*pol_y(1,5,jg)
             coef_xy(1,26)=coef_xy(1,26)+coef_x(3,0)*pol_y(2,5,jg)
             coef_xy(2,26)=coef_xy(2,26)+coef_x(4,0)*pol_y(2,5,jg)
             coef_xy(1,27)=coef_xy(1,27)+coef_x(1,1)*pol_y(1,5,jg)
             coef_xy(2,27)=coef_xy(2,27)+coef_x(2,1)*pol_y(1,5,jg)
             coef_xy(1,27)=coef_xy(1,27)+coef_x(3,1)*pol_y(2,5,jg)
             coef_xy(2,27)=coef_xy(2,27)+coef_x(4,1)*pol_y(2,5,jg)
             coef_xy(1,28)=coef_xy(1,28)+coef_x(1,0)*pol_y(1,6,jg)
             coef_xy(2,28)=coef_xy(2,28)+coef_x(2,0)*pol_y(1,6,jg)
             coef_xy(1,28)=coef_xy(1,28)+coef_x(3,0)*pol_y(2,6,jg)
             coef_xy(2,28)=coef_xy(2,28)+coef_x(4,0)*pol_y(2,6,jg)
       END DO
                coef_xyz(1)=coef_xyz(1)+coef_xy(1,1)*pol_z(1,0,kg)
                coef_xyz(1)=coef_xyz(1)+coef_xy(2,1)*pol_z(2,0,kg)
                coef_xyz(2)=coef_xyz(2)+coef_xy(1,2)*pol_z(1,0,kg)
                coef_xyz(2)=coef_xyz(2)+coef_xy(2,2)*pol_z(2,0,kg)
                coef_xyz(3)=coef_xyz(3)+coef_xy(1,3)*pol_z(1,0,kg)
                coef_xyz(3)=coef_xyz(3)+coef_xy(2,3)*pol_z(2,0,kg)
                coef_xyz(4)=coef_xyz(4)+coef_xy(1,4)*pol_z(1,0,kg)
                coef_xyz(4)=coef_xyz(4)+coef_xy(2,4)*pol_z(2,0,kg)
                coef_xyz(5)=coef_xyz(5)+coef_xy(1,5)*pol_z(1,0,kg)
                coef_xyz(5)=coef_xyz(5)+coef_xy(2,5)*pol_z(2,0,kg)
                coef_xyz(6)=coef_xyz(6)+coef_xy(1,6)*pol_z(1,0,kg)
                coef_xyz(6)=coef_xyz(6)+coef_xy(2,6)*pol_z(2,0,kg)
                coef_xyz(7)=coef_xyz(7)+coef_xy(1,7)*pol_z(1,0,kg)
                coef_xyz(7)=coef_xyz(7)+coef_xy(2,7)*pol_z(2,0,kg)
                coef_xyz(8)=coef_xyz(8)+coef_xy(1,8)*pol_z(1,0,kg)
                coef_xyz(8)=coef_xyz(8)+coef_xy(2,8)*pol_z(2,0,kg)
                coef_xyz(9)=coef_xyz(9)+coef_xy(1,9)*pol_z(1,0,kg)
                coef_xyz(9)=coef_xyz(9)+coef_xy(2,9)*pol_z(2,0,kg)
                coef_xyz(10)=coef_xyz(10)+coef_xy(1,10)*pol_z(1,0,kg)
                coef_xyz(10)=coef_xyz(10)+coef_xy(2,10)*pol_z(2,0,kg)
                coef_xyz(11)=coef_xyz(11)+coef_xy(1,11)*pol_z(1,0,kg)
                coef_xyz(11)=coef_xyz(11)+coef_xy(2,11)*pol_z(2,0,kg)
                coef_xyz(12)=coef_xyz(12)+coef_xy(1,12)*pol_z(1,0,kg)
                coef_xyz(12)=coef_xyz(12)+coef_xy(2,12)*pol_z(2,0,kg)
                coef_xyz(13)=coef_xyz(13)+coef_xy(1,13)*pol_z(1,0,kg)
                coef_xyz(13)=coef_xyz(13)+coef_xy(2,13)*pol_z(2,0,kg)
                coef_xyz(14)=coef_xyz(14)+coef_xy(1,14)*pol_z(1,0,kg)
                coef_xyz(14)=coef_xyz(14)+coef_xy(2,14)*pol_z(2,0,kg)
                coef_xyz(15)=coef_xyz(15)+coef_xy(1,15)*pol_z(1,0,kg)
                coef_xyz(15)=coef_xyz(15)+coef_xy(2,15)*pol_z(2,0,kg)
                coef_xyz(16)=coef_xyz(16)+coef_xy(1,16)*pol_z(1,0,kg)
                coef_xyz(16)=coef_xyz(16)+coef_xy(2,16)*pol_z(2,0,kg)
                coef_xyz(17)=coef_xyz(17)+coef_xy(1,17)*pol_z(1,0,kg)
                coef_xyz(17)=coef_xyz(17)+coef_xy(2,17)*pol_z(2,0,kg)
                coef_xyz(18)=coef_xyz(18)+coef_xy(1,18)*pol_z(1,0,kg)
                coef_xyz(18)=coef_xyz(18)+coef_xy(2,18)*pol_z(2,0,kg)
                coef_xyz(19)=coef_xyz(19)+coef_xy(1,19)*pol_z(1,0,kg)
                coef_xyz(19)=coef_xyz(19)+coef_xy(2,19)*pol_z(2,0,kg)
                coef_xyz(20)=coef_xyz(20)+coef_xy(1,20)*pol_z(1,0,kg)
                coef_xyz(20)=coef_xyz(20)+coef_xy(2,20)*pol_z(2,0,kg)
                coef_xyz(21)=coef_xyz(21)+coef_xy(1,21)*pol_z(1,0,kg)
                coef_xyz(21)=coef_xyz(21)+coef_xy(2,21)*pol_z(2,0,kg)
                coef_xyz(22)=coef_xyz(22)+coef_xy(1,22)*pol_z(1,0,kg)
                coef_xyz(22)=coef_xyz(22)+coef_xy(2,22)*pol_z(2,0,kg)
                coef_xyz(23)=coef_xyz(23)+coef_xy(1,23)*pol_z(1,0,kg)
                coef_xyz(23)=coef_xyz(23)+coef_xy(2,23)*pol_z(2,0,kg)
                coef_xyz(24)=coef_xyz(24)+coef_xy(1,24)*pol_z(1,0,kg)
                coef_xyz(24)=coef_xyz(24)+coef_xy(2,24)*pol_z(2,0,kg)
                coef_xyz(25)=coef_xyz(25)+coef_xy(1,25)*pol_z(1,0,kg)
                coef_xyz(25)=coef_xyz(25)+coef_xy(2,25)*pol_z(2,0,kg)
                coef_xyz(26)=coef_xyz(26)+coef_xy(1,26)*pol_z(1,0,kg)
                coef_xyz(26)=coef_xyz(26)+coef_xy(2,26)*pol_z(2,0,kg)
                coef_xyz(27)=coef_xyz(27)+coef_xy(1,27)*pol_z(1,0,kg)
                coef_xyz(27)=coef_xyz(27)+coef_xy(2,27)*pol_z(2,0,kg)
                coef_xyz(28)=coef_xyz(28)+coef_xy(1,28)*pol_z(1,0,kg)
                coef_xyz(28)=coef_xyz(28)+coef_xy(2,28)*pol_z(2,0,kg)
                coef_xyz(29)=coef_xyz(29)+coef_xy(1,1)*pol_z(1,1,kg)
                coef_xyz(29)=coef_xyz(29)+coef_xy(2,1)*pol_z(2,1,kg)
                coef_xyz(30)=coef_xyz(30)+coef_xy(1,2)*pol_z(1,1,kg)
                coef_xyz(30)=coef_xyz(30)+coef_xy(2,2)*pol_z(2,1,kg)
                coef_xyz(31)=coef_xyz(31)+coef_xy(1,3)*pol_z(1,1,kg)
                coef_xyz(31)=coef_xyz(31)+coef_xy(2,3)*pol_z(2,1,kg)
                coef_xyz(32)=coef_xyz(32)+coef_xy(1,4)*pol_z(1,1,kg)
                coef_xyz(32)=coef_xyz(32)+coef_xy(2,4)*pol_z(2,1,kg)
                coef_xyz(33)=coef_xyz(33)+coef_xy(1,5)*pol_z(1,1,kg)
                coef_xyz(33)=coef_xyz(33)+coef_xy(2,5)*pol_z(2,1,kg)
                coef_xyz(34)=coef_xyz(34)+coef_xy(1,6)*pol_z(1,1,kg)
                coef_xyz(34)=coef_xyz(34)+coef_xy(2,6)*pol_z(2,1,kg)
                coef_xyz(35)=coef_xyz(35)+coef_xy(1,8)*pol_z(1,1,kg)
                coef_xyz(35)=coef_xyz(35)+coef_xy(2,8)*pol_z(2,1,kg)
                coef_xyz(36)=coef_xyz(36)+coef_xy(1,9)*pol_z(1,1,kg)
                coef_xyz(36)=coef_xyz(36)+coef_xy(2,9)*pol_z(2,1,kg)
                coef_xyz(37)=coef_xyz(37)+coef_xy(1,10)*pol_z(1,1,kg)
                coef_xyz(37)=coef_xyz(37)+coef_xy(2,10)*pol_z(2,1,kg)
                coef_xyz(38)=coef_xyz(38)+coef_xy(1,11)*pol_z(1,1,kg)
                coef_xyz(38)=coef_xyz(38)+coef_xy(2,11)*pol_z(2,1,kg)
                coef_xyz(39)=coef_xyz(39)+coef_xy(1,12)*pol_z(1,1,kg)
                coef_xyz(39)=coef_xyz(39)+coef_xy(2,12)*pol_z(2,1,kg)
                coef_xyz(40)=coef_xyz(40)+coef_xy(1,14)*pol_z(1,1,kg)
                coef_xyz(40)=coef_xyz(40)+coef_xy(2,14)*pol_z(2,1,kg)
                coef_xyz(41)=coef_xyz(41)+coef_xy(1,15)*pol_z(1,1,kg)
                coef_xyz(41)=coef_xyz(41)+coef_xy(2,15)*pol_z(2,1,kg)
                coef_xyz(42)=coef_xyz(42)+coef_xy(1,16)*pol_z(1,1,kg)
                coef_xyz(42)=coef_xyz(42)+coef_xy(2,16)*pol_z(2,1,kg)
                coef_xyz(43)=coef_xyz(43)+coef_xy(1,17)*pol_z(1,1,kg)
                coef_xyz(43)=coef_xyz(43)+coef_xy(2,17)*pol_z(2,1,kg)
                coef_xyz(44)=coef_xyz(44)+coef_xy(1,19)*pol_z(1,1,kg)
                coef_xyz(44)=coef_xyz(44)+coef_xy(2,19)*pol_z(2,1,kg)
                coef_xyz(45)=coef_xyz(45)+coef_xy(1,20)*pol_z(1,1,kg)
                coef_xyz(45)=coef_xyz(45)+coef_xy(2,20)*pol_z(2,1,kg)
                coef_xyz(46)=coef_xyz(46)+coef_xy(1,21)*pol_z(1,1,kg)
                coef_xyz(46)=coef_xyz(46)+coef_xy(2,21)*pol_z(2,1,kg)
                coef_xyz(47)=coef_xyz(47)+coef_xy(1,23)*pol_z(1,1,kg)
                coef_xyz(47)=coef_xyz(47)+coef_xy(2,23)*pol_z(2,1,kg)
                coef_xyz(48)=coef_xyz(48)+coef_xy(1,24)*pol_z(1,1,kg)
                coef_xyz(48)=coef_xyz(48)+coef_xy(2,24)*pol_z(2,1,kg)
                coef_xyz(49)=coef_xyz(49)+coef_xy(1,26)*pol_z(1,1,kg)
                coef_xyz(49)=coef_xyz(49)+coef_xy(2,26)*pol_z(2,1,kg)
                coef_xyz(50)=coef_xyz(50)+coef_xy(1,1)*pol_z(1,2,kg)
                coef_xyz(50)=coef_xyz(50)+coef_xy(2,1)*pol_z(2,2,kg)
                coef_xyz(51)=coef_xyz(51)+coef_xy(1,2)*pol_z(1,2,kg)
                coef_xyz(51)=coef_xyz(51)+coef_xy(2,2)*pol_z(2,2,kg)
                coef_xyz(52)=coef_xyz(52)+coef_xy(1,3)*pol_z(1,2,kg)
                coef_xyz(52)=coef_xyz(52)+coef_xy(2,3)*pol_z(2,2,kg)
                coef_xyz(53)=coef_xyz(53)+coef_xy(1,4)*pol_z(1,2,kg)
                coef_xyz(53)=coef_xyz(53)+coef_xy(2,4)*pol_z(2,2,kg)
                coef_xyz(54)=coef_xyz(54)+coef_xy(1,5)*pol_z(1,2,kg)
                coef_xyz(54)=coef_xyz(54)+coef_xy(2,5)*pol_z(2,2,kg)
                coef_xyz(55)=coef_xyz(55)+coef_xy(1,8)*pol_z(1,2,kg)
                coef_xyz(55)=coef_xyz(55)+coef_xy(2,8)*pol_z(2,2,kg)
                coef_xyz(56)=coef_xyz(56)+coef_xy(1,9)*pol_z(1,2,kg)
                coef_xyz(56)=coef_xyz(56)+coef_xy(2,9)*pol_z(2,2,kg)
                coef_xyz(57)=coef_xyz(57)+coef_xy(1,10)*pol_z(1,2,kg)
                coef_xyz(57)=coef_xyz(57)+coef_xy(2,10)*pol_z(2,2,kg)
                coef_xyz(58)=coef_xyz(58)+coef_xy(1,11)*pol_z(1,2,kg)
                coef_xyz(58)=coef_xyz(58)+coef_xy(2,11)*pol_z(2,2,kg)
                coef_xyz(59)=coef_xyz(59)+coef_xy(1,14)*pol_z(1,2,kg)
                coef_xyz(59)=coef_xyz(59)+coef_xy(2,14)*pol_z(2,2,kg)
                coef_xyz(60)=coef_xyz(60)+coef_xy(1,15)*pol_z(1,2,kg)
                coef_xyz(60)=coef_xyz(60)+coef_xy(2,15)*pol_z(2,2,kg)
                coef_xyz(61)=coef_xyz(61)+coef_xy(1,16)*pol_z(1,2,kg)
                coef_xyz(61)=coef_xyz(61)+coef_xy(2,16)*pol_z(2,2,kg)
                coef_xyz(62)=coef_xyz(62)+coef_xy(1,19)*pol_z(1,2,kg)
                coef_xyz(62)=coef_xyz(62)+coef_xy(2,19)*pol_z(2,2,kg)
                coef_xyz(63)=coef_xyz(63)+coef_xy(1,20)*pol_z(1,2,kg)
                coef_xyz(63)=coef_xyz(63)+coef_xy(2,20)*pol_z(2,2,kg)
                coef_xyz(64)=coef_xyz(64)+coef_xy(1,23)*pol_z(1,2,kg)
                coef_xyz(64)=coef_xyz(64)+coef_xy(2,23)*pol_z(2,2,kg)
                coef_xyz(65)=coef_xyz(65)+coef_xy(1,1)*pol_z(1,3,kg)
                coef_xyz(65)=coef_xyz(65)+coef_xy(2,1)*pol_z(2,3,kg)
                coef_xyz(66)=coef_xyz(66)+coef_xy(1,2)*pol_z(1,3,kg)
                coef_xyz(66)=coef_xyz(66)+coef_xy(2,2)*pol_z(2,3,kg)
                coef_xyz(67)=coef_xyz(67)+coef_xy(1,3)*pol_z(1,3,kg)
                coef_xyz(67)=coef_xyz(67)+coef_xy(2,3)*pol_z(2,3,kg)
                coef_xyz(68)=coef_xyz(68)+coef_xy(1,4)*pol_z(1,3,kg)
                coef_xyz(68)=coef_xyz(68)+coef_xy(2,4)*pol_z(2,3,kg)
                coef_xyz(69)=coef_xyz(69)+coef_xy(1,8)*pol_z(1,3,kg)
                coef_xyz(69)=coef_xyz(69)+coef_xy(2,8)*pol_z(2,3,kg)
                coef_xyz(70)=coef_xyz(70)+coef_xy(1,9)*pol_z(1,3,kg)
                coef_xyz(70)=coef_xyz(70)+coef_xy(2,9)*pol_z(2,3,kg)
                coef_xyz(71)=coef_xyz(71)+coef_xy(1,10)*pol_z(1,3,kg)
                coef_xyz(71)=coef_xyz(71)+coef_xy(2,10)*pol_z(2,3,kg)
                coef_xyz(72)=coef_xyz(72)+coef_xy(1,14)*pol_z(1,3,kg)
                coef_xyz(72)=coef_xyz(72)+coef_xy(2,14)*pol_z(2,3,kg)
                coef_xyz(73)=coef_xyz(73)+coef_xy(1,15)*pol_z(1,3,kg)
                coef_xyz(73)=coef_xyz(73)+coef_xy(2,15)*pol_z(2,3,kg)
                coef_xyz(74)=coef_xyz(74)+coef_xy(1,19)*pol_z(1,3,kg)
                coef_xyz(74)=coef_xyz(74)+coef_xy(2,19)*pol_z(2,3,kg)
                coef_xyz(75)=coef_xyz(75)+coef_xy(1,1)*pol_z(1,4,kg)
                coef_xyz(75)=coef_xyz(75)+coef_xy(2,1)*pol_z(2,4,kg)
                coef_xyz(76)=coef_xyz(76)+coef_xy(1,2)*pol_z(1,4,kg)
                coef_xyz(76)=coef_xyz(76)+coef_xy(2,2)*pol_z(2,4,kg)
                coef_xyz(77)=coef_xyz(77)+coef_xy(1,3)*pol_z(1,4,kg)
                coef_xyz(77)=coef_xyz(77)+coef_xy(2,3)*pol_z(2,4,kg)
                coef_xyz(78)=coef_xyz(78)+coef_xy(1,8)*pol_z(1,4,kg)
                coef_xyz(78)=coef_xyz(78)+coef_xy(2,8)*pol_z(2,4,kg)
                coef_xyz(79)=coef_xyz(79)+coef_xy(1,9)*pol_z(1,4,kg)
                coef_xyz(79)=coef_xyz(79)+coef_xy(2,9)*pol_z(2,4,kg)
                coef_xyz(80)=coef_xyz(80)+coef_xy(1,14)*pol_z(1,4,kg)
                coef_xyz(80)=coef_xyz(80)+coef_xy(2,14)*pol_z(2,4,kg)
                coef_xyz(81)=coef_xyz(81)+coef_xy(1,1)*pol_z(1,5,kg)
                coef_xyz(81)=coef_xyz(81)+coef_xy(2,1)*pol_z(2,5,kg)
                coef_xyz(82)=coef_xyz(82)+coef_xy(1,2)*pol_z(1,5,kg)
                coef_xyz(82)=coef_xyz(82)+coef_xy(2,2)*pol_z(2,5,kg)
                coef_xyz(83)=coef_xyz(83)+coef_xy(1,8)*pol_z(1,5,kg)
                coef_xyz(83)=coef_xyz(83)+coef_xy(2,8)*pol_z(2,5,kg)
                coef_xyz(84)=coef_xyz(84)+coef_xy(1,1)*pol_z(1,6,kg)
                coef_xyz(84)=coef_xyz(84)+coef_xy(2,1)*pol_z(2,6,kg)
    END DO

  END SUBROUTINE integrate_core_6
  SUBROUTINE integrate_core_7(grid,coef_xyz,pol_x,pol_y,pol_z,map,sphere_bounds,cmax,gridbounds)
    USE kinds,                        ONLY: dp
    INTEGER, INTENT(IN)                      :: sphere_bounds(*), cmax, &
                                                map(-cmax:cmax,1:3), &
                                                gridbounds(2,3)
    REAL(dp), INTENT(IN) :: grid(gridbounds(1,1):gridbounds(2,1), gridbounds(1&
      ,2):gridbounds(2,2), gridbounds(1,3):gridbounds(2,3))
    INTEGER, PARAMETER                       :: lp = 7
    REAL(dp), INTENT(IN)                     :: pol_x(0:lp,-cmax:cmax), &
                                                pol_y(1:2,0:lp,-cmax:0), &
                                                pol_z(1:2,0:lp,-cmax:0)
    REAL(dp), INTENT(OUT) :: coef_xyz(((lp+1)*(lp+2)*(lp+3))/6)

    INTEGER                                  :: i, ig, igmax, igmin, j, j2, &
                                                jg, jg2, jgmin, k, k2, kg, &
                                                kg2, kgmin, lxp, lxy, lxyz, &
                                                lyp, lzp, sci
    REAL(dp)                                 :: coef_x(4,0:lp), &
                                                coef_xy(2,((lp+1)*(lp+2))/2), &
                                                s01, s02, s03, s04

    sci=1

    coef_xyz=0.0_dp

    kgmin=sphere_bounds(sci)
    sci=sci+1
    DO kg=kgmin,0
       kg2=1-kg
       k=map(kg,3)
       k2=map(kg2,3)

       coef_xy=0.0_dp

       jgmin=sphere_bounds(sci)
       sci=sci+1
       DO jg=jgmin,0
          jg2=1-jg
          j=map(jg,2)
          j2=map(jg2,2)
          igmin=sphere_bounds(sci)
          sci=sci+1
          igmax=1-igmin

          coef_x=0.0_dp
          DO ig=igmin,igmax
             i=map(ig,1)
             s01=grid(i,j,k)
             s02=grid(i,j,k2)
             s03=grid(i,j2,k)
             s04=grid(i,j2,k2)
             DO lxp=0,lp
                coef_x(1,lxp)=coef_x(1,lxp)+s01*pol_x(lxp,ig)
                coef_x(2,lxp)=coef_x(2,lxp)+s02*pol_x(lxp,ig)
                coef_x(3,lxp)=coef_x(3,lxp)+s03*pol_x(lxp,ig)
                coef_x(4,lxp)=coef_x(4,lxp)+s04*pol_x(lxp,ig)
             ENDDO
          END DO
             coef_xy(:,1)=coef_xy(:,1)+coef_x(1:2,0)*pol_y(1,0,jg)
             coef_xy(:,1)=coef_xy(:,1)+coef_x(3:4,0)*pol_y(2,0,jg)
             coef_xy(:,2)=coef_xy(:,2)+coef_x(1:2,1)*pol_y(1,0,jg)
             coef_xy(:,2)=coef_xy(:,2)+coef_x(3:4,1)*pol_y(2,0,jg)
             coef_xy(:,3)=coef_xy(:,3)+coef_x(1:2,2)*pol_y(1,0,jg)
             coef_xy(:,3)=coef_xy(:,3)+coef_x(3:4,2)*pol_y(2,0,jg)
             coef_xy(:,4)=coef_xy(:,4)+coef_x(1:2,3)*pol_y(1,0,jg)
             coef_xy(:,4)=coef_xy(:,4)+coef_x(3:4,3)*pol_y(2,0,jg)
             coef_xy(:,5)=coef_xy(:,5)+coef_x(1:2,4)*pol_y(1,0,jg)
             coef_xy(:,5)=coef_xy(:,5)+coef_x(3:4,4)*pol_y(2,0,jg)
             coef_xy(:,6)=coef_xy(:,6)+coef_x(1:2,5)*pol_y(1,0,jg)
             coef_xy(:,6)=coef_xy(:,6)+coef_x(3:4,5)*pol_y(2,0,jg)
             coef_xy(:,7)=coef_xy(:,7)+coef_x(1:2,6)*pol_y(1,0,jg)
             coef_xy(:,7)=coef_xy(:,7)+coef_x(3:4,6)*pol_y(2,0,jg)
             coef_xy(:,8)=coef_xy(:,8)+coef_x(1:2,7)*pol_y(1,0,jg)
             coef_xy(:,8)=coef_xy(:,8)+coef_x(3:4,7)*pol_y(2,0,jg)
             coef_xy(:,9)=coef_xy(:,9)+coef_x(1:2,0)*pol_y(1,1,jg)
             coef_xy(:,9)=coef_xy(:,9)+coef_x(3:4,0)*pol_y(2,1,jg)
             coef_xy(:,10)=coef_xy(:,10)+coef_x(1:2,1)*pol_y(1,1,jg)
             coef_xy(:,10)=coef_xy(:,10)+coef_x(3:4,1)*pol_y(2,1,jg)
             coef_xy(:,11)=coef_xy(:,11)+coef_x(1:2,2)*pol_y(1,1,jg)
             coef_xy(:,11)=coef_xy(:,11)+coef_x(3:4,2)*pol_y(2,1,jg)
             coef_xy(:,12)=coef_xy(:,12)+coef_x(1:2,3)*pol_y(1,1,jg)
             coef_xy(:,12)=coef_xy(:,12)+coef_x(3:4,3)*pol_y(2,1,jg)
             coef_xy(:,13)=coef_xy(:,13)+coef_x(1:2,4)*pol_y(1,1,jg)
             coef_xy(:,13)=coef_xy(:,13)+coef_x(3:4,4)*pol_y(2,1,jg)
             coef_xy(:,14)=coef_xy(:,14)+coef_x(1:2,5)*pol_y(1,1,jg)
             coef_xy(:,14)=coef_xy(:,14)+coef_x(3:4,5)*pol_y(2,1,jg)
             coef_xy(:,15)=coef_xy(:,15)+coef_x(1:2,6)*pol_y(1,1,jg)
             coef_xy(:,15)=coef_xy(:,15)+coef_x(3:4,6)*pol_y(2,1,jg)
             coef_xy(:,16)=coef_xy(:,16)+coef_x(1:2,0)*pol_y(1,2,jg)
             coef_xy(:,16)=coef_xy(:,16)+coef_x(3:4,0)*pol_y(2,2,jg)
             coef_xy(:,17)=coef_xy(:,17)+coef_x(1:2,1)*pol_y(1,2,jg)
             coef_xy(:,17)=coef_xy(:,17)+coef_x(3:4,1)*pol_y(2,2,jg)
             coef_xy(:,18)=coef_xy(:,18)+coef_x(1:2,2)*pol_y(1,2,jg)
             coef_xy(:,18)=coef_xy(:,18)+coef_x(3:4,2)*pol_y(2,2,jg)
             coef_xy(:,19)=coef_xy(:,19)+coef_x(1:2,3)*pol_y(1,2,jg)
             coef_xy(:,19)=coef_xy(:,19)+coef_x(3:4,3)*pol_y(2,2,jg)
             coef_xy(:,20)=coef_xy(:,20)+coef_x(1:2,4)*pol_y(1,2,jg)
             coef_xy(:,20)=coef_xy(:,20)+coef_x(3:4,4)*pol_y(2,2,jg)
             coef_xy(:,21)=coef_xy(:,21)+coef_x(1:2,5)*pol_y(1,2,jg)
             coef_xy(:,21)=coef_xy(:,21)+coef_x(3:4,5)*pol_y(2,2,jg)
             coef_xy(:,22)=coef_xy(:,22)+coef_x(1:2,0)*pol_y(1,3,jg)
             coef_xy(:,22)=coef_xy(:,22)+coef_x(3:4,0)*pol_y(2,3,jg)
             coef_xy(:,23)=coef_xy(:,23)+coef_x(1:2,1)*pol_y(1,3,jg)
             coef_xy(:,23)=coef_xy(:,23)+coef_x(3:4,1)*pol_y(2,3,jg)
             coef_xy(:,24)=coef_xy(:,24)+coef_x(1:2,2)*pol_y(1,3,jg)
             coef_xy(:,24)=coef_xy(:,24)+coef_x(3:4,2)*pol_y(2,3,jg)
             coef_xy(:,25)=coef_xy(:,25)+coef_x(1:2,3)*pol_y(1,3,jg)
             coef_xy(:,25)=coef_xy(:,25)+coef_x(3:4,3)*pol_y(2,3,jg)
             coef_xy(:,26)=coef_xy(:,26)+coef_x(1:2,4)*pol_y(1,3,jg)
             coef_xy(:,26)=coef_xy(:,26)+coef_x(3:4,4)*pol_y(2,3,jg)
             coef_xy(:,27)=coef_xy(:,27)+coef_x(1:2,0)*pol_y(1,4,jg)
             coef_xy(:,27)=coef_xy(:,27)+coef_x(3:4,0)*pol_y(2,4,jg)
             coef_xy(:,28)=coef_xy(:,28)+coef_x(1:2,1)*pol_y(1,4,jg)
             coef_xy(:,28)=coef_xy(:,28)+coef_x(3:4,1)*pol_y(2,4,jg)
             coef_xy(:,29)=coef_xy(:,29)+coef_x(1:2,2)*pol_y(1,4,jg)
             coef_xy(:,29)=coef_xy(:,29)+coef_x(3:4,2)*pol_y(2,4,jg)
             coef_xy(:,30)=coef_xy(:,30)+coef_x(1:2,3)*pol_y(1,4,jg)
             coef_xy(:,30)=coef_xy(:,30)+coef_x(3:4,3)*pol_y(2,4,jg)
             coef_xy(:,31)=coef_xy(:,31)+coef_x(1:2,0)*pol_y(1,5,jg)
             coef_xy(:,31)=coef_xy(:,31)+coef_x(3:4,0)*pol_y(2,5,jg)
             coef_xy(:,32)=coef_xy(:,32)+coef_x(1:2,1)*pol_y(1,5,jg)
             coef_xy(:,32)=coef_xy(:,32)+coef_x(3:4,1)*pol_y(2,5,jg)
             coef_xy(:,33)=coef_xy(:,33)+coef_x(1:2,2)*pol_y(1,5,jg)
             coef_xy(:,33)=coef_xy(:,33)+coef_x(3:4,2)*pol_y(2,5,jg)
             coef_xy(:,34)=coef_xy(:,34)+coef_x(1:2,0)*pol_y(1,6,jg)
             coef_xy(:,34)=coef_xy(:,34)+coef_x(3:4,0)*pol_y(2,6,jg)
             coef_xy(:,35)=coef_xy(:,35)+coef_x(1:2,1)*pol_y(1,6,jg)
             coef_xy(:,35)=coef_xy(:,35)+coef_x(3:4,1)*pol_y(2,6,jg)
             coef_xy(:,36)=coef_xy(:,36)+coef_x(1:2,0)*pol_y(1,7,jg)
             coef_xy(:,36)=coef_xy(:,36)+coef_x(3:4,0)*pol_y(2,7,jg)
       END DO
       lxyz = 0
       DO lzp=0,lp
          lxy=0
          DO lyp=0,lp-lzp
             DO lxp=0,lp-lzp-lyp
                lxyz=lxyz+1 ; lxy=lxy+1
                coef_xyz(lxyz)=coef_xyz(lxyz)+coef_xy(1,lxy)*pol_z(1,lzp,kg)
                coef_xyz(lxyz)=coef_xyz(lxyz)+coef_xy(2,lxy)*pol_z(2,lzp,kg)
             ENDDO
             lxy=lxy+lzp
          ENDDO
       ENDDO
    END DO

  END SUBROUTINE integrate_core_7
  SUBROUTINE integrate_core_8(grid,coef_xyz,pol_x,pol_y,pol_z,map,sphere_bounds,cmax,gridbounds)
    USE kinds,                        ONLY: dp
    INTEGER, INTENT(IN)                      :: sphere_bounds(*), cmax, &
                                                map(-cmax:cmax,1:3), &
                                                gridbounds(2,3)
    REAL(dp), INTENT(IN) :: grid(gridbounds(1,1):gridbounds(2,1), gridbounds(1&
      ,2):gridbounds(2,2), gridbounds(1,3):gridbounds(2,3))
    INTEGER, PARAMETER                       :: lp = 8
    REAL(dp), INTENT(IN)                     :: pol_x(0:lp,-cmax:cmax), &
                                                pol_y(1:2,0:lp,-cmax:0), &
                                                pol_z(1:2,0:lp,-cmax:0)
    REAL(dp), INTENT(OUT) :: coef_xyz(((lp+1)*(lp+2)*(lp+3))/6)

    INTEGER                                  :: i, ig, igmax, igmin, j, j2, &
                                                jg, jg2, jgmin, k, k2, kg, &
                                                kg2, kgmin, lxp, lxy, lxyz, &
                                                lyp, lzp, sci
    REAL(dp)                                 :: coef_x(4,0:lp), &
                                                coef_xy(2,((lp+1)*(lp+2))/2), &
                                                s01, s02, s03, s04

    sci=1

    coef_xyz=0.0_dp

    kgmin=sphere_bounds(sci)
    sci=sci+1
    DO kg=kgmin,0
       kg2=1-kg
       k=map(kg,3)
       k2=map(kg2,3)

       coef_xy=0.0_dp

       jgmin=sphere_bounds(sci)
       sci=sci+1
       DO jg=jgmin,0
          jg2=1-jg
          j=map(jg,2)
          j2=map(jg2,2)
          igmin=sphere_bounds(sci)
          sci=sci+1
          igmax=1-igmin

          coef_x=0.0_dp
          DO ig=igmin,igmax
             i=map(ig,1)
             s01=grid(i,j,k)
             s02=grid(i,j,k2)
             s03=grid(i,j2,k)
             s04=grid(i,j2,k2)
             DO lxp=0,lp
                coef_x(1,lxp)=coef_x(1,lxp)+s01*pol_x(lxp,ig)
                coef_x(2,lxp)=coef_x(2,lxp)+s02*pol_x(lxp,ig)
                coef_x(3,lxp)=coef_x(3,lxp)+s03*pol_x(lxp,ig)
                coef_x(4,lxp)=coef_x(4,lxp)+s04*pol_x(lxp,ig)
             ENDDO
          END DO
             coef_xy(:,1)=coef_xy(:,1)+coef_x(1:2,0)*pol_y(1,0,jg)
             coef_xy(:,1)=coef_xy(:,1)+coef_x(3:4,0)*pol_y(2,0,jg)
             coef_xy(:,2)=coef_xy(:,2)+coef_x(1:2,1)*pol_y(1,0,jg)
             coef_xy(:,2)=coef_xy(:,2)+coef_x(3:4,1)*pol_y(2,0,jg)
             coef_xy(:,3)=coef_xy(:,3)+coef_x(1:2,2)*pol_y(1,0,jg)
             coef_xy(:,3)=coef_xy(:,3)+coef_x(3:4,2)*pol_y(2,0,jg)
             coef_xy(:,4)=coef_xy(:,4)+coef_x(1:2,3)*pol_y(1,0,jg)
             coef_xy(:,4)=coef_xy(:,4)+coef_x(3:4,3)*pol_y(2,0,jg)
             coef_xy(:,5)=coef_xy(:,5)+coef_x(1:2,4)*pol_y(1,0,jg)
             coef_xy(:,5)=coef_xy(:,5)+coef_x(3:4,4)*pol_y(2,0,jg)
             coef_xy(:,6)=coef_xy(:,6)+coef_x(1:2,5)*pol_y(1,0,jg)
             coef_xy(:,6)=coef_xy(:,6)+coef_x(3:4,5)*pol_y(2,0,jg)
             coef_xy(:,7)=coef_xy(:,7)+coef_x(1:2,6)*pol_y(1,0,jg)
             coef_xy(:,7)=coef_xy(:,7)+coef_x(3:4,6)*pol_y(2,0,jg)
             coef_xy(:,8)=coef_xy(:,8)+coef_x(1:2,7)*pol_y(1,0,jg)
             coef_xy(:,8)=coef_xy(:,8)+coef_x(3:4,7)*pol_y(2,0,jg)
             coef_xy(:,9)=coef_xy(:,9)+coef_x(1:2,8)*pol_y(1,0,jg)
             coef_xy(:,9)=coef_xy(:,9)+coef_x(3:4,8)*pol_y(2,0,jg)
             coef_xy(:,10)=coef_xy(:,10)+coef_x(1:2,0)*pol_y(1,1,jg)
             coef_xy(:,10)=coef_xy(:,10)+coef_x(3:4,0)*pol_y(2,1,jg)
             coef_xy(:,11)=coef_xy(:,11)+coef_x(1:2,1)*pol_y(1,1,jg)
             coef_xy(:,11)=coef_xy(:,11)+coef_x(3:4,1)*pol_y(2,1,jg)
             coef_xy(:,12)=coef_xy(:,12)+coef_x(1:2,2)*pol_y(1,1,jg)
             coef_xy(:,12)=coef_xy(:,12)+coef_x(3:4,2)*pol_y(2,1,jg)
             coef_xy(:,13)=coef_xy(:,13)+coef_x(1:2,3)*pol_y(1,1,jg)
             coef_xy(:,13)=coef_xy(:,13)+coef_x(3:4,3)*pol_y(2,1,jg)
             coef_xy(:,14)=coef_xy(:,14)+coef_x(1:2,4)*pol_y(1,1,jg)
             coef_xy(:,14)=coef_xy(:,14)+coef_x(3:4,4)*pol_y(2,1,jg)
             coef_xy(:,15)=coef_xy(:,15)+coef_x(1:2,5)*pol_y(1,1,jg)
             coef_xy(:,15)=coef_xy(:,15)+coef_x(3:4,5)*pol_y(2,1,jg)
             coef_xy(:,16)=coef_xy(:,16)+coef_x(1:2,6)*pol_y(1,1,jg)
             coef_xy(:,16)=coef_xy(:,16)+coef_x(3:4,6)*pol_y(2,1,jg)
             coef_xy(:,17)=coef_xy(:,17)+coef_x(1:2,7)*pol_y(1,1,jg)
             coef_xy(:,17)=coef_xy(:,17)+coef_x(3:4,7)*pol_y(2,1,jg)
             coef_xy(:,18)=coef_xy(:,18)+coef_x(1:2,0)*pol_y(1,2,jg)
             coef_xy(:,18)=coef_xy(:,18)+coef_x(3:4,0)*pol_y(2,2,jg)
             coef_xy(:,19)=coef_xy(:,19)+coef_x(1:2,1)*pol_y(1,2,jg)
             coef_xy(:,19)=coef_xy(:,19)+coef_x(3:4,1)*pol_y(2,2,jg)
             coef_xy(:,20)=coef_xy(:,20)+coef_x(1:2,2)*pol_y(1,2,jg)
             coef_xy(:,20)=coef_xy(:,20)+coef_x(3:4,2)*pol_y(2,2,jg)
             coef_xy(:,21)=coef_xy(:,21)+coef_x(1:2,3)*pol_y(1,2,jg)
             coef_xy(:,21)=coef_xy(:,21)+coef_x(3:4,3)*pol_y(2,2,jg)
             coef_xy(:,22)=coef_xy(:,22)+coef_x(1:2,4)*pol_y(1,2,jg)
             coef_xy(:,22)=coef_xy(:,22)+coef_x(3:4,4)*pol_y(2,2,jg)
             coef_xy(:,23)=coef_xy(:,23)+coef_x(1:2,5)*pol_y(1,2,jg)
             coef_xy(:,23)=coef_xy(:,23)+coef_x(3:4,5)*pol_y(2,2,jg)
             coef_xy(:,24)=coef_xy(:,24)+coef_x(1:2,6)*pol_y(1,2,jg)
             coef_xy(:,24)=coef_xy(:,24)+coef_x(3:4,6)*pol_y(2,2,jg)
             coef_xy(:,25)=coef_xy(:,25)+coef_x(1:2,0)*pol_y(1,3,jg)
             coef_xy(:,25)=coef_xy(:,25)+coef_x(3:4,0)*pol_y(2,3,jg)
             coef_xy(:,26)=coef_xy(:,26)+coef_x(1:2,1)*pol_y(1,3,jg)
             coef_xy(:,26)=coef_xy(:,26)+coef_x(3:4,1)*pol_y(2,3,jg)
             coef_xy(:,27)=coef_xy(:,27)+coef_x(1:2,2)*pol_y(1,3,jg)
             coef_xy(:,27)=coef_xy(:,27)+coef_x(3:4,2)*pol_y(2,3,jg)
             coef_xy(:,28)=coef_xy(:,28)+coef_x(1:2,3)*pol_y(1,3,jg)
             coef_xy(:,28)=coef_xy(:,28)+coef_x(3:4,3)*pol_y(2,3,jg)
             coef_xy(:,29)=coef_xy(:,29)+coef_x(1:2,4)*pol_y(1,3,jg)
             coef_xy(:,29)=coef_xy(:,29)+coef_x(3:4,4)*pol_y(2,3,jg)
             coef_xy(:,30)=coef_xy(:,30)+coef_x(1:2,5)*pol_y(1,3,jg)
             coef_xy(:,30)=coef_xy(:,30)+coef_x(3:4,5)*pol_y(2,3,jg)
             coef_xy(:,31)=coef_xy(:,31)+coef_x(1:2,0)*pol_y(1,4,jg)
             coef_xy(:,31)=coef_xy(:,31)+coef_x(3:4,0)*pol_y(2,4,jg)
             coef_xy(:,32)=coef_xy(:,32)+coef_x(1:2,1)*pol_y(1,4,jg)
             coef_xy(:,32)=coef_xy(:,32)+coef_x(3:4,1)*pol_y(2,4,jg)
             coef_xy(:,33)=coef_xy(:,33)+coef_x(1:2,2)*pol_y(1,4,jg)
             coef_xy(:,33)=coef_xy(:,33)+coef_x(3:4,2)*pol_y(2,4,jg)
             coef_xy(:,34)=coef_xy(:,34)+coef_x(1:2,3)*pol_y(1,4,jg)
             coef_xy(:,34)=coef_xy(:,34)+coef_x(3:4,3)*pol_y(2,4,jg)
             coef_xy(:,35)=coef_xy(:,35)+coef_x(1:2,4)*pol_y(1,4,jg)
             coef_xy(:,35)=coef_xy(:,35)+coef_x(3:4,4)*pol_y(2,4,jg)
             coef_xy(:,36)=coef_xy(:,36)+coef_x(1:2,0)*pol_y(1,5,jg)
             coef_xy(:,36)=coef_xy(:,36)+coef_x(3:4,0)*pol_y(2,5,jg)
             coef_xy(:,37)=coef_xy(:,37)+coef_x(1:2,1)*pol_y(1,5,jg)
             coef_xy(:,37)=coef_xy(:,37)+coef_x(3:4,1)*pol_y(2,5,jg)
             coef_xy(:,38)=coef_xy(:,38)+coef_x(1:2,2)*pol_y(1,5,jg)
             coef_xy(:,38)=coef_xy(:,38)+coef_x(3:4,2)*pol_y(2,5,jg)
             coef_xy(:,39)=coef_xy(:,39)+coef_x(1:2,3)*pol_y(1,5,jg)
             coef_xy(:,39)=coef_xy(:,39)+coef_x(3:4,3)*pol_y(2,5,jg)
             coef_xy(:,40)=coef_xy(:,40)+coef_x(1:2,0)*pol_y(1,6,jg)
             coef_xy(:,40)=coef_xy(:,40)+coef_x(3:4,0)*pol_y(2,6,jg)
             coef_xy(:,41)=coef_xy(:,41)+coef_x(1:2,1)*pol_y(1,6,jg)
             coef_xy(:,41)=coef_xy(:,41)+coef_x(3:4,1)*pol_y(2,6,jg)
             coef_xy(:,42)=coef_xy(:,42)+coef_x(1:2,2)*pol_y(1,6,jg)
             coef_xy(:,42)=coef_xy(:,42)+coef_x(3:4,2)*pol_y(2,6,jg)
             coef_xy(:,43)=coef_xy(:,43)+coef_x(1:2,0)*pol_y(1,7,jg)
             coef_xy(:,43)=coef_xy(:,43)+coef_x(3:4,0)*pol_y(2,7,jg)
             coef_xy(:,44)=coef_xy(:,44)+coef_x(1:2,1)*pol_y(1,7,jg)
             coef_xy(:,44)=coef_xy(:,44)+coef_x(3:4,1)*pol_y(2,7,jg)
             coef_xy(:,45)=coef_xy(:,45)+coef_x(1:2,0)*pol_y(1,8,jg)
             coef_xy(:,45)=coef_xy(:,45)+coef_x(3:4,0)*pol_y(2,8,jg)
       END DO
       lxyz = 0
       DO lzp=0,lp
          lxy=0
          DO lyp=0,lp-lzp
             DO lxp=0,lp-lzp-lyp
                lxyz=lxyz+1 ; lxy=lxy+1
                coef_xyz(lxyz)=coef_xyz(lxyz)+coef_xy(1,lxy)*pol_z(1,lzp,kg)
                coef_xyz(lxyz)=coef_xyz(lxyz)+coef_xy(2,lxy)*pol_z(2,lzp,kg)
             ENDDO
             lxy=lxy+lzp
          ENDDO
       ENDDO
    END DO

  END SUBROUTINE integrate_core_8
  SUBROUTINE integrate_core_9(grid,coef_xyz,pol_x,pol_y,pol_z,map,sphere_bounds,cmax,gridbounds)
    USE kinds,                        ONLY: dp
    INTEGER, INTENT(IN)                      :: sphere_bounds(*), cmax, &
                                                map(-cmax:cmax,1:3), &
                                                gridbounds(2,3)
    REAL(dp), INTENT(IN) :: grid(gridbounds(1,1):gridbounds(2,1), gridbounds(1&
      ,2):gridbounds(2,2), gridbounds(1,3):gridbounds(2,3))
    INTEGER, PARAMETER                       :: lp = 9
    REAL(dp), INTENT(IN)                     :: pol_x(0:lp,-cmax:cmax), &
                                                pol_y(1:2,0:lp,-cmax:0), &
                                                pol_z(1:2,0:lp,-cmax:0)
    REAL(dp), INTENT(OUT) :: coef_xyz(((lp+1)*(lp+2)*(lp+3))/6)

    INTEGER                                  :: i, ig, igmax, igmin, j, j2, &
                                                jg, jg2, jgmin, k, k2, kg, &
                                                kg2, kgmin, lxp, lxy, lxyz, &
                                                lyp, lzp, sci
    REAL(dp)                                 :: coef_x(4,0:lp), &
                                                coef_xy(2,((lp+1)*(lp+2))/2), &
                                                s01, s02, s03, s04

    sci=1

    coef_xyz=0.0_dp

    kgmin=sphere_bounds(sci)
    sci=sci+1
    DO kg=kgmin,0
       kg2=1-kg
       k=map(kg,3)
       k2=map(kg2,3)

       coef_xy=0.0_dp

       jgmin=sphere_bounds(sci)
       sci=sci+1
       DO jg=jgmin,0
          jg2=1-jg
          j=map(jg,2)
          j2=map(jg2,2)
          igmin=sphere_bounds(sci)
          sci=sci+1
          igmax=1-igmin

          coef_x=0.0_dp
          DO ig=igmin,igmax
             i=map(ig,1)
             s01=grid(i,j,k)
             s02=grid(i,j,k2)
             s03=grid(i,j2,k)
             s04=grid(i,j2,k2)
             DO lxp=0,lp
                coef_x(1,lxp)=coef_x(1,lxp)+s01*pol_x(lxp,ig)
                coef_x(2,lxp)=coef_x(2,lxp)+s02*pol_x(lxp,ig)
                coef_x(3,lxp)=coef_x(3,lxp)+s03*pol_x(lxp,ig)
                coef_x(4,lxp)=coef_x(4,lxp)+s04*pol_x(lxp,ig)
             ENDDO
          END DO
             coef_xy(:,1)=coef_xy(:,1)+coef_x(1:2,0)*pol_y(1,0,jg)
             coef_xy(:,1)=coef_xy(:,1)+coef_x(3:4,0)*pol_y(2,0,jg)
             coef_xy(:,2)=coef_xy(:,2)+coef_x(1:2,1)*pol_y(1,0,jg)
             coef_xy(:,2)=coef_xy(:,2)+coef_x(3:4,1)*pol_y(2,0,jg)
             coef_xy(:,3)=coef_xy(:,3)+coef_x(1:2,2)*pol_y(1,0,jg)
             coef_xy(:,3)=coef_xy(:,3)+coef_x(3:4,2)*pol_y(2,0,jg)
             coef_xy(:,4)=coef_xy(:,4)+coef_x(1:2,3)*pol_y(1,0,jg)
             coef_xy(:,4)=coef_xy(:,4)+coef_x(3:4,3)*pol_y(2,0,jg)
             coef_xy(:,5)=coef_xy(:,5)+coef_x(1:2,4)*pol_y(1,0,jg)
             coef_xy(:,5)=coef_xy(:,5)+coef_x(3:4,4)*pol_y(2,0,jg)
             coef_xy(:,6)=coef_xy(:,6)+coef_x(1:2,5)*pol_y(1,0,jg)
             coef_xy(:,6)=coef_xy(:,6)+coef_x(3:4,5)*pol_y(2,0,jg)
             coef_xy(:,7)=coef_xy(:,7)+coef_x(1:2,6)*pol_y(1,0,jg)
             coef_xy(:,7)=coef_xy(:,7)+coef_x(3:4,6)*pol_y(2,0,jg)
             coef_xy(:,8)=coef_xy(:,8)+coef_x(1:2,7)*pol_y(1,0,jg)
             coef_xy(:,8)=coef_xy(:,8)+coef_x(3:4,7)*pol_y(2,0,jg)
             coef_xy(:,9)=coef_xy(:,9)+coef_x(1:2,8)*pol_y(1,0,jg)
             coef_xy(:,9)=coef_xy(:,9)+coef_x(3:4,8)*pol_y(2,0,jg)
             coef_xy(:,10)=coef_xy(:,10)+coef_x(1:2,9)*pol_y(1,0,jg)
             coef_xy(:,10)=coef_xy(:,10)+coef_x(3:4,9)*pol_y(2,0,jg)
             coef_xy(:,11)=coef_xy(:,11)+coef_x(1:2,0)*pol_y(1,1,jg)
             coef_xy(:,11)=coef_xy(:,11)+coef_x(3:4,0)*pol_y(2,1,jg)
             coef_xy(:,12)=coef_xy(:,12)+coef_x(1:2,1)*pol_y(1,1,jg)
             coef_xy(:,12)=coef_xy(:,12)+coef_x(3:4,1)*pol_y(2,1,jg)
             coef_xy(:,13)=coef_xy(:,13)+coef_x(1:2,2)*pol_y(1,1,jg)
             coef_xy(:,13)=coef_xy(:,13)+coef_x(3:4,2)*pol_y(2,1,jg)
             coef_xy(:,14)=coef_xy(:,14)+coef_x(1:2,3)*pol_y(1,1,jg)
             coef_xy(:,14)=coef_xy(:,14)+coef_x(3:4,3)*pol_y(2,1,jg)
             coef_xy(:,15)=coef_xy(:,15)+coef_x(1:2,4)*pol_y(1,1,jg)
             coef_xy(:,15)=coef_xy(:,15)+coef_x(3:4,4)*pol_y(2,1,jg)
             coef_xy(:,16)=coef_xy(:,16)+coef_x(1:2,5)*pol_y(1,1,jg)
             coef_xy(:,16)=coef_xy(:,16)+coef_x(3:4,5)*pol_y(2,1,jg)
             coef_xy(:,17)=coef_xy(:,17)+coef_x(1:2,6)*pol_y(1,1,jg)
             coef_xy(:,17)=coef_xy(:,17)+coef_x(3:4,6)*pol_y(2,1,jg)
             coef_xy(:,18)=coef_xy(:,18)+coef_x(1:2,7)*pol_y(1,1,jg)
             coef_xy(:,18)=coef_xy(:,18)+coef_x(3:4,7)*pol_y(2,1,jg)
             coef_xy(:,19)=coef_xy(:,19)+coef_x(1:2,8)*pol_y(1,1,jg)
             coef_xy(:,19)=coef_xy(:,19)+coef_x(3:4,8)*pol_y(2,1,jg)
             coef_xy(:,20)=coef_xy(:,20)+coef_x(1:2,0)*pol_y(1,2,jg)
             coef_xy(:,20)=coef_xy(:,20)+coef_x(3:4,0)*pol_y(2,2,jg)
             coef_xy(:,21)=coef_xy(:,21)+coef_x(1:2,1)*pol_y(1,2,jg)
             coef_xy(:,21)=coef_xy(:,21)+coef_x(3:4,1)*pol_y(2,2,jg)
             coef_xy(:,22)=coef_xy(:,22)+coef_x(1:2,2)*pol_y(1,2,jg)
             coef_xy(:,22)=coef_xy(:,22)+coef_x(3:4,2)*pol_y(2,2,jg)
             coef_xy(:,23)=coef_xy(:,23)+coef_x(1:2,3)*pol_y(1,2,jg)
             coef_xy(:,23)=coef_xy(:,23)+coef_x(3:4,3)*pol_y(2,2,jg)
             coef_xy(:,24)=coef_xy(:,24)+coef_x(1:2,4)*pol_y(1,2,jg)
             coef_xy(:,24)=coef_xy(:,24)+coef_x(3:4,4)*pol_y(2,2,jg)
             coef_xy(:,25)=coef_xy(:,25)+coef_x(1:2,5)*pol_y(1,2,jg)
             coef_xy(:,25)=coef_xy(:,25)+coef_x(3:4,5)*pol_y(2,2,jg)
             coef_xy(:,26)=coef_xy(:,26)+coef_x(1:2,6)*pol_y(1,2,jg)
             coef_xy(:,26)=coef_xy(:,26)+coef_x(3:4,6)*pol_y(2,2,jg)
             coef_xy(:,27)=coef_xy(:,27)+coef_x(1:2,7)*pol_y(1,2,jg)
             coef_xy(:,27)=coef_xy(:,27)+coef_x(3:4,7)*pol_y(2,2,jg)
             coef_xy(:,28)=coef_xy(:,28)+coef_x(1:2,0)*pol_y(1,3,jg)
             coef_xy(:,28)=coef_xy(:,28)+coef_x(3:4,0)*pol_y(2,3,jg)
             coef_xy(:,29)=coef_xy(:,29)+coef_x(1:2,1)*pol_y(1,3,jg)
             coef_xy(:,29)=coef_xy(:,29)+coef_x(3:4,1)*pol_y(2,3,jg)
             coef_xy(:,30)=coef_xy(:,30)+coef_x(1:2,2)*pol_y(1,3,jg)
             coef_xy(:,30)=coef_xy(:,30)+coef_x(3:4,2)*pol_y(2,3,jg)
             coef_xy(:,31)=coef_xy(:,31)+coef_x(1:2,3)*pol_y(1,3,jg)
             coef_xy(:,31)=coef_xy(:,31)+coef_x(3:4,3)*pol_y(2,3,jg)
             coef_xy(:,32)=coef_xy(:,32)+coef_x(1:2,4)*pol_y(1,3,jg)
             coef_xy(:,32)=coef_xy(:,32)+coef_x(3:4,4)*pol_y(2,3,jg)
             coef_xy(:,33)=coef_xy(:,33)+coef_x(1:2,5)*pol_y(1,3,jg)
             coef_xy(:,33)=coef_xy(:,33)+coef_x(3:4,5)*pol_y(2,3,jg)
             coef_xy(:,34)=coef_xy(:,34)+coef_x(1:2,6)*pol_y(1,3,jg)
             coef_xy(:,34)=coef_xy(:,34)+coef_x(3:4,6)*pol_y(2,3,jg)
             coef_xy(:,35)=coef_xy(:,35)+coef_x(1:2,0)*pol_y(1,4,jg)
             coef_xy(:,35)=coef_xy(:,35)+coef_x(3:4,0)*pol_y(2,4,jg)
             coef_xy(:,36)=coef_xy(:,36)+coef_x(1:2,1)*pol_y(1,4,jg)
             coef_xy(:,36)=coef_xy(:,36)+coef_x(3:4,1)*pol_y(2,4,jg)
             coef_xy(:,37)=coef_xy(:,37)+coef_x(1:2,2)*pol_y(1,4,jg)
             coef_xy(:,37)=coef_xy(:,37)+coef_x(3:4,2)*pol_y(2,4,jg)
             coef_xy(:,38)=coef_xy(:,38)+coef_x(1:2,3)*pol_y(1,4,jg)
             coef_xy(:,38)=coef_xy(:,38)+coef_x(3:4,3)*pol_y(2,4,jg)
             coef_xy(:,39)=coef_xy(:,39)+coef_x(1:2,4)*pol_y(1,4,jg)
             coef_xy(:,39)=coef_xy(:,39)+coef_x(3:4,4)*pol_y(2,4,jg)
             coef_xy(:,40)=coef_xy(:,40)+coef_x(1:2,5)*pol_y(1,4,jg)
             coef_xy(:,40)=coef_xy(:,40)+coef_x(3:4,5)*pol_y(2,4,jg)
             coef_xy(:,41)=coef_xy(:,41)+coef_x(1:2,0)*pol_y(1,5,jg)
             coef_xy(:,41)=coef_xy(:,41)+coef_x(3:4,0)*pol_y(2,5,jg)
             coef_xy(:,42)=coef_xy(:,42)+coef_x(1:2,1)*pol_y(1,5,jg)
             coef_xy(:,42)=coef_xy(:,42)+coef_x(3:4,1)*pol_y(2,5,jg)
             coef_xy(:,43)=coef_xy(:,43)+coef_x(1:2,2)*pol_y(1,5,jg)
             coef_xy(:,43)=coef_xy(:,43)+coef_x(3:4,2)*pol_y(2,5,jg)
             coef_xy(:,44)=coef_xy(:,44)+coef_x(1:2,3)*pol_y(1,5,jg)
             coef_xy(:,44)=coef_xy(:,44)+coef_x(3:4,3)*pol_y(2,5,jg)
             coef_xy(:,45)=coef_xy(:,45)+coef_x(1:2,4)*pol_y(1,5,jg)
             coef_xy(:,45)=coef_xy(:,45)+coef_x(3:4,4)*pol_y(2,5,jg)
             coef_xy(:,46)=coef_xy(:,46)+coef_x(1:2,0)*pol_y(1,6,jg)
             coef_xy(:,46)=coef_xy(:,46)+coef_x(3:4,0)*pol_y(2,6,jg)
             coef_xy(:,47)=coef_xy(:,47)+coef_x(1:2,1)*pol_y(1,6,jg)
             coef_xy(:,47)=coef_xy(:,47)+coef_x(3:4,1)*pol_y(2,6,jg)
             coef_xy(:,48)=coef_xy(:,48)+coef_x(1:2,2)*pol_y(1,6,jg)
             coef_xy(:,48)=coef_xy(:,48)+coef_x(3:4,2)*pol_y(2,6,jg)
             coef_xy(:,49)=coef_xy(:,49)+coef_x(1:2,3)*pol_y(1,6,jg)
             coef_xy(:,49)=coef_xy(:,49)+coef_x(3:4,3)*pol_y(2,6,jg)
             coef_xy(:,50)=coef_xy(:,50)+coef_x(1:2,0)*pol_y(1,7,jg)
             coef_xy(:,50)=coef_xy(:,50)+coef_x(3:4,0)*pol_y(2,7,jg)
             coef_xy(:,51)=coef_xy(:,51)+coef_x(1:2,1)*pol_y(1,7,jg)
             coef_xy(:,51)=coef_xy(:,51)+coef_x(3:4,1)*pol_y(2,7,jg)
             coef_xy(:,52)=coef_xy(:,52)+coef_x(1:2,2)*pol_y(1,7,jg)
             coef_xy(:,52)=coef_xy(:,52)+coef_x(3:4,2)*pol_y(2,7,jg)
             coef_xy(:,53)=coef_xy(:,53)+coef_x(1:2,0)*pol_y(1,8,jg)
             coef_xy(:,53)=coef_xy(:,53)+coef_x(3:4,0)*pol_y(2,8,jg)
             coef_xy(:,54)=coef_xy(:,54)+coef_x(1:2,1)*pol_y(1,8,jg)
             coef_xy(:,54)=coef_xy(:,54)+coef_x(3:4,1)*pol_y(2,8,jg)
             coef_xy(:,55)=coef_xy(:,55)+coef_x(1:2,0)*pol_y(1,9,jg)
             coef_xy(:,55)=coef_xy(:,55)+coef_x(3:4,0)*pol_y(2,9,jg)
       END DO
       lxyz = 0
       DO lzp=0,lp
          lxy=0
          DO lyp=0,lp-lzp
             DO lxp=0,lp-lzp-lyp
                lxyz=lxyz+1 ; lxy=lxy+1
                coef_xyz(lxyz)=coef_xyz(lxyz)+coef_xy(1,lxy)*pol_z(1,lzp,kg)
                coef_xyz(lxyz)=coef_xyz(lxyz)+coef_xy(2,lxy)*pol_z(2,lzp,kg)
             ENDDO
             lxy=lxy+lzp
          ENDDO
       ENDDO
    END DO

  END SUBROUTINE integrate_core_9
