program test18

implicit none

integer, parameter :: MPI_COMM_WORLD = 0

integer :: ierr
integer :: rank

if (rank == 0 .or. rank == 1) then

  call mpi_barrier(MPI_COMM_WORLD, ierr)

else

  call mpi_barrier(MPI_COMM_WORLD, ierr)

end if

end 