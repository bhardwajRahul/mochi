// Generated by Mochi compiler v0.10.28 on 2025-07-18T09:34:10Z
List<int> randOrder(int seed, int n) {
  var next = (seed * 1664525 + 1013904223) % 2147483647;
  return [next, (next as num) % n];
}

List<int> randChaos(int seed, int n) {
  var next = (seed * 1103515245 + 12345) % 2147483647;
  return [next, (next as num) % n];
}

void _main() {
  var nBuckets = 10;
  var initialSum = 1000;
  List<int> buckets = [];
  for (var i = 0; i < nBuckets; i++) {
    buckets = List.from(buckets)..add(0);
  }
  var i = nBuckets;
  var dist = initialSum;
  while ((i as num) > 0) {
    var v = (dist as num) / (i as num);
    i = (i as num) - 1;
    buckets[i] = v;
    dist = (dist as num) - (v as num);
  }
  num tc0 = 0;
  num tc1 = 0;
  num total = 0;
  num nTicks = 0;
  var seedOrder = 1;
  var seedChaos = 2;
  print('sum  ---updates---    mean  buckets');
  num t = 0;
  while ((t as num) < 5) {
    var r = randOrder(seedOrder, nBuckets);
    seedOrder = r[0];
    var b1 = r[1];
    var b2 = (((b1 as num) + 1) as num) % (nBuckets as num);
    var v1 = buckets[b1];
    var v2 = buckets[b2];
    if ((v1 as num) > (v2 as num)) {
      var a = int.parse(((((v1 as num) - (v2 as num)) as num) / 2));
      if ((a as num) > (buckets[b1] as num)) {
        a = buckets[b1];
      }
      buckets[b1] = (buckets[b1] as num) - (a as num);
      buckets[b2] = (buckets[b2] as num) + (a as num);
    }
    else {
      var a = int.parse(((((v2 as num) - (v1 as num)) as num) / 2));
      if ((a as num) > (buckets[b2] as num)) {
        a = buckets[b2];
      }
      buckets[b2] = (buckets[b2] as num) - (a as num);
      buckets[b1] = (buckets[b1] as num) + (a as num);
    }
    tc0 = (tc0 as num) + 1;
    r = randChaos(seedChaos, nBuckets);
    seedChaos = r[0];
    b1 = r[1];
    b2 = (((b1 as num) + 1) as num) % (nBuckets as num);
    r = randChaos(seedChaos, (buckets[b1] as num) + 1);
    seedChaos = r[0];
    var amt = r[1];
    if ((amt as num) > (buckets[b1] as num)) {
      amt = buckets[b1];
    }
    buckets[b1] = (buckets[b1] as num) - (amt as num);
    buckets[b2] = (buckets[b2] as num) + (amt as num);
    tc1 = (tc1 as num) + 1;
    num sum = 0;
    num idx = 0;
    while ((idx as num) < (nBuckets as num)) {
      sum = (sum as num) + (buckets[idx] as num);
      idx = (idx as num) + 1;
    }
    total = ((total as num) + (tc0 as num) as num) + (tc1 as num);
    nTicks = (nTicks as num) + 1;
    print(sum.toString() + ' ' + tc0.toString() + ' ' + tc1.toString() + ' ' + (total as num) / (nTicks as num).toString() + '  ' + buckets.toString());
    tc0 = 0;
    tc1 = 0;
    t = (t as num) + 1;
  }
}

void main() {
  _main();
}
