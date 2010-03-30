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

unit Config;

{$MODE Delphi}

interface

uses
  SysUtils, {WinTypes, WinProcs,} Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Compos, Menus, Grids, Common, ExtCtrls, Tabs,
  Spin, LResources, lcltype;

type
  TOpcodeType = (otR, otI, otJ);

  { Use this class to decode the instructions }
  TEncoding = class
  public
    MaxWidth: Integer;
    procedure CalcMaxWidth;
    function Opcode(Index: Integer): string;
    function Index(Opcode: string): Integer;
    function OpcodeType(Index: Integer): TOpcodeType;
    function Operands(Index: Integer): string;
  end;

  { This is the configuration form. Many of the fields are read directly by other units }
  TConfigForm = class(TForm)
    TabSet1: TTabSet;
    Notebook1: TNotebook;
    MicroStuff: TGroupBox;
    Label7: TLabel;
    Label9: TLabel;
    WA: TCheckBox;
    RAA: TCheckBox;
    RBA: TCheckBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    ImemSize: TPowerSpin;
    DmemSize: TPowerSpin;
    Label2: TLabel;
    CompleteExtend: TRadioGroup;
    CompleteMemOps: TRadioGroup;
    ALUBox: TGroupBox;
    CompleteALU: TCheckBox;
    CompleteCompOps: TRadioGroup;
    Label12: TLabel;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    NumRegisters: TPowerSpin;
    NumOpcodes: TPowerSpin;
    Label4: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    RBox_Opc: TShape;
    RBox_r1: TShape;
    IBox_Opc: TShape;
    IBox_r1: TShape;
    RBox_r3: TShape;
    RBox_r2: TShape;
    RBox_r4: TShape;
    RBox_r5: TShape;
    RBox_r6: TShape;
    IBox_r2: TShape;
    IBox_imm: TShape;
    RBox_imm: TShape;
    JBox_imm: TShape;
    JBox_Opc: TShape;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    RLab_Opc: TLabel;
    RLab_r1: TLabel;
    RLab_r2: TLabel;
    RLab_r3: TLabel;
    RLab_r4: TLabel;
    RLab_r5: TLabel;
    RLab_r6: TLabel;
    ILab_Opc: TLabel;
    JLab_Opc: TLabel;
    ILab_r1: TLabel;
    ILab_r2: TLabel;
    ILab_imm: TLabel;
    JLab_imm: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Imm1: TEdit;
    Imm2: TEdit;
    Formals: TEdit;
    Grid: TNewStringGrid;
    GroupBox3: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    Label6: TLabel;
    DropBox: TListBox;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    HideForm1: TMenuItem;
    N1: TMenuItem;
    SaveFileAs1: TMenuItem;
    SaveFile1: TMenuItem;
    OpenFile1: TMenuItem;
    NewFile1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    TmpNames: TNewStringGrid;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    PopupMenu1: TPopupMenu;
    HideForm2: TMenuItem;
    RegFileRead: TRadioGroup;
    Courier101: TLabel;
    Courier91: TLabel;
    MSSansSerif81: TLabel;
    Courier102: TLabel;
    Courier92: TLabel;
    MSSansSerif82: TLabel;
    RRA: TSpinEdit;
    RRB: TSpinEdit;
    NumJumpTables: TSpinEdit;
    uCodeRows: TSpinEdit;
    NumConstBits: TSpinEdit;
    StallControl: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TabSet1Change(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure NumRegistersChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure GridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GridSelectCell(Sender: TObject; Col, Row: Longint;
      var CanSelect: Boolean);
    procedure DropBoxClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure About1Click(Sender: TObject);
    procedure HideForm1Click(Sender: TObject);
    procedure NewFile1Click(Sender: TObject);
    procedure SaveFileAs1Click(Sender: TObject);
    procedure OpenFile1Click(Sender: TObject);
    procedure SetModify(Sender: TObject);
    procedure TmpNamesKeyPress(Sender: TObject; var Key: Char);
    procedure SaveFile1Click(Sender: TObject);
    procedure GridKeyPress(Sender: TObject; var Key: Char);
  private
    NumFormals: Integer;
    LastCol: Integer;
    LastRow: Integer;
    procedure ClearConfiguration;
    procedure UpdateConfiguration;
    procedure ShowDropDown(Row: Integer);
    destructor Destroy; override;
    procedure LoadFile;
    procedure SaveFile;
    procedure ReadSet(Item: string; Value: array of TCheckBox; var Error: Boolean);
    procedure WriteSet(Item: string; Value: array of TCheckBox);
    procedure ShowCaption;
  public
    NumTemps: Integer;
    RAF: array [0..5] of TCheckBox;
    RBF: array [0..5] of TCheckBox;
    WF: array [0..5] of TCheckBox;
    OpcodeType: array [0..255] of TOpcodeType;
    function SaveFirst: Boolean;
  end;

var
  ConfigForm: TConfigForm;
  Encoding: TEncoding;

implementation

uses Main;

{$R *.lfm}

function TEncoding.Opcode(Index: Integer): string;
begin
  if (Index<0) or (Index>=ConfigForm.Grid.RowCount-1) then
    Result:=''
  else
    Result:=ConfigForm.Grid.Cells[0,Index+1];
end;

function TEncoding.Index(Opcode: string): Integer;
var
  i: Integer;
begin
  Result:=-1;
  for i:=0 to ConfigForm.Grid.RowCount-2 do
    if CompareText(ConfigForm.Grid.cells[0,i+1],Opcode)=0 then
      Result:=i;
end;

function TEncoding.OpcodeType(Index:Integer): TOpcodeType;
begin
  Result:=ConfigForm.OpcodeType[Index]
end;

function TEncoding.Operands(Index: Integer): string;
begin
  Result:=ConfigForm.Grid.Cells[2,Index+1]
end;

procedure TEncoding.CalcMaxWidth;
var
  i: Integer;
begin
  MaxWidth:=0;
  for i:=1 to ConfigForm.Grid.RowCount-1 do
    if Length(ConfigForm.Grid.Cells[0,i])>MaxWidth then
      MaxWidth:=Length(ConfigForm.Grid.Cells[0,i])
end;

procedure TConfigForm.FormCreate(Sender: TObject);
var
  i: Integer;
  Dummy: Boolean;
  SearchRec: TSearchRec;
begin
  Grid.DefaultRowHeight:=MSSansSerif8Height+2;
  Grid.ColWidths[2]:=Grid.ClientWidth-Grid.CellRect(2,0).Left;
  Grid.Cells[0,0]:='Opcode';
  Grid.Cells[1,0]:='Type';
  Grid.Cells[2,0]:='Mnemonic Representation';
  for i:=0 to 5 do
  begin
    RAF[i]:=TCheckBox.Create(MicroStuff);
    with RAF[i] do
    begin
      Left:=8;
      Top:=56+i*16;
      Width:=65;
      OnClick:=SetModify;
      Caption:='RAF'+IntToStr(i+1)
    end;
    MicroStuff.InsertControl(RAF[i]);
    RBF[i]:=TCheckBox.Create(MicroStuff);
    with RBF[i] do
    begin
      Left:=96;
      Top:=56+i*16;
      Width:=65;
      OnClick:=SetModify;
      Caption:='RBF'+IntToStr(i+1)
    end;
    MicroStuff.InsertControl(RBF[i]);
    WF[i]:=TCheckBox.Create(MicroStuff);
    with WF[i] do
    begin
      Left:=184;
      Top:=56+i*16;
      Width:=65;
      OnClick:=SetModify;
      Caption:='WF'+IntToStr(i+1)
    end;
    MicroStuff.InsertControl(WF[i])
  end;
  TabSet1Change(Sender,0,Dummy);
  NumRegistersChange(Sender);
  DropBox.Height:=DropBox.ItemHeight*DropBox.Items.Count+5;
  ClearConfiguration;
  if FileExists('Escape.ecf') then
    OpenDialog1.FileName:='Escape.ecf'
  else begin
    if FindFirst('*.ecf',$3F,SearchRec)=0 then
      OpenDialog1.FileName:=SearchRec.Name;
    FindClose(SearchRec.FindHandle)
  end;
  if Length(OpenDialog1.FileName)>0 then
  begin
    LoadFile;
    UpdateConfiguration
  end;
  LastRow:=1;
  LastCol:=0
end;

procedure TConfigForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  UpdateConfiguration;
  Action:=caHide;
  MainForm.Show;
  MainForm.WindowState:=wsNormal
end;

destructor TConfigForm.Destroy;
var
  i: Integer;
begin
  for i:=0 to 5 do
  begin
    RAF[i].Free;
    RBF[i].Free;
    WF[i].Free
  end;
  inherited Destroy
end;

procedure TConfigForm.UpdateConfiguration;
var
  i,p: Integer;
  S: string;
begin
  NumTemps:=0;
  for i:=0 to 9 do
  begin
    p:=1;
    S:=ReadIdentifier(TmpNames.Cells[0,i],p);
    if Length(S)>0 then
    begin
      TmpNames.Cells[0,NumTemps]:=S;
      NumTemps:=NumTemps+1
    end
  end;
  for i:=NumTemps to 9 do
    TmpNames.Cells[0,i]:='';
  Unravel.UpdateFields;
  Encoding.CalcMaxWidth
end;

procedure TConfigForm.TabSet1Change(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
  NoteBook1.PageIndex:=NewTab
end;

procedure TConfigForm.NumRegistersChange(Sender: TObject);
var
  i,Opc: Integer;
begin
  Imm1.Text:=IntToStr(32-NumRegisters.Exponent*2-NumOpcodes.Exponent);
  Imm2.Text:=IntToStr(32-NumOpcodes.Exponent);
  NumFormals:=(32-NumOpcodes.Exponent) div NumRegisters.Exponent;
  if NumFormals>6 then
    NumFormals:=6;
  Formals.Text:=IntToStr(NumFormals);
  RBox_Opc.Width:=7*NumOpcodes.Exponent+1;
  RBox_r1.Left:=RBox_Opc.Left+RBox_Opc.Width-1;
  RBox_r1.Width:=7*NumRegisters.Exponent+1;
  RBox_r2.Left:=RBox_r1.Left+RBox_r1.Width-1;
  RBox_r2.Width:=RBox_r1.Width;
  RBox_r3.Left:=RBox_r2.Left+RBox_r2.Width-1;
  RBox_r3.Width:=RBox_r1.Width;
  RBox_r4.Left:=RBox_r3.Left+RBox_r3.Width-1;
  RBox_r4.Width:=RBox_r1.Width;
  RBox_r5.Left:=RBox_r4.Left+RBox_r4.Width-1;
  RBox_r5.Width:=RBox_r1.Width;
  RBox_r6.Left:=RBox_r5.Left+RBox_r5.Width-1;
  RBox_r6.Width:=RBox_r1.Width;
  IBox_Opc.Width:=RBox_Opc.Width;
  IBox_r1.Left:=RBox_r1.Left;
  IBox_r1.Width:=RBox_r1.Width;
  IBox_r2.Left:=RBox_r2.Left;
  IBox_r2.Width:=RBox_r1.Width;
  IBox_imm.Left:=RBox_r3.Left;
  IBox_imm.Width:=225-(IBox_imm.Left-248);
  JBox_Opc.Width:=RBox_Opc.Width;
  JBox_imm.Left:=RBox_r1.Left;
  JBox_imm.Width:=225-(JBox_imm.Left-248);
  RLab_Opc.Left:=RBox_Opc.Left;
  RLab_Opc.Width:=RBox_Opc.Width;
  RLab_r1.Left:=RBox_r1.Left;
  RLab_r1.Width:=RBox_r1.Width;
  RLab_r2.Left:=RBox_r2.Left;
  RLab_r2.Width:=RBox_r2.Width;
  RLab_r3.Left:=RBox_r3.Left;
  RLab_r3.Width:=RBox_r3.Width;
  RLab_r4.Left:=RBox_r4.Left;
  RLab_r4.Width:=RBox_r4.Width;
  RLab_r5.Left:=RBox_r5.Left;
  RLab_r5.Width:=RBox_r5.Width;
  RLab_r6.Left:=RBox_r6.Left;
  RLab_r6.Width:=RBox_r6.Width;
  ILab_Opc.Left:=RBox_Opc.Left;
  ILab_Opc.Width:=RBox_Opc.Width;
  ILab_r1.Left:=RBox_r1.Left;
  ILab_r1.Width:=RBox_r1.Width;
  ILab_r2.Left:=RBox_r2.Left;
  ILab_r2.Width:=RBox_r2.Width;
  ILab_imm.Left:=IBox_imm.Left;
  ILab_imm.Width:=IBox_imm.Width;
  JLab_Opc.Left:=JBox_Opc.Left;
  JLab_Opc.Width:=JBox_Opc.Width;
  JLab_imm.Left:=JBox_imm.Left;
  JLab_imm.Width:=JBox_imm.Width;
  RBox_r6.Visible:=(NumFormals>=6);
  RLab_r6.Visible:=(NumFormals>=6);
  RBox_r5.Visible:=(NumFormals>=5);
  RLab_r5.Visible:=(NumFormals>=5);
  RBox_r4.Visible:=(NumFormals>=4);
  RLab_r4.Visible:=(NumFormals>=4);
  case NumFormals of
    3: RBox_imm.Left:=RBox_r4.Left;
    4: RBox_imm.Left:=RBox_r5.Left;
    5: RBox_imm.Left:=RBox_r6.Left;
    6: RBox_imm.Left:=RBox_r6.Left+RBox_r6.Width-1
  end;
  RBox_imm.Width:=225-(RBox_imm.Left-248);
  for i:=2 to 5 do
  begin
    RAF[i].Enabled:=(NumFormals>i);
    RBF[i].Enabled:=(NumFormals>i);
    WF[i].Enabled:=(NumFormals>i);
    if NumFormals<=i then
    begin
      RAF[i].Checked:=false;
      RBF[i].Checked:=false;
      WF[i].Checked:=false
    end
  end;
  RRA.MaxValue:=NumFormals;
  if RRA.Value>NumFormals then
    RRA.Value:=NumFormals;
  RRB.MaxValue:=NumFormals;
  if RRB.Value>NumFormals then
    RRA.Value:=NumFormals;
  Grid.RowCount:=NumOpcodes.Value;
  for Opc:=0 to Grid.RowCount-1 do
    Grid.Cells[1,Opc+1]:=DropBox.Items[Ord(OpcodeType[Opc])];
  SetModify(Sender)
end;

procedure TConfigForm.FormResize(Sender: TObject);
begin
  Grid.Height:=ClientHeight-215;
  Notebook1.Height:=ClientHeight-21
end;

procedure TConfigForm.GridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Grid.Options:=Grid.Options+[goEditing];
  if Grid.Col=1 then
    Key:=0
end;

procedure TConfigForm.GridMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Grid.Options:=Grid.Options-[goEditing]
end;

procedure TConfigForm.GridSelectCell(Sender: TObject; Col, Row: Longint;
  var CanSelect: Boolean);
var
  p: Integer;
begin
  if Col=1 then
    ShowDropDown(Row)
  else
    DropBox.Visible:=false;
  if LastCol=0 then
  begin
    p:=1;
    Grid.Cells[0,LastRow]:=ReadIdentifier(Grid.Cells[0,LastRow],p)
  end;
  LastCol:=Col;
  LastRow:=Row;
end;

procedure TConfigForm.ShowDropDown(Row: Integer);
var
  T: Integer;
begin
  DropBox.ItemIndex:=Ord(OpcodeType[Row-1]);
  DropBox.Left:=Grid.CellRect(1,0).Left+Grid.Left;
  T:=Grid.CellRect(1,Row).Top;
  if (T+DropBox.Height>Grid.Height) or (Row>=Grid.TopRow+Grid.VisibleRowCount) then
    T:=Grid.Height-DropBox.Height;
  if (T<=Grid.DefaultRowHeight) or (Row<Grid.TopRow) then
    T:=Grid.DefaultRowHeight+1;
  DropBox.Top:=T+Grid.Top;
  DropBox.Width:=Grid.CellRect(1,0).Right-Grid.CellRect(1,0).Left+2;
  DropBox.Visible:=true
end;

procedure TConfigForm.DropBoxClick(Sender: TObject);
var
  Opc: Integer;
  t: TOpcodeType;
begin
  case DropBox.ItemIndex of
    1: t:=otI;
    2: t:=otJ
  else
    t:=otR
  end;
  if Grid.Selection.Top-1<Grid.Selection.Bottom-1 then
    for Opc:=Grid.Selection.Top-1 to Grid.Selection.Bottom-1 do
    begin
      OpcodeType[Opc]:=t;
      Grid.Cells[1,Opc+1]:=DropBox.Items[DropBox.ItemIndex]
    end
  else begin
    Opc:=LastRow-1;
    OpcodeType[Opc]:=t;
    Grid.Cells[1,Opc+1]:=DropBox.Items[DropBox.ItemIndex]
  end;
  DropBox.Visible:=false;
  SetModify(Sender)
end;

procedure TConfigForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Dummy: Boolean;
begin
  if (Key=VK_RETURN) and (NoteBook1.PageIndex=1) then
    GridSelectCell(Sender,LastCol,LastRow,Dummy)
end;

procedure TConfigForm.About1Click(Sender: TObject);
begin
  AboutBox
end;

procedure TConfigForm.HideForm1Click(Sender: TObject);
begin
  Close
end;

procedure TConfigForm.NewFile1Click(Sender: TObject);
begin
  if SaveFirst then
    ClearConfiguration
end;

function TConfigForm.SaveFirst: Boolean;
var
  Answer: Integer;
begin
  Result:=true;
  if SaveFile1.Enabled then
  begin
    Answer:=AppliMessage('Save changes to '+
           ExtractFileName(SaveDialog1.FileName)+'?','Confirm',$23);
    case Answer of
      6: begin
           SaveFile1Click(ConfigForm);
           Result:=not SaveFile1.Enabled
         end;
      7: { no -> Don't do anything but return true }
    else
      Result:=false
    end
  end
end;

procedure TConfigForm.ClearConfiguration;
var
  i: Integer;
begin
  for i:=0 to 255 do
    OpcodeType[i]:=otR;
  CompleteALU.Checked:=false;
  CompleteCompOps.ItemIndex:=1;
  CompleteExtend.ItemIndex:=1;
  CompleteMemOps.ItemIndex:=1;
  DmemSize.Value:=1024;
  ImemSize.Value:=512;
  NumOpcodes.Value:=64;
  NumRegisters.Value:=32;
  NumRegistersChange(ConfigForm);
  for i:=1 to Grid.RowCount do
  begin
    Grid.Cells[1,i]:=DropBox.Items[Ord(OpcodeType[i-1])];
    Grid.Cells[0,i]:='';
    Grid.Cells[2,i]:=''
  end;
  uCodeRows.Value:=256;
  NumConstBits.Value:=12;
  NumJumpTables.Value:=3;
  for i:=0 to 9 do
    TmpNames.Cells[0,i]:='';
  RRA.Value:=1;
  RRB.Value:=2;
  for i:=0 to 5 do
  begin
    RAF[i].Checked:=false;
    RAF[i].Checked:=false;
    WF[i].Checked:=false
  end;
  WF[0].Checked:=true;
  WF[2].Checked:=true;
  RAA.Checked:=false;
  RBA.Checked:=false;
  WA.Checked:=false;
  RegFileRead.ItemIndex:=0;
  UpdateConfiguration;
  SaveDialog1.FileName:='Untitled.ecf';
  SaveFile1.Enabled:=false;
  ShowCaption
end;

procedure TConfigForm.ShowCaption;
begin
  Caption:='Configuration - '+ExtractFileName(SaveDialog1.FileName)
end;

procedure TConfigForm.SaveFileAs1Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
    SaveFile
end;

procedure TConfigForm.SaveFile;
var
  i: Integer;
  t: string;
begin
  FileIO.UseFile(SaveDialog1.FileName);
  Rewrite(FileIO.F);
  Writeln(FileIO.F,'[General Options]');
  FileIO.WriteYesNo('AluDivAndMult',CompleteALU.Checked);
  FileIO.WriteYesNo('CompleteComparatorSet',CompleteCompOps.ItemIndex=1);
  FileIO.WriteYesNo('CompleteSignExtend',CompleteExtend.ItemIndex=1);
  FileIO.WriteYesNo('CompleteMemoryOperations',CompleteMemOps.ItemIndex=1);
  FileIO.WriteInteger('DataMemorySize',DmemSize.Value);
  FileIO.WriteInteger('CodeMemorySize',ImemSize.Value);
  Writeln(FileIO.F);
  Writeln(FileIO.F,'[Instruction Encoding]');
  FileIO.WriteInteger('NumberOfOpcodes',NumOpcodes.Value);
  FileIO.WriteInteger('NumberOfRegisters',NumRegisters.Value);
  Writeln(FileIO.F);
  Writeln(FileIO.F,'[Instructions]');
  Writeln(FileIO.F,';Opcode  |Type|Mnemonic Representation');
  for i:=1 to Grid.RowCount-1 do
  begin
    if Length(Grid.Cells[0,i])>0 then
    begin
      case OpcodeType[i-1] of
        otR: t:='R';
        otI: t:='I';
        otJ: t:='J'
      end;
      Writeln(FileIO.F,Format('%-9s| %s  |%s',[Grid.Cells[0,i],t,Grid.Cells[2,i]]))
    end
  end;
  Writeln(FileIO.F);
  Writeln(FileIO.F,'[Microprogrammed Architecture]');
  FileIO.WriteInteger('MicroCodeSize',uCodeRows.Value);
  FileIO.WriteInteger('ConstantSize',NumConstBits.Value);
  FileIO.WriteInteger('NumberOfJumpTables',NumJumpTables.Value);
  FileIO.WriteInteger('RRFormalA',RRA.Value);
  FileIO.WriteInteger('RRFormalB',RRB.Value);
  WriteSet('RAF',RAF);
  WriteSet('RBF',RBF);
  WriteSet('WF',WF);
  FileIO.WriteYesNo('RAA',RAA.Checked);
  FileIO.WriteYesNo('RBA',RBA.Checked);
  FileIO.WriteYesNo('WA',WA.Checked);
  Writeln(FileIO.F);
  Writeln(FileIO.F,'[Extra Registers]');
  for i:=0 to 9 do
    if Length(TmpNames.Cells[0,i])>0 then
      Writeln(FileIO.F,TmpNames.Cells[0,i]);
  Writeln(FileIO.F);
  Writeln(FileIO.F,'[Pipelined Architecture]');
  FileIO.WriteYesNo('BlindRegisterFileReading',RegFileRead.ItemIndex=0);
  FileIO.WriteYesNo('OnlyStallWhenNecessary',StallControl.ItemIndex=0);
  CloseFile(FileIO.F);
  SaveFile1.Enabled:=false;
  ShowCaption
end;

procedure TConfigForm.WriteSet(Item: string; Value: array of TCheckBox);
var
  i: Integer;
  First: Boolean;
begin
  First:=true;
  Write(FileIO.F,Item+'=[');
  for i:=Low(Value) to High(Value) do
    if Value[i].Checked then
    begin
      if First then
        First:=false
      else
        Write(FileIO.F,',');
      Write(FileIO.F,IntToStr(i+1))
    end;
  Writeln(FileIO.F,']')
end;

procedure TConfigForm.OpenFile1Click(Sender: TObject);
begin
  if SaveFirst and OpenDialog1.Execute then
    LoadFile
end;

procedure TConfigForm.LoadFile;
var
  i,p,Opc: Integer;
  L: string;
  Error: Boolean;
begin
  FileIO.UseFile(OpenDialog1.FileName);
  Reset(FileIO.F);
  Error:=false;
  CompleteALU.Checked:=FileIO.ReadYesNo('AluDivAndMult',Error);
  if FileIO.ReadYesNo('CompleteComparatorSet',Error) then
    CompleteCompOps.ItemIndex:=1
  else
    CompleteCompOps.ItemIndex:=0;
  if FileIO.ReadYesNo('CompleteSignExtend',Error) then
    CompleteExtend.ItemIndex:=1
  else
    CompleteExtend.ItemIndex:=0;
  if FileIO.ReadYesNo('CompleteMemoryOperations',Error) then
    CompleteMemOps.ItemIndex:=1
  else
    CompleteMemOps.ItemIndex:=0;
  DmemSize.Value:=FileIO.ReadInteger('DataMemorySize',Error);
  ImemSize.Value:=FileIO.ReadInteger('CodeMemorySize',Error);
  NumOpcodes.Value:=FileIO.ReadInteger('NumberOfOpcodes',Error);
  NumRegisters.Value:=FileIO.ReadInteger('NumberOfRegisters',Error);
  NumRegistersChange(ConfigForm);
  if FileIO.FindString('[Instructions]',L) then
  begin
    Opc:=0;
    repeat
      Readln(FileIO.F,L);
      p:=1;
      if EndLine(L,p) then
        break;
      SkipSpaces(L,p);
      if L[p]=';' then
        continue;
      Grid.Cells[0,Opc+1]:=ReadIdentifier(L,p);
      SkipPastPipe(L,p);
      SkipSpaces(L,P);
      if EndLine(L,p) then
      begin
        Error:=true;
        continue
      end;
      case L[p] of
        'R': OpcodeType[Opc]:=otR;
        'I': OpcodeType[Opc]:=otI;
        'J': OpcodeType[Opc]:=otJ
      end;
      SkipPastPipe(L,p);
      Grid.Cells[2,Opc+1]:=Copy(L,p,1000);
      Opc:=Opc+1
    until Opc>NumOpcodes.Value;
  end else
    Error:=true;
  uCodeRows.Value:=FileIO.ReadInteger('MicroCodeSize',Error);
  NumConstBits.Value:=FileIO.ReadInteger('ConstantSize',Error);
  NumJumpTables.Value:=FileIO.ReadInteger('NumberOfJumpTables',Error);
  RRA.Value:=FileIO.ReadInteger('RRFormalA',Error);
  RRB.Value:=FileIO.ReadInteger('RRFormalB',Error);
  ReadSet('RAF',RAF,Error);
  ReadSet('RBF',RBF,Error);
  ReadSet('WF',WF,Error);
  RAA.Checked:=FileIO.ReadYesNo('RAA',Error);
  RBA.Checked:=FileIO.ReadYesNo('RBA',Error);
  WA.Checked:=FileIO.ReadYesNo('WA',Error);
  i:=0;
  if FileIO.FindString('[Extra Registers]',L) then
    repeat
      Readln(FileIO.F,L);
      p:=1;
      if EndLine(L,p) then
        break;
      TmpNames.Cells[0,i]:=ReadIdentifier(L,p);
      i:=i+1
    until i>9
  else
    Error:=true;
  for i:=i to 9 do
    TmpNames.Cells[0,i]:='';
  for Opc:=0 to Grid.RowCount-1 do
    Grid.Cells[1,Opc+1]:=DropBox.Items[Ord(OpcodeType[Opc])];
  if FileIO.ReadYesNo('BlindRegisterFileReading',Error) then
    RegFileRead.ItemIndex:=0
  else
    RegFileRead.ItemIndex:=1;
  if FileIO.ReadYesNo('OnlyStallWhenNecessary',Error) then
    StallControl.ItemIndex:=0
  else
    StallControl.ItemIndex:=1;
  CloseFile(FileIO.F);
  SaveDialog1.FileName:=OpenDialog1.FileName;
  ShowCaption;
  SaveFile1.Enabled:=false;
  if Error then
  begin
    MainForm.WindowState:=wsMinimized;
    ConfigForm.Show;
    AppliMessage('File Format Corrupt; configuration may be incorrect','Warning',$40)
  end
end;

procedure TConfigForm.ReadSet(Item: string; Value: array of TCheckBox; var Error: Boolean);
var
  L: string;
  p,q: Integer;
begin
  for p:=Low(Value) to High(Value) do
    Value[p].Checked:=false;
  if FileIO.FindString(Item,L) then
  begin
    p:=Pos('=',L);
    q:=Pos('[',L);
    if (p>0) and (q>p) then
    begin
      q:=q+1;
      repeat
        SkipSpaces(L,q);
        if L[q]=',' then
        begin
          q:=q+1;
          SkipSpaces(L,q);
        end;
        if L[q]=']' then
          break;
        if EndLine(L,q) then
        begin
          Error:=true;
          break
        end;
        p:=ReadInt(L,q)-1;
        if (p>=0) and (p<NumFormals) then
          Value[p].Checked:=true;
      until false
    end else
      Error:=true
  end else
    Error:=true
end;

procedure TConfigForm.SetModify(Sender: TObject);
begin
  SaveFile1.Enabled:=true
end;

procedure TConfigForm.TmpNamesKeyPress(Sender: TObject; var Key: Char);
begin
  SetModify(Sender)
end;

procedure TConfigForm.SaveFile1Click(Sender: TObject);
begin
  if SaveDialog1.FileName='Untitled.ecf' then
    SaveFileAs1Click(Sender)
  else
    SaveFile
end;

procedure TConfigForm.GridKeyPress(Sender: TObject; var Key: Char);
begin
  SetModify(Sender)
end;

end.


