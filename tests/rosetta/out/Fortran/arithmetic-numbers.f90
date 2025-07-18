! Generated by Mochi compiler v0.10.28 on 2006-01-02T15:04:05Z
program arithmetic_numbers
  implicit none
    integer, allocatable, dimension(:) :: spf
    integer :: i
    integer :: j
    integer, allocatable, dimension(:) :: primes
        integer, allocatable, dimension(:) :: app0
    integer :: s
    character(len=100) :: s1
    character(len=100) :: out
    integer :: c
    character(len=100) :: s2
    integer :: lo
    integer :: hi
    integer :: mid
    integer :: count
    integer, dimension(1) :: arr
    integer :: x
    integer :: sigma
    integer :: tau
    integer :: p
    integer :: cnt
    integer :: power
    integer :: sum
        integer, allocatable, dimension(:) :: app3
          integer, allocatable, dimension(:) :: app4
    character(len=100) :: line
    integer :: lastc
    integer :: pc
    integer :: comp
    integer, dimension(4) :: arr5 = (/1000,10000,100000,1000000/)
    integer :: i5
  call main()
  
  contains
  recursive integer function sieve(limit) result(res)
    integer, intent(in) :: limit
    allocate(spf(0))
    i = 0
    do while ((i <= limit))
      spf = (/0/)
      i = (i + 1)
    end do
    i = 2
    do while ((i <= limit))
      if ((spf(((i)+1)) == 0)) then
        spf(((i)+1)) = i
        if (((i * i) <= limit)) then
          j = (i * i)
          do while ((j <= limit))
            if ((spf(((j)+1)) == 0)) then
              spf(((j)+1)) = i
            end if
            j = (j + i)
          end do
        end if
      end if
      i = (i + 1)
    end do
    res = spf
    return
  end function sieve
  recursive integer function primesFrom(spf,limit) result(res)
    integer, intent(in) :: spf
    integer, intent(in) :: limit
    allocate(primes(0))
    i = 3
    do while ((i <= limit))
      if ((spf(((i)+1)) == i)) then
        if (allocated(app0)) deallocate(app0)
        allocate(app0(size(primes)+1))
        app0(1:size(primes)) = primes
        app0(size(primes)+1) = i
        primes = app0
      end if
      i = (i + 1)
    end do
    res = primes
    return
  end function primesFrom
  recursive character(len=100) function pad3(n) result(res)
    integer, intent(in) :: n
    write(s1,'(G0)') n
    s = s1
    do while ((size(s) < 3))
      s = ' ' // s
    end do
    res = s
    return
  end function pad3
  recursive character(len=100) function commatize(n) result(res)
    integer, intent(in) :: n
    write(s2,'(G0)') n
    s = s2
    out = ''
    i = (size(s) - 1)
    c = 0
    do while ((i >= 0))
      out = (s(i+1:(i + 1)) + out)
      c = (c + 1)
      if ((((mod(c,3) == 0) .and. i) > 0)) then
        out = ',' // out
      end if
      i = (i - 1)
    end do
    res = out
    return
  end function commatize
  recursive integer function primeCount(primes,last,spf) result(res)
    integer, intent(in) :: primes
    integer, intent(in) :: last
    integer, intent(in) :: spf
    lo = 0
    hi = size(primes)
    do while ((lo < hi))
      mid = int(((((lo + hi)) / 2)))
      if ((primes(((mid)+1)) < last)) then
        lo = (mid + 1)
      else
        hi = mid
      end if
    end do
    count = (lo + 1)
    if ((spf(((last)+1)) /= last)) then
      count = (count - 1)
    end if
    res = count
    return
  end function primeCount
  recursive integer function arithmeticNumbers(limit,spf) result(res)
    integer, intent(in) :: limit
    integer, intent(in) :: spf
    arr = (/1/)
    n = 3
    do while ((1 < limit))
      if ((spf(((n)+1)) == n)) then
        if (allocated(app3)) deallocate(app3)
        allocate(app3(size(arr)+1))
        app3(1:size(arr)) = arr
        app3(size(arr)+1) = n
        arr = app3
      else
        x = n
        sigma = 1
        tau = 1
        do while ((x > 1))
          p = spf(((x)+1))
          if ((p == 0)) then
            p = x
          end if
          cnt = 0
          power = p
          sum = 1
          do while ((mod(x,p) == 0))
            x = (x / p)
            cnt = (cnt + 1)
            sum = (sum + power)
            power = (power * p)
          end do
          sigma = (sigma * sum)
          tau = (tau * ((cnt + 1)))
        end do
        if ((mod(sigma,tau) == 0)) then
          if (allocated(app4)) deallocate(app4)
          allocate(app4(size(arr)+1))
          app4(1:size(arr)) = arr
          app4(size(arr)+1) = n
          arr = app4
        end if
      end if
      n = (n + 1)
    end do
    res = arr
    return
  end function arithmeticNumbers
  recursive subroutine main()
    limit = 1228663
    spf = sieve(limit)
    primes = primesFrom(spf,limit)
    arr = arithmeticNumbers(1000000,spf)
    print *, 'The first 100 arithmetic numbers are:'
    i = 0
    do while ((i < 100))
      line = ''
      j = 0
      do while ((j < 10))
        line = (line + pad3(arr((((i + j))+1))))
        if ((j < 9)) then
          line = line // ' '
        end if
        j = (j + 1)
      end do
      print *, line
      i = (i + 10)
    end do
    do i5 = 1, 4
      x = arr5(i5)
      last = arr((((x - 1))+1))
      lastc = commatize(last)
      print *, trim(trim(''//char(10)//'The ' // commatize(x)) // 'th arithmetic number is: ') // lastc
      pc = primeCount(primes,last,spf)
      comp = ((x - pc) - 1)
      print *, trim(trim(trim('The count of such numbers <= ' // lastc) // ' which are composite is ') // commatize(comp)) // '.'
    end do
  end subroutine main
end program arithmetic_numbers
