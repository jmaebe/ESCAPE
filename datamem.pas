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

unit DataMem;

{$MODE Delphi}

interface

uses
  SysUtils, {WinTypes, WinProcs,} Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids, StdCtrls, ExtCtrls, Menus,LResources, Common, NewStr,
  lcltype;

type
  { Data memory form }
  TDmemForm = class(TForm)
    MainMenu1: TMainMenu;
    Edit1: TMenuItem;
    GroupSize1: TMenuItem;
    Byte1: TMenuItem;
    Half1: TMenuItem;
    Word1: TMenuItem;
    SelectAll1: TMenuItem;
    Grid: TStringGrid;
    Clear1: TMenuItem;
    Random1: TMenuItem;
    Fill1: TMenuItem;
    View1: TMenuItem;
    PopupMenu1: TPopupMenu;
    SelectAll2: TMenuItem;
    Clear2: TMenuItem;
    Random2: TMenuItem;
    Fill2: TMenuItem;
    Size1: TMenuItem;
    Word2: TMenuItem;
    Half2: TMenuItem;
    Byte2: TMenuItem;
    Base2: TMenuItem;
    SignedDecimal2: TMenuItem;
    UnsignedDecimal2: TMenuItem;
    UnsignedHexadecimal2: TMenuItem;
    N1: TMenuItem;
    Help2: TMenuItem;
    About1: TMenuItem;
    Base1: TMenuItem;
    SignedDecimal1: TMenuItem;
    UnsignedDecimal1: TMenuItem;
    UnsignedHexadecimal1: TMenuItem;
    File1: TMenuItem;
    HideForm1: TMenuItem;
    N2: TMenuItem;
    SaveFileAs1: TMenuItem;
    SaveFile1: TMenuItem;
    OpenFile1: TMenuItem;
    NewFile1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure GridDblClick(Sender: TObject);
    procedure GridEditingDone(Sender: TObject);
    procedure UnsignedHexadecimal1Click(Sender: TObject);
    procedure Byte1Click(Sender: TObject);
    procedure Half1Click(Sender: TObject);
    procedure Word1Click(Sender: TObject);
    procedure UnsignedDecimal1Click(Sender: TObject);
    procedure SignedDecimal1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SelectAll1Click(Sender: TObject);
    procedure GridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GridSelectCell(Sender: TObject; Col, Row: Longint;
      var CanSelect: Boolean);
    procedure About1Click(Sender: TObject);
    procedure OpenFile1Click(Sender: TObject);
    procedure SaveFile1Click(Sender: TObject);
    procedure SaveFileAs1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure Random1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure GridMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Fill1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure HideForm1Click(Sender: TObject);
    procedure NewFile1Click(Sender: TObject);
    procedure GridKeyPress(Sender: TObject; var Key: Char);
  private
    GoodWidth: Integer;
    IncrementalWidth: Integer;
    CellWidth: Integer;
    FixedWidth: Integer;
    GroupSize: Integer;
    Base: Integer;
    LastRow: Integer;
    LastCol: Integer;
    procedure UpdateGroupSizeMenu;
    procedure AdjustSize;
    procedure UpdateBaseMenu;
    procedure CalculateGridSize;
    procedure UpdateGrid;
    procedure UpdateSelection;
    procedure FillRegion(Value: LongInt);
    procedure ShowCaption;
    function SaveFirst: Boolean;
    procedure SaveFile;
  public
    procedure SetModify;
    procedure LoadFile;
    function SaveFileClick: Boolean;
    procedure ClearMemory;
    procedure ShowAll;
    procedure ShowRegion(BeginRegion, EndRegion: LongInt);
    procedure ShowSingleAddress(Address: LongInt);
  end;

var
  DmemForm: TDmemForm;

implementation

uses Config, Micro, Pipe;

{$R *.lfm}

procedure TDmemForm.Byte1Click(Sender: TObject);
begin
  GroupSize:=0;
  UpdateGroupSizeMenu
end;

procedure TDmemForm.Half1Click(Sender: TObject);
begin
  GroupSize:=1;
  UpdateGroupSizeMenu
end;

procedure TDmemForm.Word1Click(Sender: TObject);
begin
  GroupSize:=2;
  UpdateGroupSizeMenu
end;

