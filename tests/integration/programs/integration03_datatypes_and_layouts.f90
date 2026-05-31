program integration03

implicit none

integer, parameter :: MPI_COMM_WORLD = 0
integer, parameter :: MPI_INTEGER    = 1
integer, parameter :: MPI_REAL       = 2
integer, parameter :: MPI_COMPLEX    = 3
integer, parameter :: MPI_BYTE       = 4

integer :: size

integer :: a(5)
real    :: r(10)
complex :: c(5)

! ----------------------------------------------------
! Non-BIND(C) derived type
! ----------------------------------------------------

type :: particle

  integer :: id
  real    :: mass

end type

! ----------------------------------------------------
! Valid BIND(C) derived type
! ----------------------------------------------------

type, bind(C) :: good_particle

  integer :: id
  real    :: mass

end type

type(particle)      :: p
type(good_particle) :: gp

! ----------------------------------------------------
! 1. Datatype mismatch
! ----------------------------------------------------

call mpi_send(r, 10, MPI_INTEGER, 1, 0, MPI_COMM_WORLD)

call mpi_send(c, 5, MPI_REAL, 1, 0, MPI_COMM_WORLD)

! ----------------------------------------------------
! 2. Non-contiguous array section
! ----------------------------------------------------

call mpi_send(a(1:5:2), 3, MPI_INTEGER, 1, 0, MPI_COMM_WORLD)

! ----------------------------------------------------
! 3. Dynamic count
! ----------------------------------------------------

call mpi_send(a, size * 4, MPI_INTEGER, 1, 0, MPI_COMM_WORLD)

! ----------------------------------------------------
! 4. Derived type without BIND(C)
! ----------------------------------------------------

call mpi_send(p, 1, MPI_BYTE, 1, 0, MPI_COMM_WORLD)

! ----------------------------------------------------
! 5. Derived layout mismatch
! ----------------------------------------------------

call mpi_send(p, 1, MPI_INTEGER, 1, 0, MPI_COMM_WORLD)

! ----------------------------------------------------
! 6. Valid BIND(C) type
! ----------------------------------------------------

call mpi_send(gp, 1, MPI_BYTE, 1, 0, MPI_COMM_WORLD)

end