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

unit Pipe;

{$MODE Delphi}

interface

uses
  SysUtils, {WinTypes, WinProcs,} Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls, Compos, Menus, Common, PipeDef,
  DataMem, InstrMem, BrkForm, Spin, LResources, lcltype;

type
  { This is the main form for the pipelined architecture simulator }
  TPipeForm = class(TForm)
    Datapath: TGroupBox;
    Control: TGroupBox;
    MainMenu1: TMainMenu;
    LineBox1: TLineBox;
    LineBox2: TLineBox;
    LineBox3: TLineBox;
    File1: TMenuItem;
    Exit1: TMenuItem;
    N1: TMenuItem;
    SetTraceFile1: TMenuItem;
    N2: TMenuItem;
    SaveProjectAs1: TMenuItem;
    SaveProject1: TMenuItem;
    OpenProject1: TMenuItem;
    NewProject1: TMenuItem;
    View1: TMenuItem;
    BreakPoints1: TMenuItem;
    Pipecode1: TMenuItem;
    DataMemory1: TMenuItem;
    InstructionMemory1: TMenuItem;
    Options1: TMenuItem;
    RewindCheck: TMenuItem;
    GenTrace: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    EnableForwarding1: TMenuItem;
    N3: TMenuItem;
    DelaySlot1: TMenuItem;
    NoDelaySlot1: TMenuItem;
    SingleDelaySlot1: TMenuItem;
    DoubleDelaySlot1: TMenuItem;
    PopupMenu1: TPopupMenu;
    InstructionMemory2: TMenuItem;
    DataMemory2: TMenuItem;
    Pipelinefunctionality1: TMenuItem;
    BreakPoints2: TMenuItem;
    N4: TMenuItem;
    GenTrace2: TMenuItem;
    RewindCheck2: TMenuItem;
    N5: TMenuItem;
    EnableForwarding2: TMenuItem;
    DelayedBranching1: TMenuItem;
    DoubleDelaySlot2: TMenuItem;
    SingleDelaySlot2: TMenuItem;
    NoDelaySlot2: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    SaveDialog2: TSaveDialog;
    DataMemoryAccessTime1: TMenuItem;
    Panel2: TPanel;
    Label18: TLabel;
    ClockButton: TButton;
    ResetButton: TButton;
    Clock: TEditInteger;
    RewindButton: TButton;
    MultiCycleCheck: TCheckBox;
    Panel1: TPanel;
    DataMemoryAccessTime2: TMenuItem;
    N6: TMenuItem;
    PipelineActivityDiagram1: TMenuItem;
    PipelineUsageDiagram1: TMenuItem;
    EnablePipelineDiagrams1: TMenuItem;
    N7: TMenuItem;
    EnablePipelineDiagrams2: TMenuItem;
    PipelineActivityDiagram2: TMenuItem;
    PipelineUsageDiagram2: TMenuItem;
    PC: TRegBox;
    PC1: TRegBox;
    Comp: TComparatorBox;
    CondLabel: TLabel;
    Cond: TRegBox;
    CompMux: TMuxBox;
    RegFile: TRegFileBox;
    IncrMux: TMuxBox;
    Incr: TComparatorBox;
    AMux: TMuxBox;
    BMux: TMuxBox;
    BLabel: TLabel;
    ALabel: TLabel;
    A: TRegBox;
    B: TRegBox;
    S2Mux: TMuxBox;
    S1Mux: TMuxBox;
    ALU: TAluBox;
    ALULabel: TLabel;
    RES1: TRegBox;
    RES1Label: TLabel;
    MAR: TRegBox;
    MARLabel: TLabel;
    SMDR: TRegBox;
    SMDRLabel: TLabel;
    PC1Label: TLabel;
    PCLabel: TLabel;
    LMDRLabel: TLabel;
    LMDR: TRegBox;
    RES2Label: TLabel;
    RES2: TRegBox;
    WBMux: TMuxBox;
    CompLabel: TLabel;
    IncrLabel: TLabel;
    IR: TRegBox;
    IRLabel: TLabel;
    IR1: TRegBox;
    ST1: TRegBox;
    ST1Label: TLabel;
    IR1Label: TLabel;
    IR2: TRegBox;
    ST2: TRegBox;
    IR2Label: TLabel;
    ST2Label: TLabel;
    ST3: TRegBox;
    IR3: TRegBox;
    IR3Label: TLabel;
    ST3Label: TLabel;
    ImemLabel1: TLabel;
    ImemLabel2: TLabel;
    ImemLabel3: TLabel;
    Mask1: TPanel;
    LineBox4: TLineBox;
    DmemLabel1: TLabel;
    DmemLabel2: TLabel;
    DmemLabel3: TLabel;
    LineBox6: TLineBox;
    LineBox5: TLineBox;
    WireValue: TMemo;
    MultiCycle: TSpinEdit;
    Imem: TShape3D;
    Dmem: TShape3D;
    SignExtend: TShape3D;
    Decoder: TShape3D;
    Null1: TShape3D;
    Null2: TShape3D;
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure InstructionMemory1Click(Sender: TObject);
    procedure DataMemory1Click(Sender: TObject);
    procedure RewindCheckClick(Sender: TObject);
    procedure ResetButtonClick(Sender: TObject);
    procedure ClockButtonClick(Sender: TObject);
    procedure RewindButtonClick(Sender: TObject);
    procedure ClockExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure About1Click(Sender: TObject);
    procedure GenTraceClick(Sender: TObject);
    procedure EnableRewind1Click(Sender: TObject);
    procedure EnableForwarding1Click(Sender: TObject);
    procedure NoDelaySlot1Click(Sender: TObject);
    procedure SingleDelaySlot1Click(Sender: TObject);
    procedure DoubleDelaySlot1Click(Sender: TObject);
    procedure Pipecode1Click(Sender: TObject);
    procedure BreakPoints1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure SetDelaySlotSize(S: Integer);
    procedure SetEnableForwarding(F: Boolean);
    procedure NewProject1Click(Sender: TObject);
    procedure OpenProject1Click(Sender: TObject);
    procedure SaveProject1Click(Sender: TObject);
    procedure SaveProjectAs1Click(Sender: TObject);
    procedure SetTraceFile1Click(Sender: TObject);
    procedure DataMemoryAccessTime1Click(Sender: TObject);
    procedure PipelineActivityDiagram1Click(Sender: TObject);
    procedure EnablePipelineDiagrams1Click(Sender: TObject);
    procedure PipelineUsageDiagram1Click(Sender: TObject);
    procedure LineBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LineBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LineBox3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LineBox4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LineBox5MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LineBox6MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LineBox2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Checks if files need to be saved first -- returns true when it's okay to exit }
    function SaveFirst: Boolean;
    { Clear the current project and set the filename to Untitled.mpr }
    procedure ClearProject;
    { Save the project using SaveDialog1.FileName }
    procedure SaveProject;
    { Load a new project using OpenDialog1.FileName }
    procedure LoadProject;
    { Update the name in the titlebar after a change of filename }
    procedure ShowCaption;
    { Disables the 'Trace' menu when no valid tracefile is set }
    procedure DisableTrace;
  public
    DmemAccessTime: Integer;
    DelaySlot: Integer;
    Forwarding: Boolean;
    { Show the pop-up box with the value of the driver the user clicked on }
    procedure ShowWireValue(X,Y: Integer; Source: TDataSource);
    { Enables the 'Save' menu indicating one of the files needs to be updated }
    procedure SetModify;
  end;

  { These combinational and sequential blocks are only used in the microprgrammed
    simulator -- Check out the files in Common.pas first }

  { After decoding an intruction the result doesn't fit in a 32 bit LongInt. Therefore the state is
    internally represented by two DataSources (X and Y). TSTYCombiSource is a simple wire that
    connects the input (STYin) to the output. Furthermore it supplies various memberfunctions that unravel
    the state coded in X and Y }
  TSTYCombiSource = class(TCombiSource)
  private
    STX: TDataSource;
    STYin: TDataSource;
  public
    { True when Nullified }
    function Null: Boolean;
    { Actual A, or -1 when no RRA required }
    function ActualA: Integer;
    { Actual B, or -1 when no RRB required }
    function ActualB: Integer;
    { Actual C, or -1 when no WB required }
    function ActualC: Integer;
    { True when write-back required }
    function WBRequired: Boolean;
    { True when Reg A, False when PC1}
    function S1Source: Boolean;
    { True when Reg B, False when IR }
    function S2Source: Boolean;
    { True when RegisterFile Read Port 1 into Reg A required }
    function RRARequired: Boolean;
    { True when RegisterFile Read Port 2 into Reg B required }
    function RRBRequired: Boolean;
    { Comparator function }
    function CmpFunc: Integer;
    { Sign extend size }
    function ExtSize: Integer;
    { ALU function }
    function ALUFunc: Integer;
    { Data memory function }
    function MemFunc: Integer;
    { Connect: X DataSource, Y DataSource }
    procedure Connect(Inputs: array of TDataSource); override;
    function GetValue: LongInt; override;
    function StrValue: string; override;
  end;

  { X part of the decoder }
  TDecoderX = class(TCombiSource)
  private
    IR: TDataSource;
    Comp: TDataSource;
    Cond: TDataSource;
  public
    RecentYValue: LongInt;
    procedure Connect(Inputs: array of TDataSource); override;
    function GetValue: LongInt; override;
  end;

  { Y part of the decoder }
  TDecoderY = class(TSTYCombiSource)
  public
    procedure Connect(Inputs: array of TDataSource); override;
    function GetValue: LongInt; override;
  end;

  { A or B mux select }
  TABMuxSelect = class(TCombiSource)
  private
    STY0: TSTYCombiSource;
    STY1: TSTYCombiSource;
    IDStall: TDataSource;
    STY3: TSTYCombiSource;
    WBStall: TDataSource;
    Mux: TMetaFormal;
  public
    procedure SetMux(M: TMetaFormal);
    procedure Connect(Inputs: array of TDataSource); override;
    function GetValue: LongInt; override;
  end;

  TMuxSource = (msCmp,msS1,msS2);

  { Comparator, S1 or S2 mux select }
  TCompS1S2MuxSelect = class(TCombiSource)
  private
    STY1: TSTYCombiSource;
    STY2: TSTYCombiSource;
    STY3: TSTYCombiSource;
    Mux: TMuxSource;
  public
    procedure SetMux(M: TMuxSource);
    procedure Connect(Inputs: array of TDataSource); override;
    function GetValue: LongInt; override;
  end;

  { Write-back mux select }
  TWBMuxSelect = class(TCombiSource)
  private
    STY3: TSTYCombiSource;
  public
    procedure Connect(Inputs: array of TDataSource); override;
    function GetValue: LongInt; override;
  end;

  { Comparator, ALU or data memory function }
  TResourceFunc = class(TCombiSource)
  private
    STY: TSTYCombiSource;
    Resource: TResource;
  public
    procedure SetResource(R: TResource);
    procedure Connect(Inputs: array of TDataSource); override;
    function GetValue: LongInt; override;
  end;

  { Comparator function, but disabled when Nullified -- only for STY1}
  TCompFunc = class(TCombiSource)
  private
    STY1: TSTYCombiSource;
  public
    procedure Connect(Inputs: array of TDataSource); override;
    function GetValue: LongInt; override;
  end;

  { Actual to be read or written }
  TActual = class(TCombiSource)
  private
    STY: TSTYCombiSource;
    Stall: TDataSource;
    Formal: TMetaFormal;
  public
    procedure SetFormal(F: TMetaFormal);
    procedure Connect(Inputs: array of TDataSource); override;
    function GetValue: LongInt; override;
  end;

  { Sign Extend Size }
  TExtendSize = class(TCombiSource)
  private
    STY1: TSTYCombiSource;
  public
    procedure Connect(Inputs: array of TDataSource); override;
    function GetValue: LongInt; override;
  end;

  { Nullifier (X part -- Y part is a short) }
  TNullifier = class(TCombiSource)
  private
    STY: TDataSource;
    Stall: TDataSource;
  public
    procedure Connect(Inputs: array of TDataSource); override;
    function GetValue: LongInt; override;
  end;

  { EX stall -- is IF and ID stall as well }
  TEXStallControl = class(TCombiSource)
  private
    MemStall: TDataSource;
    WBStall: TDataSource;
    STY1: TSTYCombiSource;
    STY2: TSTYCombiSource;
    STY3: TSTYCombiSource;
  public
    procedure Connect(Inputs: array of TDataSource); override;
    function GetValue: LongInt; override;
  end;

  { Mem stall -- 0 (stall) when WB is stalled or when Mem is busy and
    a memory operation is in the Mem stage}
  TMemStallControl = class(TCombiSource)
  private
    NextStall: TDataSource;
    STY2: TSTYCombiSource;
    DelayedMemBusy: TDataSource;
  public
    procedure Connect(Inputs: array of TDataSource); override;
    function GetValue: LongInt; override;
  end;

  { EX2Mem stall -- 0 (stall) when Mem stall or when COND = 1 and EX stall }
  TEX2MemStallControl = class(TCombiSource)
  private
    EXStall: TDataSource;
    MemStall: TDataSource;
    Cond: TDataSource;
  public
    procedure Connect(Inputs: array of TDataSource); override;
    function GetValue: LongInt; override;
  end;

  { WB stall }
  TWBStallControl = class(TCombiSource)
  private
    STY3: TSTYCombiSource;
    DelayedMemBusy: TDataSource;
  public
    procedure Connect(Inputs: array of TDataSource); override;
    function GetValue: LongInt; override;
  end;

  { This is the main simulator module for the pipelined architecture }
  TPSimulator = class(TSimulator)
  public
    PC1: TReg;
    A: TReg;
    B: TReg;
    COND: TReg;
    SMDR: TReg;
    MAR: TReg;
    RES1: TReg;
    LMDR: TReg;
    RES2: TReg;
    IR: TRegIR;
    IR1: TRegIR;
    IR2: TRegIR;
    IR3: TRegIR;
    STX1: TReg;
    STX2: TReg;
    STX3: TReg;
    STYR1: TReg;
    STYR2: TReg;
    STYR3: TReg;
    STY1: TSTYCombiSource;
    STY2: TSTYCombiSource;
    STY3: TSTYCombiSource;
    IncrMux: TMux;
    IM1: TReg;
    IM2: TReg;
    IM3: TReg;
    IM4: TReg;
    AMux: TMux;
    BMux: TMux;
    CompMux: TMux;
    S1Mux: TMux;
    S2Mux: TMux;
    WBMux: TMux;
    RegFileBis: TRegFileBis;
    Incr: TIncrementor;
    Comp:TComparator;
    Alu: TAlu;
    SignExtend: TSignExtend;
    Imem: TRWMem;
    ImemAddress: TRWMemAddress;
    ImemAddress1: TRegIRPC;
    ImemAddress2: TRegIRPC;
    ImemAddress3: TRegIRPC;
    Dmem: TRWMem;
    DmemBusy: TRWMemBusy;
    ConstantOne: TConstant;
    DelayedDmemBusy: TReg;
    AMuxSelect: TABMuxSelect;
    BMuxSelect: TABMuxSelect;
    CompMuxSelect: TCompS1S2MuxSelect;
    S1MuxSelect: TCompS1S2MuxSelect;
    S2MuxSelect: TCompS1S2MuxSelect;
    WBMuxSelect: TWBMuxSelect;
    AluFunc: TResourceFunc;
    CompFunc: TCompFunc;
    ExtendSize: TExtendSize;
    ImemFunc: TConstant;
    DmemFunc: TResourceFunc;
    RegFileReadA: TActual;
    RegFileReadB: TActual;
    RegFileWrite: TActual;
    DecoderX: TDecoderX;
    DecoderY: TDecoderY;
    Null1X: TNullifier;
    Null2X: TNullifier;
    Null1Y: TSTYCombiSource;
    Null2Y: TSTYCombiSource;
    WBStall: TWBStallControl;
    MemStall: TMemStallControl;
    EX2MemStall: TEX2MemStallControl;
    EXStall: TExStallControl;
    AEnable: TOrGate;
    BEnable: TOrGate;
    ActivityStartIndex: Integer;
    ActivityNextIndex: Integer;
    ActivityStartTime: LongInt;
    ActivityTime: LongInt;
    ActivityData: array [0..4,0..1023] of LongInt;
    constructor Create(RwndBtn: TButton; RwndChk: TMenuItem;
       GenTrace: TMenuItem; MltCyc: TSpinEdit; MltCycChk: TCheckBox;
       Clk: TEditInteger; ChkStab: Boolean); override;
    destructor Destroy; override;
    procedure Evaluate; override;
    procedure Propagate; override;
    procedure Reset; override;
    procedure Simulate(Clocks: LongInt); override;
    procedure TraceActivity;
    procedure ClearActivity;
  end;

