unit buscarpersctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, mvc;

type

  { TBuscarAlumnosController }

  TBuscarPersonasController = class(TController)
  public
    procedure Aceptar(Sender: IFormView);
    procedure Cancelar(Sender: IFormView);
  end;

var
  BuscarPersonasController: TBuscarPersonasController;

implementation

{ TBuscarAlumnosController }

procedure TBuscarPersonasController.Aceptar(Sender: IFormView);
begin

end;

procedure TBuscarPersonasController.Cancelar(Sender: IFormView);
begin

end;

end.
