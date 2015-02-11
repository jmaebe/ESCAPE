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

unit MicroCod;

{$MODE Delphi}

interface

uses
  SysUtils, {WinTypes, WinProcs,} Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ComCtrls, ExtCtrls, Grids, Compos, {Tabs,} Config, Common, Menus,
  StdCtrls,LResources, NewStr, lcltype;

type
  TuCodeField = (ufLabel, ufAdr, ufConst, ufReg, ufALU, ufS1, ufS2,
                 ufDest, ufMemAdr, ufMemDest, ufIRSize, ufJCond, ufMem);

type
  TMicroCodeEntryException = class(Exception)
  end;

  { Don't confuse uLabel with the labels used by Disassemble in InstrMem.pas }
  TuLabel = class(TObject)
    uAR: LongInt;
    constructor Create(Adr: LongInt);
  end;

  { The microcode and jump tables form }

  TMicroCode = class(TForm)
    Notebook1: TPageControl;
    OverwriteBox: TComboBox;
    Page1,
    Page2: TTabSheet;
    Grid1: TNewStringGrid;
    MainMenu1: TMainMenu;
    Grid2: TNewStringGrid;
    File1: TMenuItem;
    SaveFileAs1: TMenuItem;
    SaveFile1: TMenuItem;
    OpenFile1: TMenuItem;
    Edit1: TMenuItem;
    SelectAll1: TMenuItem;
    Delete1: TMenuItem;
    Paste1: TMenuItem;
    Copy1: TMenuItem;
    Cut1: TMenuItem;
    View1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Microcode1: TMenuItem;
    JumpTables1: TMenuItem;
    N1: TMenuItem;
    PopupMenu1: TPopupMenu;
    Cut2: TMenuItem;
    Copy2: TMenuItem;
    Paste2: TMenuItem;
    Delete2: TMenuItem;
    SelectAll2: TMenuItem;
    N2: TMenuItem;
    Base2: TMenuItem;
    SignedDecimal2: TMenuItem;
    UnsignedDecimal2: TMenuItem;
    UnsignedHexadecimal2: TMenuItem;
    JumpTables2: TMenuItem;
    N3: TMenuItem;
    N6: TMenuItem;
    Assemble2: TMenuItem;
    PopupMenu2: TPopupMenu;
    Microcode3: TMenuItem;
    N7: TMenuItem;
    Fill1: TMenuItem;
    N8: TMenuItem;
    Fill2: TMenuItem;
    N9: TMenuItem;
    Assemble3: TMenuItem;
    CopyOpcodes1: TMenuItem;
    CopyOpcodes2: TMenuItem;
    HideForm1: TMenuItem;
    NewFile1: TMenuItem;
    N4: TMenuItem;
    Assemble4: TMenuItem;
    Assemble1: TMenuItem;
    Base1: TMenuItem;
    SignedDecimal1: TMenuItem;
    UnsignedDecimal1: TMenuItem;
    UnsignedHexadecimal1: TMenuItem;
    N5: TMenuItem;
    Status2: TPanel;
    Status3: TPanel;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Grid1Resize(Sender: TObject);
    procedure Grid1SelectEditor(Sender: TObject; aCol, aRow: Integer;
      var Editor: TWinControl);
    procedure Grid1Selection(Sender: TObject; Col, Row: Integer);
    procedure Grid1ValidateEntry(sender: TObject; aCol, aRow: Integer;
      const OldValue: string; var NewValue: String);
    procedure Grid2Resize(Sender: TObject);
    procedure Grid2Selection(Sender: TObject; Col, Row: Integer);
    procedure Notebook1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure OverwriteBoxChange(Sender: TObject);
    procedure TabSetChange(Sender: TObject; NewTab: Integer);
    procedure Grid1SelectCell(Sender: TObject; Col, Row: Longint;
      var CanSelect: Boolean);
    procedure Grid2SelectCell(Sender: TObject; Col, Row: Longint;
      var CanSelect: Boolean);
    procedure UnsignedHexadecimal1Click(Sender: TObject);
    procedure UnsignedDecimal1Click(Sender: TObject);
    procedure SignedDecimal1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure SelectAll1Click(Sender: TObject);
    procedure Microcode1Click(Sender: TObject);
    procedure JumpTables1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure OpenFile1Click(Sender: TObject);
    procedure SaveFile1Click(Sender: TObject);
    procedure SaveFileAs1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure SetCursorPage1(Row, Col: Integer);
    procedure SetCursorPage2(Row, Col: Integer);
    procedure CloseFile1Click(Sender: TObject);
    procedure Assemble1Click(Sender: TObject);
    procedure Fill1Click(Sender: TObject);
    procedure CopyOpcodes1Click(Sender: TObject);
    procedure HideForm1Click(Sender: TObject);
    procedure NewFile1Click(Sender: TObject);
    procedure Grid1KeyPress(Sender: TObject; var Key: Char);
    procedure Grid2KeyPress(Sender: TObject; var Key: Char);
  private
    MCode: array [0..1023,TuCodeField] of LongInt;
    JTable: array [0..3,0..255] of LongInt;
    TabIndex: Integer;
    Overwrite: Boolean;
    uCodeRows: Integer;
    NumOpcodes: Integer;
    NumJumpTables: Integer;
    NumConstBits: Integer;
    CompleteExtend: Boolean;
    CompleteJCond: Boolean;
    CompleteMemOps: Boolean;
    ClipBoardBuffer: TClipBoardBuffer;
    Base: Integer;
    ConstantHexWidth: Integer;
    procedure ShowGrid;
    procedure FillFixed;
    procedure SetOverwrite(Value: Boolean);
    function EnterField(uAR: Integer; Field: TuCodeField; S: string): Boolean;
    procedure DisplayField(uAR: Integer; Field: TuCodeField);
    procedure InitializePickLists;
    function ColToField(Col: Integer): TuCodeField;
    function FieldToCol(Field: TuCodeField): Integer;
    procedure InsertLines(StartRow: Integer; NumLines: Integer);
    procedure DeleteLines(StartRow: Integer; NumLines: Integer);
    procedure ClearLines(StartRow: Integer; StopRow: Integer);
    procedure UpdateBaseMenu;
    procedure ShowConstants;
    procedure ShowSingleConstant(Col,uAR: Integer);
    function RowToStr(Row: Integer): string;
    function StrToRow(Row: Integer; Line: string): Boolean;
    procedure SetModify;
    procedure ShowCaption;
    procedure SaveFile;
    function ReadAssembled: Boolean;
    procedure WriteAssembled(Val: Boolean);
  public
    LastCol1: Integer;
    LastRow1: Integer;
    LastCol2: Integer;
    LastRow2: Integer;
{    Assembled: Boolean;}
    procedure HighLight(uAR: LongInt);
    procedure ClearMicrocode;
    procedure LoadFile;
    function SaveFileClick: Boolean;
    function Assemble(Query: string): Boolean;
    function SaveFirst: Boolean;
    function uCode(Index: Integer; Field: TuCodeField): LongInt;
    function Jump(Instr: LongInt; Table: Integer): LongInt;
    destructor Destroy; override;
  published
    property Assembled: Boolean read ReadAssembled write WriteAssembled;
  end;

var
  MicroCode: TMicroCode;

implementation

uses
  Micro, platformconsts;

{$R *.lfm}

{
MicroCode[uAR,field] is
  ufLabel   -> <>0 when ufConst is not empty
  ufALU     -> NOP, ADD, SUB, RSUB, AND, OR, XOR, SLL, SRL, SRA, S1, S2 [, MUL, DIV]
  ufS1      -> --, A, CONST, PC, MAR, MDR, IR, TMP[0], TMP[1], ...
  ufS2      -> --, B, CONST, PC, MAR, MDR, IR, TMP[0], TMP[1], ...
  ufIRSize  -> --, BYTE, HALF, WORD
            or --, WORD
  ufDest    -> --, C, PC, MAR, MDR, TMP[0], TMP[1], ...
  ufJCond   -> --, TRUE, EQ, NE, LT, GT, LE, GE, Mbusy, Jump1, Jump2, ...
            or --, TRUE, EQ, LT, MBusy, Jump1, Jump2, ...
  ufMem     -> --, RB, RH, RW, WB, WH, WW
            or --, RW, WW
  ufMemAdr  -> --, MAR, PC (-- is MAR)
  ufMemDest -> --, MDR, IR (-- is IR)
  ufConst   -> Const, sign extended to LongInt
  ufReg     -> Bits 9-0:  read A
               Bits 19-10: read B
               Bits 29-20: write C
                 upper 2 bits of 10 bit field: 00, 01: NOP
                                               10: Read/Write Formal
                                               11: Read/Write Actual
               Bit 31: 1 when RR operation

uCode(uAR,field) is
  ufLabel   -> not used
  ufALU     -> same
  ufS1      -> same
  ufS2      -> same
  ufDest    -> same
  ufConst   -> same
  ufIRSize  -> 4, 8, 16 or 32 (4 implies no extending, result always -1)
  ufJCond   -> --, TRUE, EQ, NE, LT, GT, LE, GE, MBusy, Jump1, Jump2, ...
  ufMem     -> --, RB=4, RH, RW, WB=8, WH, WW
  ufMemAdr  -> PC, MAR
  ufMemDest -> IR, MDR
  ufAdr     -> uAR[Label] or 0 when no match
}

function TMicroCode.uCode(Index: Integer; Field: TuCodeField): LongInt;
begin
  Result:=MCode[Index,Field];
  case Field of
    ufMemAdr: begin
                if Result=0 then
                  Result:=1;
                Result:=Result and 1
              end;
    ufMemDest: Result:=Result and 1;
    ufIRSize: begin
                if (Result=1) and (not CompleteExtend) then
                  Result:=3;
                Result:=4 shl Result
              end;
    ufJCond: if not CompleteJCond then
             begin
               if Result=3 then
                 Result:=4
               else if Result>3 then
                 Result:=Result+4
             end;
    ufMem: begin
             if not CompleteMemOps then
               Result:=Result*3;
             if Result>0 then
               Result:=Result+3;
             if Result>6 then
               Result:=Result+1
           end
  end
end;

function TMicroCode.Jump(Instr: LongInt; Table: Integer): LongInt;
var
  Opc: Integer;
begin
  Opc:=Unravel.Opcode(Instr);
  Result:=JTable[Table-1,Opc]
end;

procedure TMicroCode.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caHide
end;

destructor TMicroCode.Destroy;
begin
  ClipBoardBuffer.Free;
  inherited Destroy
end;

procedure TMicroCode.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  LastCol1:=1;
  LastRow1:=0;
  LastCol2:=1;
  LastRow2:=0;
  ClipBoardBuffer:=TClipBoardBuffer.Create;
  NumOpcodes:=ConfigForm.NumOpcodes.Value;
  NumJumpTables:=ConfigForm.NumJumpTables.Value;
  uCodeRows:=ConfigForm.uCodeRows.Value;
  CompleteExtend:=(ConfigForm.CompleteExtend.ItemIndex=1);
  CompleteJCond:=(ConfigForm.CompleteCompOps.ItemIndex=1);
  CompleteMemOps:=(ConfigForm.CompleteMemOps.ItemIndex=1);
  NumConstBits:=ConfigForm.NumConstBits.Value;
  ConstantHexWidth:=(NumConstBits+3) div 4;
  Grid1.DefaultRowHeight:=MSSansSerif8Height+2+MSSansSerif8HeightGridRowFudge;
  Grid1.RowCount:=uCodeRows+1;
  Grid2.DefaultRowHeight:=MSSansSerif8Height+2+MSSansSerif8HeightGridRowFudge;
  Grid2.RowCount:=NumOpCodes+1;
  { title row }
  Grid2.FixedRows:=1;
  { opcodes column }
  with Grid2.Columns.Add do
    Title.Caption:='Opcode';
  for i:=1 to NumJumpTables do
    with Grid2.Columns.Add do
      Title.Caption:='Jump Table '+IntToStr(i);
  FillFixed;
  ShowGrid;
  SetOverwrite(true);
  Base:=2;
  UpdateBaseMenu;
  InitializePickLists;
  ClearMicroCode;
  Notebook1.ActivePage:=Page1;
end;

procedure TMicroCode.InitializePickLists;
var
  i: Integer;
begin
  if ConfigForm.CompleteALU.Checked then
  begin
    Grid1.Columns[FieldToCol(ufALU)].PickList.Add(ALUOperation[MULT]);
    Grid1.Columns[FieldToCol(ufALU)].PickList.Add(ALUOperation[DIVI]);
  end;
  for i:=0 to ConfigForm.NumTemps-1 do
  begin
    Grid1.Columns[FieldToCol(ufS1)].PickList.Add(ConfigForm.TmpNames.Cells[0,i]);
    Grid1.Columns[FieldToCol(ufS2)].PickList.Add(ConfigForm.TmpNames.Cells[0,i]);
    Grid1.Columns[FieldToCol(ufDest)].PickList.Add(ConfigForm.TmpNames.Cells[0,i]);
  end;
  if CompleteExtend then
  begin
    Grid1.Columns[FieldToCol(ufIRSize)].PickList.Insert(1,'Byte');
    Grid1.Columns[FieldToCol(ufIRSize)].PickList.Insert(2,'Half')
  end;
  if not CompleteJCond then
  begin
    Grid1.Columns[FieldToCol(ufJCond)].PickList.Delete(7);
    Grid1.Columns[FieldToCol(ufJCond)].PickList.Delete(6);
    Grid1.Columns[FieldToCol(ufJCond)].PickList.Delete(5);
    Grid1.Columns[FieldToCol(ufJCond)].PickList.Delete(3)
  end;
  for i:=1 to NumJumpTables do
    Grid1.Columns[FieldToCol(ufJCond)].PickList.add('Jump'+IntToStr(i));
  if not CompleteMemOps then
  begin
    Grid1.Columns[FieldToCol(ufMem)].PickList.Delete(5);
    Grid1.Columns[FieldToCol(ufMem)].PickList.Delete(4);
    Grid1.Columns[FieldToCol(ufMem)].PickList.Delete(2);
    Grid1.Columns[FieldToCol(ufMem)].PickList.Delete(1)
  end;
  for i:=1 to 6 do
    if ConfigForm.RAF[i-1].Checked then
      Grid1.Columns[FieldToCol(ufReg)].PickList.Add('RAF'+IntToStr(i));
  for i:=1 to 6 do
    if ConfigForm.RBF[i-1].Checked then
      Grid1.Columns[FieldToCol(ufReg)].PickList.Add('RBF'+IntToStr(i));
  for i:=1 to 6 do
    if ConfigForm.WF[i-1].Checked then
      Grid1.Columns[FieldToCol(ufReg)].PickList.Add('WF'+IntToStr(i));
  if ConfigForm.RAA.Checked then
    Grid1.Columns[FieldToCol(ufReg)].PickList.Add('RAA');
  if ConfigForm.RBA.Checked then
    Grid1.Columns[FieldToCol(ufReg)].PickList.Add('RBA');
  if ConfigForm.WA.Checked then
    Grid1.Columns[FieldToCol(ufReg)].PickList.Add('WA');
end;

procedure TMicroCode.SetOverwrite(Value: Boolean);
begin
  Overwrite:=Value;
  OverwriteBox.ItemIndex:=ord(not(Value));
end;

procedure TMicroCode.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN: begin
      if TabIndex=0 then
      begin
        Grid1Selection(Sender,1,LastRow1);
        if (not Overwrite) and (Grid1.Row<Grid1.RowCount-1) then
        begin
          InsertLines(Grid1.Row+1,1);
          ClearLines(Grid1.Row+1,Grid1.Row+1)
        end
      end else
        Grid2Selection(Sender,LastCol2,LastRow2);
    end;
    VK_INSERT:
      SetOverwrite(not OverWrite);
    VK_DELETE: if (TabIndex=0) and
                  ((Grid1.Selection.Left<Grid1.Selection.Right) or
                  (Grid1.Selection.Top<Grid1.Selection.Bottom)) then
               begin
                 Delete1Click(Sender);
                 Key:=0
               end
  end
end;

procedure TMicroCode.Grid1Resize(Sender: TObject);
var
  W,i: Integer;
begin
  W:=5*MSSansSerif8Width+MSSansSerif8MicroCodeAddrWidthFudge;
  Grid1.ColWidths[0]:=W;
  for i:=1 to 12 do
    Grid1.ColWidths[i]:=((Grid1.ClientWidth-W)*i) div 13 +W-Grid1.CellRect(i,0).Left;
  Grid1.ColWidths[13]:=Grid1.ClientWidth-Grid1.CellRect(13,0).Left-1;
end;

procedure TMicroCode.Grid1SelectEditor(Sender: TObject; aCol, aRow: Integer; var Editor: TWinControl);
begin
  if Editor is TPickListCellEditor then
    TPickListCellEditor(Editor).AutoComplete:=true;
end;

procedure TMicroCode.Grid2Resize(Sender: TObject);
var
  i: Integer;
begin
  for i:=0 to Grid2.ColCount-2 do
    Grid2.ColWidths[i]:=(Grid2.ClientWidth*(i+1)) div Grid2.ColCount-Grid2.CellRect(i,0).Left;
  Grid2.ColWidths[Grid2.ColCount-1]:=Grid2.ClientWidth-Grid2.CellRect(Grid2.ColCount-1,0).Left-1
end;

procedure TMicroCode.Notebook1Changing(Sender: TObject; var AllowChange: Boolean);
begin
  TabSetChange(Sender,ord(Notebook1.ActivePage=Page1));
end;

procedure TMicroCode.OverwriteBoxChange(Sender: TObject);
begin
  SetOverwrite(OverwriteBox.ItemIndex=0);
end;

procedure TMicroCode.TabSetChange(Sender: TObject; NewTab: Integer);
begin
  if TabIndex=0 then
    begin
      if LastCol1=0 then
        LastCol1:=1;
      Grid1Selection(Sender,LastCol1,LastRow1)
    end
  else
    begin
      if LastCol2=0 then
        LastCol2:=1;
      Grid2Selection(Sender,LastCol2,LastRow2);
    end;
  TabIndex:=NewTab;
  ShowGrid;
end;

procedure TMicroCode.ShowGrid;
begin
  Cut1.Enabled:=(TabIndex=0);
  Copy1.Enabled:=(TabIndex=0);
  Paste1.Enabled:=(TabIndex=0);
  Delete1.Enabled:=(TabIndex=0);
  SelectAll1.Enabled:=(TabIndex=0);
  Fill1.Enabled:=not (TabIndex=0);
  CopyOpcodes1.Enabled:=not (TabIndex=0);
  Cut2.Enabled:=(TabIndex=0);
  Copy2.Enabled:=(TabIndex=0);
  Paste2.Enabled:=(TabIndex=0);
  Delete2.Enabled:=(TabIndex=0);
  SelectAll2.Enabled:=(TabIndex=0);
  Fill2.Enabled:=not (TabIndex=0);
  CopyOpcodes1.Enabled:=not (TabIndex=0)
end;

procedure TMicroCode.FillFixed;
var
  uAR, Opc: Integer;
begin
  for uAR:=0 to uCodeRows-1 do
    Grid1.Cells[0,uAR+1]:=IntToHex(uAR,4);
  for Opc:=0 to NumOpcodes-1 do
    Grid2.Cells[0,Opc+1]:=Encoding.Opcode(Opc)
end;

procedure TMicroCode.Grid1SelectCell(Sender: TObject; Col, Row: Longint;
  var CanSelect: Boolean);
begin
  if Col=0 then
    CanSelect:=false
end;

procedure TMicroCode.Grid1Selection(Sender: TObject; Col, Row: Integer);
begin
  LastCol1:=Col;
  LastRow1:=Row
end;

procedure TMicroCode.Grid1ValidateEntry(sender: TObject; aCol, aRow: Integer;
  const OldValue: string; var NewValue: String);
var
  Field: TuCodeField;
begin
  Field:=ColToField(aCol);
  if EnterField(aRow-1,Field,NewValue) then
    begin
      NewValue:=OldValue;
      Raise TMicroCodeEntryException.Create('Invalid value entered');
    end;
  if OldValue<>NewValue then
    SetModify;
end;

function TMicroCode.EnterField(uAR: Integer; Field: TuCodeField; S: string): Boolean;
var
  Items: TStrings;
  p,b,c: Integer;
begin
  Result:=false;
  p:=1;
  SkipSpaces(S,p);
  case Field of
    ufLabel: Grid1.Cells[1,uAR+1]:=ReadIdentifier(S,p);
    ufAdr: Grid1.Cells[9,uAR+1]:=ReadIdentifier(S,p);
    ufConst: if EndLine(S,p) then
             begin
               MCode[uAR,ufConst]:=0;
               MCode[uAR,ufLabel]:=0
             end else
             begin
               p:=1;
               b:=32-NumConstBits;
               if b<32 then
                 MCode[uAR,ufConst]:=(ReadInt(S,p) shl b) div (LongInt(1) shl b)
               else
                 MCode[uAR,ufConst]:=0;
               MCode[uAR,ufLabel]:=1
             end;
    ufReg: begin
             S:=UpperCase(Copy(S,p,1000));
             if Length(S)=0 then
               MCode[uAR,ufReg]:=0
             else if Pos('RR',S)=1 then
             begin
               MCode[uAR,ufReg]:=LongInt(ConfigForm.RRA.Value)+$200+
                       (ConfigForm.RRB.Value+$200) shl 10 or longint($80000000);
               p:=3
             end else
             begin
               p:=3;
               c:=ReadInt(S,p);
               p:=4;
               b:=ReadInt(S,p);
               if (Pos('RAF',S)=1) and (b>0) and (b<=6) and
                               ConfigForm.RAF[b-1].Checked then
                 MCode[uAR,ufReg]:=b+$200
               else if (Pos('RBF',S)=1) and (b>0) and (b<=6) and
                               ConfigForm.RBF[b-1].Checked then
                 MCode[uAR,ufReg]:=LongInt(b+$200) shl 10
               else if (Pos('WF',S)=1) and (c>0) and (c<=6) and
                               ConfigForm.WF[c-1].Checked then
                 MCode[uAR,ufReg]:=LongInt(c+$200) shl 20
               else if (Pos('RAA',S)=1) and ConfigForm.RAA.Checked and
                     (b>=0) and (b<ConfigForm.NumRegisters.Value) then
                 MCode[uAR,ufReg]:=b+$300
               else if (Pos('RBA',S)=1) and ConfigForm.RBA.Checked and
                     (b>=0) and (b<ConfigForm.NumRegisters.Value) then
                 MCode[uAR,ufReg]:=LongInt(b+$300) shl 10
               else if (Pos('WA',S)=1) and ConfigForm.WA.Checked and
                     (c>=0) and (c<ConfigForm.NumRegisters.Value) then
                 MCode[uAR,ufReg]:=LongInt(c+$300) shl 20
               else
                 Result:=true
             end
           end;
    ufALU..ufMem:
      begin
        Items:=Grid1.Columns[FieldToCol(Field)].PickList;
        b:=Items.IndexOf(ReadIdentifier(S,p));
        if b<0 then
          Result:=true
        else
          MCode[uAR,Field]:=b;
      end;
    else
      Result:=true;
  end;
  SkipSpaces(S,p);
  if not EndLine(S,p) then
    Result:=true
end;

procedure TMicroCode.DisplayField(uAR: Integer; Field: TuCodeField);
var
  Regs: LongInt;
  RegField: string;
  Col: Integer;
begin
  Col:=FieldToCol(Field);
  case Field of
    ufConst: ShowSingleConstant(Col,uAR);
    ufReg: begin
             Regs:=MCode[uAR,ufReg];
             if Regs=0 then
               RegField:=''
             else if Regs<0 then
               RegField:='RR'
             else begin
               if (Regs and $300)>0 then
                 RegField:='RA'
               else begin
                 Regs:=Regs shr 10;
                 if (Regs and $300)>0 then
                   RegField:='RB'
                 else begin
                   Regs:=Regs shr 10;
                   RegField:='W'
                 end
               end;
               if (Regs and $300)=$200 then
                 RegField:=RegField+'F'
               else
                 RegField:=RegField+'A';
               RegField:=RegField+IntToStr(Regs and $FF)
             end;
             Grid1.Cells[Col,uAR+1]:=RegField
           end;
    ufALU..ufMem:
      begin
        Grid1.Cells[Col,uAR+1]:=Grid1.Columns[Col].PickList[MCode[uAR,Field]];
      end;
  end;
end;

function TMicroCode.ColToField(Col: Integer): TuCodeField;
begin
  case Col of
     1: Result:=ufLabel;
     2: Result:=ufALU;
     3: Result:=ufS1;
     4: Result:=ufS2;
     5: Result:=ufDest;
     6: Result:=ufIRSize;
     7: Result:=ufConst;
     8: Result:=ufJCond;
     9: Result:=ufAdr;
    10: Result:=ufMem;
    11: Result:=ufMemAdr;
    12: Result:=ufMemDest;
    13: Result:=ufReg
  else
    raise Exception.Create('Invalid Col in ColToField')
  end
end;

function TMicroCode.FieldToCol(Field: TuCodeField): Integer;
begin
  case Field of
    ufLabel: Result:=1;
    ufALU: Result:=2;
    ufS1: Result:=3;
    ufS2: Result:=4;
    ufDest: Result:=5;
    ufIRSize: Result:=6;
    ufConst: Result:=7;
    ufJCond: Result:=8;
    ufAdr: Result:=9;
    ufMem: Result:=10;
    ufMemAdr: Result:=11;
    ufMemDest: Result:=12;
    ufReg: Result:=13
  else
    raise Exception.Create('Field can not be decoded (call to TMicroCode.FieldToCol)');
  end
end;

procedure TMicroCode.Grid2SelectCell(Sender: TObject; Col, Row: Longint;
  var CanSelect: Boolean);
begin
  if Col=0 then
    CanSelect:=false;
end;

procedure TMicroCode.Grid2Selection(Sender: TObject; Col, Row: Integer);
var
  Opc,p: Integer;
  Lab: string;
begin
  Opc:=LastRow2-1;
  if (Opc>=0) and (Opc<NumOpcodes) then
  begin
    Lab:=Grid2.Cells[LastCol2,LastRow2];
    p:=1;
    SkipSpaces(Lab,p);
    Grid2.Cells[LastCol2,LastRow2]:=ReadIdentifier(Lab,p)
  end;
  LastCol2:=Col;
  LastRow2:=Row;
end;

procedure TMicroCode.InsertLines(StartRow: Integer; NumLines: Integer);
var
  Col, Row: Integer;
  f: TuCodeField;
begin
  for Row:=Grid1.RowCount-1 downto StartRow+NumLines do
  begin
    for Col:=1 to Grid1.ColCount-1 do
      Grid1.Cells[Col,Row]:=Grid1.Cells[Col,Row-NumLines];
    for f:=Low(TuCodeField) to High(TuCodeField) do
      MCode[Row-1,f]:=MCode[Row-1-NumLines,f]
  end;
  SetModify
end;

procedure TMicroCode.DeleteLines(StartRow: Integer; NumLines: Integer);
var
  Col, Row: Integer;
  f: TuCodeField;
begin
  for Row:=StartRow to Grid1.RowCount-NumLines-1 do
  begin
    for Col:=1 to Grid1.ColCount-1 do
      Grid1.Cells[Col,Row]:=Grid1.Cells[Col,Row+NumLines];
    for f:=Low(TuCodeField) to High(TuCodeField) do
      MCode[Row-1,f]:=MCode[Row-1+NumLines,f]
  end;
  ClearLines(Grid1.RowCount-NumLines,Grid1.RowCount-1);
  SetModify
end;

procedure TMicroCode.ClearLines(StartRow: Integer; StopRow: Integer);
var
  Col, Row: Integer;
  f: TuCodeField;
begin
  for Row:=StartRow to StopRow do
  begin
    for Col:=1 to Grid1.ColCount-1 do
      Grid1.Cells[Col,Row]:='';
    for f:=Low(TuCodeField) to High(TuCodeField) do
      MCode[Row-1,f]:=0
  end;
  SetModify
end;

procedure TMicroCode.UnsignedHexadecimal1Click(Sender: TObject);
begin
  Base:=0;
  UpdateBaseMenu
end;

procedure TMicroCode.UnsignedDecimal1Click(Sender: TObject);
begin
  Base:=1;
  UpdateBaseMenu
end;

procedure TMicroCode.SignedDecimal1Click(Sender: TObject);
begin
  Base:=2;
  UpdateBaseMenu
end;

procedure TMicroCode.UpdateBaseMenu;
begin
   UnsignedHexadecimal1.checked:=(Base=0);
   UnsignedDecimal1.checked:=(Base=1);
   SignedDecimal1.checked:=(Base=2);
   UnsignedHexadecimal2.checked:=(Base=0);
   UnsignedDecimal2.checked:=(Base=1);
   SignedDecimal2.checked:=(Base=2);
   ShowConstants
end;

procedure TMicroCode.ShowConstants;
var
  uAR: Integer;
begin
  for uAR:=0 to uCodeRows-1 do
    ShowSingleConstant(FieldToCol(ufConst),uAR)
end;

procedure TMicroCode.ShowSingleConstant(Col,uAR: Integer);
var
  Val: LongInt;
  Msk: LongInt;
begin
  if MCode[uAR,ufLabel]<>0 then
  begin
    if Base<2 then
    begin
      if NumConstBits=32 then
        Msk:=-1
      else
        Msk:=(1 shl NumConstBits-1);
      Val:=MCode[uAR,ufConst] and Msk
    end else
      Val:=MCode[uAR,ufConst];
    if Base=0 then
      Grid1.Cells[Col,uAR+1]:='0x'+IntToHex(Val,ConstantHexWidth)
    else
      Grid1.Cells[Col,uAR+1]:=NewIntToStr(Val,0,Base)
  end else
    Grid1.Cells[Col,uAR+1]:=''
end;

procedure TMicroCode.About1Click(Sender: TObject);
begin
  AboutBox
end;

procedure TMicroCode.SelectAll1Click(Sender: TObject);
var
  SRect: TGridRect;
begin
  SRect.Top:=1;
  SRect.Bottom:=Grid1.RowCount-1;
  SRect.Left:=1;
  SRect.Right:=Grid1.ColCount-1;
  Grid1.Selection:=SRect
end;

procedure TMicroCode.Microcode1Click(Sender: TObject);
begin
  Notebook1.ActivePage:=Page1;
end;

procedure TMicroCode.JumpTables1Click(Sender: TObject);
begin
  Notebook1.ActivePage:=Page2;
end;

procedure TMicroCode.Delete1Click(Sender: TObject);
begin
  DeleteLines(Grid1.Selection.Top,Grid1.Selection.Bottom-Grid1.Selection.Top+1);
  SetCursorPage1(Grid1.Selection.Top,1)
end;

procedure TMicroCode.Cut1Click(Sender: TObject);
begin
  Copy1Click(Sender);
  Delete1Click(Sender)
end;

procedure TMicroCode.Copy1Click(Sender: TObject);
var
  Row: Integer;
begin
  ClipBoardBuffer.Clear;
  for Row:=Grid1.Selection.top to Grid1.Selection.Bottom do
    ClipBoardBuffer.AddLine(RowToStr(Row));
  ClipBoardBuffer.ToClipBoard;
  SetCursorPage1(Grid1.Row,1)
end;

procedure TMicroCode.OpenFile1Click(Sender: TObject);
begin
  if SaveFirst and OpenDialog1.Execute then
    LoadFile
end;

procedure TMicroCode.SaveFile1Click(Sender: TObject);
begin
  SaveFileClick
end;

function TMicroCode.SaveFileClick: Boolean;
begin
  if not Assemble('Save anyway?') then
  begin
    if SaveDialog1.FileName='Untitled.mco' then
      SaveFileAs1Click(MicroCode)
    else
      SaveFile
  end;
  Result:=not SaveFile1.Enabled
end;

procedure TMicroCode.SaveFileAs1Click(Sender: TObject);
begin
  if not Assemble('Save anyway?') and SaveDialog1.Execute then
    SaveFile
end;

procedure TMicroCode.Paste1Click(Sender: TObject);
var
  Row: Integer;
  Line: string;
begin
  ClipBoardBuffer.FromClipBoard;
  Row:=Grid1.Row;
  if not Overwrite then
    InsertLines(Row,ClipBoardBuffer.NumLines(Grid1.RowCount-Row));
  while (Row<Grid1.RowCount-1) and ClipBoardBuffer.GetLine(Line) do
  begin
    StrToRow(Row,Line);
    Row:=Row+1
  end;
  if Row<Grid1.RowCount-1 then
    SetCursorPage1(Row,1)
  else
    SetCursorPage1(Grid1.RowCount-1,1)
end;

function TMicroCode.RowToStr(Row: Integer): string;
var
  Col: Integer;
begin
  Result:=IntToHex(Row-1,4)+' ';
  for Col:=1 to Grid1.ColCount-1 do
    Result:=Result+Format('|%-6s',[Grid1.Cells[Col,Row]])
end;

function TMicroCode.StrToRow(Row: Integer; Line: string): Boolean;
var
  Col: Integer;
  f: TuCodeField;
  p: Integer;
begin
  p:=1;
  Result:=false;
  for Col:=1 to Grid1.ColCount-1 do
  begin
    SkipPastPipe(Line,p);
    if p<Length(Line) then
    begin
      f:=ColToField(Col);
      if EnterField(Row-1,f,ReadUntilPipe(Line,p)) then
        Result:=true;
      DisplayField(Row-1,f)
    end else
      break
  end
end;

procedure TMicroCode.SetCursorPage1(Row, Col: Integer);
var
  SRect: TGridRect;
begin
  SRect.Top:=Row;
  SRect.Bottom:=Row;
  SRect.Left:=Col;
  SRect.Right:=Col;
  Grid2.Selection:=SRect;
  Grid2.Row:=Row;
  Grid2.Col:=Col;
  Notebook1.ActivePage:=Page1;
end;

procedure TMicroCode.SetCursorPage2(Row, Col: Integer);
var
  SRect: TGridRect;
begin
  SRect.Top:=Row;
  SRect.Bottom:=Row;
  SRect.Left:=Col;
  SRect.Right:=Col;
  Grid2.Selection:=SRect;
  Grid2.Row:=Row;
  Grid2.Col:=Col;
  Notebook1.ActivePage:=Page2;
end;

procedure TMicroCode.CloseFile1Click(Sender: TObject);
begin
  ShowMessage('Close File not yet implemented')
end;

constructor TuLabel.Create(Adr: LongInt);
begin
  inherited Create;
  uAR:=Adr
end;

function TMicroCode.Assemble(Query: string): Boolean;
var
  Labels: TStringList;
  L: TuLabel;
  uAR,Col,Opc,j,Index: Integer;
  S,msg: string;
begin
  Result:=false;
  { Step 1: add labels to a sorted list of strings }
  Labels:=TStringList.Create;
  Labels.Sorted:=true;
  Labels.Duplicates:=dupError;
  for uAR:=0 to uCodeRows-1 do
  begin
    S:=Grid1.Cells[1,uAR+1];
    if Length(S)>0 then
    try
      L:=TuLabel.Create(uAR);
      Labels.AddObject(S,L);
    except
      Result:=true;
      SetCursorPage1(uAR+1,1);
      msg:='Duplicate labels are not allowed ('+IntToHex(uAR,4)+': '+S+')';
      break
    end
  end;
  { Step 2: Look up labels for Adr }
  if not Result then
  begin
    Col:=FieldToCol(ufAdr);
    for uAR:=0 to uCodeRows-1 do
    begin
      S:=Grid1.Cells[Col,uAR+1];
      if Length(S)>0 then
      begin
        Index:=Labels.IndexOf(S);
        if Index<0 then
        begin
          Result:=true;
          SetCursorPage1(uAR+1,Col);
          msg:='Undefined label ('+IntToHex(uAR,4)+': '+S+')';
          break
        end;
        MCode[uAR,ufAdr]:=(Labels.Objects[Index] as TuLabel).uAR;
      end else
        MCode[uAR,ufAdr]:=0;
    end
  end;
  { Step 3: Look up labels for jump tables }
  if not Result then
  begin
    for j:=0 to NumJumpTables-1 do
    begin
      for Opc:=0 to NumOpcodes-1 do
      begin
        S:=Grid2.Cells[j+1,Opc+1];
        if Length(S)>0 then
        begin
          Index:=Labels.IndexOf(S);
          if Index<0 then
          begin
            Result:=true;
            SetCursorPage2(Opc+1,j+1);
            msg:='Undefined label ('+Grid2.Cells[0,Opc+1]+': '+S+')';
            break
          end;
          JTable[j,Opc]:=(Labels.Objects[Index] as TuLabel).uAR
        end else
          JTable[j,Opc]:=0
      end;
      if Result then
        break
    end
  end;
  Assembled:=not Result;
  if Result then
  begin
    if Length(Query)>0 then
      Result:=(AppliMessage(msg+Chr(13)+Chr(10)+Query,'Error',$31)<>1)
    else
      AppliMessage(msg,'Error',$10)
  end
end;

procedure TMicroCode.Assemble1Click(Sender: TObject);
var
  Dummy: Boolean;
begin
  Grid1Selection(Sender,1,LastRow1);
  Assemble('')
end;

procedure TMicroCode.Fill1Click(Sender: TObject);
var
  L: string;
  p,i,j: Integer;
begin
  L:='';
  if InputQuery('Fill Selection','Enter label',L) then
  begin
    p:=1;
    SkipSpaces(L,p);
    L:=ReadIdentifier(L,p);
    for j:=Grid2.Selection.Left to Grid2.Selection.Right do
      for i:=Grid2.Selection.Top to Grid2.Selection.Bottom do
        Grid2.Cells[j,i]:=L;
    SetModify
  end
end;

procedure TMicroCode.CopyOpcodes1Click(Sender: TObject);
var
  i,j: Integer;
begin
  j:=Grid2.Col;
  for i:=1 to Grid2.RowCount-1 do
    Grid2.Cells[j,i]:=Grid2.Cells[0,i];
  SetModify
end;

procedure TMicroCode.HideForm1Click(Sender: TObject);
begin
  Hide
end;

procedure TMicroCode.NewFile1Click(Sender: TObject);
begin
  if SaveFirst then
    ClearMicroCode
end;

function TMicroCode.SaveFirst: Boolean;
var
  Answer: Integer;
begin
  Result:=true;
  if SaveFile1.Enabled then
  begin
    Answer:=AppliMessage('Save changes to '+
           ExtractFileName(SaveDialog1.FileName)+'?','Microcode - Confirm',$23);
    case Answer of
      6: begin
           SaveFile1Click(MicroCode);
           Result:=not SaveFile1.Enabled
         end;
      7: { no -> Don't do anything but return true }
    else
      Result:=false
    end
  end
end;

procedure TMicroCode.SetModify;
begin
  Assembled:=false;
  SaveFile1.Enabled:=true;
  MicroForm.SetModify
end;

procedure TMicroCode.ClearMicrocode;
var
  f: TuCodeField;
  i,j: Integer;
begin
  for i:=1 to uCodeRows do
  begin
    for f:=Low(TuCodeField) to High(TuCodeField) do
      MCode[i-1,f]:=0;
    for j:=1 to Grid1.ColCount-1 do
    Grid1.Cells[j,i]:=''
  end;
  for i:=1 to NumOpcodes do
    for j:=1 to NumJumpTables do
      Grid2.Cells[j,i]:='';
  SaveDialog1.FileName:='Untitled.mco';
  SaveFile1.Enabled:=false;
  Assemble('');
  ShowCaption
end;

procedure TMicroCode.LoadFile;
var
  i,p,Row,Opc: Integer;
  L: string;
  Error: Boolean;
begin
  FileIO.UseFile(OpenDialog1.FileName);
  Reset(FileIO.F);
  Error:=false;
  ClearMicrocode;
  Assembled:=false;
  if FileIO.FindString('[Microcode]',L) then
  begin
    Row:=1;
    repeat
      Readln(FileIO.F,L);
      p:=1;
      SkipSpaces(L,p);
      if EndLine(L,p) then
        break;
      if L[p]=';' then
        continue;
      if StrToRow(Row,L) then
        Error:=true;
      Row:=Row+1
    until Row>uCodeRows;
  end else
    Error:=true;
  if FileIO.FindString('[Jump Tables]',L) then
  begin
    repeat
      Readln(FileIO.F,L);
      p:=1;
      SkipSpaces(L,p);
      if EndLine(L,p) then
        break;
      if L[p]=';' then
        continue;
      Opc:=Encoding.Index(ReadIdentifier(L,p));
      if Opc<0 then
      begin
        Error:=true;
        break
      end;
      for i:=1 to NumJumpTables do
      begin
        SkipPastPipe(L,p);
        Grid2.Cells[i,Opc+1]:=ReadIdentifier(L,p)
      end
    until false;
  end else
    Error:=true;
  CloseFile(FileIO.F);
  SaveDialog1.FileName:=OpenDialog1.FileName;
  ShowCaption;
  if Error then
    AppliMessage('File Format Corrupt; microcode may be incorrect','Warning',$40)
  else
    Assemble('');
  SaveFile1.Enabled:=false
end;

procedure TMicroCode.SaveFile;
var
  i,j: Integer;
  Used: Boolean;
begin
  FileIO.UseFile(SaveDialog1.FileName);
  Rewrite(FileIO.F);
  Writeln(FileIO.F,'[Microcode]');
  Writeln(FileIO.F,';uAR |Label |ALU   |S1    |S2    |Dest  |ExtIR |Const |JCond |Adr   |Mem   |MAdr  |MDest |Regs');
  for i:=1 to Grid1.RowCount-1 do
  begin
    Used:=false;
    for j:=1 to Grid1.ColCount-1 do
      if Length(Grid1.Cells[j,i])>0 then
      begin
        Used:=true;
        break
      end;
    if Used then
      Writeln(FileIO.F,RowToStr(i))
  end;
  Writeln(FileIO.F);
  Writeln(FileIO.F,'[Jump Tables]');
  Write(FileIO.F,Format('%-9s',[';Opcode']));
  for j:=1 to NumJumpTables do
    Write(FileIO.F,Format('|%-13s',['Jump Table '+IntToStr(j)]));
  Writeln(FileIO.F);
  for i:=1 to Grid2.RowCount-1 do
    if Length(Grid2.Cells[0,i])>0 then
    begin
      Write(FileIO.F,Format('%-9s',[Grid2.Cells[0,i]]));
      for j:=1 to NumJumpTables do
        Write(FileIO.F,Format('|%-13s',[Grid2.Cells[j,i]]));
      Writeln(FileIO.F)
    end;
  Writeln(FileIO.F);
  CloseFile(FileIO.F);
  SaveFile1.Enabled:=false;
  ShowCaption
end;

procedure TMicroCode.ShowCaption;
begin
  Caption:='Microcode - '+ExtractFileName(SaveDialog1.FileName)
end;

procedure TMicroCode.Grid1KeyPress(Sender: TObject; var Key: Char);
begin
  SetModify
end;

procedure TMicroCode.Grid2KeyPress(Sender: TObject; var Key: Char);
begin
  SetModify
end;

procedure TMicroCode.HighLight(uAR: LongInt);
var
  SRect: TGridRect;
begin
  if (uAR>=0) and (uAR<Grid1.RowCount-1) then
  begin
    if uAR+1<Grid1.TopRow then
      Grid1.TopRow:=uAR+1;
    if Grid1.TopRow+Grid1.VisibleRowCount-1<uAR+1 then
      Grid1.TopRow:=uAR+2-Grid1.VisibleRowCount;
    SRect.Top:=uAR+1;
    SRect.Bottom:=uAR+1;
    SRect.Left:=0;
    SRect.Right:=Grid1.ColCount-1;
    Grid1.Selection:=SRect;
  end
end;

function TMicroCode.ReadAssembled: Boolean;
begin
  Result:=not Assemble1.Enabled
end;

procedure TMicroCode.WriteAssembled(Val: Boolean);
begin
  Assemble1.Enabled:=not Val;
  Assemble2.Enabled:=not Val
end;

end.