var
  PipeForm: TPipeForm;
  PSimulator: TPSimulator;

implementation

uses
  Main, Config, ACTIVITY, USAGE;

{$R *.lfm}

procedure TPipeForm.FormResize(Sender: TObject);
var
  W,H,H2: Integer;
  C2,C2Max,C3,C3Min,C4,C4Max: Integer;
  X1,X2: Integer;

  LineBox1toLineBox4YAdj,
  LineBox1toLineBox4XAdj: Integer;
begin
  { Size Datapath Panel }
  Datapath.Height:=ClientHeight-152;
  if Datapath.Height<266 then
    Datapath.Height:=266;
  Datapath.Width:=ClientWidth-2*DataPath.Left;
  if Datapath.Width<632 then
    Datapath.Width:=632;
  { Size and Position Control Panel }
  Control.Top:=Datapath.Height;
  Control.Width:=ClientWidth-Control.Left-DataPath.Left;
  LineBox2.Top:=Datapath.Height;
  LineBox3.Width:=Control.Width;
  LineBox5.Top:=Datapath.Height;
  { Size and Position Panel }
  if ClientWidth>545 then
    W:=(ClientWidth-545) div 2
  else
    W:=0;
  Panel1.Top:=Control.Top+88;
  Panel1.Width:=ClientWidth-2*DataPath.Left;
  Panel2.Left:=W;
  { Size Register File }
  RegFile.Height:=Datapath.Height-48;
  RegFile.Width:=MaxRegisterLength(ConfigForm.NumRegisters.Value)*Courier9Width+5;
  { Position Vertically }
  Incr.Top:=RegFile.Height div 2;
  IncrMux.Top:=Incr.Top+20;
  AMux.Top:=RegFile.Height div 2 +16;
  BMux.Top:=AMux.Top+60;
  A.Top:=AMux.Top;
  B.Top:=BMux.Top;
  S1Mux.Top:=AMux.Top-3;
  S2Mux.Top:=BMux.Top-13;
  ALU.Top:=AMux.Top+2;
  RES1.Top:=RegFile.Height-44;
  if RegFile.Height>273 then
    RES1.Top:=RES1.Top-(RegFile.Height-273) div 2;
  LMDR.Top:=RES1.Top-48;
  RES2.Top:=RES1.Top;
  WBMux.Top:=RES1.Top+30;
  SignExtend.Top:=(Datapath.Height+WBMux.Top) div 2 -16;
  { Position Horizontally }
  C3Min:=RegFile.Left+RegFile.Width+226+MAR.Width div 2;
  W:=(Datapath.Width-(126+3*40))div 4;
  C3:=116+2*(W+40)+W div 2;
  if C3Min>C3 then
  begin
    C3:=C3Min;
    C2:=C3-183;
  end else
    C2:=C3-W-40;
  C2Max:=C3-183;
  if C2Max<=C2 then
  begin
    C2:=C2Max;
    W:=((C2-Control.Left-60)*2) div 3;
  end;
  C4:=Datapath.Width-10-W div 2;
  C4Max:=Datapath.Width-30-LMDR.Width div 2;
  if C4Max<C4 then
    C4:=C4Max;
  A.Left:=C2-A.Width div 2;
  B.Left:=A.Left;
  PC1.Left:=A.Left;
  AMux.Left:=A.Left-24;
  BMux.Left:=AMux.Left;
  RegFile.Width:=AMux.Left-18-RegFile.Left;
  CompMux.Left:=A.Left+96;
  S1Mux.Left:=CompMux.Left;
  S2Mux.Left:=CompMux.Left;
  SignExtend.Left:=(C2+C3-IR2Label.Width-2) div 2 -8;
  LineBox5.Left:=SignExtend.Left+2;
  LineBox6.Left:=SignExtend.Left-Control.Left+2;
  Comp.Left:=CompMux.Left+28;
  ALU.Left:=Comp.Left;
  COND.Left:=C3-COND.Width div 2;
  SMDR.Left:=C3-SMDR.Width div 2;
  MAR.Left:=SMDR.Left;
  RES1.Left:=SMDR.Left;
  LMDR.Left:=C4-LMDR.Width div 2;
  RES2.Left:=LMDR.Left;
  WBMux.Left:=RES2.Left+52;
  { Calculate translations of coordinates between different line boxes }
  LineBox1toLineBox4YAdj:=(LineBox4.ClientOrigin.Y-LineBox4.Top)-(LineBox1.ClientOrigin.Y-LineBox1.Top);
  LineBox1toLineBox4XAdj:=(LineBox4.ClientOrigin.X-LineBox4.Left)-(LineBox1.ClientOrigin.X-LineBox1.Left);
  { Size and Position components in Control Panel}
  IR.Width:=W;
  IR1.Width:=W;
  IR2.Width:=W;
  IR3.Width:=W;
  ST1.Width:=W;
  ST2.Width:=W;
  ST3.Width:=W;
  IR1.Left:=C2-W div 2-Control.Left;
  ST1.Left:=IR1.Left;
  IR2.Left:=C3-W div 2-Control.Left;
  ST2.Left:=IR2.Left;
  IR3.Left:=C4-W div 2-Control.Left;
  ST3.Left:=IR3.Left;
  Decoder.Left:=(IR.Left+IR.Width+IR1.Left) div 2 - 20;
  Null1.Left:=(IR1.Left+IR1.Width+IR2.Left) div 2 - 8;
  Null2.Left:=(IR2.Left+IR2.Width+IR3.Left) div 2 - 8;
  { Position Masks }
  Mask1.Left:=SMDR.Left+SMDR.Width+32;
  Mask1.Width:=Datapath.Width-Mask1.Left-8;
  Mask1.Height:=Datapath.Height-176;
  if Mask1.Height>152 then
    Mask1.Height:=152;
  LineBox4.Left:=Mask1.Left+2;
  LineBox4.Width:=Mask1.Width-2;
  LineBox4.Height:=Mask1.Height-LineBox1toLineBox4YAdj;
  Dmem.Top:=Mask1.Height-70;
  { Position Labels }
  IncrLabel.Top:=Incr.Top+20;
  CompLabel.Left:=Comp.Left;
  PCLabel.Left:=PC.Left;
  PCLabel.Top:=PC.Top+24;
  PC1Label.Left:=PC1.Left;
  PC1Label.Top:=PC1.Top+24;
  ALabel.Left:=A.Left;
  ALabel.Top:=A.Top-14;
  BLabel.Left:=B.Left;
  BLabel.Top:=B.Top-14;
  CONDLabel.Left:=Cond.Left-10;
  CONDLabel.Top:=Cond.Top-14;
  SMDRLabel.Left:=SMDR.Left;
  SMDRLabel.Top:=SMDR.Top-14;
  MARLabel.Left:=MAR.Left;
  MARLabel.Top:=Mar.Top-14;
  RES1Label.Left:=RES1.Left;
  RES1Label.Top:=RES1.Top-14;
  LMDRLabel.Left:=LMDR.Left;
  LMDRLabel.Top:=LMDR.Top-14;
  RES2Label.Left:=RES2.Left;
  RES2Label.Top:=RES2.Top-14;
  IRLabel.Left:=IR.Left-IRLabel.Width-2;
  IRLabel.Top:=IR.Top-4;
  IR1Label.Left:=IR1.Left-IR1Label.Width-2;
  IR1Label.Top:=IR1.Top-4;
  ST1Label.Left:=IR1.Left-ST1Label.Width-2;
  ST1Label.Top:=ST1.Top-11;
  IR2Label.Left:=IR2.Left-IR2Label.Width-2;
  IR2Label.Top:=IR2.Top-4;
  ST2Label.Left:=IR2.Left-ST2Label.Width-2;
  ST2Label.Top:=ST2.Top-11;
  IR3Label.Left:=IR3.Left-IR3Label.Width-2;
  IR3Label.Top:=IR3.Top-4;
  ST3Label.Left:=IR3.Left-ST3Label.Width-2;
  ST3Label.Top:=ST3.Top-11;
  DmemLabel1.Top:=Dmem.Top+6;
  DmemLabel2.Top:=Dmem.Top+24;
  DmemLabel3.Top:=Dmem.Top+48;
  ImemLabel1.Top:=Imem.Top+6;
  ImemLabel2.Top:=Imem.Top+24;
  ImemLabel3.Top:=Imem.Top+48;
  ALULabel.Left:=ALU.Left+24;
  ALULabel.Top:=ALU.Top+ALU.Height-14;
  { Draw Lines }
  LineBox1.ClearWires;
  LineBox2.ClearWires;
  LineBox3.ClearWires;
  LineBox4.ClearWires;
  LineBox5.ClearWires;
  LineBox6.ClearWires;
  W:=PC.Width;
  H:=PC.Top+10;
  if PSimulator<>nil then
  begin
    LineBox1.AddWire(PSimulator.PC,false,Point(PC.Left+W,PC.Top+10),true,[PC1.Left]);
    LineBox1.AddWire(PSimulator.PC,true,Point((PC.Left+W+RegFile.Left) div 2,H),false,
      [IncrMux.Position[0],IncrMux.Left+IncrMux.Width-1]);
    LineBox1.AddWire(PSimulator.PC1,false,Point(PC1.Left+W div 2,PC1.Top),false,
      [(S1Mux.Top+CompMux.Top+CompMux.Height) div 2,S1Mux.Left+1,S1Mux.Position[0]]);
    LineBox1.AddWire(PSimulator.AMux,false,Point(AMux.Left+AMux.Width,S1Mux.Position[1]),true,[A.Left]);
    LineBox1.AddWire(PSimulator.A,false,Point(A.Left+A.Width,S1Mux.Position[1]),true,[S1Mux.Left]);
    LineBox1.AddWire(PSimulator.B,true,Point(B.Left+69,S2Mux.Position[2]),false,
      [CompMux.Position[0],CompMux.Left]);
    H:=WBMux.Top+11;
    LineBox1.AddWire(PSimulator.WBMux,false,Point(WBMux.Left,H),true,[RegFile.Left+RegFile.Width]);
    LineBox1.AddWire(PSimulator.WBMux,true,Point(A.Left+78,H),false,
      [CompMux.Position[1],CompMux.Left]);
    LineBox1.AddWire(PSimulator.WBMux,true,Point(A.Left+78,S1Mux.Position[2]),true,[S1Mux.Left]);
    LineBox1.AddWire(PSimulator.WBMux,true,Point(A.Left+78,S2Mux.Position[0]),true,[S2Mux.Left]);
    LineBox1.AddWire(PSimulator.WBMux,true,Point(AMux.Left-10,H),false,[AMux.Position[1],AMux.Left]);
    LineBox1.AddWire(PSimulator.WBMux,true,Point(AMux.Left-10,BMux.Position[1]),true,[BMux.Left]);
    H:=RES1.Top+10;
    LineBox1.AddWire(PSimulator.RES1,false,Point(RES1.Left,H),true,[RES2.Left]);
    LineBox1.AddWire(PSimulator.RES2,false,Point(RES2.Left,H),true,
      [RES2.Left+RES2.Width+10,WBMux.Position[0],WBMux.Left+WBMux.Width-2]);
    H2:=Datapath.Height-26;
    LineBox1.AddWire(PSimulator.RES1,true,Point((RES1.Left+RES1.Width+RES2.Left) div 2,H),false,
      [H2,(PC.Left+W+RegFile.Left) div 2,IncrMux.Position[1],IncrMux.Left+IncrMux.Width-1]);
    LineBox1.AddWire(PSimulator.RES1,true,Point(A.Left+87,H2),false,[CompMux.Position[2],CompMux.Left]);
    LineBox1.AddWire(PSimulator.RES1,true,Point(A.Left+87,S1Mux.Position[3]),true,[S1Mux.Left]);
    LineBox1.AddWire(PSimulator.RES1,true,Point(A.Left+87,S2Mux.Position[1]),true,[S2Mux.Left]);
    LineBox1.AddWire(PSimulator.BMux,false,Point(BMux.Left+BMux.Width,S2Mux.Position[2]),true,[B.Left]);
    LineBox1.AddWire(PSimulator.B,false,Point(B.Left+B.Width,S2Mux.Position[2]),true,[S2Mux.Left]);
    LineBox1.AddWire(PSimulator.RegFile,false,Point(RegFile.Left,AMux.Position[0]),true,[AMux.Left]);
    LineBox1.AddWire(PSimulator.RegFileBis,false,Point(RegFile.Left,BMux.Position[0]),true,[BMux.Left]);
    LineBox1.AddWire(PSimulator.SignExtend,false,Point(S2Mux.Left+1,S2Mux.Position[3]),false,
      [SignExtend.Top+8,SignExtend.Left+2]);
    LineBox1.AddWire(PSimulator.IR1,false,Point(SignExtend.Left+8,SignExtend.Top+16),false,[Datapath.Height]);
    H:=IncrMux.Top+11;
    LineBox1.AddWire(PSimulator.Incr,false,Point(Incr.Left,H),true,[8,PC.Top+10,PC.Left]);
    LineBox1.AddWire(PSimulator.IncrMux,false,Point(IncrMux.Left,H),true,[Incr.Left+Incr.Width]);
    W:=(Incr.Left+Incr.Width+IncrMux.Left) div 2;
    LineBox1.AddWire(PSimulator.IncrMux,true,Point(W,H),false,[Datapath.Height]);
    LineBox2.AddWire(PSimulator.IncrMux,false,Point(W+2,0),false,[Imem.Top]);
    H:=SMDR.Top+10;
    LineBox1.AddWire(PSimulator.CompMux,false,Point(CompMux.Left+CompMux.Width,H),true,[SMDR.Left]);
    H2:=COND.Top+10;
    LineBox1.AddWire(PSimulator.CompMux,true,Point((CompMux.Left+CompMux.Width+Comp.Left) div 2,H),false,
      [H2,Comp.Left]);
    LineBox1.AddWire(PSimulator.Comp,false,Point(Comp.Left+Comp.Width,H2),true,[COND.Left]);
    LineBox1.AddWire(PSimulator.S1Mux,false,Point(S1Mux.Left+S1Mux.Width,S1Mux.Top+20),true,[ALU.Left]);
    LineBox1.AddWire(PSimulator.S2Mux,false,Point(S2Mux.Left+S2Mux.Width,S2Mux.Top+20),true,[ALU.Left]);
    LineBox1.AddWire(PSimulator.LMDR,false,Point(LMDR.Left+LMDR.Width,LMDR.Top+10),true,
      [LMDR.Left+LMDR.Width+20,WBMux.Position[1],WBMux.Left+WBMux.Width-1]);
    LineBox1.AddWire(PSimulator.SMDR,false,Point(SMDR.Left+SMDR.Width,SMDR.Top+10),true,
      [SMDR.Left+SMDR.Width+7,Dmem.Top+LineBox1toLineBox4YAdj+10,LineBox4.Left]);
    LineBox1.AddWire(PSimulator.MAR,false,Point(MAR.Left+MAR.Width,MAR.Top+10),true,
      [MAR.Left+MAR.Width+17,Dmem.Top+(MAR.Top-SMDR.Top)+LineBox1toLineBox4YAdj+10,LineBox4.Left]);
    X1:=LMDR.Left-10;
    X2:=LineBox4.Left+Dmem.Left+Dmem.Width+10;
    if X1>X2 then
    begin
      X1:=(X1+X2) div 2;
      X2:=X1
    end;
    H:=Dmem.Top+Dmem.Height div 2+10;
    LineBox1.AddWire(PSimulator.Dmem,false,Point(X2+LineBox1toLineBox4XAdj,Mask1.Top+Mask1.Height),false,
      [(H+LMDRLabel.Top-LineBox1toLineBox4YAdj) div 2,X1,LMDR.Top+10,LMDR.Left]);
    W:=(ALU.Left+ALU.Width+RES1.Left) div 2;
    LineBox1.AddWire(PSimulator.ALU,false,Point(RES1.Left,RES1.Top+10),true,
      [W,MAR.Top+10,MAR.Left]);
    LineBox1.AddWire(PSimulator.ALU,true,Point(W,ALU.Top+42),true,[ALU.Left+ALU.Width]);
    H:=IR.Top+10;
    LineBox2.AddWire(PSimulator.Imem,false,Point(Imem.Left+Imem.Width,H+18),true,[LineBox2.Width]);
    LineBox3.AddWire(PSimulator.Imem,false,Point(0,H),true,[IR.Left]);
    LineBox3.AddWire(PSimulator.IR,false,Point(IR.Left+IR.Width,H),true,[IR1.Left]);
    LineBox3.AddWire(PSimulator.IR1,false,Point(IR1.Left+IR1.Width,H),true,[IR2.Left]);
    LineBox3.AddWire(PSimulator.IR1,true,Point(SignExtend.Left+8-Control.Left,H),false,[0]);
    LineBox3.AddWire(PSimulator.IR2,false,Point(IR2.Left+IR2.Width,H),true,[IR3.Left]);
    LineBox3.AddWire(PSimulator.IR,true,Point(Decoder.Left+8,H),false,[Decoder.Top]);
    H:=ST1.Top+10;
    LineBox3.AddWire(PSimulator.DecoderY,false,Point(Decoder.Left+Decoder.Width,H),true,[ST1.Left]);
    LineBox3.AddWire(PSimulator.STY1,false,Point(ST1.Left+ST1.Width,H),true,[Null1.Left]);
    LineBox3.AddWire(PSimulator.Null1Y,false,Point(Null1.Left+Null1.Width,H),true,[ST2.Left]);
    LineBox3.AddWire(PSimulator.STY2,false,Point(ST2.Left+ST2.Width,H),true,[Null2.Left]);
    LineBox3.AddWire(PSimulator.Null2Y,false,Point(Null2.Left+Null2.Width,H),true,[ST3.Left]);
    LineBox4.AddWire(PSimulator.SMDR,false,Point(0,Dmem.Top+10),true,[Dmem.Left]);
    LineBox4.AddWire(PSimulator.MAR,false,Point(0,Dmem.Top+(MAR.Top-SMDR.Top)+10),true,[Dmem.Left]);
    LineBox4.AddWire(PSimulator.Dmem,false,Point(Dmem.Left+Dmem.Width,Dmem.Top+Dmem.Height div 2),true,
      [X2-LineBox4.Left,Mask1.Top+Mask1.Height-LineBox1toLineBox4YAdj]);
    LineBox5.AddWire(PSimulator.IR1,false,Point(8,0),false,[LineBox5.Height]);
    LineBox6.AddWire(PSimulator.IR1,false,Point(8,0),false,[LineBox6.Height]);
  end;
  LineBox4.Refresh;
  { Show Register File }
  if PSimulator<>nil then
    PSimulator.RegFile.Show(-1)
