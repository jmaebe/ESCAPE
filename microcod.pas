{ Project: Escape                                                            }
{ Version: 1.1                                                               }
{ Author: Peter Verplaetse                                                   }
{ Date: 22 July 1998                                                         }

unit MicroCod;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, Grids, Compos, Tabs, Config, Common, Menus,
  StdCtrls, NewStr;

type
  TuCodeField = (ufLabel, ufAdr, ufConst, ufReg, ufALU, ufS1, ufS2,
                 ufDest, ufMemAdr, ufMemDest, ufIRSize, ufJCond, ufMem);

  { Don't confuse uLabel with the labels used by Disassemble in InstrMem.pas }
  TuLabel = class(TObject)
    uAR: LongInt;
    constructor Create(Adr: LongInt);
  end;

  { The microcode and jump tables form }
  TMicroCode = class(TForm)
    TabSet: TTabSet;
    Grid1: TNewStringGrid;
    MainMenu1: TMainMenu;
    Grid2: TNewStringGrid;
    DropMem: TListBox;
    DropMAdr: TListBox;
    DropS2: TListBox;
    DropS1: TListBox;
    DropDest: TListBox;
    DropIR: TListBox;
    DropJCond: TListBox;
    DropMDest: TListBox;
    DropALU: TListBox;
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
    DropdownMode1: TMenuItem;
    DropReg: TListBox;
    PopupMenu1: TPopupMenu;
    Cut2: TMenuItem;
    Copy2: TMenuItem;
    Paste2: TMenuItem;
    Delete2: TMenuItem;
    SelectAll2: TMenuItem;
    N2: TMenuItem;
    DropdownMode2: TMenuItem;
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
    Status1: TPanel;
    Status2: TPanel;
    Status3: TPanel;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure TabSetChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure Grid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Grid1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Grid1SelectCell(Sender: TObject; Col, Row: Longint;
      var CanSelect: Boolean);
    procedure Grid2SelectCell(Sender: TObject; Col, Row: Longint;
      var CanSelect: Boolean);
    procedure DropDownClick(Sender: TObject);
    procedure DropdownMode1Click(Sender: TObject);
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
    procedure SetCursor(Row, Col: Integer);
    procedure CloseFile1Click(Sender: TObject);
    procedure Assemble1Click(Sender: TObject);
    procedure Fill1Click(Sender: TObject);
    procedure Grid2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Grid2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
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
    UseDropDown: Boolean;
    uCodeRows: Integer;
    NumOpcodes: Integer;
    NumJumpTables: Integer;
    NumConstBits: Integer;
    CompleteExtend: Boolean;
    CompleteJCond: Boolean;
    CompleteMemOps: Boolean;
    ClipBoardBuffer: TClipBoardBuffer;
    LastDropDownField: TuCodeField;
    Base: Integer;
    ConstantHexWidth: Integer;
    procedure ShowGrid;
    procedure FillFixed;
    procedure SetOverwrite(Value: Boolean);
    procedure SetUseDropDown(Value: Boolean);
    function EnterField(uAR: Integer; Field: TuCodeField; S: string): Boolean;
    procedure DisplayField(uAR: Integer; Field: TuCodeField);
    procedure InitializeDropBoxes;
    function ColToField(Col: Integer): TuCodeField;
    function FieldToCol(Field: TuCodeField): Integer;
    procedure InsertLines(StartRow: Integer; NumLines: Integer);
    procedure DeleteLines(StartRow: Integer; NumLines: Integer);
    procedure ClearLines(StartRow: Integer; StopRow: Integer);
    function FieldToDrop(Field: TuCodeField): TListBox;
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
  Micro;

{$R *.DFM}

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
  ClipBoardBuffer:=TClipBoardBuffer.Create;
  NumOpcodes:=ConfigForm.NumOpcodes.Value;
  NumJumpTables:=ConfigForm.NumJumpTables.Value;
  uCodeRows:=ConfigForm.uCodeRows.Value;
  CompleteExtend:=(ConfigForm.CompleteExtend.ItemIndex=1);
  CompleteJCond:=(ConfigForm.CompleteCompOps.ItemIndex=1);
  CompleteMemOps:=(ConfigForm.CompleteMemOps.ItemIndex=1);
  NumConstBits:=ConfigForm.NumConstBits.Value;
  ConstantHexWidth:=(NumConstBits+3) div 4;
  Grid1.DefaultRowHeight:=MSSansSerif8Height+2;
  Grid1.RowCount:=uCodeRows+1;
  Grid1.Cells[0,0]:='uAR';
  Grid1.Cells[1,0]:='Label';
  Grid1.Cells[2,0]:='ALU';
  Grid1.Cells[3,0]:='S1';
  Grid1.Cells[4,0]:='S2';
  Grid1.Cells[5,0]:='Dest';
  Grid1.Cells[6,0]:='ExtIR';
  Grid1.Cells[7,0]:='Const';
  Grid1.Cells[8,0]:='JCond';
  Grid1.Cells[9,0]:='Adr';
  Grid1.Cells[10,0]:='Mem';
  Grid1.Cells[11,0]:='MAdr';
  Grid1.Cells[12,0]:='MDest';
  Grid1.Cells[13,0]:='Regs';
  Grid2.RowCount:=NumOpCodes+1;
  Grid2.ColCount:=NumJumpTables+1;
  Grid2.DefaultRowHeight:=MSSansSerif8Height+2;
  Grid2.Left:=0;
  Grid2.Cells[0,0]:='Opcode';
  for i:=1 to NumJumpTables do
    Grid2.Cells[i,0]:='Jump Table '+IntToStr(i);
  FillFixed;
  LastCol1:=1;
  LastRow1:=0;
  LastCol2:=1;
  LastRow2:=0;
  ShowGrid;
  SetOverwrite(true);
  Base:=2;
  UpdateBaseMenu;
  Status3.Caption:='';
  InitializeDropBoxes;
  SetUseDropDown(true);
  ClearMicroCode
end;

procedure TMicroCode.InitializeDropBoxes;
var
  i: Integer;
  f: TuCodeField;
  DropBox: TListBox;
begin
  if ConfigForm.CompleteALU.Checked then
  begin
    DropALU.Items.Add(ALUOperation[MULT]);
    DropALU.Items.Add(ALUOperation[DIVI])
  end;
  for i:=0 to ConfigForm.NumTemps-1 do
  begin
    DropS1.Items.Add(ConfigForm.TmpNames.Cells[0,i]);
    DropS2.Items.Add(ConfigForm.TmpNames.Cells[0,i]);
    DropDest.Items.Add(ConfigForm.TmpNames.Cells[0,i])
  end;
  if CompleteExtend then
  begin
    DropIR.Items.Insert(1,'Byte');
    DropIR.Items.Insert(2,'Half')
  end;
  if not CompleteJCond then
  begin
    DropJCond.Items.Delete(7);
    DropJCond.Items.Delete(6);
    DropJCond.Items.Delete(5);
    DropJCond.Items.Delete(3)
  end;
  for i:=1 to NumJumpTables do
    DropJCond.Items.add('Jump'+IntToStr(i));
  if not CompleteMemOps then
  begin
    Dropmem.Items.Delete(5);
    Dropmem.Items.Delete(4);
    Dropmem.Items.Delete(2);
    Dropmem.Items.Delete(1)
  end;
  for i:=1 to 6 do
    if ConfigForm.RAF[i-1].Checked then
      DropReg.Items.Add('RAF'+IntToStr(i));
  for i:=1 to 6 do
    if ConfigForm.RBF[i-1].Checked then
      DropReg.Items.Add('RBF'+IntToStr(i));
  for i:=1 to 6 do
    if ConfigForm.WF[i-1].Checked then
      DropReg.Items.Add('WF'+IntToStr(i));
  if ConfigForm.RAA.Checked then
    DropReg.Items.Add('RAA');
  if ConfigForm.RBA.Checked then
    DropReg.Items.Add('RBA');
  if ConfigForm.WA.Checked then
    DropReg.Items.Add('WA');
  for f:=ufReg to High(TuCodeField) do
  begin
    DropBox:=FieldToDrop(f);
    DropBox.Height:=DropBox.ItemHeight*DropBox.Items.Count+5
  end
end;

procedure TMicroCode.SetOverwrite(Value: Boolean);
begin
  Overwrite:=Value;
  if Overwrite then
    Status2.Caption:='Overwrite'
  else
    Status2.Caption:='Insert';
end;

procedure TMicroCode.SetUseDropDown(Value: Boolean);
begin
  if LastDropDownField>=ufReg then
    FieldToDrop(LastDropDownField).Visible:=false;
  UseDropDown:=Value;
  DropdownMode1.Checked:=Value;
  DropdownMode2.Checked:=Value;
  if UseDropDown then
    Status1.Caption:='Dropdown Mode'
  else
    Status1.Caption:='Edit Mode';
  Grid1.EditorMode:=not Value
end;

procedure TMicroCode.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Dummy: Boolean;
begin
  case Key of
    VK_RETURN: begin
      if TabIndex=0 then
      begin
        Grid1SelectCell(Sender,1,LastRow1,Dummy);
        if (not Overwrite) and (Grid1.Row<Grid1.RowCount-1) then
        begin
          InsertLines(Grid1.Row+1,1);
          ClearLines(Grid1.Row+1,Grid1.Row+1)
        end
      end else
        Grid2SelectCell(Sender,LastCol2,LastRow2,Dummy);
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

procedure TMicroCode.FormResize(Sender: TObject);
var
  W,i: Integer;
begin
  if TabIndex=0 then
  begin
    Grid1.Width:=ClientWidth;
    Grid1.Height:=ClientHeight-41;
    W:=5*MSSansSerif8Width;
    Grid1.ColWidths[0]:=W;
    for i:=1 to 12 do
      Grid1.ColWidths[i]:=((Grid1.ClientWidth-W)*i) div 13 +W-Grid1.CellRect(i,0).Left;
    Grid1.ColWidths[13]:=Grid1.ClientWidth-Grid1.CellRect(13,0).Left-1;
    Status3.Width:=Width-248;
    Status1.Top:=ClientHeight-38;
    Status2.Top:=ClientHeight-38;
    Status3.Top:=ClientHeight-38
  end else
  begin
    Grid2.Width:=ClientWidth;
    Grid2.Height:=ClientHeight-22;
    for i:=0 to Grid2.ColCount-2 do
      Grid2.ColWidths[i]:=(Grid2.ClientWidth*(i+1)) div Grid2.ColCount-Grid2.CellRect(i,0).Left;
    Grid2.ColWidths[Grid2.ColCount-1]:=Grid2.ClientWidth-Grid2.CellRect(Grid2.ColCount-1,0).Left-1
  end
end;

procedure TMicroCode.TabSetChange(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
var
  Dummy: Boolean;
begin
  if TabIndex=0 then
    Grid1SelectCell(Sender,LastCol1,LastRow1,Dummy)
  else
    Grid2SelectCell(Sender,LastCol2,LastRow2,Dummy);
  TabIndex:=NewTab;
  FormResize(Sender);
  ShowGrid;
  if LastDropDownField>=ufReg then
    FieldToDrop(LastDropDownField).Visible:=false
end;

procedure TMicroCode.ShowGrid;
begin
  Grid1.Visible:=(TabIndex=0);
  Grid2.Visible:=not (TabIndex=0);
  Status1.Visible:=(TabIndex=0);
  Status2.Visible:=(TabIndex=0);
  Status3.Visible:=(TabIndex=0);
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

procedure TMicroCode.Grid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Grid1.Options:=Grid1.Options+[goEditing]
end;

procedure TMicroCode.Grid1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Grid1.Options:=Grid1.Options-[goEditing]
end;

procedure TMicroCode.Grid1SelectCell(Sender: TObject; Col, Row: Longint;
  var CanSelect: Boolean);
var
  T, uAR: Integer;
  Field: TuCodeField;
  DropBox: TListBox;
begin
  if LastDropDownField>=ufReg then
    FieldToDrop(LastDropDownField).Visible:=false;
  if Col>0 then
  begin
    Field:=ColToField(Col);
    if UseDropDown and (Field>=ufReg) then
    begin
      LastDropDownField:=Field;
      DropBox:=FieldToDrop(Field);
      uAR:=Row-1;
      if Field>=ufALU then
        DropBox.ItemIndex:=MCode[uAR,Field]
      else
        DropBox.ItemIndex:=DropReg.Items.IndexOf(Grid1.Cells[Col,Row]);
      DropBox.Left:=Grid1.CellRect(Col,Row).Left;
      T:=Grid1.CellRect(Col,Row).Top;
      if T+DropBox.Height>Grid1.Height then
        T:=Grid1.Height-DropBox.Height;
      if Top<=Grid1.DefaultRowHeight then
        T:=Grid1.DefaultRowHeight+1;
      DropBox.Top:=T;
      DropBox.Width:=Grid1.CellRect(Col,Row).Right-Grid1.CellRect(Col,Row).Left+2;
      DropBox.Visible:=true
    end
  end;
  uAR:=LastRow1-1;
  Field:=ColToField(LastCol1);
  EnterField(uAR,Field,Grid1.Cells[LastCol1,LastRow1]);
  DisplayField(uAR,Field);
  if Col=0 then
    CanSelect:=false
  else begin
    LastCol1:=Col;
    LastRow1:=Row
  end
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
                       (ConfigForm.RRB.Value+$200) shl 10+$80000000;
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
    ufALU..ufMem: begin
                    Items:=FieldToDrop(Field).Items;
                    b:=Items.IndexOf(ReadIdentifier(S,p));
                    if b<0 then
                      Result:=true
                    else
                      MCode[uAR,Field]:=b;
                  end
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
    ufALU..ufMem: Grid1.Cells[Col,uAR+1]:=FieldToDrop(Field).Items[MCode[uAR,Field]]
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
  if Col=0 then
    CanSelect:=false;
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

function TMicroCode.FieldToDrop(Field: TuCodeField): TListBox;
begin
  case Field of
    ufReg: Result:=DropReg;
    ufALU: Result:=DropALU;
    ufS1: Result:=DropS1;
    ufS2: Result:=DropS2;
    ufDest: Result:=DropDest;
    ufMemAdr: Result:=DropMAdr;
    ufMemDest: Result:=DropMDest;
    ufIRSize: Result:=DropIR;
    ufJCond: Result:=DropJCond;
    ufMem: Result:=DropMem
  else
    raise Exception.Create('This field has no dropbox')
  end
end;

procedure TMicroCode.DropDownClick(Sender: TObject);
var
  uAR: Integer;
  DropBox: TListBox;
  S, Val: string;
begin
  if LastDropDownField>=ufReg then
  begin
    uAR:=LastRow1-1;
    DropBox:=FieldToDrop(LastDropDownField);
    if LastDropDownField=ufReg then
    begin
      S:=DropReg.Items[DropReg.ItemIndex];
      if (Length(S)=2) and (S[2]='A') then
      begin
        Val:='0';
        if InputQuery('Read or Write Actual Register',
           'Enter actual register number:',Val) then
          S:=S+Val
        else
          S:='void'
      end;
      EnterField(uAR,ufReg,S)
    end else
      MCode[uAR,LastDropDownField]:=DropBox.ItemIndex;
    DisplayField(uAR,LastDropDownField);
    SetModify;
    DropBox.Visible:=false
  end
end;

procedure TMicroCode.DropdownMode1Click(Sender: TObject);
begin
  SetUseDropDown(not UseDropDown)
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
  TabSet.TabIndex:=0
end;

procedure TMicroCode.JumpTables1Click(Sender: TObject);
begin
  TabSet.TabIndex:=1
end;

procedure TMicroCode.Delete1Click(Sender: TObject);
begin
  DeleteLines(Grid1.Selection.Top,Grid1.Selection.Bottom-Grid1.Selection.Top+1);
  SetCursor(Grid1.Selection.Top,1)
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
  SetCursor(Grid1.Row,1)
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
    SetCursor(Row,1)
  else
    SetCursor(Grid1.RowCount-1,1)
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

procedure TMicroCode.SetCursor(Row, Col: Integer);
var
  SRect: TGridRect;
begin
  SRect.Top:=Row;
  SRect.Bottom:=Row;
  SRect.Left:=Col;
  SRect.Right:=Col;
  Grid1.Selection:=SRect;
  Grid1.Row:=Row;
  Grid1.Col:=Col;
  TabSet.TabIndex:=0;
  Grid1.PressKey(VK_DOWN,[]);
  Grid1.PressKey(VK_UP,[])
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
      SetCursor(uAR+1,1);
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
          SetCursor(uAR+1,Col);
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
            Grid2.Row:=Opc+1;
            Grid2.Col:=j+1;
            TabSet.TabIndex:=1;
            Grid2.PressKey(VK_DOWN,[]);
            Grid2.PressKey(VK_UP,[]);
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
  Grid1SelectCell(Sender,1,LastRow1,Dummy);
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

procedure TMicroCode.Grid2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Grid2.Options:=Grid2.Options+[goEditing]
end;

procedure TMicroCode.Grid2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Grid2.Options:=Grid2.Options-[goEditing]
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

