program IfElse;
{$mode objfpc}
{$modeswitch nestedprocvars}

uses SysUtils, fgl, fphttpclient, Classes, Variants, fpjson, jsonparser, fpjsonrtti;

type
  generic TArray<T> = array of T;

var
  x: integer;

begin
  x := 5;
  if (x > 3) then
    begin
      writeln('big');
    end
  else
    begin
      writeln('small');
    end;
end.
