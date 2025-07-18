! Generated by Mochi compiler v0.10.28 on 2006-01-02T15:04:05Z
program canny_edge_detector
  implicit none
  real :: PI
    integer :: h
    integer :: w
    integer :: n
    integer :: half
    integer, allocatable, dimension(:) :: out
    integer :: y
    integer, allocatable, dimension(:) :: row
    integer :: x
    integer :: sum
    integer :: j
    integer :: i
    integer :: yy
    integer :: xx
        integer, allocatable, dimension(:) :: app0
      integer, allocatable, dimension(:) :: app1
    integer, dimension(3,3) :: hx
    integer, dimension(3,3) :: hy
    integer :: gx
    integer :: gy
    integer :: g
        integer, allocatable, dimension(:) :: app2
      integer, allocatable, dimension(:) :: app3
          integer, allocatable, dimension(:) :: app4
      integer, allocatable, dimension(:) :: app5
    character(len=100) :: line
        character(len=100) :: s6
    integer :: edges
  PI = 3.141592653589793
  call main()
  
  contains
  recursive integer function conv2d(img,k) result(res)
    integer, intent(in) :: img
    integer, intent(in) :: k
    h = size(img)
    w = size(img(((0)+1)))
    n = size(k)
    half = (n / 2)
    allocate(out(0))
    y = 0
    do while ((y < h))
      allocate(row(0))
      x = 0
      do while ((x < w))
        sum = 0.0
        j = 0
        do while ((j < n))
          i = 0
          do while ((i < n))
            yy = ((y + j) - half)
            if ((yy < 0)) then
              yy = 0
            end if
            if ((yy >= h)) then
              yy = (h - 1)
            end if
            xx = ((x + i) - half)
            if ((xx < 0)) then
              xx = 0
            end if
            if ((xx >= w)) then
              xx = (w - 1)
            end if
            sum = ((sum + img(((yy)+1),((xx)+1))) * k(((j)+1),((i)+1)))
            i = (i + 1)
          end do
          j = (j + 1)
        end do
        if (allocated(app0)) deallocate(app0)
        allocate(app0(size(row)+1))
        app0(1:size(row)) = row
        app0(size(row)+1) = sum
        row = app0
        x = (x + 1)
      end do
      if (allocated(app1)) deallocate(app1)
      allocate(app1(size(out)+1))
      app1(1:size(out)) = out
      app1(size(out)+1) = row
      out = app1
      y = (y + 1)
    end do
    res = out
    return
  end function conv2d
  recursive integer function gradient(img) result(res)
    integer, intent(in) :: img
    hx = reshape((/-1.0,0.0,1.0,-2.0,0.0,2.0,-1.0,0.0,1.0/),(/3,3/))
    hy = reshape((/1.0,2.0,1.0,0.0,0.0,0.0,-1.0,-2.0,-1.0/),(/3,3/))
    gx = conv2d(img,hx)
    gy = conv2d(img,hy)
    h = size(img)
    w = size(img(((0)+1)))
    allocate(out(0))
    y = 0
    do while ((y < h))
      allocate(row(0))
      x = 0
      do while ((x < w))
        g = (((gx(((y)+1),((x)+1)) * gx(((y)+1),((x)+1))) + gy(((y)+1),((x)+1))) * gy(((y)+1),((x)+1)))
        if (allocated(app2)) deallocate(app2)
        allocate(app2(size(row)+1))
        app2(1:size(row)) = row
        app2(size(row)+1) = g
        row = app2
        x = (x + 1)
      end do
      if (allocated(app3)) deallocate(app3)
      allocate(app3(size(out)+1))
      app3(1:size(out)) = out
      app3(size(out)+1) = row
      out = app3
      y = (y + 1)
    end do
    res = out
    return
  end function gradient
  recursive integer function threshold(g,t) result(res)
    integer, intent(in) :: g
    real, intent(in) :: t
    h = size(g)
    w = size(g(((0)+1)))
    allocate(out(0))
    y = 0
    do while ((y < h))
      allocate(row(0))
      x = 0
      do while ((x < w))
        if ((g(((y)+1),((x)+1)) >= t)) then
          row = (/1/)
        else
          if (allocated(app4)) deallocate(app4)
          allocate(app4(size(row)+1))
          app4(1:size(row)) = row
          app4(size(row)+1) = 0
          row = app4
        end if
        x = (x + 1)
      end do
      if (allocated(app5)) deallocate(app5)
      allocate(app5(size(out)+1))
      app5(1:size(out)) = out
      app5(size(out)+1) = row
      out = app5
      y = (y + 1)
    end do
    res = out
    return
  end function threshold
  recursive subroutine printMatrix(m)
    integer, intent(in) :: m
    y = 0
    do while ((y < size(m)))
      line = ''
      x = 0
      do while ((x < size(m(((0)+1)))))
        write(s6,'(G0)') m(((y)+1),((x)+1))
        line = (line + s6)
        if (((x < size(m(((0)+1)))) - 1)) then
          line = line // ' '
        end if
        x = (x + 1)
      end do
      print *, line
      y = (y + 1)
    end do
  end subroutine printMatrix
  recursive subroutine main()
    img = reshape((/0.0,0.0,0.0,0.0,0.0,0.0,255.0,255.0,255.0,0.0,0.0,255.0,255.0,255.0,0.0,0.0,255.0,255.0,255.0,0.0,0.0,0.0,0.0,0.0,0.0/),(/5,5/))
    g = gradient(img)
    edges = threshold(g,(1020.0 * 1020.0))
    call printMatrix(edges)
  end subroutine main
end program canny_edge_detector
