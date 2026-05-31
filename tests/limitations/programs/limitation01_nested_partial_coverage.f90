! Limitation: Nested non-rank conditions inside rank-conditioned collective regions may not always be modeled precisely.

program limitation01

implicit none

integer, parameter :: MPI_COMM_WORLD = 0

integer :: ierr
integer :: rank
integer :: size

if (rank == 0) then

  if (size > 2) then
    call mpi_barrier(MPI_COMM_WORLD, ierr)
  end if

else

  call mpi_barrier(MPI_COMM_WORLD, ierr)

end if

end

