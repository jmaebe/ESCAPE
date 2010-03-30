{ Project: Escape                                                            }
{ Version: 1.1                                                               }
{ Author: Peter Verplaetse                                                   }
{ Date: 22 July 1998                                                         }

unit About;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  { This is the 'About' form }
  TAboutForm = class(TForm)
    Panel1: TPanel;
    OKButton: TBitBtn;
    Memo1: TMemo;
    Panel2: TPanel;
    ProgramIcon: TImage;
    Label1: TLabel;
    procedure OKButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.DFM}

uses
  Main;

procedure TAboutForm.OKButtonClick(Sender: TObject);
begin
  Close
end;

procedure TAboutForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree
end;

procedure TAboutForm.FormCreate(Sender: TObject);
begin
  ProgramIcon.Picture:=MainForm.ProgramIcon.Picture
end;

end.

