program test01
integer :: a(5)
call mpi_send(a,10,MPI_INTEGER,1,0,MPI_COMM_WORLD)
end