end;

procedure TPipeForm.FormCreate(Sender: TObject);
var
  W: Integer;
begin
  { Size Registers }
  W:=Courier9Width*8+12;
  PC.Width:=W;
  PC1.Width:=W;
  A.Width:=W;
  B.Width:=W;
  COND.Width:=Courier9Width+9;
  SMDR.Width:=W;
  MAR.Width:=W;
  RES1.Width:=W;
  LMDR.Width:=W;
  RES2.Width:=W;
  RewindCheck.Checked:=true;
  GenTrace.Checked:=false;
  Application.CreateForm(TPipeCode, PipeCode);
  PipeCode.Hide;
  PSimulator:=TPSimulator.Create(RewindButton, RewindCheck, GenTrace,
              MultiCycle,MultiCycleCheck, Clock, false);
  RewindCheck.Checked:=true;
  RewindCheck2.Checked:=true;
  GenTrace.Checked:=false;
  GenTrace2.Checked:=false;
  SetDelaySlotSize(0);
  SetEnableForwarding(true);
  DisableTrace;
  TraceDialog:=SaveDialog2;
  ClearProject;
end;

procedure TDecoderX.Connect(Inputs: array of TDataSource);
begin
  IR:=Inputs[0];
  Comp:=Inputs[1];
  Cond:=Inputs[2];
