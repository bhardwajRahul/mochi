! Generated by Mochi compiler v0.10.30 on 2006-01-02T15:04:05Z
program ackermann_function_2
  implicit none
    integer :: result
    integer :: i
    character(len=100) :: s0
    character(len=100) :: s1
    character(len=100) :: s2
    character(len=100) :: s3
  call main()
  
  contains
  recursive integer function pow(base,exp) result(res)
    integer, intent(in) :: base
    integer, intent(in) :: exp
    result = 1
    i = 0
    do while ((i < exp))
      result = (result * base)
      i = (i + 1)
    end do
    res = result
    return
  end function pow
  recursive integer function ackermann2(m,n) result(res)
    integer, intent(in) :: m
    integer, intent(in) :: n
    if ((m == 0)) then
      res = (n + 1)
      return
    end if
    if ((m == 1)) then
      res = (n + 2)
      return
    end if
    if ((m == 2)) then
      res = ((2 * n) + 3)
      return
    end if
    if ((m == 3)) then
      res = ((8 * pow(2,n)) - 3)
      return
    end if
    if ((n == 0)) then
      res = ackermann2((m - 1),1)
      return
    end if
    res = ackermann2((m - 1),ackermann2(m,(n - 1)))
    return
  end function ackermann2
  recursive subroutine main()
    write(s0,'(G0)') ackermann2(0,0)
    print *, 'A(0, 0) = ' // s0
    write(s1,'(G0)') ackermann2(1,2)
    print *, 'A(1, 2) = ' // s1
    write(s2,'(G0)') ackermann2(2,4)
    print *, 'A(2, 4) = ' // s2
    write(s3,'(G0)') ackermann2(3,4)
    print *, 'A(3, 4) = ' // s3
  end subroutine main
end program ackermann_function_2
