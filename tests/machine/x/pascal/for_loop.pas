program ForLoop;
{$mode objfpc}
{$modeswitch nestedprocvars}

uses SysUtils, fgl, fphttpclient, Classes, Variants, fpjson, jsonparser, fpjsonrtti;

type
  generic TArray<T> = array of T;

var
  i: integer;

begin
  for i := 1 to 4 - 1 do
    begin
      writeln(i);
    end;
end.