procedure TDmemForm.UpdateGroupSizeMenu;
begin
  Word1.checked:=(GroupSize=2);
  Half1.checked:=(GroupSize=1);
  Byte1.checked:=(GroupSize=0);
  Word2.checked:=(GroupSize=2);
  Half2.checked:=(GroupSize=1);
  Byte2.checked:=(GroupSize=0);
  AdjustSize
end;

procedure TDmemForm.UnsignedHexadecimal1Click(Sender: TObject);
begin
  Base:=0;
  UpdateBaseMenu
end;

procedure TDmemForm.GridEditingDone(Sender: TObject);
begin
  Grid.Options:=Grid.Options-[goEditing];
end;

procedure TDmemForm.GridDblClick(Sender: TObject);
begin
  Grid.Options:=Grid.Options+[goEditing]
end;

procedure TDmemForm.UnsignedDecimal1Click(Sender: TObject);
begin
  Base:=1;
  UpdateBaseMenu
end;

procedure TDmemForm.SignedDecimal1Click(Sender: TObject);
begin
  Base:=2;
  UpdateBaseMenu
end;

procedure TDmemForm.UpdateBaseMenu;
begin
   UnsignedHexadecimal1.checked:=(Base=0);
   UnsignedDecimal1.checked:=(Base=1);
   SignedDecimal1.checked:=(Base=2);
   UnsignedHexadecimal2.checked:=(Base=0);
   UnsignedDecimal2.checked:=(Base=1);
   SignedDecimal2.checked:=(Base=2);
   AdjustSize
end;

procedure TDmemForm.CalculateGridSize;
var
  col_count: Integer;
  row_count: LongInt;
  col_text_width,
  fixed_text_width: Integer;
  str: String;
  i: Integer;
begin
  if Base=0 then
  begin
    FixedWidth:=(ConfigForm.DmemSize.Exponent+3) div 4 +2;
    CellWidth:=2 shl GroupSize +1;
  end else
  begin
    FixedWidth:=(ConfigForm.DmemSize.Exponent+6) div 4 +2;
    CellWidth:=4;
    if GroupSize>0 then
      CellWidth:=GroupSize*5+1;
    if Base=2 then
      CellWidth:=CellWidth+1;
  end;

  SetLength(str,CellWidth);
  for i:=1 to length(str) do
    str[i]:='0';
  col_text_width:=Grid.Canvas.TextWidth(str);
  SetLength(str,FixedWidth);
  for i:=CellWidth+1 to length(str) do
    str[i]:='0';
  fixed_text_width:=Grid.Canvas.TextWidth(str);

  col_count:=((Grid.ClientWidth-1) - fixed_text_width) div col_text_width;
  row_count:=(ConfigForm.DmemSize.Value-1) div (col_count*(1 shl GroupSize))+1;
  Grid.ColCount:=col_count+1;
  Grid.RowCount:=row_count;
  Grid.DefaultColWidth:=col_text_width;
  Grid.ColWidths[0]:=fixed_text_width;
//  Grid.ColWidths[col_count]:=(2*CellWidth-1)*Courier9Width div 2;
  Grid.DefaultRowHeight:=Courier9Height+2;
  GoodWidth:=(col_count*col_text_width+fixed_text_width)+1+Width-Grid.ClientWidth;
  IncrementalWidth:=col_text_width;
end;

procedure TDmemForm.UpdateGrid;
var
  FormatString: string;
  row: LongInt;
begin
  FormatString:='%'+IntToStr(FixedWidth-2)+'d';
  for row:=0 to Grid.RowCount-1 do
    if base = 0 then
      Grid.Cells[0,row]:=IntToHex(row*(Grid.ColCount-1)*(1 shl GroupSize),FixedWidth-2)+':'
    else
      Grid.Cells[0,row]:=Format(FormatString,[row*(Grid.ColCount-1)*(1 shl GroupSize)])+':';
  ShowAll
end;

procedure TDmemForm.AdjustSize;
begin
  CalculateGridSize;
  if Width-GoodWidth > IncrementalWidth div 3 then
    Width:=GoodWidth+IncrementalWidth
  else if Width<>GoodWidth then
    Width:=GoodWidth;
  UpdateGrid
end;

