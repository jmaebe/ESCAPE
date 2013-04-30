unit platformconsts;

{$mode delphi}

interface

Const
{$ifdef LCLQt}
  { microcod constants }
  MSSansSerif8HeightGridRowFudge = 0;
  MSSansSerif8MicroCodeAddrWidthFudge = 4;
  DropBoxHeightFudge = 5;
{$endif}

{$ifdef LCLCarbon}
  { microcod constants }
  MSSansSerif8HeightGridRowFudge = 6;
  MSSansSerif8MicroCodeAddrWidthFudge = 4;
  DropBoxHeightFudge = 5;
{$endif}

{$ifdef LCLWin32}
  { microcod constants }
  MSSansSerif8HeightGridRowFudge = 0;
  MSSansSerif8MicroCodeAddrWidthFudge = 0;
  DropBoxHeightFudge = 0;
{$endif}

{$ifdef LCLGtk2}
  { microcod constants }
  MSSansSerif8HeightGridRowFudge = 0;
  MSSansSerif8MicroCodeAddrWidthFudge = 0;
  DropBoxHeightFudge = 0;
{$endif}

implementation

end.

