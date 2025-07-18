// Generated by Mochi compiler v0.10.30 on 1970-01-01T00:00:00Z
program ActiveDirectorySearchForAUser;
{$mode objfpc}
{$modeswitch nestedprocvars}
uses SysUtils, fgl, Classes, Variants;

type
  generic TArray<T> = array of T;

function search_user(directory: specialize TFPGMap<string, specialize TArray<string>>; username: string): specialize TArray<string>;
begin
  result := directory.KeyData[username];
  exit;
end;

procedure main();
var
  _tmp0: specialize TFPGMap<string, Variant>;
  _tmp1: specialize TFPGMap<string, specialize TArray<string>>;
  client: specialize TFPGMap<Variant, Variant>;
  directory: specialize TFPGMap<Variant, Variant>;
  groups: Variant;
  i: integer;
  out: string;
begin
  _tmp0 := specialize TFPGMap<string, Variant>.Create;
  _tmp0.AddOrSetData('Base', 'dc=example,dc=com');
  _tmp0.AddOrSetData('Host', 'ldap.example.com');
  _tmp0.AddOrSetData('Port', 389);
  _tmp0.AddOrSetData('GroupFilter', '(memberUid=%s)');
  client := _tmp0;
  _tmp1 := specialize TFPGMap<string, specialize TArray<string>>.Create;
  _tmp1.AddOrSetData('username', specialize TArray<string>(['admins', 'users']));
  _tmp1.AddOrSetData('john', specialize TArray<string>(['users']));
  directory := _tmp1;
  groups := search_user(directory, 'username');
  if (Length(groups) > 0) then
  begin
    out := 'Groups: [';
    i := 0;
    while (i < Length(groups)) do
    begin
      out := out + '"' + groups[i] + '"';
      if (i < Length(groups) - 1) then ;
      i := i + 1;
    end;
    out := out + ']';
    writeln(out);
  end else
  begin
    writeln('User not found');
  end;
end;

begin
  main();
end.
