! Generated by Mochi compiler v0.10.28 on 2006-01-02T15:04:05Z
program chinese_remainder_theorem
  implicit none
  integer, dimension(3) :: n
  integer, dimension(3) :: a
  integer :: res
  character(len=100) :: s0
    integer :: g
    integer :: x1
    integer :: y1
    integer :: r
    integer :: x
    integer :: prod
    integer :: i
    integer :: ni
    integer :: ai
    integer :: p
    integer :: inv
  n = (/3,5,7/)
  a = (/2,3,2/)
  res = crt(a,n)
  write(s0,'(G0)') res
  print *, s0 // ' <nil>'
  
  contains
  recursive integer function egcd(a,b) result(res)
    integer, intent(in) :: a
    integer, intent(in) :: b
    if ((a == 0)) then
      res = (/b,0,1/)
      return
    end if
    res = egcd(mod(b,a),a)
    g = res(((0)+1))
    x1 = res(((1)+1))
    y1 = res(((2)+1))
    res = (/g,((y1 - ((b / a))) * x1),x1/)
    return
  end function egcd
  recursive integer function modInv(a,m) result(res)
    integer, intent(in) :: a
    integer, intent(in) :: m
    r = egcd(a,m)
    if ((r(((0)+1)) /= 1)) then
      res = 0
      return
    end if
    x = r(((1)+1))
    if ((x < 0)) then
      res = (x + m)
      return
    end if
    res = x
    return
  end function modInv
  recursive integer function crt(a,n) result(res)
    integer, intent(in) :: a
    integer, intent(in) :: n
    prod = 1
    i = 0
    do while ((i < 3))
      prod = (prod * n(((i)+1)))
      i = (i + 1)
    end do
    x = 0
    i = 0
    do while ((i < 3))
      ni = n(((i)+1))
      ai = a(((i)+1))
      p = (prod / ni)
      inv = modInv(mod(p,ni),ni)
      x = (((x + ai) * inv) * p)
      i = (i + 1)
    end do
    res = mod(x,prod)
    return
  end function crt
end program chinese_remainder_theorem
