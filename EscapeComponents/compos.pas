{
  ESCAPE, Environment for the Simulation of Computer Architectures
  for the Purpose of Education
  Copyright (C) 1998-2001 Peter Verplaetse, ELIS Department, Ghent University
  Copyright (C) 2010-2015 Jonas Maebe, ELIS Department, Ghent University
  Copyright (C) 1996-1998 Jan Van Campenhout, ELIS Department, Ghent University

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
}


{ Project: Escape                                                            }
{ Version: 1.1                                                               }
{ Author: Peter Verplaetse                                                   }
{ Date: 22 July 1998                                                         }

unit Compos;

{$MODE Delphi}

{ This unit contains components to be installed before building Escape }

interface

uses
  SysUtils, {WinTypes, WinProcs,} Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Spin, Menus, ExtCtrls, Grids, lmessages, lcltype;

type
  { TNewStringGrid: TStringGrid with an extra function to simulate a key press }
  TNewStringGrid = class(TStringGrid)
  public
    procedure PressKey(Key: Word; Shift: TShiftState);
  end;

  { TEditInteger: like TEdit, but only for Integer values }
  TEditInteger = class(TEdit)
  private
    FMinValue: LongInt;
    FMaxValue: LongInt;
    procedure CMExit(var Message: TLMExit);   message LM_EXIT;
    function GetValue: LongInt;
    procedure SetValue (NewValue: LongInt);
    function CheckValue (NewValue: LongInt): LongInt;
  protected
    procedure KeyPress(var Key: Char); override;
    function IsValidChar(Key: Char): Boolean;
  published
    property MinValue: LongInt read FMinValue write FMinValue default 0;
    property MaxValue: LongInt read FMaxValue write FMaxValue default 0;
    property Value: LongInt read GetValue write SetValue;
  end;

  { THexSpin: Like TSpinEdit, but with hexadecimal display and non-fixed increment }
  THexSpin = class(TSpinEdit)
  private
    FIncrement: Integer;
    FDigits: Integer;
    function GetValue2: LongInt;
    procedure SetValue2 (Val: LongInt);
    function CheckValue(Val: LongInt): LongInt;