end;

function TDecoderX.GetValue: LongInt;
{ STX[7-0] = RA
  STX[15-8] = RB
  STX[23-16] = RC
  STX[24] = 1 when WB required
  STX[25] = 1 when S1 source is A
  STX[26] = 1 when S2 source is B
  STX[27] = 1 when RRA required
  STX[28] = 1 when RRB required
  STX[31] = 0 when Nullified
  STY[7-0] = ExtendSize
  STY[15-8] = ALU Func
  STY[23-16] = Comp Func
  STY[31-24 = Dmem Func              }
var
  Opcode: Integer;
  FormalA: Integer;
  FormalB: Integer;
  FormalC: Integer;
  Instr: LongInt;
begin
  Instr:=IR.Value;
  Opcode:=Unravel.Opcode(Instr);
  FormalA:=PipeCode.Formal(Opcode,foA);
  FormalB:=PipeCode.Formal(Opcode,foB);
  FormalC:=PipeCode.Formal(Opcode,foC);
  Result:=Unravel.Register(Instr,FormalA)+Unravel.Register(Instr,FormalB) shl 8 +
          LongInt(Unravel.Register(Instr,FormalC)) shl 16 + $80000000;
  if FormalC>0 then
    Result:=Result+$1000000;
  if PipeCode.SSource(Opcode,1)=1 then
    Result:=Result+$2000000;
  if PipeCode.SSource(Opcode,2)=1 then
    Result:=Result+$4000000;
  if FormalA>0 then
    Result:=Result+$8000000;
  if FormalB>0 then
    Result:=Result+$10000000;
  RecentYValue:=PipeCode.ExtendSize(Opcode)+PipeCode.Func(Opcode,reALU) shl 8 +
                LongInt(PipeCode.Func(Opcode,reCmp)) shl 16 +
                LongInt(PipeCode.Func(Opcode,reMem)) shl 24;
  if ((PipeForm.DelaySlot<1) and (Comp.Value<>0)) or
     ((PipeForm.DelaySlot<2) and (Cond.Value<>0)) or
     (ActualClock=0) then { nullify first instruction in ID stage }
   Result:=Result and $7FFFFFFF
end;

procedure TDecoderY.Connect(Inputs: array of TDataSource);
begin
  STX:=Inputs[0] as TDataSource
end;

function TDecoderY.GetValue: LongInt;
begin
  STX.Value; {To make sure DecoderX.RecentYValue is recent}
  Result:=(STX as TDecoderX).RecentYValue
end;

function TSTYCombiSource.Null: Boolean;
begin
  Result:=(STX.Value>=0)
end;

function TSTYCombiSource.ActualA: Integer;
begin
  if (STX.Value and $8000000)>0 then
    Result:=STX.Value and $FF
  else
    Result:=-1
end;

function TSTYCombiSource.ActualB: Integer;
begin
  if (STX.Value and $10000000)>0 then
    Result:=(STX.Value shr 8) and $FF
  else
    Result:=-1
end;

function TSTYCombiSource.ActualC: Integer;
begin
  Result:=(STX.Value shr 16) and $FF
end;

function TSTYCombiSource.WBRequired: Boolean;
begin
  Result:=((STX.Value and $1000000)>0)
end;

function TSTYCombiSource.S1Source: Boolean;
begin
  Result:=((STX.Value and $2000000)>0)
end;

function TSTYCombiSource.S2Source: Boolean;
begin
  Result:=((STX.Value and $4000000)>0)
end;

function TSTYCombiSource.RRARequired: Boolean;
begin
  Result:=((STX.Value and $8000000)>0)
end;

function TSTYCombiSource.RRBRequired: Boolean;
begin
  Result:=((STX.Value and $10000000)>0)
end;

function TSTYCombiSource.CmpFunc: Integer;
begin
  Result:=(Value shr 16) and $FF
end;

function TSTYCombiSource.ExtSize: Integer;
begin
  Result:=Value and $FF
end;

function TSTYCombiSource.ALUFunc: Integer;
begin
  Result:=(Value shr 8) and $FF
end;

function TSTYCombiSource.MemFunc: Integer;
begin
  Result:=(Value shr 24) and $FF
end;

procedure TSTYCombiSource.Connect(Inputs: array of TDataSource);
begin
  STX:=Inputs[0];
  STYin:=Inputs[1];
end;

function TSTYCombiSource.GetValue: LongInt;
begin
  Result:=STYin.Value;
  if (Viewer<>nil) and ShowValues then
    (Viewer as TRegBox).Text:=StrValue
end;

function TSTYCombiSource.StrValue: string;
var
  Fun: Integer;
begin
  if Null then
    Result:='NULL'
  else begin
    Result:='';
    if RRARequired then
      Result:='+RRA['+IntToStr(ActualA)+']';
    if RRBRequired then
      Result:=Result+'+RRB['+IntToStr(ActualB)+']';
    Fun:=CmpFunc;
    if Fun<>NOP then
      Result:=Result+'+Cmp['+CompOperation[Fun]+']';
    if ExtSize>=8 then
      Result:=Result+'+Ext['+IntToStr(ExtSize)+']';
    Fun:=ALUFunc;
    if Fun<>NOP then
    begin
      Result:=Result+'+ALU['+AluOperation[Fun]+',';
      if S1Source then
       Result:=Result+'A,'
      else
        Result:=Result+'PC1,';
      if S2Source then
        Result:=Result+'B]'
      else
        Result:=Result+'IR]'
    end;
    Fun:=MemFunc;
    if Fun<>NOP then
      Result:=Result+'+Mem['+MemOperation[Fun-4]+']';
    if WBRequired then
      Result:=Result+'+RW['+IntToStr(ActualC)+']';
    Result:=Copy(Result,2,1000)
  end
end;

procedure TABMuxSelect.SetMux(M: TMetaFormal);
begin
  Mux:=M
end;

procedure TABMuxSelect.Connect(Inputs: array of TDataSource);
begin
  STY0:=Inputs[0] as TSTYCombiSource;
  STY1:=Inputs[1] as TSTYCombiSource;
  IDStall:=Inputs[2];
  STY3:=Inputs[3] as TSTYCombiSource;
  WBStall:=Inputs[4]
end;

function TABMuxSelect.GetValue: LongInt;
var
  Actual: integer;
  STY: TSTYCombiSource;
begin
  Result:=0;
  if (not STY3.Null) and STY3.WBRequired and
    (WBStall.Value<>0) then
  begin
    if IDStall.Value<>0 then
      STY:=STY0
    else
      STY:=STY1;
    if Mux=foA then
      Actual:=STY.ActualA
    else
      Actual:=STY.ActualB;
    if Actual=STY3.ActualC then
      Result:=1
  end
end;

procedure TCompS1S2MuxSelect.SetMux(M: TMuxSource);
begin
  Mux:=M
end;

procedure TCompS1S2MuxSelect.Connect(Inputs: array of TDataSource);
begin
  STY1:=Inputs[0] as TSTYCombiSource;
  STY2:=Inputs[1] as TSTYCombiSource;
  STY3:=Inputs[2] as TSTYCombiSource
end;

function TCompS1S2MuxSelect.GetValue: LongInt;
var
  Actual: Integer;
  Forwarding: Integer;
begin
  if (Mux=msS1) and (not STY1.S1Source) and (not STY1.Null) then
    Result:=0
  else if (Mux=msS2) and (not STY1.S2Source) and (not STY1.Null) then
    Result:=3
  else
  begin
    Result:=Ord(Mux);
    if PipeForm.Forwarding then
    begin
      Forwarding:=0;
      if Mux=msS1 then
        Actual:=STY1.ActualA
      else
        Actual:=STY1.ActualB;
      if (not STY2.Null) and (STY2.WBRequired) and (Actual=STY2.ActualC) then
        Forwarding:=2
      else if (not STY3.Null) and (STY3.WBRequired) and (Actual=STY3.ActualC) then
        Forwarding:=1;
      if Forwarding>0 then
        case Mux of
          msCmp, msS1: Result:=Result+Forwarding;
                 msS2: Result:=Forwarding-1
          end
    end
  end
end;

procedure TWBMuxSelect.Connect(Inputs: array of TDataSource);
begin
  STY3:=Inputs[0] as TSTYCombiSource
end;

function TWBMuxSelect.GetValue: LongInt;
begin
  if (STY3.MemFunc>=READBYTE) and (STY3.MemFunc<=READWORD) then
    Result:=1
  else
    Result:=0
end;

procedure TResourceFunc.SetResource(R: TResource);
begin
  Resource:=R
end;

procedure TResourceFunc.Connect(Inputs: array of TDataSource);
begin
  STY:=Inputs[0] as TSTYCombiSource
end;

function TResourceFunc.GetValue: LongInt;
begin
  case Resource of
    reCmp: Result:=STY.CmpFunc;
    reAlu: Result:=STY.ALUFunc
  else {reMem:} if STY.Null then
                  Result:=NOP
                else
                  Result:=STY.MemFunc
  end
end;

procedure TCompFunc.Connect(Inputs: array of TDataSource);
begin
  STY1:=Inputs[0] as TSTYCombiSource
end;

function TCompFunc.GetValue: LongInt;
begin
  if STY1.Null then
    Result:=0
  else
    Result:=STY1.CmpFunc
end;

procedure TActual.SetFormal(F: TMetaFormal);
begin
  Formal:=F
end;

procedure TActual.Connect(Inputs: array of TDataSource);
begin
  STY:=Inputs[0] as TSTYCombiSource;
  Stall:=Inputs[1]
end;

function TActual.GetValue: LongInt;
begin
  Result:=-1;
  case Formal of
    foA: begin
           if STY.RRARequired then
             Result:=STY.ActualA
         end;
    foB: begin
           if STY.RRBRequired then
             Result:=STY.ActualB
           end
    else begin
           if STY.WBRequired and (not STY.Null) and (Stall.Value<>0) then { foC }
             Result:=STY.ActualC
         end
  end
end;

procedure TExtendSize.Connect(Inputs: array of TDataSource);
begin
  STY1:=Inputs[0] as TSTYCombiSource
end;

function TExtendSize.GetValue: LongInt;
begin
  Result:=STY1.ExtSize
end;

procedure TNullifier.Connect(Inputs: array of TDataSource);
begin
  STY:=Inputs[0];
  Stall:=Inputs[1]
end;

function TNullifier.GetValue: LongInt;
begin
  if Stall.Value<>0 then
    Result:=STY.Value
  else
    Result:=0
end;

procedure TEXStallControl.Connect(Inputs: array of TDataSource);
begin
  MemStall:=Inputs[0];
  WBStall:=Inputs[1];
  STY1:=Inputs[2] as TSTYCombiSource;
  STY2:=Inputs[3] as TSTYCombiSource;
  STY3:=Inputs[4] as TSTYCombiSource
end;

function TEXStallControl.GetValue: LongInt;
var
  Actual: Integer;
  i: Integer;
begin
  Result:=1;
  if (not STY1.Null) or (ConfigForm.StallControl.ItemIndex=1) then
  begin
    if MemStall.Value=0 then
      Result:=0
    else begin
      for i:=0 to 1 do
      begin
        if i=1 then
          Actual:=STY1.ActualA
        else
          Actual:=STY1.ActualB;
        if ((not STY2.Null) and (STY2.WBRequired) and ((STY2.MemFunc>=READBYTE) and
            (STY2.MemFunc<=READWORD) or not PipeForm.Forwarding) and (Actual=STY2.ActualC)) or
           ((not STY3.Null) and (STY3.WBRequired) and ((WBStall.Value=0) or
            not PipeForm.Forwarding) and (Actual=STY3.ActualC)) then
        begin
          Result:=0;
          break
        end;
      end
    end
  end
end;

procedure TMemStallControl.Connect(Inputs: array of TDataSource);
begin
  NextStall:=Inputs[0];
  STY2:=Inputs[1] as TSTYCombiSource;
  DelayedMemBusy:=Inputs[2]
end;

function TMemStallControl.GetValue: LongInt;
begin
  if ((not STY2.Null) or (ConfigForm.StallControl.ItemIndex=1)) and
     ((NextStall.Value=0) or (STY2.MemFunc<>NOP) and (DelayedMemBusy.Value<>0)) then
    Result:=0
  else
    Result:=1
end;

procedure TEX2MemStallControl.Connect(Inputs: array of TDataSource);
begin
  EXStall:=Inputs[0];
  MemStall:=Inputs[1];
  Cond:=Inputs[2]
end;

function TEX2MemStallControl.GetValue: LongInt;
begin
  if (MemStall.Value=0) or ((Cond.Value=1) and (EXStall.Value=0)) then
    Result:=0
  else
    Result:=1
end;

procedure TWBStallControl.Connect(Inputs: array of TDataSource);
begin
  STY3:=Inputs[0] as TSTYCombiSource;
  DelayedMemBusy:=Inputs[1]
end;

function TWBStallControl.GetValue: LongInt;
begin
  if (not STY3.Null) and (DelayedMemBusy.Value<>0) and
     (STY3.MemFunc>=READBYTE) and (STY3.MemFunc<=READWORD) then
    Result:=0
  else
    Result:=1
end;

constructor TPSimulator.Create(RwndBtn: TButton; RwndChk: TMenuItem;
       GenTrace: TMenuItem; MltCyc: TSpinEdit; MltCycChk: TCheckBox;
       Clk: TEditInteger; ChkStab: Boolean);
var
  i: Integer;
begin
  CodeMemory:=TMemoryInterface.Create(ctCode);
  DataMemory:=TMemoryInterface.Create(ctData);
  CodeCaptionBase:='Instruction Memory';
  DataCaptionBase:='Data Memory';
  inherited Create(RwndBtn, RwndChk, GenTrace, MltCyc, MltCycChk, Clk, false);

  PC:=TReg.Create(PipeForm.PC,'PC');
  PC1:=TReg.Create(PipeForm.PC1,'PC1');
  A:=TReg.Create(PipeForm.A,'A');
  B:=TReg.Create(PipeForm.B,'B');
  COND:=TReg.Create(PipeForm.COND,'COND');
  SMDR:=TReg.Create(PipeForm.SMDR,'SMDR');
  MAR:=TReg.Create(PipeForm.MAR,'MAR');
  RES1:=TReg.Create(PipeForm.RES1,'RES1');
  LMDR:=TReg.Create(PipeForm.LMDR,'LMDR');
  RES2:=TReg.Create(PipeForm.RES2,'RES2');
  IR:=TRegIR.Create(PipeForm.IR,'IR');
  IR1:=TRegIR.Create(PipeForm.IR1,'IR1');
  IR2:=TRegIR.Create(PipeForm.IR2,'IR2');
  IR3:=TRegIR.Create(PipeForm.IR3,'IR3');
  STX1:=TReg.Create(nil,'');
  STX2:=TReg.Create(nil,'');
  STX3:=TReg.Create(nil,'');
  STYR1:=TReg.Create(PipeForm.ST1,'');
  STYR2:=TReg.Create(PipeForm.ST2,'');
  STYR3:=TReg.Create(PipeForm.ST3,'');
  STY1:=TSTYCombiSource.Create(PipeForm.ST1,'ST1');
  STY2:=TSTYCombiSource.Create(PipeForm.ST2,'ST2');
  STY3:=TSTYCombiSource.Create(PipeForm.ST3,'ST3');
  IncrMux:=TMux.Create(PipeForm.IncrMux,'PC Multiplexer');
  IM1:=TReg.Create(nil,'');
  IM2:=TReg.Create(nil,'');
  IM3:=TReg.Create(nil,'');
  IM4:=TReg.Create(nil,'');
  AMux:=TMux.Create(PipeForm.AMux,'A Explicit Write-Through Multiplexer');
  BMux:=TMux.Create(PipeForm.BMux,'B Explicit Write-Through Multiplexer');
  CompMux:=TMux.Create(PipeForm.CompMux,'Comparator & SMDR Multiplexer');
  S1Mux:=TMux.Create(PipeForm.S1Mux,'S1 Multiplexer');
  S2Mux:=TMux.Create(PipeForm.S2Mux,'S2 Multiplexer');
  WBMux:=TMux.Create(PipeForm.WBMux,'Write-Back Multiplexer');
  RegFile:=TRegFile.Create(PipeForm.RegFile,'Register File (port A)');
  RegFileBis:=TRegFileBis.Create(nil,'Register File (port B)');
  RegFileReadA:=TActual.Create(nil,'');
  RegFileReadB:=TActual.Create(nil,'');
  RegFileWrite:=TActual.Create(nil,'');
  Incr:=TIncrementor.Create(nil,'PC Incrementer');
  Comp:=TComparator.Create(PipeForm.CompLabel,'Comparator');
  Alu:=TAlu.Create(PipeForm.AluLabel,'ALU');
  SignExtend:=TSignExtend.Create(nil,'Sign Extender');
  Imem:=TRWMem.Create(PipeForm.ImemLabel3,'Instruction Memory');
  ImemAddress:=TRWMemAddress.Create(nil,'');
  ImemAddress1:=TRegIRPC.Create(nil,'');
  ImemAddress2:=TRegIRPC.Create(nil,'');
  ImemAddress3:=TRegIRPC.Create(nil,'');
  Dmem:=TRWMem.Create(PipeForm.Dmemlabel3,'Data Memory');
  DmemBusy:=TRWMemBusy.Create(nil,'');
  ConstantOne:=TConstant.Create(nil,'');
  DelayedDmemBusy:=TReg.Create(nil,'');
  AMuxSelect:=TABMuxSelect.Create(nil,'');
  BMuxSelect:=TABMuxSelect.Create(nil,'');
  CompMuxSelect:=TCompS1S2MuxSelect.Create(nil,'');
  S1MuxSelect:=TCompS1S2MuxSelect.Create(nil,'');
  S2MuxSelect:=TCompS1S2MuxSelect.Create(nil,'');
  WBMuxSelect:=TWBMuxSelect.Create(nil,'');
  AluFunc:=TResourceFunc.Create(nil,'');
  CompFunc:=TCompFunc.Create(nil,'');
  ExtendSize:=TExtendSize.Create(nil,'');
  ImemFunc:=TConstant.Create(nil,'');
  DmemFunc:=TResourceFunc.Create(nil,'');
  DecoderX:=TDecoderX.Create(nil,'');
  DecoderY:=TDecoderY.Create(nil,'Decoder');
  Null1X:=TNullifier.Create(nil,'');
  Null2X:=TNullifier.Create(nil,'');
  Null1Y:=TSTYCombiSource.Create(nil,'Nullator (EX stage)');
  Null2Y:=TSTYCombiSource.Create(nil,'Nullator (Mem stage)');
  WBStall:=TWBStallControl.Create(nil,'');
  MemStall:=TMemStallControl.Create(nil,'');
  EX2MemStall:=TEX2MemStallControl.Create(nil,'');
  EXStall:=TExStallControl.Create(nil,'');
  AEnable:=TOrGate.Create(nil,'');
  BEnable:=TOrGate.Create(nil,'');

  PC.Connect([EXStall,Incr]);
  PC1.Connect([EXStall,PC]);
  A.Connect([AEnable,AMux]);
  B.Connect([BEnable,BMux]);
  COND.Connect([EXStall,Comp]);
  COND.SetShowSize(1);
  SMDR.Connect([EX2MemStall,CompMux]);
  MAR.Connect([EX2MemStall,ALU]);
  RES1.Connect([EX2MemStall,ALU]);
  LMDR.Connect([ConstantOne,Dmem]);
  RES2.Connect([WBStall,RES1]);
  IR.Connect([EXStall,Imem,ImemAddress]);
  IR1.Connect([EXStall,IR,ImemAddress1]);
  IR2.Connect([EX2MemStall,IR1,ImemAddress2]);
  IR3.Connect([WBStall,IR2,ImemAddress3]);
  STX1.Connect([EXStall,DecoderX]);
  STX2.Connect([EX2MemStall,Null1X]);
  STX3.Connect([WBStall,Null2X]);
  STYR1.Connect([EXStall,DecoderY]);
  STYR1.SetShowSize(0);
  STYR2.Connect([EX2MemStall,STY1]);
  STYR2.SetShowSize(0);
  STYR3.Connect([WBStall,STY2]);
  STYR3.SetShowSize(0);
  STY1.Connect([STX1,STYR1]);
  STY2.Connect([STX2,STYR2]);
  STY3.Connect([STX3,STYR3]);
  IncrMux.Connect([COND,PC,RES1]);
  IM1.Connect([EXStall,IncrMux]);
  IM2.Connect([EXStall,IM1]);
  IM3.Connect([EX2MemStall,IM2]);
  IM4.Connect([WBStall,IM3]);
  AMux.Connect([AMuxSelect,RegFile,WBMux]);
  BMux.Connect([BMuxSelect,RegFileBis,WBMux]);
  CompMux.Connect([CompMuxSelect,B,WBMux,RES1]);
  S1Mux.Connect([S1MuxSelect,PC1,A,WBMux,RES1]);
  S2Mux.Connect([S2MuxSelect,WBMux,RES1,B,SignExtend]);
  WBMux.Connect([WBMuxSelect,RES2,LMDR]);
  RegFile.Connect([RegFileReadA,RegFileWrite,WBMux]);
  RegFileBis.Connect([RegFileReadB,RegFile]);
  RegFileReadA.Connect([DecoderY,nil]);
  RegFileReadA.SetFormal(foA);
  RegFileReadB.Connect([DecoderY,nil]);
  RegFileReadB.SetFormal(foB);
  RegFileWrite.Connect([STY3,WBStall]);
  RegFileWrite.SetFormal(foC);
  Incr.Connect([IncrMux]);
  Incr.SetIncrement(4);
  Comp.Connect([CompFunc,CompMux]);
  Alu.Connect([ALUFunc,S1Mux,S2Mux]);
  SignExtend.Connect([ExtendSize,IR1]);
  Imem.Connect([ImemFunc,IncrMux,IncrMux]);
  ImemAddress.Connect([Imem]);
  ImemAddress1.Connect([IR]);
  ImemAddress2.Connect([IR1]);
  ImemAddress3.Connect([IR2]);
  Imem.SetMemory(CodeMemory);
  Imem.SetSpeed(1);
  Dmem.Connect([DmemFunc,MAR,SMDR]);
  DmemBusy.Connect([Dmem]);
  DelayedDmemBusy.Connect([ConstantOne,DmemBusy]);
  ConstantOne.SetConstant(1);
  Dmem.SetMemory(DataMemory);
  Dmem.SetSpeed(PipeForm.DmemAccessTime);
  AMuxSelect.Connect([DecoderY,STY1,EXStall,STY3,WBStall]);
  AMuxSelect.SetMux(foA);
  BMuxSelect.Connect([DecoderY,STY1,EXStall,STY3,WBStall]);
  BMuxSelect.SetMux(foB);
  CompMuxSelect.Connect([STY1,STY2,STY3]);
  CompMuxSelect.SetMux(msCmp);
  S1MuxSelect.Connect([STY1,STY2,STY3]);
  S1MuxSelect.SetMux(msS1);
  S2MuxSelect.Connect([STY1,STY2,STY3]);
  S2MuxSelect.SetMux(msS2);
  WBMuxSelect.Connect([STY3]);
  AluFunc.Connect([STY1]);
  AluFunc.SetResource(reALU);
  CompFunc.Connect([STY1]);
  ExtendSize.Connect([STY1]);
  ImemFunc.SetConstant(READWORD);
  DmemFunc.Connect([STY2]);
  DmemFunc.SetResource(reMem);
  DecoderX.Connect([IR,Comp,COND]);
  DecoderY.Connect([DecoderX]);
  Null1X.Connect([STX1,EXStall]);
  Null2X.Connect([STX2,EX2MemStall]);
  Null1Y.Connect([Null1X,STYR1]);
  Null2Y.Connect([Null2X,STYR2]);
  WBStall.Connect([STY3,DelayedDmemBusy]);
  MemStall.Connect([WBStall,STY2,DelayedDmemBusy]);
  EX2MemStall.Connect([EXStall,MemStall,COND]);
  EXStall.Connect([MemStall,WBStall,STY1,STY2,STY3]);
  AEnable.Connect([EXStall,AMuxSelect]);
  BEnable.Connect([EXStall,BMuxSelect]);
  for i:=0 to NumBreakPoints div 2-1 do
  begin
    BreakForm.ORBox[i].Items.AddObject('PC',PC);
    BreakForm.ORBox[i].Items.AddObject('PC1',PC1);
    BreakForm.ORBox[i].Items.AddObject('COND',COND);
    BreakForm.ORBox[i].Items.AddObject('A',A);
    BreakForm.ORBox[i].Items.AddObject('B',B);
    BreakForm.ORBox[i].Items.AddObject('RES1',RES1);
    BreakForm.ORBox[i].Items.AddObject('RES2',RES2);
    BreakForm.ORBox[i].Items.AddObject('SMDR',SMDR);
    BreakForm.ORBox[i].Items.AddObject('MAR',MAR);
    BreakForm.ORBox[i].Items.AddObject('LMDR',LMDR);
    BreakForm.ORBox[i].Items.AddObject('IR',IR);
    BreakForm.ORBox[i].Items.AddObject('IR1',IR1);
    BreakForm.ORBox[i].Items.AddObject('IR2',IR2);
    BreakForm.ORBox[i].Items.AddObject('IR3',IR3);
    BreakForm.OrBox[i].ItemIndex:=i
  end
end;

destructor TPSimulator.Destroy;
begin
  PC.Free;
  PC1.Free;
  A.Free;
  B.Free;
  COND.Free;
  SMDR.Free;
  MAR.Free;
  RES1.Free;
  LMDR.Free;
  RES2.Free;
  IR.Free;
  IR1.Free;
  IR2.Free;
  IR3.Free;
  STX1.Free;
  STX2.Free;
  STX3.Free;
  STYR1.Free;
  STYR2.Free;
  STYR3.Free;
  STY1.Free;
  STY2.Free;
  STY3.Free;
  IncrMux.Free;
  IM1.Free;
  IM2.Free;
  IM3.Free;
  IM4.Free;
  AMux.Free;
  BMux.Free;
  CompMux.Free;
  S1Mux.Free;
  S2Mux.Free;
  WBMux.Free;
  RegFile.Free;
  RegFileBis.Free;
  RegFileReadA.Free;
  RegFileReadB.Free;
  RegFileWrite.Free;
  Incr.Free;
  Comp.Free;
  Alu.Free;
  SignExtend.Free;
  Imem.Free;
  ImemAddress.Free;
  ImemAddress1.Free;
  ImemAddress2.Free;
  ImemAddress3.Free;
  Dmem.Free;
  DmemBusy.Free;
  ConstantOne.Free;
  DelayedDmemBusy.Free;
  AMuxSelect.Free;
  BMuxSelect.Free;
  CompMuxSelect.Free;
  S1MuxSelect.Free;
  S2MuxSelect.Free;
  WBMuxSelect.Free;
  AluFunc.Free;
  CompFunc.Free;
  ExtendSize.Free;
  ImemFunc.Free;
  DmemFunc.Free;
  DecoderX.Free;
  DecoderY.Free;
  Null1X.Free;
  Null2X.Free;
  Null1Y.Free;
  Null2Y.Free;
  WBStall.Free;
  MemStall.Free;
  EXStall.Free;
  AEnable.Free;
  BEnable.Free;

  inherited Destroy;
  CodeMemory.Free;
  DataMemory.Free;
end;

procedure TPipeForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if SaveFirst then
  begin
    PSimulator.Destroy;
    PipeCode.Destroy;
    PSimulator:=nil;
    Action:=caFree;
    if EnablePipelineDiagrams1.Checked then
    begin
      ActivityForm.Destroy;
      UsageForm.Destroy
    end;
    MainForm.Show
  end else
    Action:=caNone
end;

procedure TPipeForm.InstructionMemory1Click(Sender: TObject);
begin
  ImemForm.Show
end;

procedure TPipeForm.DataMemory1Click(Sender: TObject);
begin
  DmemForm.Show
end;

procedure TPSimulator.Evaluate;
begin
  ALU.Value;
  PC.Evaluate;
  PC1.Evaluate;
  A.Evaluate;
  B.Evaluate;
  COND.Evaluate;
  SMDR.Evaluate;
  MAR.Evaluate;
  RES1.Evaluate;
  LMDR.Evaluate;
  RES2.Evaluate;
  IR.Evaluate;
  IR1.Evaluate;
  IR2.Evaluate;
  IR3.Evaluate;
  STX1.Evaluate;
  STX2.Evaluate;
  STX3.Evaluate;
  STYR1.Evaluate;
  STY1.GetValue;    { To make sure the register content is shown properly }
  STYR2.Evaluate;
  STY2.GetValue;
  STYR3.Evaluate;
  STY3.GetValue;
  RegFile.Evaluate;
  Dmem.Evaluate;
  DelayedDmemBusy.Evaluate;
  Imem.Evaluate;
  IM1.Evaluate;
  IM2.Evaluate;
  IM3.Evaluate;
  IM4.Evaluate;
end;

procedure TPSimulator.Reset;
begin
  inherited Reset;
  PC.Reset;
  PC1.Reset;
  A.Reset;
  B.Reset;
  COND.Reset;
  SMDR.Reset;
  MAR.Reset;
  RES1.Reset;
  LMDR.Reset;
  RES2.Reset;
  IR.Reset;
  IR1.Reset;
  IR2.Reset;
  IR3.Reset;
  STX1.Reset;
  STX2.Reset;
  STX3.Reset;
  STYR1.Reset;
  STYR2.Reset;
  STYR3.Reset;
  STY1.Reset;
  STY2.Reset;
  STY3.Reset;
  IncrMux.Reset;
  IM1.Reset;
  IM2.Reset;
  IM3.Reset;
  IM4.Reset;
  AMux.Reset;
  BMux.Reset;
  CompMux.Reset;
  S1Mux.Reset;
  S2Mux.Reset;
  WBMux.Reset;
  RegFile.Reset;
  RegFileReadA.Reset;
  RegFileReadB.Reset;
  RegFileWrite.Reset;
  Incr.Reset;
  Comp.Reset;
  Alu.Reset;
  SignExtend.Reset;
  Imem.Reset;
  ImemAddress.Reset;
  Dmem.Reset;
  DmemBusy.Reset;
  DelayedDmemBusy.Reset;
  AMuxSelect.Reset;
  BMuxSelect.Reset;
  CompMuxSelect.Reset;
  S1MuxSelect.Reset;
  S2MuxSelect.Reset;
  WBMuxSelect.Reset;
  AluFunc.Reset;
  CompFunc.Reset;
  ExtendSize.Reset;
  DmemFunc.Reset;
  DecoderX.Reset;
  DecoderY.Reset;
  Null1X.Reset;
  Null2X.Reset;
  Null1Y.Reset;
  Null2Y.Reset;
  WBStall.Reset;
  MemStall.Reset;
  EXStall.Reset;
  AEnable.Reset;
  BEnable.Reset;
  if PipeForm.EnablePipelineDiagrams1.Checked then
    ClearActivity
end;

procedure TPSimulator.Propagate;
begin
  inherited Propagate;
  PC.Propagate;
  PC1.Propagate;
  A.Propagate;
  B.Propagate;
  COND.Propagate;
  SMDR.Propagate;
  MAR.Propagate;
  RES1.Propagate;
  LMDR.Propagate;
  RES2.Propagate;
  IR.Propagate;
  IR1.Propagate;
  IR2.Propagate;
  IR3.Propagate;
  STX1.Propagate;
  STX2.Propagate;
  STX3.Propagate;
  STYR1.Propagate;
  STYR2.Propagate;
  STYR3.Propagate;
  RegFile.Propagate;
  Dmem.Propagate;
  DelayedDmemBusy.Propagate;
  Imem.Propagate;
  IM1.Propagate;
  IM2.Propagate;
  IM3.Propagate;
  IM4.Propagate;
  if PipeForm.EnablePipelineDiagrams1.Checked then
    TraceActivity
end;

procedure TPSimulator.Simulate(Clocks: LongInt);
begin
  inherited Simulate(Clocks);
  if PipeForm.EnablePipelineDiagrams1.Checked then
  begin
    ActivityForm.AddLines;
    UsageForm.AddLines
  end
end;

procedure TPipeForm.RewindCheckClick(Sender: TObject);
begin
  PSimulator.RewindCheckClick
end;

procedure TPipeForm.ResetButtonClick(Sender: TObject);
var
  Dummy: Boolean;
begin
  PipeCode.GridSelectCell(Sender,0,PipeCode.LastRow,Dummy);
  PSimulator.ResetClick
end;

procedure TPipeForm.ClockButtonClick(Sender: TObject);
begin
  PSimulator.ClockClick
end;

procedure TPipeForm.RewindButtonClick(Sender: TObject);
begin
  PSimulator.RewindClick
end;

procedure TPipeForm.ClockExit(Sender: TObject);
begin
  PSimulator.ClockChangedByUser
end;

procedure TPipeForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_RETURN) and Clock.Focused then
    ClockButton.SetFocus
