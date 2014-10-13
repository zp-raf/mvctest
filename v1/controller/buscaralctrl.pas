unit buscaralctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, mvc;

type

  { TBuscarAlumnosController }

  TBuscarAlumnosController = class(TController)
    procedure Aceptar(Sender: IFormView);
    procedure Cancelar(Sender: IFormView);
    procedure CloseQuery(Sender: IView; var CanClose: boolean); override;
  end;

implementation

{ TBuscarAlumnosController }

procedure TBuscarAlumnosController.Aceptar(Sender: IFormView);
begin

end;

procedure TBuscarAlumnosController.Cancelar(Sender: IFormView);
begin

end;

procedure TBuscarAlumnosController.CloseQuery(Sender: IView;
  var CanClose: boolean);
begin
  //inherited CloseQuery(Sender, CanClose);
end;

end.
