program integration02

implicit none

integer, parameter :: MPI_COMM_WORLD = 0
integer, parameter :: MPI_COMM_SELF  = 1
integer, parameter :: MPI_INTEGER    = 1

integer :: ierr
integer :: rank
integer :: size
integer :: i
integer :: a(10)

! ----------------------------------------------------
! 1. Collective Reachability
! ----------------------------------------------------

if (rank == 0) then
  call mpi_barrier(MPI_COMM_WORLD, ierr)
end if

! ----------------------------------------------------
! 2. Collective Ordering
! ----------------------------------------------------

if (rank == 0) then

  call mpi_bcast(a, 10, MPI_INTEGER, 0, MPI_COMM_WORLD, ierr)
  call mpi_barrier(MPI_COMM_WORLD, ierr)

else

  call mpi_barrier(MPI_COMM_WORLD, ierr)
  call mpi_bcast(a, 10, MPI_INTEGER, 0, MPI_COMM_WORLD, ierr)

end if

! ----------------------------------------------------
! 3. Communicator Mismatch
! ----------------------------------------------------

if (rank == 0) then

  call mpi_bcast(a, 10, MPI_INTEGER, 0, MPI_COMM_WORLD, ierr)

else

  call mpi_bcast(a, 10, MPI_INTEGER, 0, MPI_COMM_SELF, ierr)

end if

! ----------------------------------------------------
! 4. Loop Collective
! ----------------------------------------------------

do i = 1, size

  if (rank == 0) then
    call mpi_bcast(a, 10, MPI_INTEGER, 0, MPI_COMM_WORLD, ierr)
  end if

end do

end