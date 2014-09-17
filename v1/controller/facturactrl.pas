unit facturactrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mvc, ctrl, frmfacturadatamodule;

type

  { TFacturaController }

  TFacturaController = class(TController)
    procedure ErrorHandler(E: Exception; Sender: IModel);
    procedure ActualizarTotal(Sender: IView);
    procedure NuevaFactura(Sender: IView);
  end;

var
  FacturaController: TFacturaController;

implementation

{ TFacturaController }

procedure TFacturaController.ErrorHandler(E: Exception; Sender: IModel);
begin

end;

procedure TFacturaController.ActualizarTotal(Sender: IView);
begin
  (Model as TFacturaDataModule).ActualizarTotal(Self);
end;

procedure TFacturaController.NuevaFactura(Sender: IView);
begin
  Model.NewRecord;
end;

end.
