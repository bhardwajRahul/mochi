// Generated by Mochi compiler v0.10.27 on 2025-07-17T18:09:01Z
program LenMap;
{$mode objfpc}
{$modeswitch nestedprocvars}
uses SysUtils, fgl, fphttpclient, Classes, Variants, fpjson, jsonparser, fpjsonrtti;

type
  generic TArray<T> = array of T;

var
  _tmp0: specialize TFPGMap<string, integer>;

begin
  _tmp0 := specialize TFPGMap<string, integer>.Create;
  _tmp0.AddOrSetData('a', 1);
  _tmp0.AddOrSetData('b', 2);
  writeln(_tmp0.Count);
end.
