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

unit PipeDef;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Common, Grids, Compos, Menus, Config, ExtCtrls, StdCtrls;

type
  TMetaFormal = (foA,foB,foC);
  TResource = (reCmp,reALU,reMem);

  { Pipeline functionality form }
  TPipeCode = class(TForm)
    Grid: TNewStringGrid;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    HideForm1: TMenuItem;
    N1: TMenuItem;
    SaveFileAs1: TMenuItem;
    SaveFile1: TMenuItem;
    OpenFile1: TMenuItem;
    NewFile1: TMenuItem;
    Edit1: TMenuItem;
    DropdownMode1: TMenuItem;
    N2: TMenuItem;
    Fill1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Status1: TPanel;
    Status2: TPanel;
    Status3: TPanel;
    PopupMenu1: TPopupMenu;
    Fill2: TMenuItem;
    N3: TMenuItem;
    DropdownMode2: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GridDrawCell(Sender: TObject; Col, Row: Longint;
      Rect: TRect; State: TGridDrawState);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GridSelectCell(Sender: TObject; Col, Row: Longint;
      var CanSelect: Boolean);
    procedure DropdownMode1Click(Sender: TObject);
    procedure GridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Fill1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DropDownClick(Sender: TObject);
    procedure HideForm1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure NewFile1Click(Sender: TObject);
    procedure OpenFile1Click(Sender: TObject);
    procedure SaveFile1Click(Sender: TObject);
    procedure SaveFileAs1Click(Sender: TObject);
    procedure GridKeyPress(Sender: TObject; var Key: Char);
  private
    LastDropDownField: Integer;
    DropBoxes: array[0..8] of TListBox;
    PCode: array [0..255,0..8] of Integer;
    CompleteExtend: Boolean;
    CompleteCompOps: Boolean;
    CompleteMemOps: Boolean;
    procedure SetUseDropDown(Value: Boolean);
    function EnterField(Opcode,Field: Integer; S: string): Boolean;
    procedure DisplayField(Opcode,Field: Integer);
    procedure InitializeDropBoxes;
    procedure ShowDropDown(Row,Col: Integer);
    procedure SaveFile;
    procedure ShowCaption;
    function SaveFirst: Boolean;
    procedure SetModify;
  public
    LastCol: Integer;
    LastRow: Integer;
    procedure LoadFile;
    function SaveFileClick: Boolean;
    procedure ClearPipeCode;
    function Formal(Index: Integer; Register: TMetaFormal): Integer;
    function ExtendSize(Index: Integer): Integer;
    function Func(Index: Integer; Resource: TResource): Integer;
    function SSource(Index,S: Integer): Integer; {1 when formal A/B}
  end;

var
  PipeCode: TPipeCode;

implementation

uses
  Pipe;

{$R *.DFM}

function TPipeCode.Formal(Index: Integer; Register: TMetaFormal): Integer;
begin
  Result:=PCode[Index,Ord(Register)];
end;

function TPipeCode.SSource(Index,S: Integer): Integer;
begin
  if PCode[Index,2+S]<2 then
    Result:=1
  else
    Result:=0
end;

function TPipeCode.ExtendSize(Index: Integer): Integer;
begin
  Result:=PCode[Index,5];
  if (Result=1) and (not CompleteExtend) then
    Result:=3;
  Result:=4 shl Result
end;

function TPipeCode.Func(Index: Integer; Resource: TResource): Integer;
begin
  case Resource of
    reAlu: Result:=PCode[Index,6];
    reCmp: begin
             Result:=PCode[Index,7];
             if (not CompleteCompOps) and (Result=3) then
                 Result:=4
           end
    else {reMem:}
    begin
      Result:=PCode[Index,8];
      if not CompleteMemOps then
        Result:=Result*3;
      if Result>0 then
        Result:=Result+3;
      if Result>6 then
        Result:=Result+1
    end
  end
end;

procedure TPipeCode.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caHide
end;

procedure TPipeCode.GridDrawCell(Sender: TObject; Col,
  Row: Longint; Rect: TRect; State: TGridDrawState);
var
  Cap: string;
