program test08

type :: particle
 integer :: id
 real :: mass
end type

type(particle) :: p(4)

call mpi_send(p,4,MPI_BYTE,1,0,MPI_COMM_WORLD)
end