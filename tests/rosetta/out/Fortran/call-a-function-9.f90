! Generated by Mochi compiler v0.10.28 on 2006-01-02T15:04:05Z
program call_a_function_9
  implicit none
    integer :: ab
    integer :: cb
    integer :: d
    integer :: e
    integer :: i
    integer, allocatable, dimension(:) :: list
    integer, allocatable, dimension(:) :: app0
    integer, allocatable, dimension(:) :: app1
    integer, allocatable, dimension(:) :: app2
    integer, allocatable, dimension(:) :: app3
  call main()
  
  contains
  recursive integer function f() result(res)
    res = (/0,0.0/)
    return
  end function f
  recursive integer function g(a,b) result(res)
    integer, intent(in) :: a
    real, intent(in) :: b
    res = 0
    return
  end function g
  recursive subroutine h(s,nums)
    character(len=100), intent(in) :: s
    integer, intent(in) :: nums
  end subroutine h
  recursive subroutine main()
    ab = f()
    a = ab(((0)+1))
    b = ab(((1)+1))
    cb = f()(((1)+1))
    d = g(a,cb)
    e = g(d,b)
    i = g(d,2.0)
    allocate(list(0))
    if (allocated(app0)) deallocate(app0)
    allocate(app0(size(list)+1))
    app0(1:size(list)) = list
    app0(size(list)+1) = a
    list = app0
    if (allocated(app1)) deallocate(app1)
    allocate(app1(size(list)+1))
    app1(1:size(list)) = list
    app1(size(list)+1) = d
    list = app1
    if (allocated(app2)) deallocate(app2)
    allocate(app2(size(list)+1))
    app2(1:size(list)) = list
    app2(size(list)+1) = e
    list = app2
    if (allocated(app3)) deallocate(app3)
    allocate(app3(size(list)+1))
    app3(1:size(list)) = list
    app3(size(list)+1) = i
    list = app3
    i = size(list)
  end subroutine main
end program call_a_function_9
