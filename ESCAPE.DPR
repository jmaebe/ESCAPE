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
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TConfigForm, ConfigForm);
  Application.Run;
end.
