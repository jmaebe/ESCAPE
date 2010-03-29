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

unit BrkForm;

{$MODE Delphi}

interface

uses
  SysUtils,{WinTypes,WinProcs,}Messages,Classes,Graphics,Controls,Forms,Dialogs,
  StdCtrls,Compos,Menus,ExtCtrls,LResources,Config,Common,NewStr;

const
  NumBreakPoints = 10; { Must be even! }

type
  { This is the breakpoints form used for both simulators }
  TBreakForm = class(TForm)
    Organisational: TGroupBox;
    RegisterFile: TGroupBox;
    PopupMenu1: TPopupMenu;
    MainMenu1: TMainMenu;
    View1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Base1: TMenuItem;
    UnsignedHexadecimal1: TMenuItem;
    UnsignedDecimal1: TMenuItem;
    SignedDecimal1: TMenuItem;
    UnsignedHexadecimal2: TMenuItem;
    UnsignedDecimal2: TMenuItem;
    SignedDecimal2: TMenuItem;
    HideForm1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    HideForm2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure UnsignedHexadecimal1Click(Sender: TObject);
    procedure UnsignedDecimal1Click(Sender: TObject);
    procedure SignedDecimal1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ExitValues(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure HideForm1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
  private
    Base: Integer;
    Edit: array [0..NumBreakPoints-1] of TEdit;
    procedure ShowValue(i: Integer);
    procedure UpdateBaseMenu;
  public
    CheckBox: array [0..NumBreakPoints-1] of TCheckBox;
    ORBox: array [0..NumBreakPoints div 2-1] of TComboBox;
    RFReg: array [0..NumBreakPoints div 2-1] of TEditInteger;
    Value: array [0..NumBreakPoints-1] of LongInt;
    procedure UpdateAllValues;
  end;

var
  BreakForm: TBreakForm;

implementation

{$R *.lfm}

procedure TBreakForm.FormCreate(Sender: TObject);
var
  Box: TComboBox;
  Lab: TLabel;
  Int: TEditInteger;
  Pan: TPanel;
  Chk: TCheckBox;
  Val: TEdit;
  i, RegWidth: Integer;
begin
  { Create array of breakpoint boxes }
  case ConfigForm.NumRegisters.Exponent of
    0..2: RegWidth:=1;
    3..6: RegWidth:=2
  else
    RegWidth:=3
  end;
  RegWidth:=RegWidth*MSSansSerif8Width+6;
  for i:=0 to NumBreakPoints div 2-1 do
  begin
    Pan:=TPanel.Create(Organisational);
    with Pan do
    begin
      Left:=16;
      Top:=24+40*i;
      Height:=32
    end;
    Organisational.InsertControl(Pan);
    Chk:=TCheckBox.Create(Pan);
    CheckBox[i]:=Chk;
    with Chk do
    begin
      Left:=8;
      Top:=4;
      Width:=17;
      Height:=25;
    end;
    Pan.InsertControl(Chk);
    Box:=TComboBox.Create(Pan);
    ORBox[i]:=Box;
    with Box do
    begin
      Left:=32;
      Top:=5;
      Width:=73;
      Height:=21;
      Style:=csDropDownList;
      ItemHeight:=13
    end;
    Pan.InsertControl(Box);
    Lab:=TLabel.Create(Pan);
    with Lab do
    begin
      Left:=112;
      Top:=8;
      Caption:='=';
      ParentFont:=False;
      Font.Height:=-13;
      Font.Name:='System';
      Font.Style:=[fsBold]
    end;
    Pan.InsertControl(Lab);
    Val:=TEdit.Create(Pan);
    Edit[i]:=Val;
    with Val do
    begin
      Left:=128;
      Top:=6;
      Width:=MSSansSerif8Width*11+6;
      Height:=20;
      OnExit:=ExitValues
    end;
    Pan.InsertControl(Val);
    Pan.Width:=Val.Left+Val.Width+8;
    Organisational.Width:=Pan.Width+32;
    RegisterFile.Left:=Pan.Width+56;
    Pan:=TPanel.Create(RegisterFile);
    with Pan do
    begin
      Left:=16;
      Top:=24+40*i;
      Height:=32
    end;
    RegisterFile.InsertControl(Pan);
    Chk:=TCheckBox.Create(Pan);
    CheckBox[i+NumBreakPoints div 2]:=Chk;
    with Chk do
    begin
      Left:=8;
      Top:=4;
      Width:=17;
      Height:=25;
    end;
    Pan.InsertControl(Chk);
    Lab:=TLabel.Create(Pan);
    with Lab do
    begin
      Left:=32;
      Top:=8;
      Caption:='R';
      Font.Height:=-13;
      Font.Name:='System';
      Font.Style:=[fsBold];
      ParentFont:=False
    end;
    Pan.InsertControl(Lab);
    Int:=TEditInteger.Create(Pan);
    RFReg[i]:=Int;
    with Int do
    begin
      Left:=48;
      Top:=6;
      Width:=RegWidth;
      Height:=20;
      MinValue:=0;
      MaxValue:=ConfigForm.NumRegisters.Value-1;
      Value:=i+1
    end;
    Pan.InsertControl(Int);
    Lab:=TLabel.Create(Pan);
    with Lab do
    begin
      Left:=Int.Left+32;
      Top:=8;
      Caption:='=';
      ParentFont:=False;
      Font.Height:=-13;
      Font.Name:='System';
      Font.Style:=[fsBold]
    end;
    Pan.InsertControl(Lab);
    Val:=TEdit.Create(Pan);
    Edit[i+NumBreakPoints div 2]:=Val;
    with Val do
    begin
      Left:=Int.Left+48;
      Top:=6;
      Width:=MSSansSerif8Width*11+6;
      Height:=20;
      OnExit:=ExitValues
    end;
    Pan.InsertControl(Val);
    Pan.Width:=Val.Left+Val.Width+8;
    RegisterFile.Width:=Pan.Width+32;
    Value[i]:=0;
    Value[i+NumBreakPoints div 2]:=0
  end;
  Organisational.Height:=24+NumBreakPoints*20;
  RegisterFile.Height:=24+NumBreakPoints*20;
  ClientWidth:=RegisterFile.Left+RegisterFile.Width+8;
  ClientHeight:=RegisterFile.Top+RegisterFile.Height+8;
  Base:=0;
  UpdateBaseMenu
end;

procedure TBreakForm.UnsignedHexadecimal1Click(Sender: TObject);
begin
  Base:=0;
  UpdateBaseMenu
end;

procedure TBreakForm.UnsignedDecimal1Click(Sender: TObject);
begin
  Base:=1;
  UpdateBaseMenu
end;

procedure TBreakForm.SignedDecimal1Click(Sender: TObject);
begin
  Base:=2;
  UpdateBaseMenu
end;

procedure TBreakForm.UpdateBaseMenu;
var
  i: Integer;
begin
   UnsignedHexadecimal1.checked:=(Base=0);
   UnsignedDecimal1.checked:=(Base=1);
   SignedDecimal1.checked:=(Base=2);
   UnsignedHexadecimal2.checked:=(Base=0);
   UnsignedDecimal2.checked:=(Base=1);
   SignedDecimal2.checked:=(Base=2);
   for i:=0 to NumBreakPoints-1 do
     ShowValue(i)
end;

procedure TBreakForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caHide
end;

procedure TBreakForm.ExitValues(Sender: TObject);
var
  i,e: Integer;
begin
  e:=-1;
  for i:=0 to NumBreakPoints-1 do
  begin
    if Sender=Edit[i] then
    begin
      e:=i;
      break
    end
  end;
  if e=-1 then
    raise Exception.Create('No match for Sender in TBreakForm.ExitValues');
  i:=1;
  Value[e]:=ReadInt(Edit[e].Text,i);
  ShowValue(e)
end;

procedure TBreakForm.UpdateAllValues;
var
  i,p: Integer;
begin
  for i:=0 to NumBreakPoints-1 do
  begin
    p:=1;
    Value[i]:=ReadInt(Edit[i].Text,p)
  end
end;

procedure TBreakForm.ShowValue(i: Integer);
begin
  if Base=0 then
    Edit[i].Text:='0x'+IntToHex(Value[i],8)
  else
    Edit[i].Text:=NewIntToStr(Value[i],0,Base)
end;

procedure TBreakForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_RETURN then
    ActiveControl:=Organisational;
end;

procedure TBreakForm.HideForm1Click(Sender: TObject);
begin
  Hide
end;

procedure TBreakForm.About1Click(Sender: TObject);
begin
  AboutBox
end;

end.
