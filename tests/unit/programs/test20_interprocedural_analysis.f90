program test20

implicit none

call level1()

contains

subroutine level1()

  call level2()

end subroutine level1

subroutine level2()

  integer, parameter :: MPI_COMM_WORLD = 0
  integer, parameter :: MPI_INTEGER = 1

  integer :: a(5)

  call mpi_send(a, 5, MPI_INTEGER, 1, 0, MPI_COMM_WORLD)

end subroutine level2

end