program test17

implicit none

integer, parameter :: MPI_COMM_WORLD = 0
integer, parameter :: MPI_INTEGER = 1

integer :: size
integer :: a(5)

call mpi_send(a, size * 4, MPI_INTEGER, 1, 0, MPI_COMM_WORLD)

end 