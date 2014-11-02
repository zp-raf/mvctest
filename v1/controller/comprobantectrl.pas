unit comprobantectrl;

{$mode objfpc}{$H+}

interface

uses
  mvc, ctrl, frmcomprobantedatamodule;

type

  { TComprobanteController }

  TComprobanteController = class(TABMController)
  protected
    function GetCustomModel: TComprobanteDataModule;
  public
    procedure ActualizarTotales(Sender: IView);
    procedure CerrarComprobante(Sender: IView);
    procedure NuevoComprobante(Sender: IView);
    function GetEstadoComprobante(Sender: IView): TEstadoComprobante;
  end;

implementation

{ TComprobanteController }

function TComprobanteController.GetCustomModel: TComprobanteDataModule;
begin
  Result := GetModel as TComprobanteDataModule;
end;

procedure TComprobanteController.ActualizarTotales(Sender: IView);
begin

end;

procedure TComprobanteController.CerrarComprobante(Sender: IView);
begin

end;

procedure TComprobanteController.NuevoComprobante(Sender: IView);
begin

end;

function TComprobanteController.GetEstadoComprobante(Sender: IView): TEstadoComprobante;
begin
  Result := GetCustomModel.Estado;
end;

end.
