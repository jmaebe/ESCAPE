{ Project: Escape                                                            }
{ Version: 1.1                                                               }
{ Author: Peter Verplaetse                                                   }
{ Date: 22 July 1998                                                         }

{ This file gets executed first }

program Escape;

{$MODE Delphi}

uses
  Forms,Interfaces,
  Main in 'main.pas' {MainForm},
  Common in 'common.pas',
  Config in 'config.pas' {ConfigForm},
  Datamem in 'datamem.pas' {DmemForm},
  Micro in 'micro.pas' {MicroForm},
  Pipe in 'pipe.pas' {PipeForm},
  Usage in 'usage.pas' {UsageForm},
  Activity in 'activity.pas' {ActivityForm},
  Instrmem in 'instrmem.pas' {ImemForm},
  Range in 'range.pas' {RangeForm},
  Pipedef in 'pipedef.pas' {PipeCode},
  Microcod in 'microcod.pas' {MicroCode},
  Brkform in 'brkform.pas' {BreakForm},
  About in 'about.pas' {AboutForm};

{$R *.res}

begin
  { for compatibility with the Delphi version }
  DefaultTextLineBreakStyle:=tlbsCRLF;
  { Initialize data structures }
  Encoding:=TEncoding.Create;
  Unravel:=TUnravel.Create;
  Labels:=TLabels.Create;
  Tracker:=TTrackBuffer.Create;
  FileIO:=TFileIO.Create;
  { Create forms and start application }
  Application.Title:='Escape v1.2.0RC2';
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TConfigForm, ConfigForm);
  Application.Run;
end.
