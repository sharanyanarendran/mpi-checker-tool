program test16

implicit none

integer, parameter :: MPI_COMM_WORLD = 0
integer, parameter :: MPI_INTEGER = 1

integer :: ierr
integer :: rank
integer :: a(5)

if (rank == 0) then

  call mpi_send(a, 5, MPI_INTEGER, 1, 10, MPI_COMM_WORLD)

else

  call mpi_recv(a, 5, MPI_INTEGER, -1, 10, MPI_COMM_WORLD, ierr)

end if

end