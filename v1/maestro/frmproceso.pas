unit frmproceso;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ButtonPanel, frmMaestro, mvc, LCLType;

type

  { TProceso }

  TProceso = class(TMaestro)
    ButtonPanel1: TButtonPanel;
    procedure ButtonPanel1KeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
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
  MenuItemAyudaClick(Self);
end;

procedure TProceso.CloseButtonClick(Sender: TObject);
begin
  GetController.Close(Self as IFormView);
end;

procedure TProceso.ButtonPanel1KeyUp(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Abort;
end;

end.


