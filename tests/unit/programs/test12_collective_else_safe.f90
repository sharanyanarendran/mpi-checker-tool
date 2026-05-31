program test12

implicit none

integer, parameter :: MPI_COMM_WORLD = 0
integer, parameter :: MPI_INTEGER = 1

integer :: ierr
integer :: rank
integer :: a(5)

if (rank == 0) then
  call mpi_bcast(a, 5, MPI_INTEGER, 0, MPI_COMM_WORLD, ierr)
else
  call mpi_bcast(a, 5, MPI_INTEGER, 0, MPI_COMM_WORLD, ierr)
end if

end