//    procedure UpClick (Sender: TObject); override;
//    procedure DownClick (Sender: TObject); override;
    procedure DoExit; override;
  protected
    procedure KeyPress(var Key: Char); override;
  published
    property Increment: Integer read FIncrement write FIncrement default 1;
    property Digits: Integer read FDigits write FDigits default 8;
    property Value: LongInt read GetValue2 write SetValue2;
  end;

  { TIntegerComboBox: a combox containing only integer values, with a value
      property }
  TIntegerComboBox = class(TCombobox)
  private
    function GetValue: LongInt;
    procedure SetValue(NewValue: LongInt);
    function GetExponentValue: LongInt;
    procedure SetExponentValue(NewExponent: Longint);
  published
    property Value: LongInt read GetValue write SetValue;
    property Exponent: LongInt read GetExponentValue write SetExponentValue;
  end;

  { TRegBox: TEdit with different border }
  TRegBox = class(TCustomPanel)
  private
    FEdit: TEdit;
    FPanel: TCustomPanel;
  protected
    procedure Paint; override;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    function GetReadOnly: Boolean;
    procedure SetReadOnly(Val: Boolean);
    function GetText: string;
    procedure SetText(Val: string);
    function GetCol: TColor;
    procedure SetCol(Val: Tcolor);
  public
    constructor Create(AOwner: TComponent); override;
    property Text: string read GetText write SetText;
  published
    property Color: TColor read GetCol write SetCol default clWindow;
    property Font;
    property ParentFont;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default true;
  end;

  { TRegFileBox: TMemo with different border }
  TRegFileBox = class(TCustomPanel)
  private
    FMemo: TMemo;
  protected
    procedure Paint; override;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    function GetReadOnly: Boolean;
    procedure SetReadOnly(Val: Boolean);
    function GetLines: TStrings;
    procedure SetLines(Val: TStrings);
    function GetCol: TColor;
    procedure SetCol(Val: Tcolor);
  public
    constructor Create(AOwner: TComponent); override;
    property Lines: TStrings read GetLines write SetLines;
    procedure Clear;
  published
    property Color: TColor read GetCol write SetCol default clWindow;
    property Font;
    property ParentFont;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default true;
  end;

  { TMuxORBusBox: Busses and multiplexers are really the same thing }
  TMuxOrBusBox = class(TGraphicControl)
  protected
    FIndex: Integer;
    procedure SetIndex(Value: Integer); virtual;
  published
    property Index: Integer read FIndex write SetIndex default 0;
  end;

  { TMuxBox: multiplexer symbol}
  TMuxBox = class(TMuxOrBusBox)
  private
    FLeftToRight: Boolean;
    FInputs: Integer;
    FOverlap: Integer;
    FBarWidth: Integer;
    FBoxHeight: Integer;
    FRealHeight: Integer;
    function GetPosition(Index: Integer): Integer;
    procedure Paint; override;
    procedure SetLeftToRight(Value: Boolean);
    procedure SetInputs(Value: Integer);
    procedure SetIndex(Value: Integer); override;
    procedure SetOverlap(Value: Integer);
    procedure SetBarWidth(Value: Integer);
    procedure SetBoxHeight(Value: Integer);
    procedure CalcParams;
    constructor Create(AOwner: TComponent); override;
  public
    { Returns the vertical position of the multiplexer data terminal}
    property Position[Index: Integer]: Integer read GetPosition;
  published
    { Orientation }
    property LeftToRight: Boolean read FLeftToRight write SetLeftToRight default true;
    { Number of inputs }
    property Inputs: Integer read FInputs write SetInputs default 2;
    { Selected input (0 -- Inputs-1 }
    property Index: Integer read FIndex write SetIndex default 0;
    { Number of pixels the vertical bar overlaps the outermost terminals }
    property Overlap: Integer read FOverlap write SetOverlap default 3;
    { Width of the vertical bar }
    property BarWidth: Integer read FBarWidth write SetBarWidth default 2;
    { Height of the termial box }
    property BoxHeight: Integer read FBoxHeight write SetBoxHeight default 4;
   end;

  { TBusBox }
  { btLeft:  Selectable (input) , connects to the left
    btRight: Selectable (input) , connects to the Right
    btBoth:  Selectable (input) , connects to both sides
    btConnect: Always selected (output). Doesn't matter where it connects }
  TBusTerminalType = (btLeft,btRight,btBoth,btConnect);
  TBusTerminal = record
    Position: Integer;
    TerminalType: TBusTerminalType;
  end;
  TBusBox = class(TMuxOrBusBox)
  private
    FInputs: Integer;
    FBarWidth: Integer;
    FBoxOverlap: Integer;
    FTerminal: array [0..255] of TBusTerminal;
    function GetPosition(Index: Integer): Integer;
    procedure SetTerminal(Index: Integer; Value: TBusTerminal);
    procedure Paint; override;
    procedure SetInputs(Value: Integer);
    procedure SetIndex(Value: Integer); override;
    procedure SetBarWidth(Value: Integer);
    procedure SetBoxOverlap(Value: Integer);
    constructor Create(AOwner: TComponent); override;
  public
    { Use Position to get the terminal position }
    property Position[Index: Integer]: Integer read GetPosition;
    { Use Terminal to set the terminal position and type }
    property Terminal[Index: Integer]: TBusTerminal write SetTerminal;
  published
    property Inputs: Integer read FInputs write SetInputs default 3;
    property Index: Integer read FIndex write SetIndex default 3;
    property BarWidth: Integer read FBarWidth write SetBarWidth default 2;
    { Number of pixels the terminal box overlaps the vertical bar on each side }
    property BoxOverlap: Integer read FBoxOverlap write SetBoxOverlap default 2;
   end;

  { TLineBox: TPanel with additional functionality to draw rectilinear lines }
  TWire = class
    Points: TList;
    Dotted: Boolean;
    Objec: TObject;
    procedure Paint(Canvas: TCanvas);
    constructor Create(Dot: Boolean; Obj: TObject);
    destructor Destroy; override;
    { Returns the minimum rectilinear distance to point (X,Y) }
    function Distance(X,Y: Integer): Integer;
  end;

  TLineBox = class(TPanel)
  private
    Wires: TList;
    procedure Paint; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  public
    procedure ClearWires;
    { Draws a wire. When Dot = true the line starts with a dot. When Horizontal = true the
      initial direction is horizontal. Start is the starting point, and Pos is an array with
      Y (X) coordinates for the horizontal (vertical) lines. Obj can be any object }
    procedure AddWire(Obj:TObject; Dot: Boolean; Start: TPoint; Horizontal: Boolean; Pos: array of Integer);
    { Returns the object associated with the nearest wire, or nil if no wire is near enough }
    function Objects(X,Y: Integer): TObject;
  end;

  { TAluBox: ALU symbol }
  TAluBox = class(TGraphicControl)
  private
    FColor: TColor;
    procedure Paint; override;
  published
    property Color: TColor read FColor write FColor default clBlack;
  end;

  { TComparatorBox: Comparator symbol }
  TComparatorBox = class(TGraphicControl)
  private
    FColor: TColor;
    FLeftToRight: Boolean;
    procedure Paint; override;
    constructor Create(AOwner: TComponent); override;
  published
    property Color: TColor read FColor write FColor default clBlack;
    property LeftToRight: Boolean read FLeftToRight write FLeftToRight default true;
  end;

  { T3DShape: Shape with 3D border }
  TShape3D = class(TGraphicControl)
  private
    FColor: TColor;
    FShape: TShapeType;
    procedure Paint; override;
  published
    property Color: TColor read FColor write FColor default clBlack;
    property Shape: TShapeType read FShape write FShape default stSquare;
  end;

procedure Register;
{ Use this function to generate objects of type BusTerminal }
function BusTerminal(Position: Integer; TerminalType: TBusTerminalType): TBusTerminal;
{ This procedure draws a 3D border }
procedure Draw3DBox(Canvas: TCanvas; Width,Height: Integer);

implementation

uses
  NewStr;

{ TNewStringGrid }
procedure TNewStringGrid.PressKey(Key: Word; Shift: TShiftState);
var
  K: Word;
begin
  K:=Key;
  KeyDown(K,Shift)
end;

{ TEditInteger }
procedure TEditInteger.KeyPress(var Key: Char);
begin
  if not IsValidChar(Key) then
  begin
    Key := #0;
//    MessageBeep(0)
  end;
  if Key <> #0 then inherited KeyPress(Key);
end;

function TEditInteger.IsValidChar(Key: Char): Boolean;
begin
  { Filter the keys }
  Result := (Key in [{DecimalSeparator, }'+', '-', '0'..'9']) or
    ((Key < #32) and (Key <> Chr(VK_RETURN)));
end;

function TEditInteger.GetValue: LongInt;
begin
  try
    Result := CheckValue(StrToInt(Text));
  except
    Result := FMinValue;
    Text := IntToStr(Result);
  end;
end;

procedure TEditInteger.SetValue(NewValue: LongInt);
begin
  Text := IntToStr(CheckValue(NewValue));
end;

function TEditInteger.CheckValue(NewValue: LongInt): LongInt;
begin
  Result := NewValue;
  if (FMaxValue <> FMinValue) then
  begin
    if NewValue < FMinValue then
      Result := FMinValue
    else if NewValue > FMaxValue then
      Result := FMaxValue;
  end;
end;

procedure TEditInteger.CMExit(var Message: TLMExit);
begin
  inherited;
  Text := IntToStr(Value);
end;

function THexSpin.GetValue2: LongInt;
begin
  try
    Result:=CheckValue(NewStrToInt(Text,0,2))
  except
    Result:=MinValue
  end;
  Text := IntToHex(Result,FDigits)
end;

{ THexSpin }
function THexSpin.CheckValue(Val: LongInt): LongInt;
begin
  Result := Val;
  if (MaxValue <> MinValue) then
  begin
    if Val < MinValue then
      Result := MinValue
    else if Val > MaxValue then
      Result := MaxValue;
  end;
end;

procedure THexSpin.SetValue2 (Val: LongInt);
begin
  Text := IntToHex(CheckValue(Val),FDigits)
end;
(*
procedure THexSpin.UpClick (Sender: TObject);
begin
  if ReadOnly then MessageBeep(0)
  else Value := Value + FIncrement;
end;

procedure THexSpin.DownClick (Sender: TObject);
begin
  if ReadOnly then MessageBeep(0)
  else Value := Value - FIncrement;
end;
*)
procedure THexSpin.DoExit;
begin
  GetValue2
end;

procedure THexSpin.KeyPress(var Key: Char);
begin
end;

{ TRegBox }
procedure Draw3DBox(Canvas: TCanvas; Width,Height: Integer);
begin
  with Canvas do
  begin
    Pen.Style:=psSolid;
    Pen.Color:=clBtnHighlight;
    PolyLine([Point(0,Height-2),Point(0,0),Point(Width-1,0)]);
    Pen.Color:=clBtnFace;
    PolyLine([Point(1,Height-3),Point(1,1),Point(Width-2,1)]);
    Pen.Color:=clBtnShadow;
    PolyLine([Point(1,Height-2),Point(Width-2,Height-2),Point(Width-2,1)]);
    Pen.Color:=clWindowText;
    PolyLine([Point(0,Height-1),Point(Width-1,Height-1),Point(Width-1,0)])
  end
end;

constructor TRegBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPanel:=TCustomPanel.Create(Self);
  FPanel.Parent:=Self;
  FEdit:=TEdit.Create(FPanel);
  FEdit.Parent:=FPanel;
  FPanel.Left:=Left+2;
  FPanel.Top:=Top+2;
  FEdit.BorderStyle:=bsNone;
  FEdit.ReadOnly:=true;
  FEdit.Color:=clWindow
end;

procedure TRegBox.Paint;
begin
  Draw3DBox(Canvas,Width,Height)
end;

procedure TRegBox.WMSize(var Message: TWMSize);
var
  PreferredWidth, PreferredHeight: Integer;
begin
  inherited;
  FPanel.Width:=Width-4;
  FEdit.Width:=Width-1;
  Canvas.Font:=Font;
  FEdit.GetPreferredSize(PreferredWidth,PreferredHeight);
  Height:=PreferredHeight+5;
  Fpanel.Height:=Height-4;
  FEdit.Height:=Height-2;
  Message.Result:=0;
end;

function TRegBox.GetReadOnly: Boolean;
begin
  Result:=FEdit.ReadOnly
end;

procedure TRegBox.SetReadOnly(Val: Boolean);
begin
  FEdit.ReadOnly:=Val
end;

function TRegBox.GetText: string;
begin
  Result:=FEdit.Text
end;

procedure TRegBox.SetText(Val: string);
begin
  FEdit.Text:=Val
end;

function TRegBox.GetCol: TColor;
begin
  Result:=FEdit.Color
end;

procedure TRegBox.SetCol(Val: TColor);
begin
  FEdit.Color:=Val
end;

{ TRegFileBox }
constructor TRegFileBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMemo:=TMemo.Create(Self);
  FMemo.Parent:=Self;
  FMemo.Left:=2;
  FMemo.Top:=2;
  FMemo.BorderStyle:=bsNone;
  FMemo.ReadOnly:=true;
  FMemo.Color:=clWindow
end;

procedure TRegFileBox.Paint;
begin
  Draw3DBox(Canvas,Width,Height)
end;

procedure TRegFileBox.WMSize(var Message: TWMSize);
begin
  inherited;
  FMemo.Width:=Width-5;
  FMemo.Height:=Height-5;
  Message.Result:=0;
end;

function TRegFileBox.GetReadOnly: Boolean;
begin
  Result:=FMemo.ReadOnly
end;

procedure TRegFileBox.SetReadOnly(Val: Boolean);
begin
  FMemo.ReadOnly:=Val
end;

function TRegFileBox.GetLines: TStrings;
begin
  Result:=FMemo.Lines
end;

procedure TRegFileBox.SetLines(Val: TStrings);
begin
  FMemo.Lines:=Val
end;

function TRegFileBox.GetCol: TColor;
begin
  Result:=FMemo.Color
end;

procedure TRegFileBox.SetCol(Val: TColor);
begin
  FMemo.Color:=Val
end;

procedure TRegFileBox.Clear;
begin
  FMemo.Clear
end;

{ TmuxBox }
procedure TMuxOrBusBox.SetIndex(Value: Integer);
begin
  FIndex:=Value
end;

constructor TMuxBox.Create(AOwner: TComponent);
begin
  inherited Create(Aowner);
  FBarWidth:=2;
  FBoxHeight:=4;
  FIndex:=0;
  FInputs:=2;
  FLeftToRight:=true;
  FOverlap:=3
end;

procedure TMuxBox.CalcParams;
begin
  if FBoxHeight<1 then
    FBoxHeight:=1;
  if FOverlap<0 then FOverlap:=0;
  FRealHeight:=Height-2*FOverlap-FBoxHeight+1;
  if FRealHeight<FBoxHeight*(FInputs-1) then
  begin
    Height:=2*FOverlap+FBoxHeight+FBoxHeight*(FInputs-1)-1;
    FRealHeight:=0
  end
end;

procedure TMuxBox.Paint;
var
  BarLeft: Integer;
  BarRight: Integer;
  NotBoxLeft: Integer;
  NotBoxRight: Integer;
  i,Pos: Integer;
begin
  CalcParams;
  if Width<BarWidth then
    Width:=BarWidth;
  if FIndex>=FInputs then
    FIndex:=FInputs-1;
  if FIndex<0 then
    FIndex:=0;
  if FLeftToRight then
  begin
    BarLeft:=Width-BarWidth;
    BarRight:=Width;
    NotBoxLeft:=0;
    NotBoxRight:=BoxHeight
  end
  else begin
    BarLeft:=0;
    BarRight:=BarWidth;
    NotBoxLeft:=Width-BoxHeight;
    NotBoxRight:=Width
  end;
  Canvas.Brush.style:=bsSolid;
  Canvas.Brush.color:=clBtnFace;
  Canvas.FillRect(Rect(0,FOverlap,Width,FOverlap+FRealHeight+FBoxHeight));
  Canvas.Brush.color:=clBlack;
  Canvas.FillRect(Rect(BarLeft,0,BarRight,Height));
  for i:=0 to FInputs-1 do
  begin
    Pos:=FRealHeight*i div (FInputs-1)+FOverlap;
    if i=FIndex then
      Canvas.Rectangle(0,Pos,Width,Pos+FBoxHeight)
    else
      Canvas.Rectangle(NotBoxLeft,Pos,NotBoxRight,Pos+FBoxHeight)
  end
end;

function TMuxBox.GetPosition(Index: Integer): Integer;
begin
  CalcParams;
  if (Index<0) or (Index>=Inputs) then
    Result:=-1
  else
    Result:=Top+FRealHeight*Index div (FInputs-1)+FOverlap+ (FBoxHeight-1) div 2;
end;

procedure TMuxBox.SetLeftToRight(Value: Boolean);
begin
  FLeftToRight:=Value;
  Invalidate;
end;

procedure TMuxBox.SetInputs(Value: Integer);
begin
  FInputs:=Value;
  Invalidate;
end;

procedure TMuxBox.SetIndex(Value: Integer);
begin
  FIndex:=Value;
  Invalidate;
end;

procedure TMuxBox.SetOverlap(Value: Integer);
begin
  FOverlap:=Value;
  Invalidate;
end;

procedure TMuxBox.SetBarWidth(Value: Integer);
begin
  FBarWidth:=Value;
  Invalidate;
end;

procedure TMuxBox.SetBoxHeight(Value: Integer);
begin
  FBoxHeight:=Value;
  Invalidate;
end;

{ TBusBox }
constructor TBusBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInputs:=3;
  FIndex:=3;
  FBarWidth:=2;
  FBoxOverlap:=2
end;

function TBusBox.GetPosition(Index: Integer): Integer;
begin
  if Index>=FInputs then
    raise Exception.Create('Index out of range while reading TBusBox');
  Result:=Top+FTerminal[Index].Position+ (Width-1) div 2
end;

procedure TBusBox.SetTerminal(Index: Integer; Value: TBusTerminal);
begin
  if Index>=FInputs then
    raise Exception.Create('Index out of range while writing TBusBox');
  FTerminal[Index]:=Value;
  Invalidate;
end;

procedure TBusBox.Paint;
var
  BarLeft: Integer;
  BarRight: Integer;
  BoxLeft: Integer;
  BoxRight: Integer;
  Top,Bottom: Integer;
  HMid,VMid: Integer;
  i: Integer;
begin
  if Width<BarWidth then
    Width:=BarWidth;
  if FIndex>FInputs then
    FIndex:=FInputs;
  if FIndex<0 then
    FIndex:=0;
  BarLeft:=(Width-BarWidth) div 2;
  BarRight:=BarLeft+BarWidth;
  BoxLeft:=BarLeft-BoxOverlap;
  BoxRight:=BarRight+BoxOverlap+1;
  Canvas.Brush.style:=bsSolid;
  HMid:=Width div 2;
  for i:=0 to FInputs-1 do
  begin
    VMid:=FTerminal[i].Position;
    Top:=VMid-(BarWidth div 2+BoxOverlap-1);
    Bottom:=Top+BarWidth+2*BoxOverlap;
    Canvas.Pen.Style:=psClear;
    Canvas.Brush.color:=clBlack;
    if (FTerminal[i].TerminalType=btConnect) or (FIndex=i) then
      Canvas.Rectangle(BoxLeft,Top,BoxRight,Bottom)
    else begin
      Canvas.Brush.color:=clBtnFace;
      Canvas.FillRect(Rect(BoxLeft,Top,BoxRight,Bottom));
      Canvas.Brush.color:=clBlack;
      Canvas.Pen.Style:=psSolid;
      if FTerminal[i].TerminalType=btRight then
        Canvas.MoveTo(HMid,VMid)
      else
        Canvas.MoveTo(BoxLeft,VMid);
      if FTerminal[i].TerminalType=btLeft then
        Canvas.LineTo(HMid,VMid)
      else
        Canvas.LineTo(BoxRight,VMid);
      Canvas.Pen.Style:=psClear
    end
  end;
  Canvas.FillRect(Rect(BarLeft,0,BarRight,Height))
end;

procedure TBusBox.SetInputs(Value: Integer);
begin
  FInputs:=Value;
  if (FInputs<0) or (FInputs>256) then
  begin
    raise Exception.Create('Number of inputs out of range (0..256)');
    FInputs:=1
  end;
  Invalidate;
end;

function BusTerminal(Position: Integer; TerminalType: TBusTerminalType): TBusTerminal;
begin
  Result.Position:=Position;
  Result.TerminalType:=TerminalType
end;

procedure TBusBox.SetIndex(Value: Integer);
begin
  FIndex:=Value;
  Invalidate;
end;

procedure TBusBox.SetBarWidth(Value: Integer);
begin
  FBarWidth:=Value;
  Invalidate;
end;

procedure TBusBox.SetBoxOverlap(Value: Integer);
begin
  FBoxOverlap:=Value;
  Invalidate;
end;

{ TLineBox }
constructor TWire.Create(Dot: Boolean; Obj: TObject);
begin
  Dotted:=Dot;
  Objec:=Obj;
  Points:=TList.Create
end;

destructor TWire.Destroy;
type
  PPoint = ^TPoint;
var
  j: Integer;
begin
  for j:=0 to Points.Count-1 do
    Dispose(PPoint(Points[j]));
  Points.Free;
  inherited Destroy;
end;

function TWire.Distance(X,Y: Integer): Integer;
var
  j,d,min,max: Integer;
  P1,P2: ^TPoint;
begin
  Result:=10000;
  for j:=1 to Points.Count-1 do
  begin
    P1:=Points[j-1];
    P2:=Points[j];
    if P1^.X<>P2^.X then
    begin
      d:=Abs(Y-P1^.Y);
      if P1^.X<P2^.X then
      begin
        min:=P1^.X;
        max:=P2^.X;
      end else
      begin
        min:=P2^.X;
        max:=P1^.X;
      end;
      if X<min then
        d:=d+min-X
      else if X>max then
        d:=d+X-max
    end else
    begin
      d:=Abs(X-P1^.X);
      if P1^.Y<P2^.Y then
      begin
        min:=P1^.Y;
        max:=P2^.Y;
      end else
      begin
        min:=P2^.Y;
        max:=P1^.Y;
      end;
      if Y<min then
        d:=d+min-Y
      else if Y>max then
        d:=d+Y-max
    end;
    if d<Result then
      Result:=d
  end
end;

procedure TWire.Paint(Canvas: TCanvas);
var
  j: Integer;
  P: ^TPoint;
begin
  for j:=0 to Points.Count-1 do
  begin
    P:=Points[j];
    if j=0 then
    begin
      Canvas.MoveTo(P^.X,P^.Y);
      if Dotted then
        Canvas.FillRect(Rect(P^.X-1,P^.Y-1,P^.X+2,P^.Y+2))
    end else
      Canvas.LineTo(P^.X,P^.Y)
  end
end;

constructor TLineBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Wires:=TList.Create;
end;

destructor TLineBox.Destroy;
begin
  ClearWires;
  Wires.Free;
  inherited Destroy
end;

procedure TLineBox.ClearWires;
var
  i: Integer;
  Wire: ^TWire;
begin
  for i:=0 to Wires.Count-1 do
  begin
    Wire:=Wires[i];
    Wire^.Free;
    Dispose(Wire)
  end;
  Wires.Clear;
  Wires.Pack;
end;

procedure TLineBox.AddWire(Obj: TObject; Dot: Boolean; Start: TPoint;
                                Horizontal: Boolean; Pos: array of Integer);
var
  Wire: ^TWire;
  Point: ^TPoint;
  i: Integer;
begin
  New(Wire);
  Wire^:=TWire.Create(Dot,Obj);
  New(Point);
  Point^:=Start;
  Wire^.Points.Add(Point);
  for i:=0 to High(Pos) do
  begin
    if Horizontal then
      Start.X:=Pos[i]
    else
      Start.Y:=Pos[i];
    Horizontal:=not Horizontal;
    New(Point);
    Point^:=Start;
    Wire^.Points.Add(Point)
  end;
  Wires.Add(Wire)
end;

function TLineBox.Objects(X,Y: Integer): TObject;
var
  i,d,min: Integer;
  Wire,minWire: ^TWire;
begin
  min:=10;
  for i:=0 to Wires.Count-1 do
  begin
    Wire:=Wires[i];
    d:=Wire^.Distance(X,Y);
    if d<min then
    begin
      min:=d;
      minWire:=Wire
    end
  end;
  if min>=10 then
    Result:=nil
  else
    Result:=minWire^.Objec
end;

procedure TLineBox.Paint;
var
  i: Integer;
  Wire: ^TWire;
begin
  inherited Paint;
  Canvas.Pen.Color:=clBlack;
  Canvas.Brush.Color:=clBlack;
  for i:=0 to Wires.Count-1 do
  begin
    Wire:=Wires[i];
    Wire^.Paint(Canvas)
  end
end;

{ TAluBox }
procedure TAluBox.Paint;
var
  W,H: Integer;
begin
  W:=(Width-1) div 2;
  H:=(Height-1) div 8;
  Canvas.Brush.Color:=FColor;
  Canvas.Pen.Color:=clBtnFace;
  Canvas.Pen.Width:=2;
  Canvas.Polygon([Point(1,1),Point(2*W+1,2*H+1),Point(2*W+1,6*H+1),Point(1,8*H+1),
                  Point(1,5*H+1),Point(W+1,4*H+1),Point(1,3*H+1),Point(1,1)]);
  Canvas.Pen.Color:=clBtnHighlight;
  Canvas.Pen.Width:=1;
  Canvas.PolyLine([Point(0,3*H+1),Point(0,1),Point(2,1),Point(2*W+2,2*H+1)]);
  Canvas.PolyLine([Point(0,8*H+1),Point(0,5*H+1),Point(W,4*H+1)]);
  Canvas.Pen.Color:=clBtnShadow;
  Canvas.PolyLine([Point(2*W,2*H+1),Point(2*W,6*H),Point(2*W+1,6*H),Point(1,8*H)]);
  Canvas.PolyLine([Point(W,4*H),Point(0,3*H)]);
  Canvas.Pen.Color:=clWindowText;
  Canvas.PolyLine([Point(2*W+1,2*H),Point(2*W+1,6*H+1),Point(1,8*H+1),Point(-1,8*H+1)]);
  Canvas.PolyLine([Point(W,4*H+1),Point(-1,3*H)]);
end;

{ TComparatorBox }
constructor TComparatorBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLeftToRight:=true
end;

procedure TComparatorBox.Paint;
var
  W,H: Integer;
begin
  W:=(Width-1) div 2;
  H:=(Height-1) div 6;
  Canvas.Brush.Color:=FColor;
  Canvas.Pen.Width:=2;
  Canvas.Pen.Color:=clBtnFace;
  if FLeftToRight then
  begin
    Canvas.Polygon([Point(1,1),Point(2*W+1,2*H+1),Point(2*W+1,4*H+1),Point(1,6*H+1),Point(1,1)]);
    Canvas.Pen.Color:=clBtnHighlight;
    Canvas.Pen.Width:=1;
    Canvas.PolyLine([Point(0,6*H+1),Point(0,1),Point(2,1),Point(2*W+2,2*H+1)]);
    Canvas.Pen.Color:=clBtnShadow;
    Canvas.PolyLine([Point(2*W,2*H+1),Point(2*W,4*H),Point(-1,6*H+1)]);
    Canvas.Pen.Color:=clWindowText;
    Canvas.PolyLine([Point(2*W+1,2*H),Point(2*W+1,4*H+1),Point(1,6*H+1),Point(-1,6*H+1)])
  end else
  begin
    Canvas.Polygon([Point(1+2*W,1),Point(1,2*H+1),Point(1,4*H+1),Point(1+2*W,6*H+1),Point(1+2*W,1)]);
    Canvas.Pen.Color:=clBtnHighlight;
    Canvas.Pen.Width:=1;
    Canvas.PolyLine([Point(2+2*W,1),Point(2*W,1),Point(0,2*H+1),Point(0,4*H+1)]);
    Canvas.Pen.Color:=clBtnShadow;
    Canvas.PolyLine([Point(0,4*H),Point(2*W,6*H),Point(2*W,1)]);
    Canvas.Pen.Color:=clWindowText;
    Canvas.PolyLine([Point(0,4*H+1),Point(2*W,6*H+1),Point(1+2*W,6*H+1),Point(1+2*W,1)])
  end
end;

{ TShape3D }
procedure TShape3D.Paint;
begin
  Canvas.Brush.Color:=FColor;
  case FShape of
    stEllipse:
      begin
        Canvas.Pen.Color:=clBtnFace;
        Canvas.Ellipse(1,1,Width-1,Height-1);
        Canvas.Pen.Color:=clBtnHighlight;
        Canvas.Arc(0,0,Width,Height,Width,0,0,Height);
        Canvas.Pen.Color:=clBtnShadow;
        Canvas.Arc(1,1,Width-1,Height-1,0,Height,Width,0);
        Canvas.Pen.Color:=clWindowText;
        Canvas.Arc(0,0,Width,Height,0,Height,Width,0)
      end;
    stSquare, stRectangle:
      begin
        if FShape=stSquare then
        begin
          if Height>Width then
            Height:=Width
          else
            Width:=Height;
        end;
        Canvas.FillRect(Rect(2,2,Width-2,Height-2));
        Draw3DBox(Canvas,Width,Height)
      end
    else
      raise Exception.Create('3D shape not supported')
  end
end;

{ Component registration }
procedure Register;
begin
  RegisterComponents('Compos', [TEditInteger, THexSpin, TIntegerComboBox,TMuxBox,
                            TbusBox, TAluBox, TLineBox, TComparatorBox,
                            TNewStringGrid, TRegBox, TRegFileBox, TShape3D])
end;

{ TIntegerComboBox }

function TIntegerComboBox.GetValue: LongInt;
  begin
    if (ItemIndex<0) or
       (ItemIndex>Items.Count-1) then
      Result:=-1
    else
      Result:=StrToInt(Items[ItemIndex]);
  end;

procedure TIntegerComboBox.SetValue(NewValue: LongInt);
  var
    newindex: longint;
  begin
    newindex:=Items.IndexOf(IntToStr(NewValue));
    if newindex>=0 then
      ItemIndex:=newindex
    else
      ItemIndex:=-1;
  end;

function Log2(Value: LongInt): Integer;
begin
  if Value<1 then
    Value:=1;
  Result:=0;
  while Value>1 do
  begin
    Result:=Result+1;
    Value:=Value shr 1;
  end
end;


function TIntegerComboBox.GetExponentValue: LongInt;
  begin
    Result:=Log2(Value);
  end;

procedure TIntegerComboBox.SetExponentValue(NewExponent: Longint);
  begin
    Value:=1 shl NewExponent;
  end;

end.