end;

procedure TPipeForm.About1Click(Sender: TObject);
begin
  AboutBox
end;

procedure TPipeForm.GenTraceClick(Sender: TObject);
begin
  GenTrace.Checked:=not GenTrace.Checked;
  GenTrace2.Checked:=GenTrace.Checked
end;

procedure TPipeForm.EnableRewind1Click(Sender: TObject);
begin
  PSimulator.RewindCheckClick;
  RewindCheck2.Checked:=RewindCheck.Checked
end;

procedure TPipeForm.EnableForwarding1Click(Sender: TObject);
begin
  SetEnableForwarding(not EnableForwarding1.Checked);
  SetModify
end;

procedure TPipeForm.SetEnableForwarding(F: Boolean);
begin
  Forwarding:=F;
  EnableForwarding1.Checked:=F;
  EnableForwarding2.Checked:=F
end;

procedure TPipeForm.NoDelaySlot1Click(Sender: TObject);
begin
  SetDelaySlotSize(0)
end;

procedure TPipeForm.SingleDelaySlot1Click(Sender: TObject);
begin
  SetDelaySlotSize(1)
end;

procedure TPipeForm.DoubleDelaySlot1Click(Sender: TObject);
begin
  SetDelaySlotSize(2)
end;

procedure TPipeForm.SetDelaySlotSize(S: Integer);
begin
  if S<0 then
    S:=0
  else if S>2 then
    S:=2;
  DelaySlot:=S;
  NoDelaySlot1.Checked:=(S=0);
  SingleDelaySlot1.Checked:=(S=1);
  DoubleDelaySlot1.Checked:=(S=2);
  NoDelaySlot2.Checked:=(S=0);
  SingleDelaySlot2.Checked:=(S=1);
  DoubleDelaySlot2.Checked:=(S=2);
  SetModify
