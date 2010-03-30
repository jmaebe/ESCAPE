unit NewStr;

interface

uses
  SysUtils;

  { Like IntToStr, but supports Hexadecimal and unsigned LongInt.
    Width: number of digits
    Base: 0 -> hexadecimal, 1 -> unsigned decimal, 2 -> signed decimal }
  function NewIntToStr(Value: LongInt; Width, Base: Integer): string;
  { Like StrToInt, but supports Hexadecimal and works with bytes and halfwords too.
    GroupSize: 0 -> byte, 1 -> half, 2 -> word }
  function NewStrToInt(S: string; Base, GroupSize: Integer): LongInt;
  { char to integer }
  function HexToInt(c: char): Integer;

implementation

function NewIntToStr(Value: LongInt; Width, Base: Integer): string;
var
  FormatString1, FormatString2: string;
begin
  if Base>0 then
  begin
    FormatString1:='%'+IntToStr(Width)+'d';
    FormatString2:='%'+IntToStr(Width-1)+'d'
  end;
  case Base of
    0: Result:=IntToHex(Value,Width);
    1: if Value<0 then
         Result:=Format(FormatString2,[((Value shr 1)div 5) and $7FFFFFFF])
                            +IntToStr(((Value shr 1)mod 5) shl 1 + (Value and 1))
       else
         Result:=Format(FormatString1,[Value]);
    2: Result:=Format(FormatString1,[Value])
  end
end;

function NewStrToInt(S: string; Base, GroupSize: Integer): LongInt;
var
  i,h: Integer;
begin
  if (Base=1) and (GroupSize=2) and (Length(S)>8) then
    Result:=((StrToIntDef(copy(S,1,9),0)*5) shl 1)+StrToIntDef(S[10],0)
  else
    if Base=0 then
    begin
      Result:=0;
      for i:=1 to (Length(S)) do
      begin
        h:=HexToInt(S[i]);
        if h>=0 then
          Result:=Result shl 4 +h
        else
          break
      end
    end else
      Result:=StrToIntDef(S,0);
  if GroupSize<2 then
    Result:=Result and ($100 shl (GroupSize*8) -1);
end;

function HexToInt(c: char): Integer;
begin
  case c of
    '0'..'9': Result:=Ord(c)-Ord('0');
    'a'..'f': Result:=Ord(c)-Ord('a')+10;
    'A'..'F': Result:=Ord(c)-Ord('A')+10
  else
    Result:=-1
  end
end;

end.
 