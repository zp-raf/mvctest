unit frmproceso;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ButtonPanel, frmMaestro, mvc;

type

  { TProceso }

  TProceso = class(TMaestro)
    ButtonPanel1: TButtonPanel;
    procedure CloseButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
  end;

var
  Proceso: TProceso;

implementation

{$R *.lfm}

{ TProceso }

procedure TProceso.HelpButtonClick(Sender: TObject);
begin

end;

procedure TProceso.CloseButtonClick(Sender: TObject);
begin
  GetController.Close(Self as IFormView);
end;

end.

