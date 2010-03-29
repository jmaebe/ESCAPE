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

unit Micro;

{$MODE Delphi}

interface

uses
  SysUtils, {WinTypes, WinProcs,} Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls, Compos, Common, Menus, Config,
  InstrMem, DataMem, BrkForm, MicroCod, Spin, LResources;

type
  { This is the main form for the microprogrammed architecture simulator }
  TMicroForm = class(TForm)
    MainMenu1: TMainMenu;
    Control: TGroupBox;
    Simulate1: TMenuItem;
    View1: TMenuItem;
    Datapath: TGroupBox;
    LineBox1: TLineBox;
    LineBox3: TLineBox;
    GenTrace: TMenuItem;
    RewindCheck: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    InstructionView1: TMenuItem;
    DataMemory1: TMenuItem;
    Microcode1: TMenuItem;
    File1: TMenuItem;
    Exit2: TMenuItem;
    N6: TMenuItem;
    N8: TMenuItem;
    SaveProjectAs1: TMenuItem;
    SaveProject1: TMenuItem;
    OpenProject1: TMenuItem;
    NewProject1: TMenuItem;
    SetTraceFile1: TMenuItem;
    BreakPoints1: TMenuItem;
    PopupMenu1: TPopupMenu;
    InstructionMemory1: TMenuItem;
    DataMemory2: TMenuItem;
    Microcode2: TMenuItem;
    BreakPoints2: TMenuItem;
    N1: TMenuItem;
    GenTrace2: TMenuItem;
    RewindCheck2: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    SaveDialog2: TSaveDialog;
    N2: TMenuItem;
    MemoryAccessTime1: TMenuItem;
    MemoryAccessTime2: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Label17: TLabel;
    Label18: TLabel;
    ResetButton: TButton;
    MultiCycleCheck: TCheckBox;
    Clock: TEditInteger;
    ClockButton: TButton;
    RewindButton: TButton;
    LineBox2: TLineBox;
    S1: TBusBox;
    S2: TBusBox;
    ALU: TAluBox;
    ALULabel: TLabel;
    ALabel: TLabel;
    BLabel: TLabel;
    A: TRegBox;
    B: TRegBox;
    RegFile: TRegFileBox;
    CLabel: TLabel;
    C: TRegBox;
    PC: TRegBox;
    PCLabel: TLabel;
    MARLabel: TLabel;
    MAR: TRegBox;
    MDR: TRegBox;
    MDRLabel: TLabel;
    MARMux: TMuxBox;
    MDRMux: TMuxBox;
    IRLabel: TLabel;
    IR: TRegBox;
    RES: TBusBox;
    uARMux: TMuxBox;
    uAR: TRegBox;
    uARLabel2: TLabel;
    uARLabel1: TLabel;
    Incr: TComparatorBox;
    IncrLabel: TLabel;
    uCodeLabel: TLabel;
    JumpLabel: TLabel;
    MemLabel1: TLabel;
    MemLabel2: TLabel;
    WireValue: TMemo;
    MultiCycle: TSpinEdit;
    uCode: TShape3D;
    Jump: TShape3D;
    Mem: TShape3D;
    SignExtend: TShape3D;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ClockButtonClick(Sender: TObject);
    procedure ResetButtonClick(Sender: TObject);
    procedure RewindButtonClick(Sender: TObject);
    procedure RewindCheckClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ClockExit(Sender: TObject);
    procedure InstructionView1Click(Sender: TObject);
    procedure DataMemory1Click(Sender: TObject);
    procedure Microcode1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure BreakPoints1Click(Sender: TObject);
    procedure GenTraceClick(Sender: TObject);
    procedure Exit2Click(Sender: TObject);
    procedure NewProject1Click(Sender: TObject);
    procedure OpenProject1Click(Sender: TObject);
    procedure SaveProject1Click(Sender: TObject);
    procedure SaveProjectAs1Click(Sender: TObject);
    procedure SetTraceFile1Click(Sender: TObject);
    procedure MemoryAccessTime1Click(Sender: TObject);
    procedure LineBox2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LineBox2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LineBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LineBox3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Checks if files need to be saved first -- returns true when it's okay to exit }
    function SaveFirst: Boolean;
    { Update the name in the titlebar after a change of filename }
    procedure ShowCaption;
    { Load a new project using OpenDialog1.FileName }
    procedure LoadProject;
    { Save the project using SaveDialog1.FileName }
    procedure SaveProject;
    { Clear the current project and set the filename to Untitled.mpr }
    procedure ClearProject;
    { Disables the 'Trace' menu when no valid tracefile is set }
    procedure DisableTrace;
  public
    MemAccessTime: Integer;
    NumTemps: Integer;
    { Extra registers are added at run-time }
    Tmp: array [0..9] of TRegBox;
    TmpLabel: array [0..9] of TLabel;
    { Show the pop-up box with the value of the driver the user clicked on }
    procedure ShowWireValue(X,Y: Integer; Source: TDataSource);
    { Enables the 'Save' menu indicating one of the files needs to be updated }
    procedure SetModify;
  end;

  { These combinational and sequential blocks are only used in the microprgrammed
    simulator -- Check out the files in Common.pas first }

  { 1 when input >=0; 0 when input <0 }
  TRegReadEnable = class(TCombiSource)
  private
    Reg: TDataSource;
  public
    procedure Connect(Inputs: array of TDataSource); override;
    function GetValue: LongInt; override;
  end;

  { 1 when the register on the result bus should be enabled, 0 otherwise }
  TResultBusEnable = class(TCombiSource)
  private
    uCodeDest: TDataSource;
    Index: Integer;
  public
    procedure SetIndex(Ind: Integer);
    procedure Connect(Inputs: array of TDataSource); override;
    function GetValue: LongInt; override;
  end;

  { 1 when the MDR should be enabled, 0 otherwise }
  TMDREnable = class(TCombiSource)
  private
    uCodeDest: TDataSource;
    uCodeMemFunc: TDataSource;
    uCodeMemDest: TDataSource;
  public
    procedure Connect(Inputs: array of TDataSource); override;
    function GetValue: LongInt; override;
  end;

  { 1 when the IR should be enabled, 0 otherwise }
  TIREnable = class(TCombiSource)
  private
    uCodeMemFunc: TDataSource;
    uCodeMemDest: TDataSource;
  public
    procedure Connect(Inputs: array of TDataSource); override;
    function GetValue: LongInt; override;
  end;

  { Returns the number of the jump table (1-4) in case of a uAR jump }
  TJumpTable = class(TCombiSource)
  private
    uAR: TDataSource;
  public
    procedure Connect(Inputs: array of TDataSource); override;
    function GetValue: LongInt; override;
  end;

  { uAR value looked up in jump table }
  TJump = class(TCombiSource)
  private
    Table: TDataSource;
    IR: TDataSource;
  public
    procedure Connect(Inputs: array of TDataSource); override;
    function GetValue: LongInt; override;
  end;

  { Value of various uCode fields indexed by uAR }
  TuCode = class(TCombiSource)
  private
    Field: TuCodeField;
    uAR: TDataSource;
  public
    procedure SetField(Val: TuCodeField);
    procedure Connect(Inputs: array of TDataSource); override;
    function GetValue: LongInt; override;
  end;

  { Actual to be read from or written to the register file}
  TRegFileRegister = class(TCombiSource)
  private
    Reg: Integer;
    uAR: TDataSource;
    IR: TDataSource;
  public
    procedure SetRegister(Val: Integer);
    procedure Connect(Inputs: array of TDataSource); override;
    function GetValue: LongInt; override;
  end;

  { uAR mux select }
  TuARMuxSelect = class(TCombiSource)
  private
    uAR: TDataSource;
    ALU: TDataSource;
    MBusy: TDataSource;
  public
    procedure Connect(Inputs: array of TDataSource); override;
    function GetValue: LongInt; override;
  end;

  { This is the main simulator module for the microprogrammed architecture }
  TMSimulator = class(TSimulator)
  public
    uAR: TReg;
    A: TReg;
    B: TReg;
    C: TReg;
    MAR: TReg;
    MDR: TReg;
    IR: TRegIR;
    TMP: array [0..9] of TReg;
    uARMux: TMux;
    MDRMux: TMux;
    MARMux: TMux;
    S1: TMux;
    S2: TMux;
    RegFileBis: TRegFileBis;
    ALU: TAlu;
    Mem: TRWMem;
    MemBusy: TRWMemBusy;
    MemAddress: TRWMemAddress;
    Incr: TIncrementor;
    SignExtend: TSignExtend;
    uAREn: TConstant;
    AEn: TRegReadEnable;
    BEn: TRegReadEnable;
    CEn: TResultBusEnable;
    PCEn: TResultBusEnable;
    MAREn: TResultBusEnable;
    MDREn: TMDREnable;
    IREn: TIREnable;
    TMPEn: array [0..9] of TResultBusEnable;
    uCodeDest: TuCode;
    uCodeAdr: TuCode;
    uCodeMemAdr: TuCode;
    uCodeMemDest: TuCode;
    uCodeALU: TuCode;
    uCodeS1: TuCode;
    uCodeS2: TuCode;
    uCodeConst: TuCode;
    uCodeMem: TuCode;
    uCodeIRSize: TuCode;
    JumpTable: TJumpTable;
    Jump: TJump;
    uARMuxSelect: TuARMuxSelect;
    RegFileReadA: TRegFileRegister;
    RegFileReadB: TRegFileRegister;
    RegFileWrite: TRegFileRegister;
    Void: TConstant;
    constructor Create(RwndBtn: TButton; RwndChk: TMenuItem; GenTrace: TMenuItem;
      MltCyc: TSpinEdit; MltCycChk: TCheckBox; Clk: TEditInteger;
      ChkStab: Boolean); override;
    destructor Destroy; override;
    procedure Evaluate; override;
    procedure Propagate; override;
    procedure Reset; override;
    procedure Simulate(Clocks: LongInt); override;
    procedure Rewind(Clocks: LongInt); override;
  end;

