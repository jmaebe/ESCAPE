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

unit About;

{$MODE Delphi}

interface

uses {WinTypes, WinProcs,} Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, LResources;

type
  { This is the 'About' form }
  TAboutForm = class(TForm)
    Memo1: TMemo;
    Panel2: TPanel;
    ProgramIcon: TImage;
    Label1: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.lfm}

uses
  Main;

procedure TAboutForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree
end;

procedure TAboutForm.FormCreate(Sender: TObject);
begin
  ProgramIcon.Picture:=MainForm.ProgramIcon.Picture
end;

end.

