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

unit Usage;

{$MODE Delphi}

interface

uses
  SysUtils, {WinTypes, WinProcs,} Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids, StdCtrls, ExtCtrls, Menus, LResources;

type
  { Pipeline Usage Form }

  { TUsageForm }

  TUsageForm = class(TForm)
    MainMenu1: TMainMenu;
    View1: TMenuItem;
    HideForm1: TMenuItem;
    PopupMenu1: TPopupMenu;
    HideForm2: TMenuItem;
    Grid: TStringGrid;
    procedure GridResize(Sender: TObject);
    procedure HideForm1Click(Sender: TObject);
    procedure GridDrawCell(Sender: TObject; Col, Row: Longint; Rect: TRect;
      State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure GridTopLeftChanged(Sender: TObject);
  private
    { For each instruction the row in the diagram is recorded in this structure }
    LookupRow: array [0..32768 div 4-1] of Integer; {bits 9-0: Row, bit 14: 1 when stalled}
    { This array has the start time of the instruction on the corresponding row }
    RowStartTime: array [0..1023] of LongInt;
    TopRowStartTime: LongInt;
    NextIndex: Integer;
    NextRow: Integer;
    function MatchStage(Stage: Integer; Time: LongInt; var MatchAdr: LongInt;
                               var Stalled: Boolean): Boolean;
  public
    { Clear the diagram }
    procedure Clear;
    { Add one or more lines to the diagram if necessary }
    procedure AddLines(MaxAmount: Integer);
    { Remove one or more lines to the diagram if necessary }
    procedure RemoveLines(Amount: Integer);
    { Display the current line if not in display }
    procedure ShowLine;
  end;

var
  UsageForm: TUsageForm;

implementation

uses
  Pipe, InstrMem, Common;
{$R *.lfm}

procedure TUsageForm.HideForm1Click(Sender: TObject);
begin
  Hide
end;

procedure TUsageForm.GridResize(Sender: TObject);
begin
  Grid.ColWidths[1]:=Grid.ClientWidth-Grid.CellRect(1,0).Left-1
end;

procedure TUsageForm.GridDrawCell(Sender: TObject; Col, Row: Longint;
  Rect: TRect; State: TGridDrawState);
var
  X,Y: Integer;
  Time: LongInt;
  Stage: Integer;
  Stalled: Boolean;
  MatchAdr: LongInt;
  c: TColor;
  s: string;
begin
  with Grid.Canvas do
  begin
    { Write text in cell }
    Font.Name:='Microsoft Sans Serif';
    if Row=0 then
    begin
      Brush.Color:=clBtnFace;
      Font.Size:=10
    end else
    begin
      Brush.Color:=clWhite;
      Font.Size:=8
    end;
    if (Col=0) and (Row>0) then
      Font.Style:=[]
    else
      Font.Style:=[fsBold];
    Brush.Style:=bsSolid;
    if (Row=0) or (Col=0) then
    begin
      if (Row=0) and (Col=1) then
        X:=Rect.Left+38
      else
        X:=Rect.Left+3;
      if Col=0 then
        Y:=Rect.Top+3
      else
        Y:=Rect.Top+2;
      TextRect(Rect,X,Y,Grid.Cells[Col,Row])
    end else
    begin
      { Draw Boxes }
      FillRect(Rect);
      Pen.Color:=clBtnFace;
      X:=Rect.Left+22;
      while X<=Rect.Right do
      begin
        PolyLine([Point(X,Rect.Top),Point(X,Rect.Bottom)]);
        X:=X+23
      end;
      Time:=RowStartTime[Row-1];
      if Time>=0 then
      begin
        X:=Rect.Left+(Time-TopRowStartTime)*23;
        MatchAdr:=-1;
        Stage:=0;
        c:=clYellow;
        s:='IF';
        Pen.Color:=clBlack;
        while (X<=Rect.Right) and (Stage<5) do
        begin
          if not MatchStage(Stage,Time,MatchAdr,Stalled) then
            break;
          Brush.Style:=bsSolid;
          Brush.Color:=c;
          Rectangle(X,Rect.Top,X+22,Rect.Bottom);
          if Stalled then
          begin
            Brush.Color:=clGray;
            Brush.Style:=bsDiagCross;
            Rectangle(X,Rect.Top,X+22,Rect.Bottom)
          end;
          Brush.Style:=bsClear;
          TextOut(X+(23-TextWidth(s))div 2,Rect.Top+3,s);
          if not Stalled then
          begin
            Stage:=Stage+1;
            case Stage of
              1: begin
                   c:=clLime;
                   s:='ID'
                 end;
              2: begin
                   c:=clAqua;
                   s:='EX'
                 end;
              3: begin
                   c:=clSilver;
                   s:='M'
                 end;
            else
             {4} begin
                   c:=clRed;
                   s:='W'
                 end
            end;
          end;
          X:=X+23;
          Time:=Time+1
        end
      end
    end;
    { Create 3D look for top row }
    if Row=0 then
    begin
      Pen.Color:=clWhite;
      PolyLine([Point(Rect.Right-1,Rect.Top),Point(Rect.Left,Rect.Top),
                Point(Rect.Left,Rect.Bottom)]);
      { Draw arrow }
      if Col=1 then
      begin
        Pen.Color:=clBlack;
        Pen.Width:=2;
        PolyLine([Point(Rect.Left+11,Rect.Bottom),Point(Rect.Left+11,Rect.Top+10),
                  Point(Rect.Left+25,Rect.Top+10)]);
        Pen.Width:=1;
        Brush.Color:=clBlack;
        Brush.Style:=bsSolid;
        Polygon([Point(Rect.Left+25,Rect.Top+4),Point(Rect.Left+31,Rect.Top+10),
                 Point(Rect.Left+25,Rect.Top+16),Point(Rect.Left+25,Rect.Top+4)]);
      end
    end
  end
end;

function TUsageForm.MatchStage(Stage: Integer; Time: LongInt; var MatchAdr: LongInt;
                               var Stalled: Boolean): Boolean;
var
  Index: Integer;
  Adr,p: LongInt;
begin
  with PSimulator do
  begin
    if (Time<ActivityStartTime) or (Time>ActivityTime) or (Time > ActualClock) then
      Result:=false
    else begin
      Index:=(Time-ActivityStartTime+ActivityStartIndex) and 1023;
      p:=ActivityData[Stage,Index];
      Adr:=p and $7FFF;
      if MatchAdr<0 then
        MatchAdr:=Adr;
      Result:=(Adr=MatchAdr) and (p>=0);
      if Result then
        Stalled:=(p and $40000000<>0)
    end
  end
end;

procedure TUsageForm.Clear;
var
  i: Integer;
begin
  for i:=1 to Grid.RowCount-1 do
    Grid.Cells[0,i]:='';
  for i:=0 to High(LookupRow) do
    LookupRow[i]:=-1;
  for i:=0 to high(RowStartTime) do
    RowStartTime[i]:=-1;
  NextIndex:=PSimulator.ActivityStartIndex;
  NextRow:=0
end;

procedure TUsageForm.ShowLine;
var
  DesiredTopRowPos: Integer;
begin
  DesiredTopRowPos:=NextRow+1-Grid.VisibleRowCount;
  if Grid.TopRow+Grid.VisibleRowCount-1<NextRow then
    Grid.TopRow:=DesiredTopRowPos
  else if Grid.TopRow<>DesiredTopRowPos then
    if DesiredTopRowPos>0 then
      Grid.TopRow:=DesiredTopRowPos
    else
      Grid.TopRow:=1;
  GridTopLeftChanged(Self)
end;

procedure TUsageForm.AddLines(MaxAmount: Integer);
var
  l, AmountAdded: Integer;
  p, Adr: LongInt;
begin
  AmountAdded:=0;
  with PSimulator do
    while NextIndex<>ActivityNextIndex do
    begin
      if AmountAdded>=MaxAmount then
        break;
      inc(AmountAdded);
      p:=ActivityData[0,NextIndex];
      if p>=0 then
      begin
        Adr:=p and $7FFF;
        l:=LookupRow[Adr shr 2];
        if l<$4000 then { new pc or not recently stalled }
        begin
          LookupRow[Adr shr 2]:=NextRow;
          RowStartTime[NextRow]:=ActivityStartTime+((NextIndex-ActivityStartIndex) and 1023);
          NextRow:=NextRow+1;
          Grid.Cells[0,NextRow]:=IntToHex(Adr,4)+': '+Disassemble(CodeMemory.Read(Adr,2),Adr,0,false);
          if NextRow>Grid.RowCount-2 then
            raise Exception.Create('Failure: usage diagram: row out of range');
        end;
        if p and $40000000<>0 then
          LookupRow[Adr shr 2]:=LookupRow[Adr shr 2] or $4000
        else
          LookupRow[Adr shr 2]:=LookupRow[Adr shr 2] and $3FFF
      end;
      NextIndex:=(NextIndex+1) and 1023
    end;
  ShowLine
end;

procedure TUsageForm.RemoveLines(Amount: Integer);
var
  l, i, ctr, col, PrevIndex: Integer;
  p, Adr, PrevAdr: LongInt;
  LastWasStall: boolean;
begin
  with PSimulator do
    for ctr:=1 to Amount do
    begin
      if NextRow=0 then
        break;
      NextIndex:=(NextIndex-1) and 1023;
      Adr:=ActivityData[0,NextIndex] and $7fff;
      PrevIndex:=(NextIndex-1) and 1023;
      p:=ActivityData[0,PrevIndex];
      PrevAdr:=p and $7FFF;
      { if the previous cycle caused a stall on the current address, no line
        was added in this cycle }
      if (p and $40000000=0) or
         (Adr<>PrevAdr) then
      begin
        LookupRow[Adr shr 2]:=-1;
        Grid.Cells[0,NextRow]:='';
        NextRow:=NextRow-1;
        if NextRow<0 then
          raise Exception.Create('Failure: usage diagram: rewind row out of range');
        RowStartTime[NextRow]:=-1;
      end;
      if NextIndex=ActivityStartIndex then
        break;
    end;
  ShowLine
end;

procedure TUsageForm.FormCreate(Sender: TObject);
begin
  Grid.Cells[0,0]:='Instruction';
  Clear
end;

procedure TUsageForm.GridTopLeftChanged(Sender: TObject);
begin
  TopRowStartTime:=RowStartTime[Grid.TopRow-1];
  if TopRowStartTime<0 then
    TopRowStartTime:=PSimulator.ActivityTime;
  Grid.Cells[1,0]:='Time: '+IntToStr(TopRowStartTime);
  Grid.Refresh
end;

end.