end;

procedure TPipeForm.Pipecode1Click(Sender: TObject);
begin
  PipeCode.Show
end;

procedure TPipeForm.BreakPoints1Click(Sender: TObject);
begin
  BreakForm.Show
end;

procedure TPipeForm.Exit1Click(Sender: TObject);
begin
  Close
end;

procedure TPipeForm.SetModify;
begin
  SaveProject1.Enabled:=true
end;

procedure TPipeForm.NewProject1Click(Sender: TObject);
begin
  if SaveFirst then
    ClearProject
end;

procedure TPipeForm.OpenProject1Click(Sender: TObject);
begin
  if SaveFirst and OpenDialog1.Execute then
    LoadProject
end;

procedure TPipeForm.SaveProject1Click(Sender: TObject);
begin
  if DmemForm.SaveFileClick and ImemForm.SaveFileClick and
     PipeCode.SaveFileClick then
  begin
    if SaveDialog1.FileName='Untitled.ppr' then
      SaveProjectAs1Click(Sender)
    else
      SaveProject
  end
end;

procedure TPipeForm.SaveProjectAs1Click(Sender: TObject);
begin
  if DmemForm.SaveFileClick and ImemForm.SaveFileClick and
     PipeCode.SaveFileClick and SaveDialog1.Execute then
    SaveProject
