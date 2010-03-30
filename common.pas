{ Project: Escape                                                            }
{ Version: 1.1                                                               }
{ Author: Peter Verplaetse                                                   }
{ Date: 22 July 1998                                                         }

{ This file contains routines common to both architectures }

unit Common;

interface

uses  StdCtrls, SysUtils, Dialogs, Classes, Compos, Graphics, Forms, WinProcs,
      ClipBrd, Menus, Spin, NewStr;
const
  { A fixed-size array is used for the data inputs of muxes and buses; 20 should be enough }
  MaxMuxDataInputs = 20;
  { Maximum number of rewind steps }
  TrackBufferSize = 1024;
  { ALU operations }
  NOP = 0;
  ADD = 1;
  SUB = 2;
  RSUB = 3;
  BITAND = 4;
  BITOR = 5;
  BITXOR = 6;
  SLL = 7;
  SRL = 8;
  SRA = 9;
  PASSS1 = 10;
  PASSS2 = 11;
  S2S1 = 12;
  MULT = 13;
  DIVI = 14;
  AluOperation: array [0..14] of string = ('NOP','ADD','SUB','RSUB','AND',
                'OR','XOR','SLL','SRL','SRA','S1','S2','S2S1','MUL','DIV');
  { Comparator Operations }
  ONE = 1;
  EQ = 2;
  NE = 3;
  LT = 4;
  GT = 5;
  LE = 6;
  GE = 7;
  CompOperation: array [0..7] of string = ('False','True','=0?','<>0?','<0?','>0?',
                 '<=0?','>=0?');

  CompOperation2: array [0..7] of string = ('','True','EQ','NE','LT','GT',
                 'LE','GE');
  { Memory Operations }
  READBYTE = 4;
  READHALF = 5;
  READWORD = 6;
  WRITEBYTE = 8;
  WRITEHALF = 9;
  WRITEWORD = 10;
  MemOperation: array [0..6] of string = ('RB','RH','RW','','WB','WH','WW');

