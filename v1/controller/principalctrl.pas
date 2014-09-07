unit principalctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, mvc, observerSubject, frmMaestro, Forms, Dialogs;

type

  { TPrincipalController }

  TPrincipalController = class(TController)
  public
    procedure CreateForm(Sender: TComponent; AViewClass: TClass;
      AModelClass: TClass; AControllerClass: TClass; out Reference);
    function GetUserName(Sender: IFormView): string;
    function GetHostName(Sender: IFormView): string;
  end;

var
  PrincipalController: TPrincipalController;

implementation

{ TPrincipalController }

procedure TPrincipalController.CreateForm(Sender: TComponent;
  AViewClass: TClass; AModelClass: TClass; AControllerClass: TClass; out Reference);
begin
  { primero creamos la vista, luego el controlador, luego el modelo  y por ultimo
    le añadimos a la vista a la lista de observadores del modelo }
  ShowMessage(AViewClass.ClassName);
end;

function TPrincipalController.GetUserName(Sender: IFormView): string;
begin

end;

function TPrincipalController.GetHostName(Sender: IFormView): string;
begin

end;

end.
