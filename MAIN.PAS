{ Project: Escape                                                            }
{ Version: 1.1                                                               }
{ Author: Peter Verplaetse                                                   }
{ Date: 22 July 1998                                                         }

{ Note: install components in file Compos.pas before building Escape. Also,
        make sure complete boolean evaluation is disabled }

unit Main;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  { This form is used to launch the simulator or to pop up the configuration form }
  TMainForm = class(TForm)
    Panel1: TPanel;
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

{$R *.DFM}

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

