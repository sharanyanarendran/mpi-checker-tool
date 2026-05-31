program test07

type :: particle
 integer :: id
 real :: mass
end type

type(particle) :: p

call mpi_send(p,1,MPI_BYTE,1,0,MPI_COMM_WORLD)

end