begin
  if gdFixed in State then
  begin
    if Row=0 then
    begin
      Grid.Canvas.Brush.Color:=clBtnFace;
      Grid.Canvas.FillRect(Rect);
      Grid.Canvas.Pen.Color:=clWhite;
      Grid.Canvas.MoveTo(Rect.Left,Rect.Bottom);
      Grid.Canvas.LineTo(Rect.Left,Rect.Top);
      Grid.Canvas.LineTo(Rect.Right,Rect.Top);
      Grid.Canvas.Pen.Color:=clBlack
    end else
      Grid.Canvas.Pen.Color:=clBtnFace;
    Grid.Canvas.MoveTo(Rect.Right,Rect.Top);
    Grid.Canvas.LineTo(Rect.Right,Rect.Bottom);
    Grid.Canvas.LineTo(Rect.Left,Rect.Bottom);
  end;
  if Row=0 then
  begin
    case Col of
       0: Cap:='Opcode';
       1: Cap:='A Formal';
       2: Cap:='B Formal';
       3: Cap:='C Formal';
       4: Cap:='IR extend';
       5: Cap:='S1';
       6: Cap:='S2';
       7: Cap:='ALU';
       8: Cap:='Comp';
       9: Cap:='Mem'
    end;
    Grid.Canvas.TextRect(Rect,Rect.Left+2,Rect.Top+2,Cap)
  end
end;

procedure TPipeCode.FormResize(Sender: TObject);
var
  i: Integer;
begin
  Grid.Width:=ClientWidth;
  Grid.Height:=ClientHeight-20;
  for i:=0 to 8 do
    Grid.ColWidths[i]:=(Grid.ClientWidth*(i+1)) div 10-Grid.CellRect(i,0).Left;
  Grid.ColWidths[9]:=Grid.ClientWidth-Grid.CellRect(9,0).Left-1;
  Status3.Width:=Width-248;
  Status1.Top:=ClientHeight-17;
  Status2.Top:=ClientHeight-17;
  Status3.Top:=ClientHeight-17
end;

procedure TPipeCode.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  Grid.DefaultRowHeight:=MSSansSerif8Height+2;
  Grid.RowCount:=ConfigForm.NumOpcodes.Value+1;
  for i:=1 to Grid.RowCount do
    Grid.Cells[0,i]:=Encoding.Opcode(i-1);
  Grid.Cells[0,0]:='Opcode';
  Grid.Cells[1,0]:='A Formal';
  Grid.Cells[2,0]:='B Formal';
  Grid.Cells[3,0]:='C Formal';
  Grid.Cells[4,0]:='S1';
  Grid.Cells[5,0]:='S2';
  Grid.Cells[6,0]:='IR extend';
  Grid.Cells[7,0]:='ALU';
  Grid.Cells[8,0]:='Comp';
  Grid.Cells[9,0]:='Mem';
  CompleteExtend:=(ConfigForm.CompleteExtend.ItemIndex=1);
  CompleteCompOps:=(ConfigForm.CompleteCompOps.ItemIndex=1);
  CompleteMemOps:=(ConfigForm.CompleteMemOps.ItemIndex=1);
  InitializeDropBoxes;
  LastDropDownField:=0;
  SetUseDropDown(true);
  Status2.Caption:='';
  Status3.Caption:='';
  ClearPipeCode
end;

procedure TPipeCode.InitializeDropBoxes;
var
  i,j,up: Integer;
  DropBox: TListBox;
begin
  for i:=0 to 8 do
  begin
    DropBox:=TListBox.Create(PipeCode);
    with DropBox do
    begin
      Font.Height:=-11;
      Font.Name:='MS Sans Serif';
      Font.Style:=[];
      ItemHeight:=13;
      ParentFont:=False;
      Visible:=False;
      OnClick:=DropDownClick
    end;
    PipeCode.InsertControl(DropBox);
    DropBoxes[i]:=DropBox;
    DropBox.Items.Add('');
    case i of
      0..2: begin
              for j:=1 to 3 do
                DropBox.Items.Add(IntToStr(j))
            end;
         3: begin
              DropBox.Items.Add('A');
              DropBox.Items.Add('PC1')
            end;
         4: begin
              DropBox.Items.Add('B');
              DropBox.Items.Add('IR')
            end;
         5: begin
              if CompleteExtend then
              begin
                DropBox.Items.Add('Byte');
                DropBox.Items.Add('Half')
              end;
              DropBox.Items.Add('Word')
            end;
         6: begin
              if ConfigForm.CompleteALU.Checked then
                up:=DIVI
              else
                up:=S2S1;
              for j:=ADD to up do
                DropBox.Items.Add(AluOperation[j]);
            end;
         7: begin
              if CompleteCompOps then
                for j:=ONE to GE do
                  DropBox.Items.Add(CompOperation2[j])
              else begin
                DropBox.Items.Add(CompOperation2[ONE]);
                DropBox.Items.Add(CompOperation2[EQ]);
                DropBox.Items.Add(CompOperation2[LT])
              end
            end;
         8: begin
              if CompleteMemOps then
              begin
                DropBox.Items.Add('RB');
                DropBox.Items.Add('RH')
              end;
              DropBox.Items.Add('RW');
              if CompleteMemOps then
              begin
                DropBox.Items.Add('WB');
                DropBox.Items.Add('WH')
              end;
              DropBox.Items.Add('WW')
            end
    end;
    DropBox.Height:=DropBox.ItemHeight*DropBox.Items.Count+5
  end