var
  MicroForm: TMicroForm;
  MSimulator: TMSimulator;

implementation

uses
  Main;

{$R *.lfm}

procedure TMicroForm.FormCreate(Sender: TObject);
var
  W,i: Integer;
begin
  { Size Registers }
  W:=Courier9Width*8+6;
  uAR.Width:=W;
  A.Width:=W;
  B.Width:=W;
  C.Width:=W;
  PC.Width:=W;
  MAR.Width:=W;
  MDR.Width:=W;
  { Add extra registers }
  NumTemps:=ConfigForm.NumTemps;
  for i:=0 to NumTemps-1 do
  begin
    Tmp[i]:=TRegBox.Create(LineBox2);
    with Tmp[i] do
    begin
      Width:=W;
      Font.Color:=clBlack;
      Font.Height:=-12;
      Font.Name:='Courier New';
      Font.Style:=[];
      ParentFont:=False;
      ReadOnly:=True
    end;
    LineBox2.InsertControl(Tmp[i]);
    TmpLabel[i]:=TLabel.Create(LineBox2);
    with TmpLabel[i] do
    begin
      Alignment:=taRightJustify;
      Caption:=ConfigForm.TmpNames.Cells[0,i];
      Font.Color:=clBlack;
      Font.Height:=-11;
      Font.Name:='Microsoft Sans Serif';
      Font.Style:=[fsBold];
      ParentFont:=False
    end;
    LineBox2.InsertControl(TmpLabel[i])
  end;
  { Set defaults }
  RewindCheck.Checked:=true;
  RewindCheck2.Checked:=true;
  GenTrace.Checked:=false;
  GenTrace2.Checked:=false;
  { Generate microcode form }
  Application.CreateForm(TMicroCode, MicroCode);
  MicroCode.Hide;
  { Create simulator (this will generate Imem, Dmem and Breakpoint forms }
  MSimulator:=TMSimulator.Create(RewindButton, RewindCheck, GenTrace, MultiCycle,
                                 MultiCycleCheck, Clock, true);
  DisableTrace;
  TraceDialog:=SaveDialog2;
  ClearProject;
  FormResize(Sender)
end;

procedure TMicroForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if SaveFirst then {okay to exit}
  begin
    { Destroy simulator -> destroys Imem, Dmem and Breakpoint forms }
    MSimulator.Destroy;
    MicroCode.Destroy;
    MSimulator:=nil; { To make sure the registerfile won't get redrawn after MSimulator is destroyed }
    Action:=caFree;
    MainForm.Show
  end else
    Action:=caNone
end;

procedure TMicroForm.FormResize(Sender: TObject);
var
  W,X,Y,i: Integer;
begin
  { Size Datapath Panel }
  Datapath.Height:=ClientHeight;
  Y:=340+NumTemps*32;
  if Y<392 then
    Y:=392;
  if ClientHeight<Y then
  begin
    VertScrollBar.Visible:=true;
    Datapath.Height:=Y
  end else
    VertScrollBar.Visible:=false;
  Datapath.Width:=ClientWidth-240;
  if Datapath.Width<357 then
    Datapath.Width:=357;
  LineBox3.Height:=Datapath.Height-20;
  { Size Register File }
  RegFile.Height:=Datapath.Height-NumTemps*32-340+124;
  RegFile.Width:=15*Courier9Width+Datapath.Width-355;
  { Show Register File }
  if MSimulator<>nil then
    MSimulator.RegFile.Show(-1);
  { Size and Position Objects }
  C.Left:=RegFile.Left+RegFile.Width+20;
  X:=RegFile.Left+(RegFile.Width-Courier9Width*8+5) div 2;
  for i:=0 to NumTemps-1 do
  begin
    Tmp[i].Top:=RegFile.Top+RegFile.Height+32*i+12;
    Tmp[i].Left:=X;
  end;
  PC.Left:=X;
  PC.Top:=RegFile.Top+RegFile.Height+32*NumTemps+12;
  MAR.Left:=X;
  MAR.Top:=PC.Top+32;
  MDR.Left:=X;
  MDR.Top:=MAR.Top+32;
  IR.Top:=MDR.Top+32;
  IR.Width:=Datapath.Width-152;
  SignExtend.Top:=IR.Top+1;
  MDRMux.Left:=Datapath.Width-49;
  MDRMux.Top:=MDR.Top-1;
  MARMux.Left:=MAR.Left div 2+10;
  MARMux.Top:=(PC.Top+MAR.Top) div 2 -1;
  S1.Height:=IR.Top+21;
  S2.Height:=S1.Height;
  RES.Left:=Datapath.Width-21;
  RES.Height:=MDR.Top+10;
  Mem.Top:=Datapath.Height-141;
  { Size and Position Panel }
  if ClientHeight>289 then
    W:=(ClientHeight-289) div 2
  else
    W:=0;
  Panel1.Left:=Datapath.Left+Datapath.Width+6;
  Panel1.Height:=ClientHeight-7;
  Panel2.Top:=W;
  { Position Labels }
  CLabel.Top:=C.Top-5;
  CLabel.Left:=C.Left-CLabel.Width-3;
  for i:=0 to NumTemps-1 do
  begin
    TmpLabel[i].Top:=Tmp[i].Top-5;
    TmpLabel[i].Left:=Tmp[i].Left-TmpLabel[i].Width-3
  end;
  PCLabel.Top:=PC.Top-5;
  PCLabel.Left:=PC.Left-PCLabel.Width-3;
  MARLabel.Top:=MAR.Top-5;
  MARLabel.Left:=MAR.Left-MARLabel.Width-3;
  MDRLabel.Top:=MDR.Top-5;
  MDRLabel.Left:=MDR.Left-MDRLabel.Width-3;
  IRLabel.Top:=IR.Top-5;
  IRLabel.Left:=IR.Left-IRLabel.Width-3;
  MemLabel1.Top:=Mem.Top+20;
  MemLabel2.Top:=Mem.Top+48;
  ALULabel.Left:=ALU.Left+24;
  ALULabel.Top:=ALU.Top+ALU.Height-14;
  { Draw Lines }
  LineBox1.ClearWires;
  LineBox2.ClearWires;
  LineBox3.ClearWires;
  X:=uARMux.Left+1;
  if MSimulator<>nil then
  begin
    LineBox1.AddWire(MSimulator.Incr,false,Point(X,uARMux.Position[0]),false,
      [Incr.Top+31,Incr.Left]);
    LineBox1.AddWire(MSimulator.Jump,false,Point(X,uARMux.Position[1]),true,
      [8,Jump.Top+25,Jump.Left]);
    LineBox1.AddWire(MSimulator.uCodeAdr,false,Point(X,uARMux.Position[2]),false,[uCode.Top+25,uCode.Left]);
    X:=uCode.Left+uCode.Width+10;
    LineBox1.AddWire(MSimulator.uAR,false,Point(uCode.Left+uCode.Width,uCode.Top+10),true,
      [X,uAR.Top+10,uAR.Left+uAR.Width]);
    LineBox1.AddWire(MSimulator.uAR,true,Point(X,uAR.Top+10),false,
      [Incr.Top+31,Incr.Left+Incr.Width]);
    LineBox1.AddWire(MSimulator.uARMux,false,Point(uARMux.Left+uARMux.Width,uAR.Top+10),true,[uAR.Left]);
    LineBox1.AddWire(MSimulator.uCodeConst,false,Point(uCode.Left+80,uCode.Top+35),true,[Control.Width]);
    LineBox1.AddWire(MSimulator.IR,false,Point(Jump.Left+80,Jump.Top+25),true,[122,Control.Height]);
    LineBox1.AddWire(MSimulator.JumpTable,false,Point(uCode.Left+40,uCode.Top+49),false,[Jump.Top]);
    LineBox2.AddWire(MSimulator.S1,false,Point(S1.Left+5,ALU.Top+17),true,[ALU.Left]);
    LineBox2.AddWire(MSimulator.S2,false,Point(S2.Left+5,ALU.Top+67),true,[ALU.Left]);
    LineBox2.AddWire(MSimulator.ALU,false,Point(ALU.Left+42,ALU.Top+42),true,[RES.Left+5]);
    LineBox2.AddWire(MSimulator.A,false,Point(S1.Left+5,A.Top+10),true,[A.Left]);
    LineBox2.AddWire(MSimulator.B,false,Point(S2.Left+5,B.Top+10),true,[B.Left]);
    W:=Courier9Width*8+5;
    LineBox2.AddWire(MSimulator.RegFile,false,Point(A.Left+W,A.Top+10),true,[RegFile.Left]);
    LineBox2.AddWire(MSimulator.RegFileBis,false,Point(B.Left+W,B.Top+10),true,[RegFile.Left]);
    LineBox2.AddWire(MSimulator.ALU,false,Point(C.Left+W,C.Top+10),true,[RES.Left+5]);
    LineBox2.AddWire(MSimulator.C,false,Point(RegFile.Left+RegFile.Width,C.Top+10),true,[C.Left]);
    for i:=0 to NumTemps-1 do
    begin
      LineBox2.AddWire(MSimulator.Tmp[i],false,Point(S1.Left+5,Tmp[i].Top+10),true,[Tmp[i].Left]);
      LineBox2.AddWire(MSimulator.ALU,false,Point(Tmp[i].Left+W,Tmp[i].Top+10),true,[RES.Left+5])
    end;
    LineBox2.AddWire(MSimulator.PC,false,Point(S1.Left+5,PC.Top+10),true,[PC.Left]);
    LineBox2.AddWire(MSimulator.ALU,false,Point(PC.Left+W,PC.Top+10),true,[RES.Left+5]);
    LineBox2.AddWire(MSimulator.MAR,false,Point(S1.Left+5,MAR.Top+10),true,[MAR.Left]);
    LineBox2.AddWire(MSimulator.ALU,false,Point(MAR.Left+W,MAR.Top+10),true,[RES.Left+5]);
    LineBox2.AddWire(MSimulator.MDR,false,Point(0,MDR.Top+10),true,[MDR.Left]);
    LineBox2.AddWire(MSimulator.MDRMux,false,Point(MDR.Left+W,MDR.Top+10),true,[MDRMux.Left]);
    LineBox2.AddWire(MSimulator.ALU,false,Point(MDRMux.Left+13,MDRMux.Position[0]),true,[RES.Left+5]);
    LineBox2.AddWire(MSimulator.SignExtend,false,Point(S1.Left+5,IR.Top+10),true,[SignExtend.Left+1]);
    LineBox2.AddWire(MSimulator.IR,false,Point(SignExtend.Left+17,IR.Top+10),true,[IR.Left]);
    LineBox2.AddWire(MSimulator.IR,true,Point((SignExtend.Left+17+IRLabel.Left)div 2,IR.Top+10),false,
      [IR.Top-6,0]);
    LineBox2.AddWire(MSimulator.Mem,false,Point(IR.Left+W,IR.Top+10),true,
      [RES.Left+5,MDRMux.Position[1],MDRMux.Left+13]);
    LineBox2.AddWire(MSimulator.Mem,true,Point(RES.Left+5,IR.Top+10),false,
      [IR.Top+32,0]);
    LineBox2.AddWire(MSimulator.PC,true,Point(MARMux.Left+22,PC.Top+10),false,
      [MARMux.Position[0],MARMux.Left+12]);
    LineBox2.AddWire(MSimulator.MAR,true,Point(MARMux.Left+22,MAR.Top+10),false,
      [MARMux.Position[1],MARMux.Left+12]);
    LineBox2.AddWire(MSimulator.MARMux,false,Point(MARMux.Left,MARMux.Top+10),true,[0]);
    LineBox2.AddWire(MSimulator.uCodeConst,false,Point(0,uCode.Top+35),true,[S2.Left+5]);
    LineBox3.AddWire(MSimulator.uCodeConst,false,Point(130,uCode.Top+35),true,[140]);
    LineBox3.AddWire(MSimulator.IR,false,Point(124,Control.Height-18),false,[IR.Top-6,140]);
    LineBox3.AddWire(MSimulator.MARMux,false,Point(112,MARMux.Top+10),true,[140]);
    LineBox3.AddWire(MSimulator.MDR,false,Point(112,MDR.Top+10),true,[140]);
    LineBox3.AddWire(MSimulator.Mem,false,Point(72,Mem.Top+69),false,[IR.Top+32,140]);
  end;
  { Set Bus Terminals }
  S1.Inputs:=7+NumTemps;
  S2.Inputs:=7+NumTemps;
  RES.Inputs:=5+NumTemps;
  S1.Terminal[0]:=BusTerminal(ALU.Top+17,btConnect);
  S2.Terminal[0]:=BusTerminal(ALU.Top+67,btConnect);
  RES.Terminal[0]:=BusTerminal(ALU.Top+42,btConnect);
  S1.Terminal[1]:=BusTerminal(A.Top+10,btRight);
  S2.Terminal[1]:=BusTerminal(B.Top+10,btRight);
  RES.Terminal[1]:=BusTerminal(C.Top+10,btConnect);
  S1.Terminal[2]:=BusTerminal(uCode.Top+35,btBoth);
  S2.Terminal[2]:=BusTerminal(uCode.Top+35,btLeft);
  S1.Terminal[3]:=BusTerminal(PC.Top+10,btRight);
  S2.Terminal[3]:=BusTerminal(PC.Top+10,btBoth);
  RES.Terminal[2]:=BusTerminal(PC.Top+10,btConnect);
  S1.Terminal[4]:=BusTerminal(MAR.Top+10,btRight);
  S2.Terminal[4]:=BusTerminal(MAR.Top+10,btBoth);
  RES.Terminal[3]:=BusTerminal(MAR.Top+10,btConnect);
  S1.Terminal[5]:=BusTerminal(MDR.Top+10,btBoth);
  S2.Terminal[5]:=BusTerminal(MDR.Top+10,btBoth);
  RES.Terminal[4]:=BusTerminal(MDRMux.Position[0],btConnect);
  S1.Terminal[6]:=BusTerminal(IR.Top+10,btRight);
  S2.Terminal[6]:=BusTerminal(IR.Top+10,btBoth);
  for i:=0 to NumTemps-1 do
  begin
    S1.Terminal[7+i]:=BusTerminal(Tmp[i].Top+10,btRight);
    S2.Terminal[7+i]:=BusTerminal(Tmp[i].Top+10,btBoth);
    RES.Terminal[5+i]:=BusTerminal(Tmp[i].Top+10,btConnect)
  end
end;

procedure TRegReadEnable.Connect(Inputs: array of TDataSource);
begin
  Reg:=Inputs[0]
end;

function TRegReadEnable.GetValue: LongInt;
begin
  if Reg.Value>=0 then
    Result:=1
  else
    Result:=0
end;

procedure TResultBusEnable.SetIndex(Ind: Integer);
begin
  Index:=Ind
end;

procedure TResultBusEnable.Connect(Inputs: array of TDataSource);
begin
  uCodeDest:=Inputs[0]
end;

function TResultBusEnable.GetValue: LongInt;
begin
  if uCodeDest.Value=Index then
    Result:=1
  else
    Result:=0
end;

procedure TuCode.SetField(Val: TuCodeField);
begin
  Field:=Val
end;

procedure TuCode.Connect(Inputs: array of TDataSource);
begin
  uAR:=Inputs[0]
end;

function TuCode.GetValue: LongInt;
begin
  Result:=MicroCode.uCode(uAR.Value,Field)
end;

procedure TIREnable.Connect(Inputs: array of TDataSource);
begin
  uCodeMemFunc:=Inputs[0];
  uCodeMemDest:=Inputs[1]
end;

function TIREnable.GetValue: LongInt;
begin
  if (uCodeMemFunc.Value>=READBYTE) and (uCodeMemFunc.Value<WRITEBYTE)
     and (uCodeMemDest.Value=0) then
    { read operation to IR }
    Result:=1
  else
    Result:=0
end;

procedure TMDREnable.Connect(Inputs: array of TDataSource);
begin
  uCodeDest:=Inputs[0];
  uCodeMemFunc:=Inputs[1];
  uCodeMemDest:=Inputs[2]
end;

function TMDREnable.GetValue: LongInt;
begin
  if (uCodeDest.Value=4) or ((uCodeMemFunc.Value>=READBYTE) and
         (uCodeMemFunc.Value<WRITEBYTE) and (uCodeMemDest.Value=1)) then
    { ResultBus writes to MDR or read operation to MDR }
    Result:=1
  else
    Result:=0
end;

procedure TRegFileRegister.SetRegister(Val: Integer);
begin
  Reg:=Val
end;

procedure TRegFileRegister.Connect(Inputs: array of TDataSource);
begin
  uAR:=Inputs[0];
  IR:=Inputs[1]
end;

function TRegFileRegister.GetValue: LongInt;
var
  uCodeReg: LongInt;
begin
  uCodeReg:=MicroCode.uCode(uAR.Value,ufReg) shr (10*Reg);
  case (uCodeReg shr 8) and 3 of
      { Read/Write Formal }
      2: Result:=Unravel.Register(IR.Value,uCodeReg and $F);
      { Read/Write Actual }
      3: Result:=uCodeReg and $FF
  else
    Result:=-1
  end
end;

procedure TuARMuxSelect.Connect(Inputs: array of TDataSource);
begin
  uAR:=Inputs[0];
  ALU:=Inputs[1];
  MBusy:=Inputs[2]
end;

function TuARMuxSelect.GetValue: LongInt;
var
  Condition: Boolean;
begin
  Condition:=false;
  Result:=0; { autoincrement by 1 }
  case MicroCode.uCode(uAR.Value,ufJCond) of
     0: { Result is already 0 };
   ONE: Result:=2;
    EQ: Condition:=(ALU.Value=0);
    NE: Condition:=(ALU.Value<>0);
    LT: Condition:=(ALU.Value<0);
    GT: Condition:=(ALU.Value>0);
    LE: Condition:=(ALU.Value<=0);
    GE: Condition:=(ALU.Value>=0);
    8: Condition:=(MBusy.Value<>0)
  else
    Result:=1;  { Jump table }
  end;
  if Condition then
    Result:=2   { Jump to adr coded in uCode }
end;

procedure TJumpTable.Connect(Inputs: array of TDataSource);
begin
  uAR:=Inputs[0]
end;

function TJumpTable.GetValue: LongInt;
var
  JCond: LongInt;
begin
  JCond:=MicroCode.uCode(uAR.Value,ufJCond);
  if JCond>=9 then
    Result:=JCond-8
  else
    Result:=1 { use jump table 1 when not specified -> otherwise a range error will occur }
end;

procedure TJump.Connect(Inputs: array of TDataSource);
begin
  Table:=Inputs[0];
  IR:=Inputs[1]
end;

function TJump.GetValue: LongInt;
begin
  Result:=MicroCode.Jump(IR.Value,Table.Value)
end;

constructor TMSimulator.Create(RwndBtn: TButton; RwndChk: TMenuItem;
       GenTrace: TMenuItem; MltCyc: TSpinEdit; MltCycChk: TCheckBox;
       Clk: TEditInteger; ChkStab: Boolean);
var
  i,j: Integer;
begin
  { von Neumann architecture }
  CodeMemory:=TMemoryInterface.Create(ctBoth);
  DataMemory:=CodeMemory;
  CodeCaptionBase:='Memory (Instruction View)';
  DataCaptionBase:='Memory (Data View)';
  inherited Create(RwndBtn, RwndChk, GenTrace ,MltCyc, MltCycChk, Clk, ChkStab);
  { Construct all building blocks for the simulator }
  uAR:=TReg.Create(MicroForm.uAR,'uAR');
  A:=TReg.Create(MicroForm.A,'A');
  B:=TReg.Create(MicroForm.B,'B');
  C:=TReg.Create(MicroForm.C,'C');
  PC:=TReg.Create(MicroForm.PC,'PC');
  MAR:=TReg.Create(MicroForm.MAR,'MAR');
  MDR:=TReg.Create(MicroForm.MDR,'MDR');
  IR:=TRegIR.Create(MicroForm.IR,'IR');
  for i:=0 to MicroForm.NumTemps-1 do
  begin
    TMP[i]:=TReg.Create(MicroForm.Tmp[i],MicroForm.TmpLabel[i].Caption);
    TMPEn[i]:=TResultBusEnable.Create(nil,'')
  end;
  uARMux:=TMux.Create(MicroForm.uARMux,'uAR Multiplexer');
  MDRMux:=TMux.Create(MicroForm.MDRMux,'MDR Multiplexer');
  MARMux:=TMux.Create(MicroForm.MARMux,'Address Multiplexer');
  S1:=TMux.Create(MicroForm.S1,'S1 Bus');
  S2:=TMux.Create(MicroForm.S2,'S2 Bus');
  RegFile:=TRegFile.Create(MicroForm.RegFile,'Register File (port 1)');
  RegFileBis:=TRegFileBis.Create(nil,'Register File (port 2)');
  ALU:=TAlu.Create(MicroForm.ALULabel,'ALU');
  Mem:=TRWMem.Create(MicroForm.MemLabel2,'Memory');
  MemBusy:=TRWMemBusy.Create(nil,'');
  MemAddress:=TRWMemAddress.Create(nil,'');
  Incr:=TIncrementor.Create(nil,'uAR Incrementer');
  SignExtend:=TSignExtend.Create(nil,'Sign Extender');
  uAREn:=TConstant.Create(nil,'');
  AEn:=TRegReadEnable.Create(nil,'');
  BEn:=TRegReadEnable.Create(nil,'');
  CEn:=TResultBusEnable.Create(nil,'');
  PCEn:=TResultBusEnable.Create(nil,'');
  MAREn:=TResultBusEnable.Create(nil,'');
  MDREn:=TMDREnable.Create(nil,'');
  IREn:=TIREnable.Create(nil,'');
  uCodeDest:=TuCode.Create(nil,'');
  uCodeAdr:=TuCode.Create(nil,'Microcode Address');
  uCodeMemAdr:=TuCode.Create(nil,'');
  uCodeMemDest:=TuCode.Create(nil,'');
  uCodeALU:=TuCode.Create(nil,'');
  uCodeS1:=TuCode.Create(nil,'');
  uCodeS2:=TuCode.Create(nil,'');
  uCodeConst:=TuCode.Create(nil,'Microcode Constant');
  uCodeMem:=TuCode.Create(nil,'');
  uCodeIRSize:=TuCode.Create(nil,'');
  JumpTable:=TJumpTable.Create(nil,'Microcode Jump Table');
  Jump:=TJump.Create(nil,'Jump Table Address');
  uARMuxSelect:=TuARMuxSelect.Create(nil,'');
  RegFileReadA:=TRegFileRegister.Create(nil,'');
  RegFileReadB:=TRegFileRegister.Create(nil,'');
  RegFileWrite:=TRegFileRegister.Create(nil,'');
  Void:=TConstant.Create(nil,'');

  { Connect all these blocks }
  uAR.Connect([uAREn,uARMux]);
  A.Connect([AEn,RegFile]);
  B.Connect([BEn,RegFileBis]);
  C.Connect([CEn,ALU]);
  PC.Connect([PCEn,ALU]);
  MAR.Connect([MAREn,ALU]);
  MDR.Connect([MDREn,MDRMux]);
  IR.Connect([IREn,Mem,MemAddress]);
  for i:=0 to MicroForm.NumTemps-1 do
  begin
    TMP[i].Connect([TMPEn[i],ALU]);
    TMPEn[i].Connect([uCodeDest]);
    TMPEn[i].SetIndex(5+i)
  end;
  RegFile.Connect([RegFileReadA,RegFileWrite,C]);
  RegFileBis.Connect([RegFileReadB,RegFile]);
  uARMux.Connect([uARMuxSelect,Incr,Jump,uCodeAdr]);
  MDRMux.Connect([uCodeMemDest,ALU,Mem]);
  MARMux.Connect([uCodeMemAdr,PC,MAR]);
  Incr.Connect([uAR]);
  Incr.SetIncrement(1);
  ALU.Connect([uCodeALU,S1,S2]);
  S1.Connect([uCodeS1,Void,A,uCodeConst,PC,MAR,MDR,SignExtend,
    TMP[0],TMP[1],TMP[2],TMP[3],TMP[4],TMP[5],TMP[6],TMP[7],TMP[8],TMP[9]]);
  S2.Connect([uCodeS2,Void,B,uCodeConst,PC,MAR,MDR,SignExtend,
    TMP[0],TMP[1],TMP[2],TMP[3],TMP[4],TMP[5],TMP[6],TMP[7],TMP[8],TMP[9]]);
  Mem.Connect([uCodeMem,MARMux,MDR]);
  Mem.SetMemory(DataMemory);
  MemBusy.Connect([Mem]);
  MemAddress.Connect([Mem]);
  SignExtend.Connect([uCodeIRSize,IR]);
  uAREn.SetConstant(1);
  AEn.Connect([RegFileReadA]);
  BEn.Connect([RegFileReadB]);
  CEn.Connect([uCodeDest]);
  CEn.SetIndex(1);
  PCEn.Connect([uCodeDest]);
  PCEn.SetIndex(2);
  MAREn.Connect([uCodeDest]);
  MAREn.SetIndex(3);
  MDREn.Connect([uCodeDest,uCodeMem,uCodeMemDest]);
  IREn.Connect([uCodeMem,uCodeMemDest]);
  uCodeDest.Connect([uAR]);
  uCodeDest.SetField(ufDest);
  uCodeAdr.Connect([uAR]);
  uCodeAdr.SetField(ufAdr);
  uCodeMemAdr.Connect([uAR]);
  uCodeMemAdr.SetField(ufMemAdr);
  uCodeMemDest.Connect([uAR]);
  uCodeMemDest.SetField(ufMemDest);
  uCodeALU.Connect([uAR]);
  uCodeALU.SetField(ufALU);
  uCodeS1.Connect([uAR]);
  uCodeS1.SetField(ufS1);
  uCodeS2.Connect([uAR]);
  uCodeS2.SetField(ufS2);
  uCodeConst.Connect([uAR]);
  uCodeConst.SetField(ufConst);
  uCodeMem.Connect([uAR]);
  uCodeMem.SetField(ufMem);
  uCodeIRSize.Connect([uAR]);
  uCodeIRSize.SetField(ufIRSize);
  JumpTable.Connect([uAR]);
  Jump.Connect([JumpTable,IR]);
  uARMuxSelect.Connect([uAR,ALU,MemBusy]);
  RegFileReadA.Connect([uAR,IR]);
  RegFileReadA.SetRegister(0);
  RegFileReadB.Connect([uAR,IR]);
  RegFileReadB.SetRegister(1);
  RegFileWrite.Connect([uAR,IR]);
  RegFileWrite.SetRegister(2);
  Void.SetConstant(-1);

  { Add breakpoint registers }
  for i:=0 to NumBreakPoints div 2-1 do
  begin
    BreakForm.ORBox[i].Items.AddObject('uAR',uAR);
    BreakForm.ORBox[i].Items.AddObject('A',A);
    BreakForm.ORBox[i].Items.AddObject('B',B);
    BreakForm.ORBox[i].Items.AddObject('C',C);
    BreakForm.ORBox[i].Items.AddObject('PC',PC);
    BreakForm.ORBox[i].Items.AddObject('MAR',MAR);
    BreakForm.ORBox[i].Items.AddObject('MDR',MDR);
    BreakForm.ORBox[i].Items.AddObject('IR',IR);
    for j:=0 to MicroForm.NumTemps-1 do
      BreakForm.ORBox[i].Items.AddObject(ConfigForm.TmpNames.Cells[0,j],TMP[j]);
    BreakForm.OrBox[i].ItemIndex:=i
  end
end;

destructor TMSimulator.Destroy;
var
  i: Integer;
begin
  uAR.Free;
  A.Free;
  B.Free;
  C.Free;
  PC.Free;
  MAR.Free;
  MDR.Free;
  IR.Free;
  for i:=0 to MicroForm.NumTemps-1 do
  begin
    TMP[i].Free;
    TMPEn[i].Free
  end;
  uARMux.Free;
  MDRMux.Free;
  MARMux.Free;
  S1.Free;
  S2.Free;
  RegFile.Free;
  RegFileBis.Free;
  ALU.Free;
  Mem.Free;
  MemBusy.Free;
  MemAddress.Free;
  Incr.Free;
  SignExtend.Free;
  uAREn.Free;
  AEn.Free;
  BEn.Free;
  CEn.Free;
  PCEn.Free;
  MAREn.Free;
  MDREn.Free;
  IREn.Free;
  uCodeDest.Free;
  uCodeAdr.Free;
  uCodeMemAdr.Free;
  uCodeMemDest.Free;
  uCodeALU.Free;
  uCodeS1.Free;
  uCodeS2.Free;
  uCodeConst.Free;
  uCodeMem.Free;
  uCodeIRSize.Free;
  JumpTable.Free;
  Jump.Free;
  uARMuxSelect.Free;
  RegFileReadA.Free;
  RegFileReadB.Free;
  RegFileWrite.Free;
  Void.Free;

  inherited Destroy;
  DataMemory.Free;
end;

procedure TMSimulator.Evaluate;
var
  i: Integer;
begin
  ALU.Value; { This will display the ALU operation and position of muxes
               -- even when the result is not required }
  MDRMux.Value;
  MARMux.Value;
  uAR.Evaluate;
  A.Evaluate;
  B.Evaluate;
  C.Evaluate;
  PC.Evaluate;
  MAR.Evaluate;
  MDR.Evaluate;
  IR.Evaluate;
  for i:=0 to MicroForm.NumTemps-1 do
  begin
    TMP[i].Evaluate;
  end;
  RegFile.Evaluate;
  Mem.Evaluate;
end;

procedure TMSimulator.Propagate;
var
  i: Integer;
begin
  inherited Propagate;
  uAR.Propagate;
  A.Propagate;
  B.Propagate;
  C.Propagate;
  MAR.Propagate;
  MDR.Propagate;
  IR.Propagate;
  for i:=0 to MicroForm.NumTemps-1 do
  begin
    TMP[i].Propagate;
  end;
  RegFile.Propagate;
  Mem.Propagate;
end;

procedure TMSimulator.Reset;
var
  i: Integer;
begin
  inherited Reset;
  uAR.Reset;
  A.Reset;
  B.Reset;
  C.Reset;
  PC.Reset;
  MAR.Reset;
  MDR.Reset;
  IR.Reset;
  for i:=0 to MicroForm.NumTemps-1 do
  begin
    TMP[i].Reset;
    TMPEn[i].Reset
  end;
  uARMux.Reset;
  MDRMux.Reset;
  MARMux.Reset;
  S1.Reset;
  S2.Reset;
  RegFile.Reset;
  ALU.Reset;
  Mem.Reset;
  MemBusy.Reset;
  MemAddress.Reset;
  Incr.Reset;
  SignExtend.Reset;
  AEn.Reset;
  BEn.Reset;
  CEn.Reset;
  PCEn.Reset;
  MAREn.Reset;
  MDREn.Reset;
  IREn.Reset;
  uCodeDest.Reset;
  uCodeAdr.Reset;
  uCodeMemAdr.Reset;
  uCodeMemDest.Reset;
  uCodeALU.Reset;
  uCodeS1.Reset;
  uCodeS2.Reset;
  uCodeConst.Reset;
  uCodeMem.Reset;
  uCodeIRSize.Reset;
  JumpTable.Reset;
  Jump.Reset;
  uARMuxSelect.Reset;
  RegFileReadA.Reset;
  RegFileReadB.Reset;
  RegFileWrite.Reset;
end;

procedure TMSimulator.Simulate(Clocks: LongInt);
begin
  inherited Simulate(Clocks);
  { Highlight the actual uCode row }
  MicroCode.HighLight(uAR.Value)
end;

procedure TMSimulator.Rewind(Clocks: LongInt);
begin
  inherited Rewind(Clocks);
  MicroCode.HighLight(uAR.Value)
end;

procedure TMicroForm.ClockButtonClick(Sender: TObject);
begin
  { Check if the microcode has been assembled }
  if MicroCode.Assembled or (not MicroCode.Assemble('Proceed anyway?')) then
    MSimulator.ClockClick
end;

procedure TMicroForm.ResetButtonClick(Sender: TObject);
var
  Dummy: Boolean;
begin
  { Make sure alterations to the uCode and jump tables have been processed }
  MicroCode.Grid1SelectCell(Sender,0,MicroCode.LastRow1,Dummy);
  MicroCode.Grid2SelectCell(Sender,0,MicroCode.LastRow2,Dummy);
  MSimulator.ResetClick
end;

procedure TMicroForm.RewindButtonClick(Sender: TObject);
begin
  MSimulator.RewindClick
end;

procedure TMicroForm.RewindCheckClick(Sender: TObject);
begin
  MSimulator.RewindCheckClick;
  RewindCheck2.Checked:=RewindCheck.Checked
end;

procedure TMicroForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  { Catch VK_Return over Clock }
  if (Key=VK_RETURN) and Clock.Focused then
  begin
    { Changing the focus will trigger a ClockExit }
    ClockButton.SetFocus;
    Key:=0
  end
end;

procedure TMicroForm.ClockExit(Sender: TObject);
begin
  MSimulator.ClockChangedByUser
end;

procedure TMicroForm.InstructionView1Click(Sender: TObject);
begin
  ImemForm.Show
end;

procedure TMicroForm.DataMemory1Click(Sender: TObject);
begin
  DmemForm.Show
end;

procedure TMicroForm.Microcode1Click(Sender: TObject);
begin
  MicroCode.Show
end;

procedure TMicroForm.About1Click(Sender: TObject);
begin
  AboutBox
end;

procedure TMicroForm.BreakPoints1Click(Sender: TObject);
begin
  BreakForm.Show
end;

procedure TMicroForm.GenTraceClick(Sender: TObject);
begin
  GenTrace.Checked:=not GenTrace.Checked;
  GenTrace2.Checked:=GenTrace.Checked
end;

procedure TMicroForm.Exit2Click(Sender: TObject);
begin
  Close
end;

procedure TMicroForm.NewProject1Click(Sender: TObject);
begin
  if SaveFirst then
    ClearProject
end;

procedure TMicroForm.ClearProject;
begin
  DmemForm.ClearMemory;
  ImemForm.ClearMemory;
  DataMemory.ChangedAll;
  MicroCode.ClearMicroCode;
  MemAccessTime:=4;
  MSimulator.Mem.SetSpeed(MemAccessTime);
  SaveDialog1.FileName:='Untitled.mpr';
  SaveProject1.Enabled:=false;
  MSimulator.ResetClick;
  ShowCaption
end;

procedure TMicroForm.OpenProject1Click(Sender: TObject);
begin
  if SaveFirst and OpenDialog1.Execute then
    LoadProject
end;

function TMicroForm.SaveFirst: Boolean;
var
  Answer: Integer;
begin
  Result:=true;
  { files need to be updated? }
  if SaveProject1.Enabled then
  begin
    Answer:=AppliMessage('Save changes to '+
           ExtractFileName(SaveDialog1.FileName)+'?','Confirm',$23);
    case Answer of

      6: { Yes } begin
           if DmemForm.SaveFileClick and ImemForm.SaveFileClick and
              MicroCode.SaveFileClick then
           begin
             SaveProject1Click(MicroForm);
             Result:=not SaveProject1.Enabled
           end else
             Result:=false { User answered cancel while saving one of the three files }
         end;
      7: { No -> Don't do anything but return true }
    else
      Result:=false
    end
  end
end;

procedure TMicroForm.SaveProject1Click(Sender: TObject);
begin
  if DmemForm.SaveFileClick and ImemForm.SaveFileClick and
     MicroCode.SaveFileClick then
  begin
    if SaveDialog1.FileName='Untitled.mpr' then
      SaveProjectAs1Click(Sender)
    else
      SaveProject
  end
end;

procedure TMicroForm.SaveProjectAs1Click(Sender: TObject);
begin
  if DmemForm.SaveFileClick and ImemForm.SaveFileClick and
     MicroCode.SaveFileClick and SaveDialog1.Execute then
    SaveProject
end;

procedure TMicroForm.ShowCaption;
begin
  Caption:='Microprogrammed Architecture - '+ExtractFileName(SaveDialog1.FileName)
end;

procedure TMicroForm.LoadProject;
var
  Error: Boolean;
begin
  FileIO.UseFile(OpenDialog1.FileName);
  Reset(FileIO.F);
  Error:=false;
  MicroCode.OpenDialog1.FileName:=FileIO.ReadString('Microcode',Error);
  ImemForm.OpenDialog1.FileName:=FileIO.ReadString('InstructionMemory',Error);
  DmemForm.OpenDialog1.FileName:=FileIO.ReadString('DataMemory',Error);
  MemAccessTime:=FileIO.ReadInteger('MemoryAccessTime',Error);
  MSimulator.Mem.SetSpeed(MemAccessTime);
  CloseFile(FileIO.F);
  SaveDialog1.FileName:=OpenDialog1.FileName;
  ShowCaption;
  if Error then
    AppliMessage('File Format Corrupt; memory modules and microcode not loaded','Warning',$40)
  else begin
    { First load Dmem, then Imem }
    DmemForm.LoadFile;
    ImemForm.LoadFile;
    MicroCode.LoadFile
  end;
  MSimulator.ResetClick;
  SaveProject1.Enabled:=false
end;

procedure TMicroForm.SaveProject;
begin
  FileIO.UseFile(SaveDialog1.FileName);
  Rewrite(FileIO.F);
  Writeln(FileIO.F,'[Microprogrammed Architecture Project]');
  FileIO.WriteString('Microcode',RelativeDir(MicroCode.SaveDialog1.FileName));
  FileIO.WriteString('InstructionMemory',RelativeDir(ImemForm.SaveDialog1.FileName));
  FileIO.WriteString('DataMemory',RelativeDir(DmemForm.SaveDialog1.FileName));
  FileIO.WriteInteger('MemoryAccessTime',MemAccessTime);
  CloseFile(FileIO.F);
  SaveProject1.Enabled:=false;
  ShowCaption
end;

procedure TMicroForm.SetModify;
begin
  SaveProject1.Enabled:=true
end;

procedure TMicroForm.SetTraceFile1Click(Sender: TObject);
var
  F: TextFile;
begin
  if SaveDialog2.Execute then
  begin
    GenTrace.Enabled:=true;
    GenTrace2.Enabled:=true;
    { Clear trace file }
    AssignFile(F,SaveDialog2.FileName);
    Rewrite(F);
    CloseFile(F)
  end else
    DisableTrace
end;

procedure TMicroForm.DisableTrace;
begin
  GenTrace.Enabled:=false;
  GenTrace2.Enabled:=false
end;

procedure TMicroForm.MemoryAccessTime1Click(Sender: TObject);
var
  AccessTime: string;
begin
  AccessTime:=IntToStr(MemAccessTime);
  if InputQuery('Memory Access Time','Enter Memory Access Time (1-9):',AccessTime) then
  begin
    MemAccessTime:=StrToIntDef(AccessTime,1);
    if MemAccessTime<1 then
      MemAccessTime:=1
    else if MemAccessTime>9 then
      MemAccessTime:=9;
    MSimulator.Mem.SetSpeed(MemAccessTime);
    SetModify;
    ResetButtonClick(Sender)
  end
end;

procedure TMicroForm.LineBox2MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Obj: TObject;
begin
  Obj:=LineBox2.Objects(X,Y);
  if Obj<>nil then
    ShowWireValue(X+136,Y+18,Obj as TDataSource)
end;

procedure TMicroForm.LineBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Obj: TObject;
begin
  Obj:=LineBox1.Objects(X,Y);
  if Obj<>nil then
    ShowWireValue(X+2,Y+18,Obj as TDataSource)
end;

procedure TMicroForm.LineBox3MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Obj: TObject;
begin
  Obj:=LineBox3.Objects(X,Y);
  if Obj<>nil then
    ShowWireValue(X,Y+18,Obj as TDataSource)
end;

procedure TMicroForm.LineBox2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  WireValue.Hide
end;

procedure TMicroForm.ShowWireValue(X,Y: Integer; Source: TDataSource);
var
  l0,l1,l: Integer;
begin
  WireValue.Color:=Application.HintColor;
  WireValue.Lines[0]:='Driver: '+Source.Name;
  WireValue.Lines[1]:='Value: '+Source.StrValue;
  WireValue.Height:=MSSansSerif8Height*2+5;
  l0:=Canvas.TextWidth(WireValue.Lines[0]);
  l1:=Canvas.TextWidth(WireValue.Lines[1]);
  if l0>l1 then
    l:=l0
  else
    l:=l1;
  WireValue.Width:=l+5;
  WireValue.Top:=Y-WireValue.Height-3;
  if WireValue.Top<0 then
    WireValue.Top:=Y+24;
  WireValue.Left:=X-WireValue.Width div 2;
  if WireValue.Left<0 then
    WireValue.Left:=0
  else if WireValue.Left+WireValue.Width>Width then
    WireValue.Left:=Width-WireValue.Width;
  WireValue.Show
end;

end.