type
  { For von Neumann and Harvard architectures: memory can contain code, data or both }
  TContentType = (ctCode, ctData, ctBoth);
  { Warnings/Errors that can occur during simulation }
  TError = (erFuncUnstable,erMARUnstable,erMDRUnstable,erNotAligned,
            erOutOfRange, erBreak);
  TErrorSet = set of TError;
  TMemoryInterface = class
  protected
    Content: array [0..32768 div 4 -1] of LongInt;
    CType: TContentType;
  public
    { Check if the address is valid }
    { Groupsize = 0 for bytes; 1 for halves and 2 for words }
    function CheckAddress(Address: LongInt; GroupSize: Integer): TErrorSet;
    { Read and Write check the address too, but throw an exception when the address is invalid }
    function Read(Address: LongInt; GroupSize: Integer): LongInt;
    procedure Write(Address, Value: LongInt; GroupSize: Integer);
    { Call these routines if the content of one or more memory locations has changed -> this will reflect the
      change in the viewer or viewers in case of a von Neumann architecture }
    procedure ChangedValue(Address: LongInt);
    procedure ChangedRegion(BeginRegion, EndRegion: LongInt);
    procedure ChangedAll;
    procedure MemoryTouched;
    constructor Create(ContentType: TContentType);
  end;

  TUnravel = class
  { This class unravels code words }
  private
    opc: Integer;
    reg: Integer;
    regmask: Integer;
    imm1mask: LongInt;
    imm2mask: LongInt;
  public
    Imm1Size: Integer;
    Imm2Size: Integer;
    Imm1Width: Integer;
    Imm2Width: Integer;
    { Call UpdateFields to ensure the field widths are valid }
    procedure UpdateFields;
    { Get the opcode number }
    function Opcode(Instr: LongInt): Integer;
    { Get the actual register of formal i (1<=i<=6) }
    function Register(Instr: LongInt; i: Integer): Integer;
    { Size of immediate 1 }
    function Imm1(Instr: LongInt; Signed: Boolean): LongInt;
    { Size of immediate 2 }
    function Imm2(Instr: LongInt; Signed: Boolean):  LongInt;
    { Inverse of unravel: encode opcode }
    function AddOpcode(Opcode: Integer): LongInt;
    { Encode register }
    function AddRegister(Register,i: Integer): LongInt;
    { Encode immediate 1 }
    function AddImm1(Imm: LongInt): LongInt;
    { Encode immediate 2 }
    function AddImm2(Imm: LongInt): LongInt;
  end;

  TSeqSource = class;

  { The following classes are for the implementation of the rewind function.
    For each clock period the changes in state are recorded. TIncrementalChange
    is the datastructure used to record these changes. The semantics for Data1
    and Data2 depend on the type of the Source object }
  TIncrementalChange = class
    Source: TSeqSource;
    Data1: LongInt;
    Data2: LongInt;
    { This is really a node of a unidirectional linked list }
    Next: TIncrementalChange;
    constructor Create;
  end;

  { All the changes for 1 clock period }
  TIncrementalState = class
  private
    { The head of the linked list }
    FirstChange: TIncrementalChange;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Rewind;
    function ReportChange: TIncrementalChange;
  end;

  { All the changes for the past 1024 clock periods }
  TTrackBuffer = class
  private
    Buffer: array [0..TrackBufferSize-1] of TIncrementalState;
    StartTime: LongInt;
    StartIndex: Integer;
    ActualIndex: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    { Call this to clear the buffer and set the start time to the actual clock }
    procedure Reset;
    { Increment the clock }
    procedure Clock;
    { Call this to call the rewind function of all the objects that changed a state and thus rewind the clock }
    procedure Rewind;
    { False when no earlier changes have been recorded }
    function Rewindable: Boolean;
    { Returns an empty TIncrementalChange to be filled in by the source object }
    function ReportChange: TIncrementalChange;
  end;

  { The simulator is value-driven and cycle-based. Each object has zero or more inputs
    and always a single output of type LongInt. }
  TDataSource = class
  protected
    { The viewer can be anything and is object specific }
    Viewer: TComponent;
  public
    { The Name is used for pop-up content boxes }
    Name: string;
    constructor Create(View: TComponent; DName: string); virtual;
    { After creation, call Connect to connect the inputs }
    procedure Connect(Inputs: array of TDataSource); virtual;
    { Returns the LongInt value }
    function Value: LongInt; virtual;
    { Returns the value as a string (used for pop-up content boxes, etc...) }
    function StrValue: string; virtual;
  end;

  { TCombiSource is a combinational object (no state) }
  TCombiSource = class(TDataSource)
  protected
    RecentValue: LongInt;
    RecentClock: LongInt;
    { Implement this function in the derived objects }
    function GetValue: LongInt; virtual;
  public
    { Value uses result-caching to speed up the simulation }
    function Value: LongInt; override;
    { Result caching introduces a state. Therefore you need to reset these objects to when resetting the system }
    procedure Reset;
  end;

  { TSeqSource is a sequential object (with state) }
  TSeqSource = class(TDataSource)
  public
    { RestoreState is called when rewinding the clock }
    procedure RestoreState(Change: TIncrementalChange); virtual;
    procedure Reset; virtual;
    { A clock period consists of two phases: Evaluate and Propagate.
      Evaluate evaluates the input but keeps the current output and state.
      Propagate propagates the evaluated input and thus overwrites the current
      output and state. Evaluate can be called as many times as you want,
      but Propagate only once. Visualization is done during the Evaluate phase }
    procedure Evaluate; virtual;
    procedure Propagate; virtual;
  end;

  { An object that always returns the same value (constant) }
  TConstant = class(TDataSource)
  private
    Constant: LongInt;
  public
    procedure SetConstant(C: LongInt);
    function Value: LongInt; override;
  end;

  { This is, guess what, an or-gate }
  TOrGate = class(TCombiSource)
  private
    S1: TDataSource;
    S2: TDataSource;
  public
    procedure Connect(Inputs: array of TDataSource); override;
    function GetValue: LongInt; override;
  end;

  { Yep, a multiplexer. Could be a bus as well. }
  TMux = class(TCombiSource)
  private
    Select: TDataSource;
    Data: array [0..MaxMuxDataInputs-1] of TDataSource;
    NumDataInputs: Integer;
  public
    { Connect: First the select input, then the data inputs }
    procedure Connect(Inputs: array of TDataSource); override;
    function GetValue: LongInt; override;
  end;

  { This is an ALU }
  TAlu = class(TCombiSource)
  private
    Func: TDataSource;
    S1: TDataSource;
    S2: TDataSource;
  public
    { Connect: Function, S1, S2 }
    procedure Connect(Inputs: array of TDataSource); override;
    function GetValue: LongInt; override;
  end;

  { Comparator }
  TComparator = class(TCombiSource)
  private
    Func: TDataSource;
    S: TDataSource;
  public
    { Connect: Function, S }
    procedure Connect(Inputs: array of TDataSource); override;
    function GetValue: LongInt; override;
    { Not the default 8 digit number, since the value can only be 0 or 1 }
    function StrValue: string; override;
  end;

  { Incrementor }
  TIncrementor = class(TCombiSource)
  private
    Constant: LongInt;
    S: TDataSource;
  public
    { Increments used are 1 and 4 }
    procedure SetIncrement(Val: LongInt);
    procedure Connect(Inputs: array of TDataSource); override;
    function GetValue: LongInt; override;
  end;

  { Sign Extender. The input bit size is derived from the instruction type stored in the code word  }
  TSignExtend = class(TCombiSource)
  private
    OutputBitSize: TDataSource;
    S: TDataSource;
  public
   { Connect: OutputBitSize, CodeWord }
    procedure Connect(Inputs: array of TDataSource); override;
    function GetValue: LongInt; override;
  end;

  { A register with enable input }
  TReg = class(TSeqSource)
  protected
    En: TDataSource;
    S: TDataSource;
    NewValue: LongInt;
    CurrentValue: LongInt;
    ShowSize: Integer;
  public
    constructor Create(View: TComponent; DName: string); override;
    { ShowSize is the number of digits used by StrValue (8 by default).
      If ShowSize is 0, the content is not shown }
    procedure SetShowSize(Size: Integer);
    { Connect: Enable, DataIn }
    procedure Connect(Inputs: array of TDataSource); override;
    procedure RestoreState(Change: TIncrementalChange); override;
    procedure Reset; override;
    procedure Evaluate; override;
    procedure Propagate; override;
    function Value: LongInt; override;
    function StrValue: string; override;
    procedure Show; virtual;
  end;

  { RegIR is a register to be used for holding code words. It has a shadow register
    with the associated PC and shows dissassembled text instead of an 8 digit hex number }
  TRegIR = class(TSeqSource)
  private
    En: TDataSource;
    S: TDataSource;
    PC: TDataSource;
    NewValue: LongInt;
    CurrentValue: LongInt;
    NewPC: LongInt;
    CurrentPC: LongInt;
  public
    { Connect: Enable, CodeIn, PCIn }
    procedure Connect(Inputs: array of TDataSource); override;
    procedure RestoreState(Change: TIncrementalChange); override;
    procedure Reset; override;
    procedure Evaluate; override;
    procedure Propagate; override;
    function Value: LongInt; override;
    function StrValue: string; override;
    procedure Show;
  end;

  { This is the second output of TRegIR: the delayed PC }
  TRegIRPC = class(TDataSource)
  private
    RegIR: TRegIR;
  public
    procedure Connect(Inputs: array of TDataSource); override;
    function Value: LongInt; override;
  end;

  { A Register File. Has two output ports }
  TRegFile = class(TSeqSource)
  private
    RR1: TDataSource;
    WR: TDataSource;
    S: TDataSource;
    NewReg: Integer;
    NewValue: LongInt;
    ShowReg: Integer;
    function Line(var Reg: Integer; Cols, Length: Integer): string;
  public
    { The number of registers (0-256) }
    NumRegisters: Integer;
    Regs: array [0..255] of LongInt;
    constructor Create(View: TComponent; DName: string); override;
    { Connect: ReadPort1Register, WriteRegister, WritePort }
    procedure Connect(Inputs: array of TDataSource); override;
    procedure RestoreState(Change: TIncrementalChange); override;
    procedure Reset; override;
    procedure Evaluate; override;
    procedure Propagate; override;
    procedure Show(Reg: Integer);
    function Value: LongInt; override;
  end;

  { This is the RegFile's second read port }
  TRegFileBis = class(TDataSource)
  private
    RR2: TDataSource;
    RegFile: TRegFile;
  public
    function Value: LongInt; override;
    { Connect: ReadPort2Register, RegFile }
    procedure Connect(Inputs: array of TDataSource); override;
  end;

  { This is a memory with fixed access time }
  TRWMem = class(TSeqSource)
  private
    SMDR: TDataSource;
    Memory: TMemoryInterface;
    NewSMDR: LongInt;
    NewMAR: LongInt;
    NewFunc: Integer;
    NewOperation: Boolean;
    LastSMDR: LongInt;
    RecentClock: LongInt;
    RecentValue: LongInt;
  public
    Func: TDataSource;
    MAR: TDataSource;
    LastMAR: LongInt;
    LastFunc: Integer;
    Counter: Integer;
    Cycles: Integer;
    { Set the memory interface after creation with this function }
    procedure SetMemory(Mem: TMemoryInterface);
    { Set the speed with this function. AccessTime must be at least 1.
      AccessTime-1 is the number of cycles you have to wait before the output
      is valid. An Accesstime of 1 makes the memory pure combinational for read
      operations }
    procedure SetSpeed(AccessTime: Integer);
    { Connect: Function, DataIn }
    procedure Connect(Inputs: array of TDataSource); override;
    procedure RestoreState(Change: TIncrementalChange); override;
    procedure Reset; override;
    procedure Evaluate; override;
    procedure Propagate; override;
    function Value: LongInt; override;
    function GetValue: LongInt;
    procedure ResetRecentClock;
  end;

  { TRWMem's second output: 1 when the memory is busy and thus no new memory operation can be started this cycle }
  TRWMemBusy = class(TCombiSource)
  private
    RWMem: TRWMem;
  public
    function GetValue: LongInt; override;
    procedure Connect(Inputs: array of TDataSource); override;
  end;

  { TRWMem's third output: the read address associated with the current output value }
  TRWMemAddress = class(TCombiSource)
  private
    RWMem: TRWMem;
  public
    function GetValue: LongInt; override;
    procedure Connect(Inputs: array of TDataSource); override;
  end;

  { This is the common part of the simulators for both architectures }
  TSimulator = class
  protected
    RewindButton: TButton;
    RewindCheck: TMenuItem;
    GenerateTrace: TMenuItem;
    MultiCycle: TSpinEdit;
    MultiCycleCheck: TCheckBox;
    SimForm: TForm;
    Clock: TEditInteger;
    RegFile: TRegFile;
    PC: TReg;
    LastPC: LongInt;
    MaxClock: LongInt;
    procedure Reset; virtual;
    procedure Evaluate; virtual;
    procedure Propagate; virtual;
    procedure Rewind(Clocks: LongInt); virtual;
    procedure Simulate(Clocks: LongInt); virtual;
    procedure Trace(P: LongInt);
    procedure CheckBreak;
  public
    { The simulator enables buttons and menu items, and reads values from spinedits, etc... }
    constructor Create(RwndBtn: TButton; RwndChk: TMenuItem; GenTrace: TMenuItem;
      MltCyc: TSpinEdit; MltCycChk: TCheckBox; Clk: TEditInteger;
      ChkStab: Boolean); virtual;
    destructor Destroy; override;
    procedure RewindClick;
    procedure ResetClick;
    procedure RewindCheckClick;
    procedure ClockClick;
    procedure ClockChangedByUser;
  end;

  { This is an interface to the clipboard (text only) }
  TClipBoardBuffer = class
  private
    Buffer: PChar;
    Pointer: PChar;
  public
    constructor Create;
    destructor Destroy; override;
    {  Clear the buffer }
    procedure Clear;
    { Write a line to the buffer }
    procedure AddLine(line: string);
    { Read a line from the buffer}
    function GetLine(var line: string): Boolean;
    { How many lines are in the buffer? }
    function NumLines(MaxLines: Integer): Integer;
    { Put buffer on clipboard }
    procedure ToClipBoard;
    { Get buffer from clipboard }
    procedure FromClipBoard;
  end;

  { This class is used for all file I/O }
  TFileIO = class
  private
    FileName: string;
  public
    { The file handle is public, this way Readln and Writeln and such can be done directly }
    F: TextFile;
    { AssignFile, but keeps the Filename -- to work around the Reset bug }
    procedure UseFile(TFName: string);
    { Write boolean }
    procedure WriteYesNo(Item: string; Value: Boolean);
    { Write integer }
    procedure WriteInteger(Item: string; Value: Integer);
    { Write string }
    procedure WriteString(Item: string; Value: string);
    { Read boolean }
    function ReadYesNo(Item: string; var Error: Boolean): Boolean;
    { Read integer }
    function ReadInteger(Item: string; var Error: Boolean): Integer;
    { Read string }
    function ReadString(Item: string; var Error: Boolean): string;
    { Find a string. If not found: rewind the file and search again from the top }
    function FindString(Item: string; var Line: string): Boolean;
  end;

  { ShowModal AboutBox }
  procedure AboutBox;
  { Measure dimensions of various fonts }
  function MSSansSerif8Width: Integer;
  function MSSansSerif8Height: Integer;
  function Courier9Width: Integer;
  function Courier9Height: Integer;
  function Courier10Width: Integer;
  function Courier10Height: Integer;
  { The following 6 outines are usefull for parsing strings. pos is the position (1=beginning) }
  procedure SkipSpaces(line: string; var pos: Integer);
  { Skip characters until a '|' is  found. Skip that one too }
  procedure SkipPastPipe(line: string; var pos: Integer);
  { Skip spaces and then read an identifier (sequence of alphanumeric characters }
  function ReadIdentifier(line: string; var pos: Integer): string;
  { Like skipping, but the '|' is not skipped and the skipped characters are returned as a string }
  function ReadUntilPipe(line: string; var pos: Integer): string;
  { Read an integer }
  function ReadInt(line: string; var pos: Integer): LongInt;
  { Returns True when pos=Length(line) }
  function EndLine(line: string; var pos: Integer): Boolean;
  { Returns a random LongInt }
  function RandomLongInt: LongInt;
  { Returns the maximum number of characters needed to print a register in the register file box }
  function MaxRegisterLength(NumRegisters: Integer): Integer;
  { Show a message box with the error }
  function ReportError(Error: TErrorSet): Boolean;
  { Show a message box }
  function AppliMessage(Msg,Cap: string; Flags: Word): Integer;
  { Set Modify on the current simulation form }
  procedure SetModifyOnSimForm;
  { Return the relative file location if possible }
  function RelativeDir(Name: string): string;

var
  Unravel: TUnravel;
  CodeMemory: TMemoryInterface;
  DataMemory: TMemoryInterface;
  ActualClock: LongInt;
  ShowValues: Boolean;
  TrackChanges: Boolean;
  Tracker: TTrackBuffer;
  SimError: TErrorSet;
  CheckStability: Boolean;
  ErrorAddress: LongInt;
  CodeCaptionBase: string;
  DataCaptionBase: string;
  TraceDialog: TSaveDialog;
  FileIO: TFileIO;

implementation

uses Config, Instrmem, Datamem, BrkForm, Micro, Pipe, About;

procedure SetModifyOnSimForm;
begin
  if MSimulator<>nil then
    MicroForm.SetModify;
  if PSimulator<>nil then
    PipeForm.SetModify
end;

procedure SkipSpaces(line: string; var pos: Integer);
begin
  while (pos<=Length(line)) and (line[pos]=' ') do
    pos:=pos+1
end;

procedure SkipPastPipe(line: string; var pos: Integer);
begin
  while (pos<=Length(line)) and (line[pos]<>'|') do
    pos:=pos+1;
  if pos<=Length(line) then
    pos:=pos+1
end;

function ReadIdentifier(line: string; var pos: Integer): string;
var
  start: Integer;
begin
  SkipSpaces(line,pos);
  start:=pos;
  while pos<=Length(line) do
    case line[pos] of
      '0'..'9','a'..'z','A'..'Z': pos:=pos+1
    else
      break
    end;
  Result:=Copy(line,start,pos-start)
end;

function ReadUntilPipe(line: string; var pos: Integer): string;
var
  start: Integer;
begin
  SkipSpaces(line,pos);
  start:=pos;
  while pos<=Length(line) do
    if line[pos]<>'|' then
      pos:=pos+1
    else
      break;
  Result:=Copy(line,start,pos-start)
end;

function ReadInt(line: string; var pos: Integer): LongInt;
var
  digit: Integer;
  negative: Boolean;
begin
  SkipSpaces(line,pos);
  if (pos<Length(line)-1) and (line[pos]='0') and (line[pos+1]='x') then
  begin
    pos:=pos+2;
    Result:=0;
    while (pos<=Length(line)) do
    begin
      digit:=HexToInt(line[pos]);
      if digit<0 then
        break;
      Result:=Result shl 4 +digit;
      pos:=pos+1
    end
  end
  else begin
    negative:=false;
    if (pos<Length(line)) and (line[pos]='-') then
    begin
      negative:=true;
      pos:=pos+1
    end
    else if (pos<Length(line)) and (line[pos]='+') then
      pos:=pos+1;
    Result:=0;
    while (pos<=Length(line)) do
    begin
      digit:=Ord(line[pos])-Ord('0');
      if (digit<0) or (digit>9) then
        break;
      Result:=(Result*5) shl 1 +digit;
      pos:=pos+1
    end;
    if negative then
      Result:=-Result
  end
end;

function EndLine(line: string; var pos: Integer): Boolean;
begin
  Result:=(pos>Length(line))
end;

procedure TFileIO.UseFile(TFName: string);
begin
  AssignFile(F,TFName);
  FileName:=TFName
end;

procedure TFileIO.WriteYesNo(Item: string; Value: Boolean);
begin
  Write(F,Item+'=');
  if Value then
    Writeln(F,'yes')
  else
    Writeln(F,'no')
end;

procedure TFileIO.WriteInteger(Item: string; Value: Integer);
begin
  Writeln(F,Item+'='+IntToStr(Value))
end;

function TFileIO.ReadInteger(Item: string; var Error: Boolean): Integer;
var
  L: string;
  p: Integer;
begin
  Result:=0;
  if FindString(Item,L) then
  begin
    p:=Pos('=',L);
    if p>0 then
    begin
      p:=p+1;
      Result:=ReadInt(L,p)
    end else
      Error:=true
  end else
    Error:=true
end;

procedure TFileIO.WriteString(Item: string; Value: string);
begin
  Writeln(F,Item+'='+Value)
end;

function TFileIO.ReadString(Item: string; var Error: Boolean): string;
var
  L: string;
  p: Integer;
begin
  Result:='';
  if FindString(Item,L) then
  begin
    p:=Pos('=',L);
    if p>0 then
    begin
      p:=p+1;
      SkipSpaces(L,p);
      Result:=Copy(L,p,1000)
    end else
      Error:=true
  end else
    Error:=true
end;

function TFileIO.ReadYesNo(Item: string; var Error: Boolean): Boolean;
var
  L: string;
  p: Integer;
begin
  Result:=false;
  if FindString(Item,L) then
  begin
    p:=Pos('=',L);
    if p>0 then
    begin
      L:=UpperCase(Copy(L,p+1,1000));
      Result:=(Pos('Y',L)>0)
    end else
      Error:=true
  end else
    Error:=true
end;

function TFileIO.FindString(Item: string; var Line: string): Boolean;
var
  q: LongInt;
  L: string;
begin
  Item:=UpperCase(Item);
  repeat
    Readln(F,Line);
    L:=UpperCase(Line);
    q:=Pos(Item,L)
  until (q>0) or SeekEof(F);
  if q=0 then
  begin
    CloseFile(F);
    AssignFile(F,FileName); { a simple Reset doesn't seem to rewind the file }
    Reset(F);
    repeat
      Readln(F,Line);
      L:=UpperCase(Line);
      q:=Pos(Item,L)
    until (q>0) or SeekEof(F);
  end;
  Result:=(q>0);
end;

function MSSansSerif8Width: Integer;
begin
  Result:=ConfigForm.MSSansSerif82.Width-ConfigForm.MSSansSerif81.Width;
end;

function MSSansSerif8Height: Integer;
begin
  Result:=ConfigForm.MSSansSerif81.Height;
end;

function Courier9Width: Integer;
begin
  Result:=ConfigForm.Courier92.Width-ConfigForm.Courier91.Width;
end;

function Courier9Height: Integer;
begin
  Result:=ConfigForm.Courier91.Height;
end;

function Courier10Width: Integer;
begin
  Result:=ConfigForm.Courier102.Width-ConfigForm.Courier101.Width;
end;

function Courier10Height: Integer;
begin
  Result:=ConfigForm.Courier101.Height;
end;

constructor TMemoryInterface.Create(ContentType: TContentType);
begin
  inherited Create;
  CType:=ContentType
end;

function TMemoryInterface.CheckAddress(Address: LongInt; GroupSize: Integer): TErrorSet;
begin
  Result:=[];
  if Address>=ConfigForm.DmemSize.Value then
    Result:=[erOutOfRange];
  if (Address and (1 shl GroupSize -1))<>0 then
    Result:=[erNotAligned];
  if Result<>[] then
    ErrorAddress:=Address
end;

function TMemoryInterface.Read(Address: LongInt; GroupSize: Integer): LongInt;
begin
  if not ReportError(CheckAddress(Address, GroupSize)) then
  begin
    Result:=Content[Address div 4];
    case GroupSize of
      0: Result:=(Result shr (24-(8*(Address and 3)))) and $FF;
      1: Result:=(Result shr (16-(8*(Address and 2)))) and $FFFF
    end
  end else
    Result:=-1
end;

procedure TMemoryInterface.Write(Address, Value: LongInt; GroupSize: Integer);
begin
  if not ReportError(CheckAddress(Address, GroupSize)) then
  begin
    case GroupSize of
      0: Content[Address div 4]:= Content[Address div 4]
            and (-1-($FF shl (24-(8*(Address and 3)))))
            or ((Value and $FF) shl (24-(8*(Address and 3))));
      1: Content[Address div 4]:= Content[Address div 4]
            and (-1-($FFFF shl (16-(8*(Address and 2)))))
            or ((Value and $FFFF) shl (16-(8*(Address and 2))));
      2: Content[Address div 4]:=Value;
    end
  end
end;

procedure TMemoryInterface.ChangedValue(Address: LongInt);
begin
  if (CType=ctCode) or (CType=ctBoth) then
    ImemForm.ShowSingleAddress(Address);
  if (CType=ctData) or (CType=ctBoth) then
    DmemForm.ShowSingleAddress(Address);
  MemoryTouched
end;

procedure TMemoryInterface.ChangedRegion(BeginRegion, EndRegion: LongInt);
begin
  if (CType=ctCode) or (CType=ctBoth) then
    ImemForm.ShowRegion(BeginRegion,EndRegion);
  if (CType=ctData) or (CType=ctBoth) then
    DmemForm.ShowRegion(BeginRegion,EndRegion);
  MemoryTouched
end;

procedure TMemoryInterface.ChangedAll;
begin
  if (CType=ctCode) or (CType=ctBoth) then
    ImemForm.ShowAll;
  if (CType=ctData) or (CType=ctBoth) then
    DmemForm.ShowAll;
  MemoryTouched
end;

procedure TMemoryInterface.MemoryTouched;
begin
  if (CType=ctCode) then
  begin
    PSimulator.Imem.ResetRecentClock;
    PSimulator.IR.Evaluate
  end
  else if (CType=ctData) then
  begin
    PSimulator.Dmem.ResetRecentClock;
    PSimulator.LMDR.Evaluate
  end
  else
  begin
    MSimulator.Mem.ResetRecentClock;
    MSimulator.MDR.Evaluate;
    MSimulator.IR.Evaluate
  end
end;

function RandomLongInt: LongInt;
begin
  Result:=Random($1000);
  Result:=(Result shl 12 + Random($1000)) shl 8 + Random($100)
end;

function MaxRegisterLength(NumRegisters: Integer): Integer;
begin
  case NumRegisters of
        0..9: Result:=12;
      10..99: Result:=13
  else
    Result:=14
  end
end;

function ReportError(Error: TErrorSet): Boolean;
var
  Cap: string;
  Flag: Word;
begin
  Cap:='Error';
  Flag:=$30;
  if erFuncUnstable in Error then
    AppliMessage('Memory function input is unstable',Cap,Flag);
  if erMARUnstable in Error then
    AppliMessage('Memory address input is unstable',Cap,Flag);
  if erMDRUnstable in Error then
    AppliMessage('Memory data input is unstable',Cap,Flag);
  if erOutOfRange in Error then
    AppliMessage('Address 0x'+IntToHex(ErrorAddress,8)+' out of range',Cap,Flag);
  if erNotAligned in Error then
    AppliMessage('Address 0x'+IntToHex(ErrorAddress,8)+' not aligned',Cap,Flag);
  if erBreak in Error then
    AppliMessage('Breakpoint condition met','Note',$40);
  Result:=(Error <> [])
end;

Function AppliMessage(Msg,Cap: string; Flags: Word): Integer;
var
  Buf1,Buf2: PChar;
begin
  Buf1:=StrAlloc(Length(Msg)+1);
  Buf2:=StrAlloc(Length(Cap)+1);
    Result:=Application.MessageBox(StrPCopy(Buf1,Msg),StrPCopy(Buf2,Cap),Flags);
    StrDispose(Buf1);
    StrDispose(Buf2)
end;

procedure TUnravel.UpdateFields;
begin
  opc:=ConfigForm.NumOpcodes.Exponent;
  Imm2Size:=32-opc;
  reg:=ConfigForm.NumRegisters.Exponent;
  regmask:=1 shl reg -1;
  Imm1Size:=Imm2Size-2*reg;
  imm1mask:=LongInt(1) shl Imm1Size -1;
  imm2mask:=LongInt(1) shl Imm2Size -1;
  Imm1Width:=(Imm1Size+3) div 4;
  Imm2Width:=(Imm2Size+3) div 4
end;

function TUnravel.Opcode(Instr: LongInt): Integer;
begin
  Result:=Instr shr Imm2Size
end;

function TUnravel.Register(Instr: LongInt; i: Integer): Integer;
begin
  Result:=(Instr shr (Imm2Size-i*reg)) and regmask
end;

function TUnravel.Imm1(Instr: LongInt; Signed: Boolean): LongInt;
begin
  Result:=Instr and imm1mask;
  if Signed and (Result>imm1mask div 2) then
    Result:=Result-imm1mask-1
end;

function TUnravel.Imm2(Instr: LongInt; Signed: Boolean): LongInt;
begin
  Result:=Instr and imm2mask;
  if Signed and (Result>imm2mask div 2) then
    Result:=Result-imm2mask-1
end;

function TUnravel.AddOpcode(Opcode: Integer): LongInt;
begin
  Result:=LongInt(Opcode) shl Imm2Size
end;

function TUnravel.AddRegister(Register,i: Integer): LongInt;
begin
  Result:=LongInt(Register) shl (Imm2Size-i*reg)
end;

function TUnravel.AddImm1(Imm: LongInt): LongInt;
begin
  Result:=Imm and imm1mask
end;

function TUnravel.AddImm2(Imm: LongInt): LongInt;
begin
  Result:=Imm and imm2mask
end;

constructor TIncrementalChange.Create;
begin
  inherited Create;
  Next:=nil;
end;

constructor TIncrementalState.Create;
begin
  inherited Create;
  FirstChange:=nil;
end;

destructor TIncrementalState.Destroy;
begin
  Clear;
  inherited Destroy
end;

procedure TIncrementalState.Clear;
var
  NextChange: TIncrementalChange;
begin
  while FirstChange<>nil do
  begin
    NextChange:=FirstChange.Next;
    FirstChange.Destroy;
    FirstChange:=NextChange
  end
end;

function TIncrementalState.ReportChange: TIncrementalChange;
begin
  Result:=TIncrementalChange.Create;
  Result.next:=FirstChange;
  FirstChange:=Result
end;

procedure TIncrementalState.Rewind;
var
  NextChange: TIncrementalChange;
begin
  while FirstChange<>nil do
  begin
    FirstChange.Source.RestoreState(FirstChange);
    NextChange:=FirstChange.Next;
    FirstChange.Destroy;
    FirstChange:=NextChange
  end
end;

constructor TTrackbuffer.Create;
var
  i: Integer;
begin
  inherited Create;
  for i:=0 to TrackBufferSize-1 do
    Buffer[i]:=TIncrementalState.Create
end;

destructor TTrackBuffer.Destroy;
var
  i: Integer;
begin
  for i:=0 to TrackBufferSize-1 do
    Buffer[i].Free;
  inherited Destroy
end;

procedure TTrackBuffer.Reset;
begin
  StartTime:=ActualClock;
  StartIndex:=0;
  ActualIndex:=0
end;

procedure TTrackBuffer.Clock;
begin
  ActualIndex:=(ActualIndex+1) mod TrackBufferSize;
  if StartIndex=ActualIndex then
  begin
    StartIndex:=(StartIndex+1) mod TrackBufferSize;
    StartTime:=StartTime+1
  end;
  Buffer[ActualIndex].Clear
end;

procedure TTrackBuffer.Rewind;
begin
  Buffer[ActualIndex].Rewind;
  ActualIndex:=(ActualIndex+TrackBufferSize-1) mod TrackBufferSize
end;

function TTrackBuffer.Rewindable: Boolean;
begin
  Result:=(StartTime<ActualClock)
end;

function TTrackBuffer.ReportChange: TIncrementalChange;
begin
  Result:=Buffer[ActualIndex].ReportChange
end;

constructor TDataSource.Create(View: TComponent; DName: string);
begin
  inherited Create;
  Name:=DName;
  Viewer:=View
end;

procedure TDataSource.Connect(Inputs: array of TDataSource);
begin
  raise Exception.Create('TDataSource.Connect called')
end;

function TDataSource.Value: LongInt;
begin
  raise Exception.Create('TDataSource.Value called')
end;

function TDataSource.StrValue: string;
begin
  Result:=IntToHex(Value,8)
end;

function TCombiSource.Value: LongInt;
begin
  if RecentClock<>ActualClock then
  begin
    RecentClock:=ActualClock;  {  Do this first, otherwise the program might enter an infinite loop }
    RecentValue:=GetValue
  end;
  Result:=RecentValue
end;

procedure TCombiSource.Reset;
begin
  RecentClock:=-1;
end;

function TCombiSource.GetValue: LongInt;
begin
  raise Exception.Create('TCombiSource.GetValue called');
end;

procedure TSeqSource.RestoreState;
begin
  raise Exception.Create('TSeqSource.RestoreState called');
end;

procedure TSeqSource.Reset;
begin
  raise Exception.Create('TSeqSource.Reset called');
end;

procedure TSeqSource.Evaluate;
begin
  raise Exception.Create('TSeqSource.Evaluate called');
end;

procedure TSeqSource.Propagate;
begin
  raise Exception.Create('TSeqSource.Propagate called');
end;

procedure TConstant.SetConstant(C: LongInt);
begin
  Constant:=C
end;

function TConstant.Value: LongInt;
begin
  Result:=Constant
end;

procedure TOrGate.Connect(Inputs: array of TDataSource);
begin
  S1:=Inputs[0];
  S2:=Inputs[1]
end;

function TOrGate.GetValue: LongInt;
begin
  Result:=S1.Value or S2.Value;
end;

procedure TMux.Connect(Inputs: array of TDataSource);
var
  i: Integer;
begin
  Select:=Inputs[0];
  NumDataInputs:=High(Inputs);
  if NumDataInputs>MaxMuxDataInputs then
    raise Exception.Create('Number of data inputs on mux out of range');
  for i:=1 to NumDataInputs do
    Data[i-1]:=Inputs[i]
end;

function TMux.GetValue: LongInt;
begin
  if Select.Value>NumDataInputs then
    raise Exception.Create('Select input out of range')
  else begin
    if ShowValues and (Viewer<>nil) then
      (Viewer as TMuxOrBusBox).Index:=Select.Value;
    Result:=Data[Select.Value].Value
  end
end;

procedure TAlu.Connect(Inputs: array of TDataSource);
begin
  Func:=Inputs[0];
  S1:=Inputs[1];
  S2:=Inputs[2]
end;

function TAlu.GetValue: LongInt;
begin
  if ShowValues and (Viewer<>nil) then
  begin
    (Viewer as TLabel).Caption:=AluOperation[Func.Value];
  end;
  case Func.Value of
    NOP: begin
           Result:=-1;
           if ShowValues then
           begin
             S1.Value;
             S2.Value
           end
         end;
    ADD: Result:=S1.Value+S2.Value;
    SUB: Result:=S1.Value-S2.Value;
    RSUB: Result:=S2.Value-S1.Value;
    BITAND: Result:=S1.Value and S2.Value;
    BITOR: Result:=S1.Value or S2.Value;
    BITXOR: Result:=S1.Value xor S2.Value;
    SLL: begin
           if S2.Value=32 then
             Result:=0
           else
             Result:=S1.Value shl S2.Value
           end;
    SRL: Result:=S1.Value shr S2.Value;
    SRA: begin
           if S2.Value>=32 then
           begin
             if S1.Value>=0 then
               Result:=0
             else
               Result:=-1
           end else
             Result:=S1.Value div (LongInt(1) shl S2.Value)
         end;
    PASSS1: begin
              Result:=S1.Value;
              if ShowValues then
                S2.Value
            end;
    PASSS2: begin
              Result:=S2.Value;
              if ShowValues then
                S1.Value
            end;
    S2S1: Result:=(S2.Value shl 16) or (S1.Value and $FFFF);
    MULT: Result:=S1.Value*S2.Value;
    DIVI: Result:=S1.Value div S2.Value
  else
    raise Exception.Create('Alu function non-existent');
  end
end;

procedure TComparator.Connect(Inputs: array of TDataSource);
begin
  Func:=Inputs[0];
  S:=Inputs[1];
end;

function TComparator.GetValue: LongInt;
var
  R: Boolean;
begin
  if ShowValues and (Viewer<>nil) then
  begin
    (Viewer as TLabel).Caption:=CompOperation[Func.Value];
  end;
  case Func.Value of
    NOP: begin
           R:=false;
           if ShowValues then
             S.Value
         end;
    ONE: R:=true;
    EQ: R:=(S.Value=0);
    NE: R:=(S.Value<>0);
    LT: R:=(S.Value<0);
    GT: R:=(S.Value>0);
    LE: R:=(S.Value<=0);
    GE: R:=(S.Value>=0)
  else
    raise Exception.Create('Comparator function non-existant')
  end;
  if R then
    Result:=1
  else
    Result:=0
end;

function TComparator.StrValue: string;
begin
  Result:=IntToHex(Value,1)
end;

procedure TIncrementor.SetIncrement(Val: LongInt);
begin
  Constant:=Val
end;

procedure TIncrementor.Connect(Inputs: array of TDataSource);
begin
  S:=Inputs[0];
end;

function TIncrementor.GetValue: LongInt;
begin
  Result:=S.Value+Constant
end;

procedure TSignExtend.Connect(Inputs: array of TDataSource);
begin
  OutputBitSize:=Inputs[0];
  S:=Inputs[1]
end;

function TSignExtend.GetValue: LongInt;
var
  NumBits: Integer;
  Msk: LongInt;
begin
  if OutputBitSize.Value<8 then
    Result:=S.Value
  else begin
    if Encoding.OpcodeType(Unravel.Opcode(S.Value))=otI then
      NumBits:=32-Unravel.Imm1Size
    else
      NumBits:=32-Unravel.Imm2Size;
    if NumBits<32 then
    begin
      if OutputBitSize.Value=32 then
        Msk:=-1
      else
        Msk:=(1 shl OutputBitSize.Value)-1;
      Result:=((S.Value shl NumBits) div (LongInt(1) shl NumBits)) and Msk
    end else
      Result:=0;
  end
end;

constructor TReg.Create(View: TComponent; DName: string);
begin
  inherited Create(View,DName);
  ShowSize:=8
end;

procedure TReg.SetShowSize(Size: Integer);
begin
  ShowSize:=Size
end;

procedure TReg.Connect(Inputs: array of TDataSource);
begin
  En:=Inputs[0];
  S:=Inputs[1]
end;

procedure TReg.RestoreState(Change: TIncrementalChange);
begin
  CurrentValue:=Change.Data1
end;

procedure TReg.Reset;
begin
  CurrentValue:=0
end;

procedure TReg.Evaluate;
var
  Col: TColor;
begin
  if En.Value<>0 then
  begin
    Col:=clWindow;
    NewValue:=S.Value
  end
  else begin
    S.Value; {Make sure multiplexers driving this register is updated properly} 
    Col:=clBtnFace;
    NewValue:=CurrentValue
  end;
  if ShowValues and (Viewer<>nil) then
    (Viewer as TRegBox).Color:=Col;
  Show
end;

procedure TReg.Propagate;
var
  Change: TIncrementalChange;
begin
  if CurrentValue<>NewValue then
  begin
    if TrackChanges then
    begin
      Change:=Tracker.ReportChange;
      Change.Source:=Self;
      Change.Data1:=CurrentValue
    end;
    CurrentValue:=NewValue
  end
end;

procedure TReg.Show;
begin
  if ShowValues and (Viewer<>nil) and (ShowSize>0) then
    (Viewer as TRegBox).Text:=StrValue
end;

function TReg.Value: LongInt;
begin
  Result:=CurrentValue
end;

function TReg.StrValue: string;
begin
  Result:=IntToHex(CurrentValue,ShowSize)
end;

procedure TRegIR.Connect(Inputs: array of TDataSource);
begin
  En:=Inputs[0];
  S:=Inputs[1];
  PC:=Inputs[2]
end;

procedure TRegIR.RestoreState(Change: TIncrementalChange);
begin
  CurrentValue:=Change.Data1;
  CurrentPC:=Change.Data2
end;

procedure TRegIR.Reset;
begin
  CurrentValue:=0;
  CurrentPC:=0
end;

procedure TRegIR.Evaluate;
var
  Col: TColor;
begin
  if En.Value<>0 then
  begin
    Col:=clWindow;
    NewValue:=S.Value;
    NewPC:=PC.Value
  end
  else begin
    Col:=clBtnFace;
    NewValue:=CurrentValue;
    NewPC:=CurrentPC
  end;
  if ShowValues and (Viewer<>nil) then
    (Viewer as TRegBox).Color:=Col;
  Show
end;

procedure TRegIR.Propagate;
var
  Change: TIncrementalChange;
begin
  if CurrentValue<>NewValue then
  begin
    if TrackChanges then
    begin
      Change:=Tracker.ReportChange;
      Change.Source:=Self;
      Change.Data1:=CurrentValue;
      Change.Data2:=CurrentPC
    end;
    CurrentValue:=NewValue;
    CurrentPC:=NewPC
  end
end;

procedure TRegIR.Show;
begin
  if ShowValues and (Viewer<>nil) then
    (Viewer as TRegBox).Text:=StrValue
end;

function TRegIR.Value: LongInt;
begin
  Result:=CurrentValue
end;

function TRegIR.StrValue: string;
begin
  Result:=Disassemble(CurrentValue,CurrentPC,0,false)
end;

procedure TRegIRPC.Connect(Inputs: array of TDataSource);
begin
  RegIR:=Inputs[0] as TRegIR
end;

function TRegIRPC.Value: LongInt;
begin
  Result:=RegIR.CurrentPC
end;

constructor TRegFile.Create(View: TComponent; DName: string);
begin
  inherited Create(View,DName);
  NumRegisters:=ConfigForm.NumRegisters.Value;
  ShowReg:=0
end;

procedure TRegFile.Connect(Inputs: array of TDataSource);
begin
  RR1:=Inputs[0];
  WR:=Inputs[1];
  S:=Inputs[2]
end;

procedure TRegFile.RestoreState;
begin
  Regs[Change.Data1]:=Change.Data2;
  ShowReg:=Change.Data1
end;

procedure TRegFile.Reset;
var
  i: Integer;
begin
  Regs[0]:=0;
  for i:=1 to NumRegisters-1 do
    Regs[i]:=RandomLongInt;
  ShowReg:=-1;
end;

procedure TRegFile.Evaluate;
begin
  Show(ShowReg);
  NewReg:=WR.Value;
  if (NewReg<NumRegisters) and (NewReg>0) then
    NewValue:=S.Value;
end;

procedure TRegFile.Propagate;
var
  Change: TIncrementalChange;
begin
  if (NewReg<NumRegisters) and (NewReg>0) then
  begin
    if TrackChanges then
    begin
      Change:=Tracker.ReportChange;
      Change.Source:=Self;
      Change.Data1:=NewReg;
      Change.Data2:=Regs[NewReg]
    end;
    Regs[NewReg]:=NewValue;
    if ShowValues then
      ShowReg:=NewReg
    else
      ShowReg:=-1
  end
end;

function TRegFile.Line(var Reg: Integer; Cols, Length: Integer): string;
var
  Col: Integer;
  Str: string;
begin
  Result:='';
  for Col:=0 to Cols-1 do
    if Reg<NumRegisters then
    begin
      if Col>0 then
        Result:=Result+'  ';
      Str:='R'+IntToStr(Reg)+': '+IntToHex(Regs[Reg],8);
      Result:=Result+Format('%*s',[Length,Str]);
      Reg:=Reg+1
    end else
      break
end;

procedure TRegFile.Show(Reg: Integer);
var
  L,Cols: Integer;
  Length: Integer;
begin
  if ShowValues and (Viewer<>nil) then
    with Viewer as TRegFileBox do
    begin
      Length:=MaxRegisterLength(NumRegisters);
      Cols:=1+((Width div Courier9Width)-Length-1) div (Length+2);
      if (Reg>=0) and (Reg<NumRegisters) then
      begin
        L:=Reg div Cols;
        Reg:=L*Cols;
        Lines[L]:=Line(Reg,Cols,Length)
      end else
      begin
        Visible:=false;
        Clear;
        Reg:=0;
        while Reg<NumRegisters do
          Lines.Add(Line(Reg,Cols,Length));
        Visible:=true
      end
    end
end;

function TRegFile.Value: LongInt;
var
  Reg: Integer;
begin
  Reg:=RR1.Value;
  if (Reg<NumRegisters) and (Reg>=0) then
    Result:=Regs[Reg]
  else
    Result:=-1
end;

procedure TRegFileBis.Connect(Inputs: array of TDataSource);
begin
  RR2:=Inputs[0];
  RegFile:=Inputs[1] as TRegFile
end;

function TRegFileBis.Value: LongInt;
var
  Reg: Integer;
begin
  Reg:=RR2.Value;
  if (Reg<RegFile.NumRegisters) and (Reg>=0) then
    Result:=RegFile.Regs[Reg]
  else
    Result:=-1
end;

procedure TRWMem.ResetRecentClock;
begin
  RecentClock:=-1
end;

procedure TRWMem.SetMemory(Mem: TMemoryInterface);
begin
  Memory:=Mem
end;

procedure TRWMem.SetSpeed(AccessTime: Integer);
begin
  Cycles:=AccessTime
end;

procedure TRWMem.Connect(Inputs: array of TDataSource);
begin
  Func:=Inputs[0];
  MAR:=Inputs[1];
  SMDR:=Inputs[2]
end;

procedure TRWMem.RestoreState(Change: TIncrementalChange);
var
  Address: LongInt;
begin
  { Data1[0]=0
     -> Data1[3-1] = LastFunc-4
     -> Data1[31-4] = LastMAR
     -> Data2 = LastSMDR
     -> NewOperation was true
    Data1[0]=1
     -> Data1[31-2] = Counter
     -> Data2 = OldMemoryValue when Data[1]=1 }
  if (Change.Data1 and 1)=0 then
  begin
    LastMAR:=Change.Data1 shr 4;
    LastFunc:=((Change.Data1 shr 1) and 7)+4;
    LastSMDR:=Change.Data2;
    NewOperation:=true
  end else
  begin
    Counter:=Change.Data1 shr 2;
    if (Change.Data1 and 2)=2 then
    begin
      Address:=LastMAR and $FFFFFFFC;
      Memory.Write(Address,Change.Data2,2);
      Memory.ChangedValue(Address)
    end
  end
end;

procedure TRWMem.Reset;
begin
  Counter:=0;
  RecentClock:=-1
end;

procedure TRWMem.Evaluate;
begin
  NewOperation:=(Func.Value<>NOP) and (Counter=0);
  if NewOperation then
  begin
    NewFunc:=Func.Value;
    NewMAR:=MAR.Value;
    NewSMDR:=SMDR.Value
  end;
  if Counter>0 then
  begin
    if (LastFunc<>Func.Value) and CheckStability then
      SimError:=SimError+[erFuncUnstable]
    else if (LastMAR<>MAR.Value) and CheckStability then
      SimError:=SimError+[erMARUnstable]
    else if (LastSMDR<>SMDR.Value) and CheckStability and (LastFunc>=WRITEBYTE) then
      SimError:=SimError+[erMDRUnstable]
  end;
  if ShowValues and (Viewer<>nil) then
    with Viewer as TLabel do
    begin
      if NewOperation then
        Caption:=MemOperation[NewFunc-4]
      else if (Counter>0) then
        Caption:=MemOperation[LastFunc-4]
      else
        Caption:='';
      if ((Cycles>1) and (NewOperation)) or (Counter>1) then
        Caption:=Caption+' - Busy'
    end
end;

procedure TRWMem.Propagate;
var
  Change: TIncrementalChange;
  CounterCopy: Integer;
begin
  CounterCopy:=Counter;
  if NewOperation then
  begin
    if TrackChanges then
    begin
      Change:=Tracker.ReportChange;
      Change.Source:=Self;
      Change.Data1:=(((LastFunc-4) and 7) shl 1)+(LastMAR shl 4);
      Change.Data2:=LastSMDR
    end;
    LastFunc:=NewFunc;
    LastMAR:=NewMAR;
    LastSMDR:=NewSMDR;
    Counter:=Cycles; {>0, so this will be tracked while decrementing}
    NewOperation:=false
  end;
  if Counter=1 then
  begin
    SimError:=SimError+Memory.CheckAddress(LastMAR,LastFunc and 3);
    if not(erOutOfRange in SimError) and not(erNotAligned in SimError) then
    begin
      if LastFunc>=WRITEBYTE then {write operation}
      begin
        if TrackChanges then
        begin
          Change:=Tracker.ReportChange; {must be restored in reverse order!}
          Change.Source:=Self;
          Change.Data1:=3+(CounterCopy shl 2);
          Change.Data2:=Memory.Read(LastMAR and $FFFFFFFC,2)
        end;
        Counter:=0; {No need to track Counter anymore}
        Memory.Write(LastMAR,LastSMDR,LastFunc and 3);
        Memory.ChangedValue(LastMAR and $FFFFFFFC);
        ImemForm.SetModify;
        DmemForm.SetModify
      end
    end
  end;
  if Counter>0 then
  begin
    if TrackChanges then
    begin
      Change:=Tracker.ReportChange;
      Change.Source:=Self;
      Change.Data1:=1+(CounterCopy shl 2)
    end;
    Counter:=Counter-1
  end
end;

function TRWMem.Value: LongInt;
begin
  if RecentClock<>ActualClock then
  begin
    RecentValue:=GetValue;
    RecentClock:=ActualClock
  end;
  Result:=RecentValue
end;

function TRWMem.GetValue: LongInt;
var
  Address: LongInt;
  GroupSize: Integer;
begin
  Result:=-1;
  Address:=MAR.Value;
  GroupSize:=Func.Value and 3;
  if (Cycles=1) and (Counter=0) and (Func.Value>NOP) and (Func.Value<WRITEBYTE) then
    Result:=0
  else if (Cycles>1) and (Counter=1) and (LastFunc<WRITEBYTE) then
  begin
    Address:=LastMAR;
    GroupSize:=LastFunc and 3;
    Result:=0
  end else
    Result:=-1;
  if Result=0 then
  begin
    SimError:=SimError+Memory.CheckAddress(Address,GroupSize);
    if not(erOutOfRange in SimError) and not(erNotAligned in SimError) then
      Result:=Memory.Read(Address,GroupSize)
  end
end;

procedure TRWMemBusy.Connect(Inputs: array of TDataSource);
begin
  RWMem:=Inputs[0] as TRWMem
end;

function TRWMemBusy.GetValue: LongInt;
begin
  if ((RWMem.Cycles>1) and (RWMem.Counter=0) and (RWMem.Func.Value<>NOP)) or (RWMem.Counter>1) then
    Result:=1
  else
    Result:=0
end;

procedure TRWMemAddress.Connect(Inputs: array of TDataSource);
begin
  RWMem:=Inputs[0] as TRWMem
end;

function TRWMemAddress.GetValue: LongInt;
begin
  if (RWMem.Cycles=1) and (RWMem.Counter=0) and (RWMem.Func.Value>NOP) and (RWMem.Func.Value<WRITEBYTE) then
    Result:=RWMem.MAR.Value
  else
    Result:=RWMem.LastMAR
end;

constructor TSimulator.Create(RwndBtn: TButton; RwndChk: TMenuItem;
      GenTrace: TMenuItem; MltCyc: TSpinEdit; MltCycChk: TCheckBox;
      Clk: TEditInteger; ChkStab: Boolean);
begin
  RewindButton:=RwndBtn;
  RewindCheck:=RwndChk;
  GenerateTrace:=GenTrace;
  MultiCycle:=MltCyc;
  MultiCycleCheck:=MltCycChk;
  SimForm:=RwndBtn.Owner as TForm;
  CheckStability:=ChkStab;
  Clock:=Clk;
  TrackChanges:=RewindCheck.Checked;
  ShowValues:=true;
  Application.CreateForm(TImemForm, ImemForm);
  Application.CreateForm(TDmemForm, DmemForm);
  Application.CreateForm(TBreakForm, BreakForm);
  ImemForm.Hide;
  DmemForm.Hide;
  BreakForm.Hide
end;

destructor TSimulator.Destroy;
begin
  ImemForm.Destroy;
  DmemForm.Destroy;
  BreakForm.Destroy;
  inherited Destroy
end;

procedure TSimulator.Evaluate;
begin
end;

procedure TSimulator.Propagate;
begin
  ActualClock:=ActualClock+1;
  Tracker.Clock;
  PC.Propagate;
  if MaxClock<ActualClock then
  begin
    MaxClock:=ActualClock;
    if PC.Value<>LastPC then
    begin
      LastPC:=PC.Value;
      Trace(LastPC)
    end
  end;
  RewindButton.Enabled:=(Tracker.Rewindable and RewindCheck.Checked);
end;

procedure TSimulator.Reset;
begin
  ActualClock:=0;
  LastPC:=0;
  MaxClock:=0;
  Trace(0);
  Tracker.Reset;
  RewindButton.Enabled:=(Tracker.Rewindable and RewindCheck.Checked)
end;

procedure TSimulator.ResetClick;
begin
  ImemForm.UpdateLastSelection;
  Reset;
  Evaluate;
  Clock.Value:=ActualClock
end;

procedure TSimulator.ClockClick;
begin
  if MultiCycleCheck.Checked then
    Simulate(MultiCycle.Value)
  else
    Simulate(1)
end;

procedure TSimulator.RewindCheckClick;
begin
  RewindCheck.Checked:=not RewindCheck.Checked;
  if RewindCheck.Checked then
  begin
    TrackChanges:=true;
    Tracker.Reset
  end else
  begin
    TrackChanges:=false;
    RewindButton.Enabled:=false
  end
end;

procedure TSimulator.Simulate(Clocks: LongInt);
var
  ImemVisible: Boolean;
  DmemVisible: Boolean;
  i: LongInt;
begin
  SimError:=[];
  BreakForm.UpdateAllValues;
  ImemForm.UpdateLastSelection;
  if Clocks>1 then
  begin
    ShowValues:=false;
    ImemVisible:=ImemForm.Visible;
    ImemForm.Hide;
    DmemVisible:=DmemForm.Visible;
    DmemForm.Hide;
    for i:=1 to Clocks do
    begin
      Propagate;
      CheckBreak;
      Evaluate;
      if SimError<>[] then
        break
    end;
    ImemForm.Visible:=ImemVisible;
    DmemForm.Visible:=DmemVisible;
    SimForm.Show;
    ShowValues:=true
  end else
  begin
    Propagate;
    CheckBreak
  end;
  Evaluate;
  Clock.Value:=ActualClock;
  if (SimError<> []) then
    ReportError(SimError)
end;

procedure TSimulator.CheckBreak;
var
  Box: TComboBox;
  Val: LongInt;
  i: Integer;
begin
  for i:=0 to NumBreakPoints-1 do
    if BreakForm.CheckBox[i].Checked then
    begin
      if i<NumBreakPoints div 2 then
      begin
        Box:=BreakForm.ORBox[i];
        Val:=(Box.Items.Objects[Box.ItemIndex] as TDataSource).Value
      end else
        Val:=RegFile.Regs[BreakForm.RFReg[i-NumBreakPoints div 2].Value];
      if Val=BreakForm.Value[i] then
      begin
        SimError:=SimError+[erBreak];
        break
      end
    end
end;

procedure TSimulator.ClockChangedByUser;
var
  TargetClock: LongInt;
begin
  TargetClock:=Clock.Value;
  if TargetClock>ActualClock then
    Simulate(TargetClock-ActualClock)
  else if TargetClock<ActualClock then
    Rewind(ActualClock-TargetClock)
end;

procedure TSimulator.RewindClick;
begin
  if MultiCycleCheck.Checked then
    Rewind(MultiCycle.Value)
  else
    Rewind(1)
end;

procedure TSimulator.Rewind(Clocks: LongInt);
var
  ImemVisible: Boolean;
  DmemVisible: Boolean;
  i: LongInt;
begin
  if not Tracker.Rewindable then
    raise Exception.Create('Rewind is not possible now')
  else begin
    if Clocks>1 then
    begin
      ShowValues:=false;
      ImemVisible:=ImemForm.Visible;
      ImemForm.Hide;
      DmemVisible:=DmemForm.Visible;
      DmemForm.Hide;
      for i:=1 to Clocks do
      begin
        ActualClock:=ActualClock-1;
        Tracker.Rewind;
        if not Tracker.Rewindable then
          break
      end;
      ImemForm.Visible:=ImemVisible;
      DmemForm.Visible:=DmemVisible;
      SimForm.Show;
      ShowValues:=true
    end else
    begin
      ActualClock:=ActualClock-1;
      Tracker.Rewind
    end;
    Evaluate;
    Clock.Value:=ActualClock
  end;
  RewindButton.Enabled:=(Tracker.Rewindable and RewindCheck.Checked)
end;

procedure TSimulator.Trace(P: LongInt);
var
  IR: LongInt;
  S: string;
  F: TextFile;
  Error: TErrorSet;
begin
  if GenerateTrace.Checked then
  begin
    S:=Format('%6d',[ActualClock])+'  '+IntToHex(LastPC,8)+': ';
    Error:=CodeMemory.CheckAddress(LastPC,2);
    if erOutOfRange in Error then
      S:=S+'out of range'
    else if erNotAligned in Error then
      S:=S+'not aligned'
    else begin
      IR:=CodeMemory.Read(LastPC,2);
      S:=S+IntToHex(IR,8)+'  '+Disassemble(IR,LastPC,0,false)
    end;
    AssignFile(F,TraceDialog.FileName);
    Append(F);
    Writeln(F,S);
    CloseFile(F)
  end
end;

procedure AboutBox;
begin
  Application.CreateForm(TAboutForm, AboutForm);
  AboutForm.Hide;
  AboutForm.ShowModal
end;

constructor TClipBoardBuffer.Create;
begin
  GetMem(Buffer,BufferSize);
  Clear
end;

destructor TClipBoardBuffer.Destroy;
begin
  FreeMem(Buffer,BufferSize);
  inherited Destroy;
end;

procedure TClipBoardBuffer.Clear;
begin
  Pointer:=Buffer;
  Buffer[0]:=Chr(0)
end;

procedure TClipBoardBuffer.AddLine(line: string);
var
  NewPointer: PChar;
begin
  NewPointer:=Pointer+Length(line);
  if NewPointer+2<Buffer+BufferSize then
  begin
    StrPCopy(Pointer,line);
    NewPointer[0]:=Chr(13);
    NewPointer[1]:=Chr(10);
    NewPointer[2]:=Chr(0);
    Pointer:=NewPointer+2
  end
end;

function TClipBoardBuffer.GetLine(var line: string): Boolean;
var
  EndLine: PChar;
begin
  EndLine:=StrScan(Pointer,Chr(13));
  if EndLine=nil then
    Result:=false
  else begin
    EndLine[0]:=Chr(0);
    line:=StrPas(Pointer);
    Pointer:=EndLine+2;
    Result:=true
  end
end;

function TClipBoardBuffer.NumLines(MaxLines: Integer): Integer;
var
  P: PChar;
begin
  P:=Buffer;
  Result:=0;
  while (P^<>Chr(0)) and (Result<MaxLines) do
  begin
    if P^=Chr(13) then
      Result:=Result+1;
    P:=P+1
  end
end;

procedure TClipBoardBuffer.ToClipBoard;
begin
  ClipBoard.SetTextBuf(Buffer)
end;

procedure TClipBoardBuffer.FromClipBoard;
begin
  ClipBoard.GetTextBuf(Buffer,BufferSize);
  Pointer:=Buffer
end;

function RelativeDir(Name: string): string;
var
  CurrentDir,d: string;
  p,q,i: Integer;
begin
  GetDir(0,CurrentDir);
  if CurrentDir[Length(CurrentDir)]<>'\' then
    CurrentDir:=CurrentDir+'\';
  Result:=ExpandFileName(Name);
  if CompareText(CurrentDir[1],Result[1])=0 then
  begin
    repeat
      p:=Pos('\',CurrentDir);
      d:=Copy(CurrentDir,1,p);
      q:=Pos(d,Result);
      if q=1 then
      begin
        CurrentDir:=Copy(CurrentDir,p+1,1000);
        Result:=Copy(Result,p+1,1000)
      end
    until (q<>1) or (Length(CurrentDir)=0);
    for i:=1 to Length(CurrentDir) do
      if CurrentDir[i]='\' then
        Result:='..\'+Result
  end
end;

end.