end;

procedure TPipeCode.GridSelectCell(Sender: TObject; Col, Row: Longint;
  var CanSelect: Boolean);
var
  MinCol: Integer;
begin
  MinCol:=(1-ConfigForm.RegFileRead.ItemIndex)*2;
  DropBoxes[LastDropDownField].Visible:=false;
  if DropDownMode1.Checked and (Col>MinCol) then
    ShowDropDown(Row,Col);
  if LastCol>MinCol then
  begin
    if EnterField(LastRow-1,LastCol-1,Grid.Cells[LastCol,LastRow]) then
      Status3.Caption:='Invalid value for this field'
    else
      Status3.Caption:='';
    DisplayField(LastRow-1,LastCol-1)
  end;
  if Col<=MinCol then
    CanSelect:=false
  else begin
    LastCol:=Col;
    LastRow:=Row
  end
end;

procedure TPipeCode.ShowDropDown(Row,Col: Integer);
var
  T: Integer;
  DropBox: TListBox;
begin
  LastDropDownField:=Col-1;
  DropBox:=DropBoxes[LastDropDownField];
  DropBox.ItemIndex:=PCode[Row-1,LastDropDownField];
  DropBox.Left:=Grid.CellRect(Col,0).Left;
  T:=Grid.CellRect(Col,Row).Top;
  if (T+DropBox.Height>Grid.Height) or (Row>=Grid.TopRow+Grid.VisibleRowCount) then
    T:=Grid.Height-DropBox.Height;
  if (T<=Grid.DefaultRowHeight) or (Row<Grid.TopRow) then
    T:=Grid.DefaultRowHeight+1;
  DropBox.Top:=T;
  DropBox.Width:=Grid.CellRect(Col,0).Right-Grid.CellRect(Col,0).Left+2;
  DropBox.Visible:=true
end;

procedure TPipeCode.SetUseDropDown(Value: Boolean);
begin
  DropBoxes[LastDropDownField].Visible:=false;
  DropdownMode1.Checked:=Value;
  DropdownMode2.Checked:=Value;
  if DropDownMode1.Checked then
    Status1.Caption:='Dropdown Mode'
  else
    Status1.Caption:='Edit Mode';
  Grid.EditorMode:=not Value
end;

procedure TPipeCode.DropdownMode1Click(Sender: TObject);
begin
  SetUseDropDown(not DropdownMode1.Checked)
end;

procedure TPipeCode.GridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Grid.Options:=Grid.Options+[goEditing]
end;

procedure TPipeCode.GridMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Grid.Options:=Grid.Options-[goEditing]
end;

function TPipeCode.EnterField(Opcode,Field: Integer; S: string): Boolean;
var
  p,b: Integer;
begin
  Result:=false;
  p:=1;
  b:=DropBoxes[Field].Items.IndexOf(ReadIdentifier(S,p));
  if b<0 then
    Result:=true
  else
    PCode[Opcode,Field]:=b
end;

procedure TPipeCode.DisplayField(Opcode,Field: Integer);
begin
  Grid.Cells[Field+1,Opcode+1]:=DropBoxes[Field].Items[PCode[Opcode,Field]]
end;

procedure TPipeCode.Fill1Click(Sender: TObject);
begin
  if Grid.Col>0 then
    ShowDropDown(Grid.Row,Grid.Col);
  SetModify
end;

procedure TPipeCode.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Dummy: Boolean;
begin
  if Key=VK_RETURN then
    GridSelectCell(Sender,LastCol,LastRow,Dummy);
end;

procedure TPipeCode.DropDownClick(Sender: TObject);
var
  Opc: Integer;
  DropBox: TListBox;
begin
  DropBox:=DropBoxes[LastDropDownField];
  if (not DropDownMode1.Checked) or
     (Grid.Selection.Top-1<>Grid.Selection.Bottom-1) then
    for Opc:=Grid.Selection.Top-1 to Grid.Selection.Bottom-1 do
    begin
      PCode[Opc,LastDropDownField]:=DropBox.ItemIndex;
      DisplayField(Opc,LastDropDownField)
    end
  else begin
    Opc:=LastRow-1;
    PCode[Opc,LastDropDownField]:=DropBox.ItemIndex;
    DisplayField(Opc,LastDropDownField)
  end;
  DropBox.Visible:=false;
  SetModify
