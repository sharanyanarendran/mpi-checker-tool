program test04
integer :: a(5)

if(rank==0) then
  call mpi_send(a,5,MPI_INTEGER,1,0,MPI_COMM_WORLD)
else
  call mpi_recv(a,10,MPI_INTEGER,0,0,MPI_COMM_WORLD,ierr)
end if
end