// Generated by Mochi compiler v0.10.26 on 2025-07-16T11:36:20Z
program CaseSensitivityOfIdentifiers;
{$mode objfpc}
{$modeswitch nestedprocvars}
uses SysUtils, fgl, fphttpclient, Classes, Variants, fpjson, jsonparser, fpjsonrtti;

type
  generic TArray<T> = array of T;

function main(): integer;
var
  DOG: string;
  Dog: string;
  d: Variant;
  dog: string;
  pkg_DOG: string;
  pkg_dog: string;
begin
  pkg_dog := 'Salt';
  Dog := 'Pepper';
  pkg_DOG := 'Mustard';
  d := packageSees(pkg_dog, Dog, pkg_DOG);
  writeln('There are ' + IntToStr(Length(d)) + ' dogs.
');
  dog := 'Benjamin';
  d := packageSees(pkg_dog, Dog, pkg_DOG);
  writeln('Main sees:   ' + dog + ' ' + Dog + ' ' + pkg_DOG);
  d['dog'] := True;
  d['Dog'] := True;
  d['pkg_DOG'] := True;
  writeln('There are ' + IntToStr(Length(d)) + ' dogs.
');
  Dog := 'Samba';
  d := packageSees(pkg_dog, Dog, pkg_DOG);
  writeln('Main sees:   ' + dog + ' ' + Dog + ' ' + pkg_DOG);
  d['dog'] := True;
  d['Dog'] := True;
  d['pkg_DOG'] := True;
  writeln('There are ' + IntToStr(Length(d)) + ' dogs.
');
  DOG := 'Bernie';
  d := packageSees(pkg_dog, Dog, pkg_DOG);
  writeln('Main sees:   ' + dog + ' ' + Dog + ' ' + DOG);
  d['dog'] := True;
  d['Dog'] := True;
  d['pkg_DOG'] := True;
  d['DOG'] := True;
  writeln('There are ' + IntToStr(Length(d)) + ' dogs.');
end;

begin
  main();
end.