end;

procedure TPipeCode.HideForm1Click(Sender: TObject);
begin
  Hide
end;

procedure TPipeCode.About1Click(Sender: TObject);
begin
  AboutBox
end;

procedure TPipeCode.NewFile1Click(Sender: TObject);
begin
  if SaveFirst then
    ClearPipeCode
end;

procedure TPipeCode.OpenFile1Click(Sender: TObject);
begin
  if SaveFirst and OpenDialog1.Execute then
    LoadFile
end;

procedure TPipeCode.SaveFile1Click(Sender: TObject);
begin
  SaveFileClick
end;

procedure TPipeCode.SaveFileAs1Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
    SaveFile
end;

procedure TPipeCode.ClearPipeCode;
var
  i,j: Integer;
begin
  for i:=0 to 8 do
    for j:=0 to ConfigForm.NumOpcodes.Value-1 do
    begin
      if (ConfigForm.RegFileRead.ItemIndex=0) and (i<=1) and (Length(Grid.Cells[0,j+1])>0) then
        PCode[j,i]:=i+1
      else
        PCode[j,i]:=0;
      DisplayField(j,i)
    end;
  SaveDialog1.FileName:='Untitled.pfu';
  SaveFile1.Enabled:=false;
  ShowCaption
end;

procedure TPipeCode.LoadFile;
var
  i,p,Opc: Integer;
  L: string;
  Error: Boolean;
begin
  FileIO.UseFile(OpenDialog1.FileName);
  Reset(FileIO.F);
  Error:=false;
  ClearPipecode;
  if FileIO.FindString('[Pipeline Functionality]',L) then
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
      for i:=0 to Grid.ColCount-2 do
      begin
        SkipPastPipe(L,p);
        if (ConfigForm.RegFileRead.ItemIndex=0) and (i<=1) then
          PCode[Opc,i]:=i+1
        else if EnterField(Opc,i,ReadUntilPipe(L,p)) then
          Error:=true;
        DisplayField(Opc,i)
      end
    until false;
  end else
    Error:=true;
  CloseFile(FileIO.F);
  SaveDialog1.FileName:=OpenDialog1.FileName;
  ShowCaption;
  if Error then
    AppliMessage('File Format Corrupt; functionality may be incorrect','Warning',$40);
  SaveFile1.Enabled:=false
end;

function TPipeCode.SaveFirst: Boolean;
var
  Answer: Integer;
begin
  Result:=true;
  if SaveFile1.Enabled then
  begin
    Answer:=AppliMessage('Save changes to '+
           ExtractFileName(SaveDialog1.FileName)+'?','Pipeline Functionality - Confirm',$23);
    case Answer of
      6: begin
           SaveFile1Click(PipeCode);
           Result:=not SaveFile1.Enabled
         end;
      7: { no -> Don't do anything but return true }
    else
      Result:=false
    end
  end
end;

procedure TPipeCode.SaveFile;
var
  i,j: Integer;
begin
  FileIO.UseFile(SaveDialog1.FileName);
  Rewrite(FileIO.F);
  Writeln(FileIO.F,'[Pipeline Functionality]');
  Writeln(FileIO.F,';Opcode|A Formal|B Formal|C Formal|IR ext  |S1      |S2      |ALU     |Comp    |Mem');
  for i:=1 to Grid.RowCount-1 do
    if Length(Grid.Cells[0,i])>0 then
    begin
      Write(FileIO.F,Format('%-7s',[Grid.Cells[0,i]]));
      for j:=1 to Grid.ColCount-1 do
        Write(FileIO.F,Format('|%-8s',[Grid.Cells[j,i]]));
      Writeln(FileIO.F)
    end;
  Writeln(FileIO.F);
  CloseFile(FileIO.F);
  SaveFile1.Enabled:=false;
  ShowCaption
end;

function TPipeCode.SaveFileClick: Boolean;
begin
  if SaveDialog1.FileName='Untitled.pfu' then
    SaveFileAs1Click(PipeCode)
  else
    SaveFile;
  Result:=not SaveFile1.Enabled
end;

procedure TPipeCode.SetModify;
begin
  SaveFile1.Enabled:=true;
  PipeForm.SetModify
end;

procedure TPipeCode.ShowCaption;
begin
  Caption:='Pipeline Functionality - '+ExtractFileName(SaveDialog1.FileName)
end;

procedure TPipeCode.GridKeyPress(Sender: TObject; var Key: Char);
begin
  SetModify
end;

end.
