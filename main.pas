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

{ Note: install components in file Compos.pas before building Escape. Also,
        make sure complete boolean evaluation is disabled }

unit Main;

{$MODE Delphi}

interface

uses {WinTypes, WinProcs,} Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, LResources;

type
  { This form is used to launch the simulator or to pop up the configuration form }
  TMainForm = class(TForm)
    Panel2: TPanel;
    Pipe: TButton;
    micro: TButton;
    ConfigButton: TButton;
    Memo2: TMemo;
    ProgramIcon: TImage;
    Label1: TLabel;
    procedure microClick(Sender: TObject);
    procedure PipeClick(Sender: TObject);
    procedure ConfigButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  end;

var
  MainForm: TMainForm;

implementation

uses Micro, Pipe, Config;

{$R *.lfm}

procedure TMainForm.microClick(Sender: TObject);
begin
  MainForm.Hide;
  Application.CreateForm(TMicroForm, MicroForm);
  MicroForm.Show
end;

procedure TMainForm.PipeClick(Sender: TObject);
begin
  MainForm.Hide;
  Application.CreateForm(TPipeForm, PipeForm);
  PipeForm.Show
end;

procedure TMainForm.ConfigButtonClick(Sender: TObject);
begin
  MainForm.Hide;
  ConfigForm.Show
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { Check if the configuration needs to be saved first }
  if ConfigForm.SaveFirst then
    Action:=caFree
  else
    { User clicked on cancel }
    Action:=caNone
end;

end.

