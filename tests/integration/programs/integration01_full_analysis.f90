program test_all
implicit none
integer, parameter :: MPI_COMM_WORLD = 0
integer, parameter :: MPI_INTEGER = 1
integer, parameter :: MPI_REAL = 2
integer, parameter :: MPI_COMPLEX = 3
integer, parameter :: MPI_BYTE = 4


integer :: ierr, rank, size
integer :: a(5)
real :: r(10)
complex :: c(5)

! Derived types
type :: mytype
integer :: x
real :: y
end type

type, bind(C) :: goodtype
integer :: x
real :: y
end type

type(mytype) :: dt
type(goodtype) :: dt_good

call mpi_init(ierr)
call mpi_comm_rank(mpi_comm_world, rank, ierr)
call mpi_comm_size(mpi_comm_world, size, ierr)

! ─────────────────────────────────────────────
! 1. BUFFER OVERFLOW
! ─────────────────────────────────────────────
call mpi_send(a, 10, mpi_integer, 1, 0, mpi_comm_world)  ! ERROR

! ─────────────────────────────────────────────
! 2. NON-CONTIGUOUS BUFFER
! ─────────────────────────────────────────────
call mpi_send(a(1:5:2), 5, mpi_integer, 1, 0, mpi_comm_world) ! ERROR

! ─────────────────────────────────────────────
! 3. DATATYPE MISMATCH
! ─────────────────────────────────────────────
call mpi_send(r, 10, mpi_integer, 1, 0, mpi_comm_world) ! ERROR
call mpi_send(c, 5, mpi_real, 1, 0, mpi_comm_world)     ! ERROR

! ─────────────────────────────────────────────
! 4. SEND/RECV MISMATCH
! ─────────────────────────────────────────────
if (rank == 0) then
call mpi_send(a, 5, mpi_integer, 1, 10, mpi_comm_world)
else if (rank == 1) then
call mpi_recv(a, 10, mpi_integer, 0, 10, mpi_comm_world, ierr) ! ERROR (count mismatch)
end if

! Missing recv
if (rank == 0) then
call mpi_send(a, 5, mpi_integer, 1, 20, mpi_comm_world) ! ERROR
end if

! Datatype mismatch
if (rank == 0) then
call mpi_send(a, 5, mpi_integer, 1, 30, mpi_comm_world)
else if (rank == 1) then
call mpi_recv(r, 5, mpi_real, 0, 30, mpi_comm_world, ierr) ! ERROR
end if

! ─────────────────────────────────────────────
! 5. OPTIONAL ARGUMENT MISUSE
! ─────────────────────────────────────────────
call mpi_recv(a, 5, mpi_integer, 0, 0, mpi_comm_world) ! ERROR (missing status)
call mpi_send(a, 5, mpi_integer, 1, 0, mpi_comm_world, ierr) ! ERROR (extra arg)

! ─────────────────────────────────────────────
! 6. DERIVED TYPE WITHOUT BIND(C)
! ─────────────────────────────────────────────
call mpi_send(dt, 1, mpi_byte, 1, 0, mpi_comm_world) ! ERROR

! ─────────────────────────────────────────────
! 7. DERIVED TYPE WITH BIND(C) (VALID)
! ─────────────────────────────────────────────
call mpi_send(dt_good, 1, mpi_byte, 1, 0, mpi_comm_world)

! ─────────────────────────────────────────────
! 8. DERIVED LAYOUT MISMATCH
! ─────────────────────────────────────────────
call mpi_send(dt, 1, mpi_integer, 1, 0, mpi_comm_world) ! ERROR

! ─────────────────────────────────────────────
! 9. COLLECTIVE REACHABILITY
! ─────────────────────────────────────────────
if (rank == 0) then
call mpi_barrier(mpi_comm_world, ierr) ! ERROR
end if

! ─────────────────────────────────────────────
! 10. COLLECTIVE ORDERING
! ─────────────────────────────────────────────
if (rank == 0) then
call mpi_bcast(a, 5, mpi_integer, 0, mpi_comm_world, ierr)
call mpi_barrier(mpi_comm_world, ierr)
else
call mpi_barrier(mpi_comm_world, ierr)
call mpi_bcast(a, 5, mpi_integer, 0, mpi_comm_world, ierr) ! ERROR
end if

call mpi_finalize(ierr)

end program
