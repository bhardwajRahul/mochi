! Generated by Mochi compiler v0.10.28 on 2006-01-02T15:04:05Z
program checkpoint_synchronization_1
  implicit none
  integer, dimension(4) :: partList
  integer :: nAssemblies
  integer :: cycle
    character(len=100) :: s0
    integer :: p
    integer :: i1
    integer :: i2
    character(len=100) :: s3
  partList = (/'A','B','C','D'/)
  nAssemblies = 3
  do cycle = 1, ((nAssemblies + 1))
    write(s0,'(G0)') cycle
    print *, 'begin assembly cycle ' // s0
    do i1 = 1, size(partList)
      p = partList(i1)
      print *, p // ' worker begins part'
    end do
    do i2 = 1, size(partList)
      p = partList(i2)
      print *, p // ' worker completes part'
    end do
    write(s3,'(G0)') cycle
    print *, trim('assemble.  cycle ' // s3) // ' complete'
  end do
end program checkpoint_synchronization_1
