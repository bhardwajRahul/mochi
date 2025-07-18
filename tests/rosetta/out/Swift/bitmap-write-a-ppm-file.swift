// Generated by Mochi compiler v0.10.26 on 2025-07-16T09:55:37Z
struct Colour: Equatable {
    var R: Int
    var G: Int
    var B: Int
}
struct Bitmap: Equatable {
    var width: Int
    var height: Int
    var pixels: [[Colour]]
}
func newBitmap(_ w: Int, _ h: Int, _ c: inout Colour) -> Bitmap {
    var rows: [[Colour]] = [Any]()
    var y = 0
    while y < h {
        var row: [Colour] = [Any]()
        var x = 0
        while x < w {
            row = row + [c]
            x = x + 1
        }
        rows = rows + [row]
        y = y + 1
    }
    return Bitmap(width: w, height: h, pixels: rows)
}
func setPixel(_ b: inout Bitmap, _ x: Int, _ y: Int, _ c: inout Colour) {
    var rows = b.pixels
    var row = rows[y]
    row[x] = c
    rows[y] = row
    b.pixels = rows
}
func fillRect(_ b: inout Bitmap, _ x: Int, _ y: Int, _ w: Int, _ h: Int, _ c: inout Colour) {
    var yy = y
    while yy < y + h {
        var xx = x
        while xx < x + w {
            setPixel(&b, xx, yy, &c)
            xx = xx + 1
        }
        yy = yy + 1
    }
}
func pad(_ n: Int, _ width: Int) -> String {
    var s = String(n)
    while s.count < width {
        s = " " + s
    }
    return s
}
func writePPMP3(_ b: inout Bitmap) -> String {
    var maxv = 0
    var y = 0
    while y < b.height {
        var x = 0
        while x < b.width {
            let p = b.pixels[y][x]
            if p.R > maxv {
                maxv = p.R
            }
            if p.G > maxv {
                maxv = p.G
            }
            if p.B > maxv {
                maxv = p.B
            }
            x = x + 1
        }
        y = y + 1
    }
    var out = "P3\n# generated from Bitmap.writeppmp3\n" + String(b.width) + " " + String(b.height) + "\n" + String(maxv) + "\n"
    var numsize = String(maxv).count
    y = b.height - 1
    while y >= 0 {
        var line = ""
        var x = 0
        while x < b.width {
            let p = b.pixels[y][x]
            line = line + "   " + pad(p.R, numsize) + " " + pad(p.G, numsize) + " " + pad(p.B, numsize)
            x = x + 1
        }
        out = out + line
        if y > 0 {
            out = out + "\n"
        }
        else {
            out = out + "\n"
        }
        y = y - 1
    }
    return out
}
func main() {
    let black = Colour(R: 0, G: 0, B: 0)
    let white = Colour(R: 255, G: 255, B: 255)
    var bm = newBitmap(4, 4, &black)
    fillRect(&bm, 1, 0, 1, 2, &white)
    setPixel(&bm, 3, 3, &Colour(R: 127, G: 0, B: 63))
    let ppm = writePPMP3(&bm)
    print(ppm)
}
main()
