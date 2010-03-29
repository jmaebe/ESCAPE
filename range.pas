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

unit Range;

{$MODE Delphi}

interface

uses
  SysUtils, {WinTypes, WinProcs,} Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, Compos, Spin, LResources;

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

{$R *.lfm}

procedure TRangeForm.OKButtonClick(Sender: TObject);
begin
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
