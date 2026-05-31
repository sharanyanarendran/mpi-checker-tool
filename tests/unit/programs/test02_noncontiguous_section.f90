program test02
integer :: a(10)
call mpi_send(a(1:10:2),5,MPI_INTEGER,1,0,MPI_COMM_WORLD)
end