procedure TDmemForm.FormCreate(Sender: TObject);
begin
  LastCol:=1;
  LastRow:=0;
  Word1Click(Sender);
  UnsignedHexadecimal1Click(Sender);
  ClearMemory
end;

procedure TDmemForm.ShowAll;
var
  Address: LongInt;
  col: Integer;
begin
  for col:=1 to Grid.ColCount-1 do
    Grid.cells[col,Grid.RowCount-1]:=''; {Clear the last row}
  Address:=0;
  while Address<ConfigForm.DmemSize.Value do
  begin
    ShowSingleAddress(Address);
    Address:=Address+ (1 shl GroupSize);
  end
end;

procedure TDmemForm.ShowRegion(BeginRegion, EndRegion: LongInt);
var
  Address: LongInt;
begin
  Address:=BeginRegion;
  while Address<=EndRegion do
  begin
    ShowSingleAddress(Address);
    Address:=Address+ (1 shl GroupSize);
  end
end;

procedure TDmemForm.ShowSingleAddress(Address: LongInt);
var
  col: Integer;
  row, number: LongInt;
begin
  row:=(Address div (1 shl GroupSize)) div (Grid.ColCount-1);
  Col:=(Address div (1 shl GroupSize)) mod (Grid.ColCount-1)+1;
  number:=DataMemory.Read(Address,GroupSize);
  case GroupSize of
    0: if (Base=2) and ((number and $80)<>0) then
           number:=number-$100;
    1: if (Base=2) and ((number and $8000)<>0) then
           number:=number-$10000
  end;
  Grid.Cells[col,row]:=NewIntToStr(number,CellWidth-1,Base);
end;

procedure TDmemForm.SelectAll1Click(Sender: TObject);
var
  SRect: TGridRect;
begin
  SRect.Top:=0;
  SRect.Bottom:=Grid.RowCount;
  SRect.Left:=1;
  SRect.Right:=Grid.ColCount-1;
  Grid.Selection:=SRect
end;

procedure TDmemForm.GridMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//  Grid.Options:=Grid.Options-[goEditing];
end;

procedure TDmemForm.GridSelectCell(Sender: TObject; Col, Row: Longint;
  var CanSelect: Boolean);
  var Address,NewValue: LongInt;
begin
  if (LastCol>0) and (LastCol<=Grid.ColCount-1) and (LastRow>=0)
      and (LastRow<=Grid.RowCount-1) then
  begin
    Address:=(LastRow*(Grid.ColCount-1)+LastCol-1)*(1 shl GroupSize);
    if (Address<0) or (Address>=ConfigForm.DmemSize.Value) then
      Grid.Cells[LastCol,LastRow]:=''
    else begin
      NewValue:=NewStrToInt(Grid.Cells[LastCol,LastRow],Base,GroupSize);
      if DataMemory.Read(Address,GroupSize)<>NewValue then
      begin
        DataMemory.Write(Address,NewValue,GroupSize);
        DataMemory.ChangedValue(Address)
      end else
      ShowSingleAddress(Address)
    end
  end;
  LastCol:=Col;
  LastRow:=Row
end;

procedure TDmemForm.About1Click(Sender: TObject);
begin
  AboutBox
end;

procedure TDmemForm.OpenFile1Click(Sender: TObject);
begin
  if SaveFirst and OpenDialog1.Execute then
    LoadFile
end;

procedure TDmemForm.SaveFile1Click(Sender: TObject);
begin
  SaveFileClick
end;

function TDmemForm.SaveFileClick: Boolean;
begin
  if SaveDialog1.FileName='Untitled.dat' then
    SaveFileAs1Click(DmemForm)
  else
    SaveFile;
  Result:=not SaveFile1.Enabled
end;

procedure TDmemForm.SaveFileAs1Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
    SaveFile
end;

procedure TDmemForm.Clear1Click(Sender: TObject);
begin
  FillRegion(0);
  SetModify
end;

procedure TDmemForm.FillRegion(Value: LongInt);
  var Col: Integer;
  var Address, Row: LongInt;
begin
  for row:=Grid.Selection.Top to Grid.Selection.Bottom do
    for col:=Grid.Selection.Left to Grid.Selection.Right do
    begin
      Address:=(Row*(Grid.ColCount-1)+Col-1)*(1 shl GroupSize);
      if (Address>=0) and (Address<ConfigForm.DmemSize.Value) then
        DataMemory.Write(Address,Value,GroupSize)
      else
        break
    end;
  UpdateSelection;
