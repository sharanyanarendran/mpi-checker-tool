program test15

implicit none

integer, parameter :: MPI_COMM_WORLD = 0
integer, parameter :: MPI_INTEGER = 1

integer :: ierr
integer :: rank
integer :: a(5)

if (rank == 0) then

  call mpi_send(a, 5, MPI_INTEGER, 1, 7, MPI_COMM_WORLD)
  call mpi_barrier(MPI_COMM_WORLD, ierr)

else

  call mpi_recv(a, 5, MPI_INTEGER, 0, 7, MPI_COMM_WORLD, ierr)
  call mpi_bcast(a, 5, MPI_INTEGER, 0, MPI_COMM_WORLD, ierr)

end if

end


! Analyzer may miss collectives guarded by nested non-rank conditions inside rank-conditioned IF/ELSE regions.