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

{ This file gets executed first }

program Escape;

uses
  Forms,
  Main in 'MAIN.PAS' {MainForm},
  Common in 'COMMON.PAS',
  Config in 'CONFIG.PAS' {ConfigForm},
  Datamem in 'DATAMEM.PAS' {DmemForm},
  Micro in 'MICRO.PAS' {MicroForm},
  Pipe in 'PIPE.PAS' {PipeForm},
  Usage in 'USAGE.PAS' {UsageForm},
  Activity in 'ACTIVITY.PAS' {ActivityForm},
  Instrmem in 'INSTRMEM.PAS' {ImemForm},
  Range in 'RANGE.PAS' {RangeForm},
  Pipedef in 'PIPEDEF.PAS' {PipeCode},
  Microcod in 'MICROCOD.PAS' {MicroCode},
  Brkform in 'BRKFORM.PAS' {BreakForm},
  About in 'ABOUT.PAS' {AboutForm};

{$R *.RES}

begin
  { Initialize data structures }
  Encoding:=TEncoding.Create;
  Unravel:=TUnravel.Create;
  Labels:=TLabels.Create;
  Tracker:=TTrackBuffer.Create;
  FileIO:=TFileIO.Create;
  { Create forms and start application }
  Application.Title := 'Escape v1.1.6';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TConfigForm, ConfigForm);
  Application.Run;
end.
