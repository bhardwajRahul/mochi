// Generated by Mochi compiler v0.10.28 on 2025-07-18T09:33:29Z
List<String> fields(String s) {
  List<String> res = [];
  var cur = '';
  num i = 0;
  while ((i as num) < s.length) {
    var c = s.substring(i, (i as num) + 1);
    if (c == ' ') {
      if (cur.length > 0) {
        res = List.from(res)..add(cur);
        cur = '';
      }
    }
    else {
      cur = (cur as num) + (c as num);
    }
    i = (i as num) + 1;
  }
  if (cur.length > 0) {
    res = List.from(res)..add(cur);
  }
  return res;
}

bool canSpell(String word, List<String> blks) {
  if (word.length == 0) {
    return true;
  }
  var c = lower(word.substring(0, 1));
  num i = 0;
  while ((i as num) < blks.length) {
    var b = blks[i];
    if (c == lower(((b is String) ? b.substring(0, 1) : (b as List).sublist(0, 1))) || c == lower(((b is String) ? b.substring(1, 2) : (b as List).sublist(1, 2)))) {
      List<String> rest = [];
      num j = 0;
      while ((j as num) < blks.length) {
        if (j != i) {
          rest = List.from(rest)..add(blks[j]);
        }
        j = (j as num) + 1;
      }
      if (canSpell(word.substring(1, word.length), rest)) {
        return true;
      }
    }
    i = (i as num) + 1;
  }
  return false;
}

Function newSpeller(String blocks) {
  var bl = fields(blocks);
  return (w) => canSpell(w, bl);
}

void _main() {
  var sp = newSpeller('BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM');
  for (var word in [
    'A',
    'BARK',
    'BOOK',
    'TREAT',
    'COMMON',
    'SQUAD',
    'CONFUSE',
  ]) {
    print(word + ' ' + sp(word).toString());
  }
}

void main() {
  _main();
}