end;

function TPipeForm.SaveFirst: Boolean;
var
  Answer: Integer;
begin
  Result:=true;
  if SaveProject1.Enabled then
  begin
    Answer:=AppliMessage('Save changes to '+
           ExtractFileName(SaveDialog1.FileName)+'?','Confirm',$23);
    case Answer of
      6: begin
           if DmemForm.SaveFileClick and ImemForm.SaveFileClick and
              PipeCode.SaveFileClick then
           begin
             SaveProject1Click(PipeForm);
             Result:=not SaveProject1.Enabled
           end else
             Result:=false { User answered cancel while saving one of the three files }
         end;
      7: { no -> Don't do anything but return true }
    else
      Result:=false
    end
  end
end;

procedure TPipeForm.ShowCaption;
begin
  Caption:='Pipelined Architecture - '+ExtractFileName(SaveDialog1.FileName)
end;

procedure TPipeForm.ClearProject;
begin
  DmemForm.ClearMemory;
  ImemForm.ClearMemory;
  CodeMemory.ChangedAll;
  DataMemory.ChangedAll;
  PipeCode.ClearPipeCode;
  DMemAccessTime:=3;
  PSimulator.DMem.SetSpeed(DMemAccessTime);
  SaveDialog1.FileName:='Untitled.ppr';
  SaveProject1.Enabled:=false;
  PSimulator.ResetClick;
  ShowCaption
end;

procedure TPipeForm.LoadProject;
var
  Error: Boolean;
begin
  FileIO.UseFile(OpenDialog1.FileName);
  Reset(FileIO.F);
  Error:=false;
  PipeCode.OpenDialog1.FileName:=FileIO.ReadString('PipelineFunctionality',Error);
  ImemForm.OpenDialog1.FileName:=FileIO.ReadString('InstructionMemory',Error);
  DmemForm.OpenDialog1.FileName:=FileIO.ReadString('DataMemory',Error);
  DMemAccessTime:=FileIO.ReadInteger('MemoryAccessTime',Error);
  PSimulator.DMem.SetSpeed(DMemAccessTime);
  SetEnableForwarding(FileIO.ReadYesNo('Forwarding',Error));
  SetDelaySlotSize(FileIO.ReadInteger('DelaySlot',Error));
  CloseFile(FileIO.F);
  SaveDialog1.FileName:=OpenDialog1.FileName;
  ShowCaption;
  if Error then
    AppliMessage('File Format Corrupt; memory modules and pipeline functionality not loaded','Warning',$40)
  else begin
    DmemForm.LoadFile;
    ImemForm.LoadFile;
    PipeCode.LoadFile
  end;
  PSimulator.ResetClick;
  SaveProject1.Enabled:=false
end;

procedure TPipeForm.SaveProject;
begin
  FileIO.UseFile(SaveDialog1.FileName);
  Rewrite(FileIO.F);
  Writeln(FileIO.F,'[Pipelined Architecture Project]');
  FileIO.WriteString('PipelineFunctionality',RelativeDir(PipeCode.SaveDialog1.FileName));
  FileIO.WriteString('InstructionMemory',RelativeDir(ImemForm.SaveDialog1.FileName));
  FileIO.WriteString('DataMemory',RelativeDir(DmemForm.SaveDialog1.FileName));
  FileIO.WriteInteger('MemoryAccessTime',DMemAccessTime);
  FileIO.WriteYesNo('Forwarding',Forwarding);
  FileIO.WriteInteger('DelaySlot',DelaySlot);
  CloseFile(FileIO.F);
  SaveProject1.Enabled:=false;
  ShowCaption
end;

procedure TPipeForm.SetTraceFile1Click(Sender: TObject);
var
  F: TextFile;
begin
  if SaveDialog2.Execute then
  begin
    GenTrace.Enabled:=true;
    GenTrace2.Enabled:=true;
    AssignFile(F,SaveDialog2.FileName);
    Rewrite(F);
    CloseFile(F)
  end else
    DisableTrace
end;

procedure TPipeForm.DisableTrace;
begin
  GenTrace.Enabled:=false;
  GenTrace2.Enabled:=false
end;

procedure TPipeForm.DataMemoryAccessTime1Click(Sender: TObject);
var
  AccessTime: string;
begin
  AccessTime:=IntToStr(DMemAccessTime);
  if InputQuery('Memory Access Time','Enter Memory Access Time (1-9):',AccessTime) then
  begin
    DMemAccessTime:=StrToIntDef(AccessTime,1);
    if DMemAccessTime<1 then
      DMemAccessTime:=1
    else if DMemAccessTime>9 then
      DMemAccessTime:=9;
    PSimulator.DMem.SetSpeed(DMemAccessTime);
    SetModify;
    ResetButtonClick(Sender)
  end
end;

procedure TPipeForm.PipelineActivityDiagram1Click(Sender: TObject);
begin
  ActivityForm.Show
end;

procedure TPipeForm.EnablePipelineDiagrams1Click(Sender: TObject);
begin
  EnablePipelineDiagrams1.Checked:=not EnablePipelineDiagrams1.Checked;
  EnablePipelineDiagrams2.Checked:=EnablePipelineDiagrams1.Checked;
  PipelineActivityDiagram1.Enabled:=EnablePipelineDiagrams1.Checked;
  PipelineUsageDiagram1.Enabled:=EnablePipelineDiagrams1.Checked;
  PipelineActivityDiagram2.Enabled:=EnablePipelineDiagrams1.Checked;
  PipelineUsageDiagram2.Enabled:=EnablePipelineDiagrams1.Checked;
  if EnablePipelineDiagrams1.Checked then
  begin
    Application.CreateForm(TActivityForm, ActivityForm);
    Application.CreateForm(TUsageForm, UsageForm);
    PSimulator.ClearActivity;
    ActivityForm.Hide;
    UsageForm.Hide
  end else
  begin
    ActivityForm.Destroy;
    UsageForm.Destroy
  end;
end;

procedure TPSimulator.TraceActivity;
var
  f,d,e,m,w: LongInt;
begin
  if ActivityTime<ActualClock then
  begin
    f:=IncrMux.Value;
    d:=IM1.Value;
    e:=IM2.Value;
    m:=IM3.Value;
    w:=IM4.Value;
    if ActualClock=0 then
      d:=d or $80000000;
    if STX1.Value>=0 then
      e:=e or $80000000;
    if STX2.Value>=0 then
      m:=m or $80000000;
    if STX3.Value>=0 then
      w:=w or $80000000;
    if EXStall.Value=0 then
    begin
      f:=f or $40000000;
      d:=d or $40000000;
      e:=e or $40000000
    end;
    if MemStall.Value=0 then
      m:=m or $40000000;
    if WBStall.Value=0 then
      w:=w or $40000000;
    ActivityData[0,ActivityNextIndex]:=f;
    ActivityData[1,ActivityNextIndex]:=d;
    ActivityData[2,ActivityNextIndex]:=e;
    ActivityData[3,ActivityNextIndex]:=m;
    ActivityData[4,ActivityNextIndex]:=w;
    ActivityTime:=ActualClock;
    ActivityNextIndex:=(ActivityNextIndex+1) and 1023;
    if ActivityNextIndex=ActivityStartIndex then
    begin
      ActivityStartIndex:=(ActivityStartIndex+100) and 1023;
      ActivityStartTime:=ActivityStartTime+100;
      ActivityForm.Clear;
      ActivityForm.AddLines;
      UsageForm.Clear;
      UsageForm.AddLines
    end
  end
end;

procedure TPSimulator.ClearActivity;
begin
  ActivityStartIndex:=0;
  ActivityNextIndex:=0;
  ActivityStartTime:=ActualClock;
  ActivityTime:=-1;
  ActivityForm.Clear;
  UsageForm.Clear;
  TraceActivity;
  ActivityForm.AddLines;
  UsageForm.AddLines
end;

procedure TPipeForm.PipelineUsageDiagram1Click(Sender: TObject);
begin
  UsageForm.Show
end;

procedure TPipeForm.LineBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  WireValue.Hide
end;

procedure TPipeForm.LineBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Obj: TObject;
begin
  Obj:=LineBox1.Objects(X,Y);
  if Obj<>nil then
    ShowWireValue(X+2,Y+18,Obj as TDataSource)
end;

procedure TPipeForm.LineBox2MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Obj: TObject;
begin
  Obj:=LineBox2.Objects(X,Y);
  if Obj<>nil then
    ShowWireValue(X,Y+LineBox2.Top,Obj as TDataSource)
end;

procedure TPipeForm.LineBox3MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Obj: TObject;
begin
  Obj:=LineBox3.Objects(X,Y);
  if Obj<>nil then
    ShowWireValue(X+2+Control.Left,Y+18+Control.Top,Obj as TDataSource)
end;

procedure TPipeForm.LineBox4MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Obj: TObject;
begin
  Obj:=LineBox4.Objects(X,Y);
  if Obj<>nil then
    ShowWireValue(X+LineBox4.Left,Y,Obj as TDataSource)
end;

procedure TPipeForm.LineBox5MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Obj: TObject;
begin
  Obj:=LineBox5.Objects(X,Y);
  if Obj<>nil then
    ShowWireValue(X+LineBox5.Left,Y+LineBox5.Top,Obj as TDataSource)
end;

procedure TPipeForm.LineBox6MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Obj: TObject;
begin
  Obj:=LineBox6.Objects(X,Y);
  if Obj<>nil then
    ShowWireValue(X+LineBox6.Left+Control.Left,Y+9+Control.Top,Obj as TDataSource)
end;

procedure TPipeForm.ShowWireValue(X,Y: Integer; Source: TDataSource);
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
  else if WireValue.Left+WireValue.Width>ClientWidth then
    WireValue.Left:=ClientWidth-WireValue.Width;
  WireValue.Show
end;

end.