end;

procedure TDmemForm.UpdateSelection;
var
  BeginRegion, EndRegion, Row: LongInt;
begin
  if (Grid.Selection.Left<>1) or (Grid.Selection.Right<>Grid.ColCount-1) then
    for Row:=Grid.Selection.Top to Grid.Selection.Bottom do
    begin
      Beginregion:=(Row*(Grid.ColCount-1)+Grid.Selection.Left-1)*(1 shl GroupSize);
      Endregion:=(Row*(Grid.ColCount-1)+Grid.Selection.Right-1)*(1 shl GroupSize);
      if EndRegion>=ConfigForm.DmemSize.Value then
        EndRegion:=ConfigForm.DmemSize.Value-(1 shl GroupSize);
      if BeginRegion<ConfigForm.DmemSize.Value then
        DataMemory.ChangedRegion(BeginRegion,EndRegion)
    end
  else begin
    Beginregion:=Grid.Selection.Top*(Grid.ColCount-1)*(1 shl GroupSize);
    Endregion:=((Grid.Selection.Bottom+1)*(Grid.ColCount-1)-1)*(1 shl GroupSize);
    if EndRegion>=ConfigForm.DmemSize.Value then
      EndRegion:=ConfigForm.DmemSize.Value-(1 shl GroupSize);
    if BeginRegion<ConfigForm.DmemSize.Value then
      DataMemory.ChangedRegion(BeginRegion,EndRegion)
  end
end;

procedure TDmemForm.Random1Click(Sender: TObject);
  var Col: Integer;
  var Address, Row, Value: LongInt;
begin
  for row:=Grid.Selection.Top to Grid.Selection.Bottom do
    for col:=Grid.Selection.Left to Grid.Selection.Right do
    begin
      Address:=(Row*(Grid.ColCount-1)+Col-1)*(1 shl GroupSize);
      Value:=RandomLongInt;
      if GroupSize<2 then
        Value:=Value and ($100 shl (8*GroupSize) -1);
      if (Address>=0) and (Address<ConfigForm.DmemSize.Value) then
        DataMemory.Write(Address,Value,GroupSize)
      else
        break
    end;
  UpdateSelection;
  SetModify
end;

procedure TDmemForm.FormResize(Sender: TObject);
begin
  if Width<300 then
    Width:=300;
  if Height<200 then
    Height:=200;
  CalculateGridSize;
  UpdateGrid
end;

procedure TDmemForm.GridMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if Width<>GoodWidth then
    Width:=GoodWidth
end;

procedure TDmemForm.Fill1Click(Sender: TObject);
var
  val: string;
begin
  val:='00000000';
  if InputQuery('Fill Region','Enter fill value:',val) then
    FillRegion(NewStrToInt(val,Base,GroupSize));
  SetModify
end;

procedure TDmemForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Dummy: Boolean;
begin
//  Grid.Options:=Grid.Options+[goEditing];
  case Key of
    VK_RETURN: GridSelectCell(Sender,LastCol,LastRow,Dummy);
    VK_DELETE: if (Grid.Selection.Left<Grid.Selection.Right) or
                  (Grid.Selection.Top<Grid.Selection.Bottom) then
               begin
                 Clear1Click(Sender);
                 Key:=0
               end
  end
end;

procedure TDmemForm.GridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Grid.Options:=Grid.Options+[goEditing]
end;

procedure TDmemForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caHide
end;

procedure TDmemForm.ShowCaption;
begin
  Caption:=DataCaptionBase+' - '+ExtractFileName(SaveDialog1.FileName)
end;

procedure TDmemForm.HideForm1Click(Sender: TObject);
begin
  Hide
end;

procedure TDmemForm.ClearMemory;
  var i: Integer;
begin
  for i:=0 to (ConfigForm.DmemSize.Value div 4)-1 do
    DataMemory.Write(i*4,0,2);
  SaveDialog1.FileName:='Untitled.dat';
  SaveFile1.Enabled:=false;
  ShowCaption
end;

procedure TDmemForm.LoadFile;
var
  p: Integer;
  Number, Address: LongInt;
  L: string;
  Error: Boolean;
