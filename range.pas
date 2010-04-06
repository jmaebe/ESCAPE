{ Project: Escape                                                            }
{ Version: 1.1                                                               }
{ Author: Peter Verplaetse                                                   }
{ Date: 22 July 1998                                                         }

unit Range;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, Compos, Spin;

type
  { Range Form -- used to set the Code Range}
  TRangeForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    StartRange: THexSpin;
    StopRange: THexSpin;
    procedure OKButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartRangeExit(Sender: TObject);
    procedure StopRangeExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
  end;

var
  RangeForm: TRangeForm;

implementation

uses Config, InstrMem;

{$R *.DFM}

procedure TRangeForm.OKButtonClick(Sender: TObject);
begin
  if StartRange.Value>StopRange.Value then
    StartRange.Value:=StopRange.Value;
  ImemForm.SetRange(StartRange.Value,StopRange.Value);
  Close
end;

procedure TRangeForm.CancelButtonClick(Sender: TObject);
begin
  Close
end;

procedure TRangeForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree
end;

procedure TRangeForm.StartRangeExit(Sender: TObject);
begin
  StartRange.Value:=StartRange.Value and $FFFC;
  StopRange.MinValue:=StartRange.Value;
end;

procedure TRangeForm.StopRangeExit(Sender: TObject);
begin
  StopRange.Value:=StopRange.Value and $FFFC;
  StartRange.MaxValue:=StopRange.Value;
end;

procedure TRangeForm.FormShow(Sender: TObject);
begin
  StartRange.Value:=ImemForm.StartRange;
  StopRange.Value:=ImemForm.StopRange;
  StartRange.MaxValue:=StopRange.Value;
  StopRange.MinValue:=StartRange.Minvalue;
  StopRange.MaxValue:=ConfigForm.ImemSize.Value-4;
end;


end.
