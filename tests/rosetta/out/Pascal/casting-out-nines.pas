// Generated by Mochi compiler v0.10.26 on 2025-07-16T11:36:20Z
program CastingOutNines;
{$mode objfpc}
{$modeswitch nestedprocvars}
uses SysUtils, fgl, fphttpclient, Classes, Variants, fpjson, jsonparser, fpjsonrtti;

type
  generic TArray<T> = array of T;

function parseIntBase(s: string; base: integer): integer;
var
  digits: string;
  i: integer;
  j: integer;
  n: integer;
  v: integer;
begin
  digits := '0123456789abcdefghijklmnopqrstuvwxyz';
  n := 0;
  i := 0;
  while (i < Length(s)) do
  begin
    j := 0;
    v := 0;
    while (j < Length(digits)) do
    begin
      if (_sliceString(digits, j, j + j + 1) = _sliceString(s, i, i + 1)) then
      begin
        v := j;
        break;
      end;
      j := j + 1;
    end;
    n := n * base + v;
    i := i + 1;
  end;
  result := n;
  exit;
end;

function intToBase(n: integer; base: integer): string;
var
  d: integer;
  digits: string;
  out: string;
  v: integer;
begin
  digits := '0123456789abcdefghijklmnopqrstuvwxyz';
  if (n = 0) then ;
  out := '';
  v := n;
  while (v > 0) do
  begin
    d := v mod base;
    out := _sliceString(digits, d, d + 1) + out;
    v := v div base;
  end;
  result := out;
  exit;
end;

function subset(base: integer; _begin: string; _end: string): specialize TArray<string>;
var
  b: Variant;
  e: Variant;
  k: Variant;
  ks: Variant;
  _mod: Variant;
  out: string;
  r1: Variant;
  r2: Variant;
begin
  b := parseIntBase(_begin, base);
  e := parseIntBase(_end, base);
  out := specialize TArray<integer>([]);
  k := b;
  while (k <= e) do
  begin
    ks := intToBase(k, base);
    _mod := base - 1;
    r1 := parseIntBase(ks, base) mod _mod;
    r2 := parseIntBase(ks, base) * parseIntBase(ks, base) mod _mod;
    if (r1 = r2) then ;
    k := k + 1;
  end;
  result := out;
  exit;
end;

generic function _appendList<T>(arr: specialize TArray<T>; val: T): specialize TArray<T>;
var i,n: Integer;
begin
  n := Length(arr);
  SetLength(Result, n + 1);
  for i := 0 to n - 1 do
    Result[i] := arr[i];
  Result[n] := val;
end;

generic function _indexList<T>(arr: specialize TArray<T>; i: integer): T;
begin
  if i < 0 then i := Length(arr) + i;
  if (i < 0) or (i >= Length(arr)) then
    raise Exception.Create('index out of range');
  Result := arr[i];
end;

function _sliceString(s: string; i, j: integer): string;
var start_, end_, n: integer;
begin
  start_ := i;
  end_ := j;
  n := Length(s);
  if start_ < 0 then start_ := n + start_;
  if end_ < 0 then end_ := n + end_;
  if start_ < 0 then start_ := 0;
  if end_ > n then end_ := n;
  if end_ < start_ then end_ := start_;
  Result := Copy(s, start_ + 1, end_ - start_);
end;

var
  _tmp0: specialize TFPGMap<string, Variant>;
  _tmp1: specialize TFPGMap<string, Variant>;
  found: boolean;
  i: integer;
  idx: integer;
  k: Variant;
  s: Variant;
  sx: integer;
  tc: specialize TArray<specialize TFPGMap<string, Variant>>;
  testCases: specialize TArray<specialize TFPGMap<string, Variant>>;
  valid: boolean;

begin
  _tmp0 := specialize TFPGMap<string, Variant>.Create;
  _tmp0.AddOrSetData('base', 10);
  _tmp0.AddOrSetData('begin', '1');
  _tmp0.AddOrSetData('end', '100');
  _tmp0.AddOrSetData('kaprekar', specialize TArray<string>(['1', '9', '45', '55', '99']));
  _tmp1 := specialize TFPGMap<string, Variant>.Create;
  _tmp1.AddOrSetData('base', 17);
  _tmp1.AddOrSetData('begin', '10');
  _tmp1.AddOrSetData('end', 'gg');
  _tmp1.AddOrSetData('kaprekar', specialize TArray<string>(['3d', 'd4', 'gg']));
  testCases := specialize TArray<specialize TFPGMap<string, Variant>>([_tmp0, _tmp1]);
  idx := 0;
  while (idx < Length(testCases)) do
  begin
    tc := specialize _indexList<specialize TFPGMap<string, Variant>>(testCases, idx);
    writeln('
Test case base = ' + IntToStr(specialize _indexList<specialize TFPGMap<string, Variant>>(tc, 'base')) + ', begin = ' + specialize _indexList<specialize TFPGMap<string, Variant>>(tc, 'begin') + ', end = ' + specialize _indexList<specialize TFPGMap<string, Variant>>(tc, 'end') + ':');
    s := subset(specialize _indexList<specialize TFPGMap<string, Variant>>(tc, 'base'), specialize _indexList<specialize TFPGMap<string, Variant>>(tc, 'begin'), specialize _indexList<specialize TFPGMap<string, Variant>>(tc, 'end'));
    writeln('Subset:  ' + IntToStr(s));
    writeln('Kaprekar:' + IntToStr(specialize _indexList<specialize TFPGMap<string, Variant>>(tc, 'kaprekar')));
    sx := 0;
    valid := True;
    i := 0;
    while (i < specialize _indexList<specialize TFPGMap<string, Variant>>(tc, 'kaprekar').Count) do
    begin
      k := specialize _indexList<specialize TFPGMap<string, Variant>>(specialize _indexList<specialize TFPGMap<string, Variant>>(tc, 'kaprekar'), i);
      found := False;
      while (sx < Length(s)) do
      begin
        if (s[sx] = k) then
        begin
          found := True;
          sx := sx + 1;
          break;
        end;
        sx := sx + 1;
      end;
      if not found then
      begin
        writeln('Fail:' + k + ' not in subset');
        valid := False;
        break;
      end;
      i := i + 1;
    end;
    if valid then ;
    idx := idx + 1;
  end;
end.
