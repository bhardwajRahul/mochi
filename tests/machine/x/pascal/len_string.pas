// Generated by Mochi compiler v0.10.27 on 2025-07-17T18:09:01Z
program LenString;
{$mode objfpc}
{$modeswitch nestedprocvars}
uses SysUtils, fgl, fphttpclient, Classes, Variants, fpjson, jsonparser, fpjsonrtti;

type
  generic TArray<T> = array of T;

begin
  writeln(Length('mochi'));
end.
