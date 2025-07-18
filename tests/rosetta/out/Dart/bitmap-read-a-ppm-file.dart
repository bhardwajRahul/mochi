// Generated by Mochi compiler v0.10.28 on 2025-07-18T09:34:36Z
class Pixel {
  int R;
  int G;
  int B;
  Pixel(this.R, this.G, this.B);
}

class Bitmap {
  int w;
  int h;
  int max;
  List<List<Pixel>> data;
  Bitmap(this.w, this.h, this.max, this.data);
}

Bitmap newBitmap(int w, int h, int max) {
  List<List<Pixel>> rows = [];
  num y = 0;
  while ((y as num) < h) {
    List<Pixel> row = [];
    num x = 0;
    while ((x as num) < w) {
      row = List.from(row)..add(Pixel(0, 0, 0));
      x = (x as num) + 1;
    }
    rows = List.from(rows)..add(row);
    y = (y as num) + 1;
  }
  return Bitmap(w, h, max, rows);
}

void setPx(Bitmap b, int x, int y, Pixel p) {
  var rows = b.data;
  var row = rows[y];
  row[x] = p;
  rows[y] = row;
  b.data = rows;
}

Pixel getPx(Bitmap b, int x, int y) {
  return b.data[y][x];
}

List<String> splitLines(String s) {
  List<String> out = [];
  var cur = '';
  num i = 0;
  while ((i as num) < s.length) {
    var ch = substr(s, i, (i as num) + 1);
    if (ch == '\n') {
      out = List.from(out)..add(cur);
      cur = '';
    }
    else {
      cur = (cur as num) + (ch as num);
    }
    i = (i as num) + 1;
  }
  out = List.from(out)..add(cur);
  return out;
}

List<String> splitWS(String s) {
  List<String> out = [];
  var cur = '';
  num i = 0;
  while ((i as num) < s.length) {
    var ch = substr(s, i, (i as num) + 1);
    if (ch == ' ' || ch == '  ' || ch == '\r' || ch == '\n') {
      if (cur.length > 0) {
        out = List.from(out)..add(cur);
        cur = '';
      }
    }
    else {
      cur = (cur as num) + (ch as num);
    }
    i = (i as num) + 1;
  }
  if (cur.length > 0) {
    out = List.from(out)..add(cur);
  }
  return out;
}

int parseIntStr(String str) {
  num i = 0;
  var neg = false;
  if (str.length > 0 && str.substring(0, 1) == '-') {
    neg = true;
    i = 1;
  }
  num n = 0;
  var digits = {
    '0': 0,
    '1': 1,
    '2': 2,
    '3': 3,
    '4': 4,
    '5': 5,
    '6': 6,
    '7': 7,
    '8': 8,
    '9': 9,
  };
  while ((i as num) < str.length) {
    n = ((n as num) * 10 as num) + (digits[str.substring(i, (i as num) + 1)] as num);
    i = (i as num) + 1;
  }
  if (neg != null) {
    n = -(n as num);
  }
  return n;
}

List<String> tokenize(String s) {
  var lines = splitLines(s);
  List<String> toks = [];
  num i = 0;
  while ((i as num) < lines.length) {
    var line = lines[i];
    if (line.length > 0 && substr(line, 0, 1) == '#') {
      i = (i as num) + 1;
      continue;
    }
    var parts = splitWS(line);
    num j = 0;
    while ((j as num) < parts.length) {
      toks = List.from(toks)..add(parts[j]);
      j = (j as num) + 1;
    }
    i = (i as num) + 1;
  }
  return toks;
}

Bitmap readP3(String text) {
  var toks = tokenize(text);
  if (toks.length < 4) {
    return newBitmap(0, 0, 0);
  }
  if (toks[0] != 'P3') {
    return newBitmap(0, 0, 0);
  }
  int w = parseIntStr(toks[1]);
  int h = parseIntStr(toks[2]);
  int maxv = parseIntStr(toks[3]);
  var idx = 4;
  var bm = newBitmap(w, h, maxv);
  var y = (h as num) - 1;
  while ((y as num) >= 0) {
    num x = 0;
    while ((x as num) < (w as num)) {
      int r = parseIntStr(toks[idx]);
      int g = parseIntStr(toks[(idx as num) + 1]);
      int b = parseIntStr(toks[(idx as num) + 2]);
      setPx(bm, x, y, Pixel(r, g, b));
      idx = (idx as num) + 3;
      x = (x as num) + 1;
    }
    y = (y as num) - 1;
  }
  return bm;
}

void toGrey(Bitmap b) {
  int h = b.h;
  int w = b.w;
  num m = 0;
  num y = 0;
  while ((y as num) < (h as num)) {
    num x = 0;
    while ((x as num) < (w as num)) {
      var p = getPx(b, x, y);
      var l = (((((p['R'] as num) * 2126 as num) + ((p['G'] as num) * 7152 as num) as num) + ((p['B'] as num) * 722 as num)) as num) / 10000;
      if ((l as num) > b.max) {
        l = b.max;
      }
      setPx(b, x, y, Pixel(l, l, l));
      if ((l as num) > (m as num)) {
        m = l;
      }
      x = (x as num) + 1;
    }
    y = (y as num) + 1;
  }
  b.max = m;
}

String pad(int n, int w) {
  var s = n.toString();
  while (s.length < w) {
    s = ' ' + s;
  }
  return s;
}

String writeP3(Bitmap b) {
  int h = b.h;
  int w = b.w;
  var max = b.max;
  var digits = max.toString().length;
  var out = 'P3\n# generated from Bitmap.writeppmp3\n' + w.toString() + ' ' + h.toString() + '\n' + max.toString() + '\n';
  var y = (h as num) - 1;
  while ((y as num) >= 0) {
    var line = '';
    num x = 0;
    while ((x as num) < (w as num)) {
      var p = getPx(b, x, y);
      line = line + '   ' + pad(p['R'], digits) + ' ' + pad(p['G'], digits) + ' ' + pad(p['B'], digits);
      x = (x as num) + 1;
    }
    out = out + line + '\n';
    y = (y as num) - 1;
  }
  return out;
}

var ppmtxt = 'P3\n' + '# feep.ppm\n' + '4 4\n' + '15\n' + ' 0  0  0    0  0  0    0  0  0   15  0 15\n' + ' 0  0  0    0 15  7    0  0  0    0  0  0\n' + ' 0  0  0    0  0  0    0 15  7    0  0  0\n' + '15  0 15    0  0  0    0  0  0    0  0  0\n';

var bm = readP3(ppmtxt);

var out = writeP3(bm);

void main() {
  print('Original Colour PPM file');
  print(ppmtxt);
  print('Grey PPM:');
  toGrey(bm);
  print(out);
}