begin
  FileIO.UseFile(OpenDialog1.FileName);
  Reset(FileIO.F);
  Error:=false;
  ClearMemory;
  GroupSize:=FileIO.ReadInteger('Size',Error);
  Base:=FileIO.ReadInteger('Base',Error);
  UpdateGroupSizeMenu;
  UpdateBaseMenu;
  if FileIO.FindString('[Data Memory Content]',L) then
  begin
    repeat
      Readln(FileIO.F,L);
      p:=1;
      SkipSpaces(L,p);
      if EndLine(L,p) then
        break;
      if L[p]=';' then
        continue;
      Address:=NewStrToInt(ReadIdentifier(L,p),Base,2);
      if (Address<0) or (Address>=ConfigForm.DmemSize.Value) then
      begin
        Error:=true;
        break
      end;
      SkipSpaces(L,p);
      if L[p]<>':' then
      begin
        Error:=true;
        break;
      end;
      p:=p+1;
      repeat
        SkipSpaces(L,p);
        if EndLine(L,p) then
          break;
        if Base=0 then
          Number:=NewStrToInt(ReadIdentifier(L,p), 0,GroupSize)
        else
          Number:=ReadInt(L,p);
        DataMemory.Write(Address,Number,GroupSize);
        Address:=Address+(1 shl GroupSize)
      until Address>=ConfigForm.DmemSize.Value;
    until false;
    DataMemory.ChangedAll;
  end else
    Error:=true;
  CloseFile(FileIO.F);
  SaveDialog1.FileName:=OpenDialog1.FileName;
  ShowCaption;
  if Error then
    AppliMessage('File Format Corrupt; memory content may be incorrect','Warning',$40);
  SaveFile1.Enabled:=false
end;

procedure TDmemForm.SaveFile;
var
  FormatString,S: string;
  Address, number: LongInt;
  i: Integer;
begin
  FileIO.UseFile(SaveDialog1.FileName);
  Rewrite(FileIO.F);
  Writeln(FileIO.F,'[Data Memory]');
  FileIO.WriteInteger('Size',GroupSize);
  FileIO.WriteInteger('Base',Base);
  Writeln(FileIO.F);
  Writeln(FileIO.F,'[Data Memory Content]');
  Address:=0;
  FormatString:='%'+IntToStr(FixedWidth-2)+'d';
  while(Address<ConfigForm.DmemSize.Value) do
  begin
    if base = 0 then
      S:=IntToHex(Address,FixedWidth-2)
    else
      S:=Format(FormatString,[Address]);
    Write(FileIO.F,S+': ');
    for i:=0 to 7 do
    begin
      number:=DataMemory.Read(Address,GroupSize);
      case GroupSize of
        0: if (Base=2) and ((number and $80)<>0) then
             number:=number-$100;
        1: if (Base=2) and ((number and $8000)<>0) then
             number:=number-$10000
      end;
      Write(FileIO.F,' '+NewIntToStr(number,CellWidth-1,Base)+' ');
      Address:=Address+(1 shl GroupSize);
      if Address>=ConfigForm.DmemSize.Value then
        break;
    end;
    Writeln(FileIO.F);
  end;
  CloseFile(FileIO.F);
  SaveFile1.Enabled:=false;
  ShowCaption
end;

procedure TDmemForm.NewFile1Click(Sender: TObject);
begin
  if SaveFirst then
  begin
    ClearMemory;
    DataMemory.ChangedAll
  end
end;

function TDmemForm.SaveFirst: Boolean;
var
  Answer: Integer;
begin
  Result:=true;
  if SaveFile1.Enabled then
  begin
    Answer:=AppliMessage('Save changes to '+
           ExtractFileName(SaveDialog1.FileName)+'?','Data Memory - Confirm',$23);
    case Answer of
      6: begin
           SaveFile1Click(DmemForm);
           Result:=not SaveFile1.Enabled
         end;
      7: { no -> Don't do anything but return true }
    else
      Result:=false
    end
  end
end;

procedure TDmemForm.GridKeyPress(Sender: TObject; var Key: Char);
begin
  SetModify
end;

procedure TDmemForm.SetModify;
begin
  SaveFile1.Enabled:=true;
  SetModifyOnSimForm
end;

end.
