program test14

implicit none

integer, parameter :: MPI_COMM_WORLD = 0
integer, parameter :: MPI_INTEGER = 1

integer :: ierr
integer :: rank
integer :: size
integer :: i
integer :: a(5)

do i = 1, size

  if (rank == 0) then
    call mpi_bcast(a, 5, MPI_INTEGER, 0, MPI_COMM_WORLD, ierr)
  end if

end do

end