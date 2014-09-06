unit principalctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, mvc, observerSubject, frmMaestro;

resourcestring

type

  { TPrincipalController }

  TPrincipalController = class(TController)
  public
    procedure CreateForm(Sender: IFormView; AView: IFormView; AModel: IModel;
      AController: TController);
  end;

implementation

{ TPrincipalController }

procedure TPrincipalController.CreateForm(Sender: IFormView; AView: IFormView;
  AModel: IModel; AController: TController);
begin

  { primero creamos el modelo, luego el controlador, luego la vista y por ultimo
    le añadimos a la vista a la lista de observadores del modelo }
  if (AView is TMaestro) and (Sender is TMaestro) then
  (AView as TMaestro).Create(Self, AController);

end;

end.
