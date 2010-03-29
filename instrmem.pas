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

unit InstrMem;

{$MODE Delphi}

interface

uses
  SysUtils, {WinTypes, WinProcs,} Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Grids, Buttons, Common, Menus, ExtCtrls,LResources,
  Compos, NewStr;

const
  BufferSize = 32760;

type
  TclError = (clNumber, clExists, clChanged, clNoChange);

  TLab = record
    stri: string;
    addr: LongInt;
  end;

  { These labels are used at the assembly level }
  TLabels = class
  private
    LabelCount: Integer;
    Labs: TList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function GetLabel(Addr: LongInt): string;
    function GetAddress(Lab: string): LongInt;
    function AddOrReplaceLabel(Addr: LongInt; Lab: string): Boolean;
    function MakeLabel(Addr: LongInt): string;
    function AddLabel(Addr: LongInt; Lab: string): Boolean;
    procedure RemoveLabel(Addr: LongInt);
  end;

  { Instruction memory form }
  TImemForm = class(TForm)
    MainMenu1: TMainMenu;
    PopupMenu1: TPopupMenu;
    Edit1: TMenuItem;
    View1: TMenuItem;
    Help1: TMenuItem;
    SetRange1: TMenuItem;
    Base1: TMenuItem;
    UnsignedHexadecimal1: TMenuItem;
    UnsignedDecimal1: TMenuItem;
    SignedDecimal1: TMenuItem;
    Status1: TPanel;
    Status2: TPanel;
    Status3: TPanel;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Delete1: TMenuItem;
    SelectAll1: TMenuItem;
    Grid: TNewStringGrid;
    About1: TMenuItem;
    File1: TMenuItem;
    HideForm1: TMenuItem;
    N1: TMenuItem;
    SaveFileAs1: TMenuItem;
    SaveFile1: TMenuItem;
    OpenFile1: TMenuItem;
    NewFile1: TMenuItem;
    Edit2: TMenuItem;
    Cut2: TMenuItem;
    Copy2: TMenuItem;
    Paste2: TMenuItem;
    Delete2: TMenuItem;
    SelectAll2: TMenuItem;
    SetCodeRange1: TMenuItem;
    Base2: TMenuItem;
    SignedDecimal2: TMenuItem;
    UnsignedDecimal2: TMenuItem;
    UnsignedHexadecimal2: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SetRange1Click(Sender: TObject);
    procedure UnsignedHexadecimal1Click(Sender: TObject);
    procedure UnsignedDecimal1Click(Sender: TObject);
    procedure SignedDecimal1Click(Sender: TObject);
    procedure GridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GridSelectCell(Sender: TObject; Col, Row: Longint;
      var CanSelect: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SelectAll1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure OpenFile1Click(Sender: TObject);
    procedure SaveFile1Click(Sender: TObject);
    procedure SaveFileAs1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure About1Click(Sender: TObject);
    procedure HideForm1Click(Sender: TObject);
    procedure NewFile1Click(Sender: TObject);
    procedure GridKeyPress(Sender: TObject; var Key: Char);
    procedure GridDblClick(Sender: TObject);
  private
    Base: Integer;
    LastRow: Integer;
    LastCol: Integer;
    Overwrite: Boolean;
    ClipBoardBuffer: TClipBoardBuffer;
    procedure UpdateBaseMenu;
    procedure SetOverwrite(Value: Boolean);
    procedure InsertLines(StartRow: Integer; NumLines: Integer);
    procedure DeleteLines(StartRow: Integer; NumLines: Integer);
    procedure ClearLines(StartRow: Integer; StopRow: Integer);
    function RowToStr(Row: Integer): string;
    procedure StrToRow(Row: Integer; Line: string);
    function ChangeLabel(Address: LongInt; var NewLab: string): TclError;
    procedure Assemble(Line: string; Address: LongInt);
    procedure AssembleRegion(StartAddress,EndAddress: LongInt);
    procedure SetCursor(Row, Col: Integer);
    function SaveFirst: Boolean;
    procedure ShowCaption;
    procedure SaveFile;
  public
    StartRange: LongInt;
    StopRange: LongInt;
    procedure SetModify;
    procedure ClearMemory;
    procedure LoadFile;
    function SaveFileClick: Boolean;
    procedure SetRange(Start,Stop: LongInt);
    procedure ShowAll;
    procedure ShowRegion(BeginRegion, EndRegion: LongInt);
    procedure ShowSingleAddress(Address: LongInt);
    procedure UpdateLastSelection;
    destructor Destroy; override;
  end;

  { This function disassembles the instruction at the given address. Numbers are
    represented in the given base, and when AddLabels is true and a jump address
    is found that has no associated label, a new label is inserted in the Labels
    structure }
  function Disassemble(Instr: LongInt; Address: LongInt; Base: Integer;
                       AddLabels: Boolean): string;

var
  ImemForm: TImemForm;
  Labels: TLabels;

implementation

uses
  Config, Range, Micro, Pipe;

{$R *.lfm}

constructor TLabels.Create;
begin
  Labs:=TList.Create
end;

destructor TLabels.Destroy;
begin
  Clear;
  Labs.Free;
  inherited Destroy
end;

procedure TLabels.Clear;
var
  L: ^TLab;
  i: Integer;
begin
  for i:=0 to Labs.Count-1 do
  begin
    L:=Labs.Items[i];
    Dispose(L)
  end;
  Labs.Clear;
  Labs.Pack
end;

function TLabels.GetLabel(Addr: LongInt): string;
var
  i: Integer;
  L: ^TLab;
begin
  Result:='';
  for i:=0 to Labs.Count-1 do
  begin
    L:=Labs.Items[i];
    if L^.addr=Addr then
    begin
      Result:=L^.stri;
      break
    end
  end
end;

function TLabels.GetAddress(Lab: string): LongInt;
var
  i: Integer;
  L: ^TLab;
begin
  Result:=-1;
  for i:=0 to Labs.Count-1 do
  begin
    L:=Labs.Items[i];
    if CompareText(L^.stri,Lab)=0 then
    begin
      Result:=L^.addr;
      break
    end
  end
end;

function TLabels.MakeLabel(Addr: LongInt): string;
begin
  repeat
    LabelCount:=labelCount+1;
    Result:='label'+IntToStr(LabelCount)
  until AddLabel(Addr,Result);
  ImemForm.Grid.Cells[1,(Addr-ImemForm.StartRange) div 4]:=Result
end;

procedure TLabels.RemoveLabel(Addr: LongInt);
var
  i: Integer;
  L: ^TLab;
begin
  for i:=0 to Labs.Count-1 do
  begin
    L:=Labs.Items[i];
    if L^.addr=Addr then
    begin
      Dispose(L);
      Labs.Delete(i);
      Labs.Pack;
      break
    end
  end
end;

function TLabels.AddLabel(Addr: LongInt; Lab: string): Boolean;
var
  L: ^TLab;
  i: Integer;
begin
  Result:=true;
  for i:=0 to Labs.Count-1 do
  begin
    L:=Labs.Items[i];
    if (CompareText(L^.stri,Lab)=0) or (L^.addr=Addr) then
    begin
      Result:=false;
      break
    end
  end;
  if Result then
  begin
    New(L);
    L^.stri:=Lab;
    L^.addr:=Addr;
    Labs.Add(L)
  end
end;

function TLabels.AddOrReplaceLabel(Addr: LongInt; Lab: string): Boolean;
{returns true when the label already exists}
var
  L: ^TLab;
  i: Integer;
  not_done: Boolean;
begin
  not_done:=true;
  Result:=false;
  for i:=0 to Labs.Count-1 do
  begin
    L:=Labs.Items[i];
    if L^.addr=Addr then
    begin
      L^.stri:=Lab;
      not_done:=false;
    end else if CompareText(L^.stri,Lab)=0 then
      Result:=true
  end;
  if not_done then
  begin
    New(L);
    L^.stri:=Lab;
    L^.addr:=Addr;
    Labs.Add(L);
  end
end;

procedure TImemForm.Assemble(Line: string; Address: LongInt);
var
  Opcode: Integer;
  Format: string;
  OpType: TOpcodeType;
  i,p: Integer;
  Reg: Integer;
  Num: LongInt;
  Instr: LongInt;
  OldInstr: LongInt;
  Valid: Boolean;
begin
  Valid:=true;
  p:=1;
  Opcode:=Encoding.Index(ReadIdentifier(Line,p));
  if Opcode=-1 then
  begin
    Valid:=false;
    Instr:=0 {to avoid warnings}
  end else
  begin
    Instr:=Unravel.AddOpcode(Opcode);
    Format:=Encoding.Operands(Opcode);
    OpType:=Encoding.OpcodeType(Opcode);
    i:=0;
    while i<Length(Format) do
    begin
      i:=i+1;
      if Format[i]=' ' then
        continue;
      SkipSpaces(Line,p);
      if EndLine(line,p) then
      begin
        Valid:=false;
        break
      end;
      case Format[i] of
        'r': begin
               if UpperCase(Line[p])<>'R' then
               begin
                 Valid:=false;
                 break
               end;
               p:=p+1;
               if EndLine(line,p) then
               begin
                 Valid:=false;
                 break
               end;
               i:=i+1;
               Reg:=Ord(Format[i])-Ord('0');
               Num:=ReadInt(Line,p);
               if (Num<0) or (Num>=ConfigForm.NumRegisters.Value) then
               begin
                 Valid:=false;
                 break
               end;
               Instr:=Instr or Unravel.AddRegister(Num,Reg)
             end;
    'i','j': begin
               if Format[i]='i' then
                 Num:=ReadInt(Line,p)
               else begin
                 if (Ord(Line[p])>=Ord('0')) and (Ord(Line[p])<=Ord('9')) then
                   Num:=ReadInt(Line,p)
                 else begin
                   Num:=Labels.GetAddress(ReadIdentifier(Line,p));
                   if Num=-1 then
                   begin
                     Valid:=false;
                     break
                   end
                 end;
                 Num:=Num-(Address+4)
               end;
               if OpType=otI then
                 Instr:=Instr or Unravel.AddImm1(Num)
               else
                 Instr:=Instr or Unravel.AddImm2(Num)
             end
      else
        if Format[i]<>Line[p] then
        begin
          Valid:=false;
          break
        end;
        p:=p+1
      end
    end
  end;
  if Valid then
  begin
    SkipSpaces(Line,p);
    if not EndLine(Line,p) then
      Valid:=false;
  end;
  if Valid then
  begin
    OldInstr:=CodeMemory.Read(Address,2);
    if Instr<>OldInstr then
    begin
      CodeMemory.Write(Address,Instr,2);
      CodeMemory.ChangedValue(Address)
    end else
      ShowSingleAddress(Address);
  end else
  begin
    if Pos('???',Line)<>0 then
      Grid.Cells[2,(Address-StartRange) div 4]:=Line
    else
    begin
      Grid.Cells[2,(Address-StartRange) div 4]:=
                           Copy(Line,1,p-1)+'???'+Copy(Line,p,1000);
      Status3.Caption:=IntToHex(Address,4)+': Invalid mnemonic'
    end
  end
end;

function Disassemble(Instr: LongInt; Address: LongInt; Base: Integer;
                             AddLabels: Boolean): string;
var
  Format: string;
  Opcode: Integer;
  OpType: TOpcodeType;
  Reg: Integer;
  Imm: LongInt;
  i: Integer;
  Lab: string;
  W: Integer;
begin
  Opcode:=Unravel.Opcode(Instr);
  Result:=Encoding.Opcode(Opcode);
  if Length(Result)=0 then
    Result:='???'
  else
  begin
    while Length(Result)<Encoding.MaxWidth+1 do
      Result:=Result+' ';
    Format:=Encoding.Operands(Opcode);
    OpType:=Encoding.OpcodeType(Opcode);
    i:=0;
    while i<Length(Format) do
    begin
      i:=i+1;
      case Format[i] of
        'r': begin
               i:=i+1;
               Reg:=Ord(Format[i])-Ord('0');
               Result:=Result+'R'+IntToStr(Unravel.Register(Instr,Reg))
             end;
        'i': begin
               if OpType=otI then
               begin
                 Imm:=Unravel.Imm1(Instr,(Base=2));
                 W:=Unravel.Imm1Width
               end
               else begin
                 Imm:=Unravel.Imm2(Instr,(Base=2));
                 W:=Unravel.Imm2Width
               end;
               if Base=0 then
                 Result:=Result+'0x'+IntToHex(Imm,W)
               else
                 Result:=Result+NewIntToStr(Imm,0,Base)
             end;
        'j': begin
               if OpType=otI then
                 Imm:=Unravel.Imm1(Instr,true)
               else
                 Imm:=Unravel.Imm2(Instr,true);
                 Imm:=Address+Imm+4;
                 Lab:=Labels.GetLabel(Imm);
                 if Length(Lab)=0 then
                   if AddLabels and (Imm>=ImemForm.StartRange) and
                      (Imm<=ImemForm.StopRange) and ((Imm and 3)=0) then
                     Result:=Result+Labels.MakeLabel(Imm)
                   else
                     Result:=Result+'0x'+IntToHex(Imm,0)
                 else
                   Result:=Result+Lab
              end
      else
        Result:=Result+Format[i]
      end
    end
  end
end;

procedure TImemForm.FormResize(Sender: TObject);
begin
  Grid.Width:=ClientWidth;
  Grid.Height:=ClientHeight-20;
  Grid.ColWidths[0]:=15*Courier10Width;
  Grid.ColWidths[1]:=10*Courier10Width;
  Grid.ColWidths[2]:=Grid.ClientWidth-Grid.CellRect(2,0).Left;
  Status3.Width:=Width-248;
  Status1.Top:=ClientHeight-17;
  Status2.Top:=ClientHeight-17;
  Status3.Top:=ClientHeight-17
end;

procedure TImemForm.FormCreate(Sender: TObject);
begin
  LastCol:=1;
  LastRow:=0;
  ClipBoardBuffer:=TClipBoardBuffer.Create;
  SetOverwrite(true);
  Grid.DefaultRowHeight:=Courier10Height+2;
  SetRange(0,ConfigForm.ImemSize.Value-4);
  UnsignedHexadecimal1Click(Sender);
  Status3.Caption:='';
  ClearMemory
end;

procedure TImemForm.ShowAll;
var
  Address: LongInt;
begin
  Address:=StartRange;
  while Address<=StopRange do
  begin
    ShowSingleAddress(Address);
    Address:=Address+4
  end
end;

procedure TImemForm.ShowRegion(BeginRegion, EndRegion: LongInt);
begin
  while BeginRegion<=StopRange do
  begin
    ShowSingleAddress(BeginRegion);
    BeginRegion:=BeginRegion+4
  end
end;

procedure TImemForm.ShowSingleAddress(Address: LongInt);
var
  Instr: LongInt;
  Row: Integer;
begin
  Row:=(Address-StartRange) div 4;
  Instr:=CodeMemory.Read(Address and $FFFFFFFC,2);
  Grid.Cells[0,Row]:=IntToHex(Address,4)+': ' +IntToHex(Instr,8);
  Grid.Cells[1,Row]:=Labels.GetLabel(Address);
  Grid.Cells[2,Row]:=Disassemble(Instr,Address,Base,true)
end;

function TImemForm.RowToStr(Row: Integer): string;
var
  Instr: LongInt;
  Address: LongInt;
  Lab: string;
begin
  Address:=Row*4+StartRange;
  Instr:=CodeMemory.Read(Address,2);
  Result:=IntToHex(Address,4)+': ' +IntToHex(Instr,8);
  Lab:=Labels.GetLabel(Address);
  Result:=Format('%s | %-10s | ',[Result,Lab]);
  Result:=Result+Disassemble(Instr,Address,Base,true)
end;

procedure TImemForm.StrToRow(Row: Integer; Line: string);
var
  p,q: Integer;
  Lab: string;
begin
  p:=1;
  SkipPastPipe(Line,p);
  if EndLine(Line,p) then
  begin
    p:=1;
    q:=1
  end else
  begin
    q:=p;
    SkipPastPipe(Line,q);
    if EndLine(Line,q) then
    begin
      q:=p;
      p:=1
    end
  end;
  if p<>q then
    Lab:=ReadIdentifier(Line,p)
  else
    Lab:='';
  ChangeLabel(Row*4+StartRange,Lab);
  SkipSpaces(Line,q);
  Grid.Cells[2,Row]:=Copy(Line,q,1000)
end;

procedure TImemForm.SetRange1Click(Sender: TObject);
begin
  Application.CreateForm(TRangeForm, RangeForm);
  RangeForm.Hide;
  RangeForm.ShowModal
end;

procedure TImemForm.UnsignedHexadecimal1Click(Sender: TObject);
begin
  Base:=0;
  UpdateBaseMenu
end;

procedure TImemForm.UnsignedDecimal1Click(Sender: TObject);
begin
  Base:=1;
  UpdateBaseMenu
end;

procedure TImemForm.SignedDecimal1Click(Sender: TObject);
begin
  Base:=2;
  UpdateBaseMenu
end;

procedure TImemForm.UpdateBaseMenu;
begin
   UnsignedHexadecimal1.checked:=(Base=0);
   UnsignedDecimal1.checked:=(Base=1);
   SignedDecimal1.checked:=(Base=2);
   UnsignedHexadecimal2.checked:=(Base=0);
   UnsignedDecimal2.checked:=(Base=1);
   SignedDecimal2.checked:=(Base=2);
   ShowAll
end;

procedure TImemForm.GridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Grid.Options:=Grid.Options+[goEditing]
end;

procedure TImemForm.GridMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Grid.Options:=Grid.Options-[goEditing]
end;

procedure TImemForm.UpdateLastSelection;
var
  Dummy: Boolean;
begin
  GridSelectCell(ImemForm,LastCol,LastRow,Dummy);
end;

procedure TImemForm.GridSelectCell(Sender: TObject; Col, Row: Longint;
  var CanSelect: Boolean);
var
  Address: LongInt;
  Line: string;
  OldLab: string;
begin
  Address:=LastRow*4+StartRange;
  Line:=Grid.Cells[LastCol,LastRow];
  Status3.Caption:='';
  case LastCol of
    1: begin
         OldLab:=Labels.GetLabel(Address);
         case ChangeLabel(Address,Line) of
           clNumber: begin {starts with a number}
               Status3.Caption:='Labels cannot start with a numeric character';
               Grid.Cells[LastCol,LastRow]:=OldLab
             end;
           clExists: begin {duplicate label}
               Status3.Caption:='Label "'+Line+'" already exists';
               AssembleRegion(StartRange,StopRange)
             end;
           clChanged: AssembleRegion(StartRange,StopRange)
         end;
       end;
    2: Assemble(Line,Address)
  end;
  if Col=0 then
    CanSelect:=false
  else begin
    LastCol:=Col;
    LastRow:=Row
  end
end;

procedure TImemForm.AssembleRegion(StartAddress,EndAddress: LongInt);
var
  Address: LongInt;
begin
  Address:=StartAddress;
  while Address<=EndAddress do
  begin
    Assemble(Grid.Cells[2,(Address-StartRange) div 4],Address);
    Address:=Address+4
  end
end;

function TImemForm.ChangeLabel(Address: LongInt; var NewLab: string): TclError;
var
  p: Integer;
  OldLab: string;
begin
  Result:=clChanged;
  p:=1;
  OldLab:=Labels.GetLabel(Address);
  NewLab:=ReadIdentifier(NewLab,p);
  if (Length(NewLab)>0) and (NewLab[1]>='0') and (NewLab[1]<='9') then
  begin {starts with a number}
    NewLab:='';
    Result:=clNumber
  end else if NewLab=OldLab then
    Result:=clNoChange
  else if NewLab='' then
    Labels.RemoveLabel(Address)
  else if Labels.AddOrReplaceLabel(Address,NewLab) then
    Result:=clExists;
  Grid.Cells[1,(Address-StartRange) div 4]:=NewLab;
end;

procedure TImemForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_DOWN: begin
      Grid.PressKey(VK_DOWN,Shift);
      Grid.PressKey(VK_F2,[]);
      Key:=VK_HOME
    end;
    VK_UP: begin
      Grid.PressKey(VK_UP,Shift);
      Grid.PressKey(VK_F2,[]);
      Key:=VK_HOME
    end;
    VK_RETURN: begin
      if LastRow=Grid.RowCount-1 then
        UpdateLastSelection;
      if (not Overwrite) and (Grid.Row<Grid.RowCount-1) then
      begin
        InsertLines(Grid.Row+1,1);
        ClearLines(Grid.Row+1,Grid.Row+1);
        AssembleRegion(StartRange,StopRange)
      end;
      Grid.PressKey(VK_DOWN,[]);
      Grid.PressKey(VK_F2,[]);
      Key:=VK_HOME
    end;
    VK_INSERT:
      SetOverwrite(not OverWrite);
    VK_DELETE: if (Grid.Selection.Left<Grid.Selection.Right) or
                  (Grid.Selection.Top<Grid.Selection.Bottom) then
               begin
                 Delete1Click(Sender);
                 AssembleRegion(StartRange,StopRange);
                 Key:=0
               end
  end
end;

procedure TImemForm.SetOverwrite(Value: Boolean);
begin
  Overwrite:=Value;
  if Overwrite then
    Status2.Caption:='Overwrite'
  else
    Status2.Caption:='Insert';
end;

procedure TImemForm.SetRange(Start,Stop: LongInt);
begin
  StartRange:=Start;
  StopRange:=Stop;
  Status1.Caption:='Range: '+IntToHex(StartRange,4)+'-'+IntToHex(StopRange,4);
  Grid.RowCount:=(StopRange-StartRange) div 4 +1;
  ShowAll
end;

procedure TImemForm.InsertLines(StartRow: Integer; NumLines: Integer);
var
  OldAddress: LongInt;
  NewAddress: LongInt;
  Lab: string;
  Row: Integer;
begin
  for Row:=Grid.RowCount-1 downto StartRow+NumLines do
  begin
    OldAddress:=(Row-NumLines)*4+StartRange;
    NewAddress:=Row*4+StartRange;
    Lab:=Grid.Cells[1,Row-NumLines];
    Labels.RemoveLabel(OldAddress);
    Grid.Cells[1,Row-NumLines]:='';
    ChangeLabel(NewAddress,lab);
    Grid.Cells[2,Row]:=Grid.Cells[2,Row-NumLines]
  end
end;

procedure TImemForm.DeleteLines(StartRow: Integer; NumLines: Integer);
var
  OldAddress: LongInt;
  NewAddress: LongInt;
  Lab: string;
  Row: Integer;
begin
  for Row:=StartRow to Grid.RowCount-NumLines-1 do
  begin
    OldAddress:=(Row+NumLines)*4+StartRange;
    NewAddress:=Row*4+StartRange;
    Lab:=Grid.Cells[1,Row+NumLines];
    Labels.RemoveLabel(OldAddress);
    Grid.Cells[1,Row+NumLines]:='';
    ChangeLabel(NewAddress,lab);
    Grid.Cells[2,Row]:=Grid.Cells[2,Row+NumLines]
  end;
  ClearLines(Grid.RowCount-NumLines,Grid.RowCount-1)
end;

procedure TImemForm.ClearLines(StartRow: Integer; StopRow: Integer);
var
  Row: Integer;
begin
  for Row:=StartRow to StopRow do
    Grid.Cells[2,Row]:='NOP'
end;

procedure TImemForm.SelectAll1Click(Sender: TObject);
var
  SRect: TGridRect;
begin
  SRect.Top:=0;
  SRect.Bottom:=Grid.RowCount-1;
  SRect.Left:=1;
  SRect.Right:=2;
  Grid.Selection:=SRect
end;

procedure TImemForm.Copy1Click(Sender: TObject);
var
  Row: Integer;
begin
  ClipBoardBuffer.Clear;
  for Row:=Grid.Selection.top to Grid.Selection.Bottom do
    ClipBoardBuffer.AddLine(RowToStr(Row));
  ClipBoardBuffer.ToClipBoard;
  SetCursor(Grid.Row,Grid.Row)
end;

procedure TImemForm.OpenFile1Click(Sender: TObject);
begin
  if SaveFirst and OpenDialog1.Execute then
    LoadFile
end;

procedure TImemForm.SaveFile1Click(Sender: TObject);
begin
  SaveFileClick
end;

function TImemForm.SaveFileClick: Boolean;
begin
  if SaveDialog1.FileName='Untitled.cod' then
    SaveFileAs1Click(ImemForm)
  else
    SaveFile;
  Result:=not SaveFile1.Enabled
end;

procedure TImemForm.SaveFileAs1Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
    SaveFile
end;

procedure TImemForm.Delete1Click(Sender: TObject);
begin
  DeleteLines(Grid.Selection.Top,Grid.Selection.Bottom-Grid.Selection.Top+1);
  AssembleRegion(StartRange,StopRange);
  SetCursor(Grid.Selection.Top,Grid.Col);
  SetModify
end;

procedure TImemForm.Cut1Click(Sender: TObject);
begin
  Copy1Click(Sender);
  Delete1Click(Sender)
end;

procedure TImemForm.Paste1Click(Sender: TObject);
var
  Row: Integer;
  Line: string;
begin
  ClipBoardBuffer.FromClipBoard;
  Row:=Grid.Row;
  if not Overwrite then
    InsertLines(Row,ClipBoardBuffer.NumLines(Grid.RowCount-Row));
  while (Row<Grid.RowCount-1) and ClipBoardBuffer.GetLine(Line) do
  begin
    StrToRow(Row,Line);
    Row:=Row+1
  end;
  AssembleRegion(StartRange,StopRange);
  if Row<Grid.RowCount-1 then
    SetCursor(Row,Grid.Col)
  else
    SetCursor(Grid.RowCount-1,Grid.Col);
  SetModify
end;

procedure TImemForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caHide
end;

destructor TImemForm.Destroy;
begin
  ClipBoardBuffer.Free;
  inherited Destroy
end;

procedure TImemForm.About1Click(Sender: TObject);
begin
  AboutBox
end;

procedure TImemForm.SetCursor(Row, Col: Integer);
var
  SRect: TGridRect;
begin
  SRect.Top:=Row;
  SRect.Bottom:=Row;
  SRect.Left:=Col;
  SRect.Right:=Col;
  Grid.Selection:=SRect;
  Grid.Row:=Row;
  Grid.Col:=Col;
  Grid.PressKey(VK_DOWN,[]);
  Grid.PressKey(VK_UP,[])
end;

procedure TImemForm.ShowCaption;
begin
  Caption:=CodeCaptionBase+' - '+ExtractFileName(SaveDialog1.FileName)
end;

procedure TImemForm.HideForm1Click(Sender: TObject);
begin
  Hide
end;

procedure TImemForm.ClearMemory;
  var i: Integer;
begin
  for i:=0 to (ConfigForm.ImemSize.Value div 4)-1 do
    CodeMemory.Write(i*4,0,2);
  Labels.Clear;
  SaveDialog1.FileName:='Untitled.cod';
  SaveFile1.Enabled:=false;
  ShowCaption
end;

procedure TImemForm.LoadFile;
var
  p: Integer;
  Row: LongInt;
  L: string;
  Error: Boolean;
begin
  FileIO.UseFile(OpenDialog1.FileName);
  Reset(FileIO.F);
  Error:=false;
  ClearMemory;
  if FileIO.FindString('[Code Memory Content]',L) then
  begin
    Row:=0;
    repeat
      Readln(FileIO.F,L);
      p:=1;
      SkipSpaces(L,p);
      if EndLine(L,p) then
        break;
      if L[p]=';' then
        continue;
      StrToRow(Row,L);
      Row:=Row+1;
    until Row>=Grid.RowCount;
    AssembleRegion(StartRange,StopRange);
    CodeMemory.ChangedAll;
  end else
    Error:=true;
  CloseFile(FileIO.F);
  SaveDialog1.FileName:=OpenDialog1.FileName;
  ShowCaption;
  if Error then
    AppliMessage('File Format Corrupt; code may be incorrect','Warning',$40);
  SaveFile1.Enabled:=false
end;

procedure TImemForm.SaveFile;
var
  Row: LongInt;
begin
  UpdateLastSelection;
  FileIO.UseFile(SaveDialog1.FileName);
  Rewrite(FileIO.F);
  Writeln(FileIO.F,'[Code Memory Content]');
  for Row:=0 to Grid.RowCount-1 do
    Writeln(FileIO.F,RowToStr(Row));
  CloseFile(FileIO.F);
  SaveFile1.Enabled:=false;
  ShowCaption
end;

procedure TImemForm.NewFile1Click(Sender: TObject);
begin
  if SaveFirst then
  begin
    ClearMemory;
    CodeMemory.ChangedAll
  end
end;

procedure TImemForm.SetModify;
begin
  SaveFile1.Enabled:=true;
  SetModifyOnSimForm
end;

function TImemForm.SaveFirst: Boolean;
var
  Answer: Integer;
begin
  Result:=true;
  if SaveFile1.Enabled then
  begin
    Answer:=AppliMessage('Save changes to '+
           ExtractFileName(SaveDialog1.FileName)+'?','Instruction Memory - Confirm',$23);
    case Answer of
      6: begin
           SaveFile1Click(ImemForm);
           Result:=not SaveFile1.Enabled
         end;
      7: { no -> Don't do anything but return true }
    else
      Result:=false
    end
  end
end;

procedure TImemForm.GridKeyPress(Sender: TObject; var Key: Char);
begin
  SetModify
end;

procedure TImemForm.GridDblClick(Sender: TObject);
begin
  Grid.Options:=Grid.Options+[goEditing]
end;

end.
