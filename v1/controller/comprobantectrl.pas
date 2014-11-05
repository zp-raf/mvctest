unit comprobantectrl;

{$mode objfpc}{$H+}

interface

uses
  mvc, ctrl, frmcomprobantedatamodule, sgcdTypes;

type

  { TComprobanteController }

  TComprobanteController = class(TABMController)
  protected
    function GetComprobanteModel: TComprobanteDataModule;
  public
    procedure ActualizarTotales(Sender: IView); virtual;
    procedure CerrarComprobante(Sender: IView); virtual; abstract;
    procedure NuevoComprobante(Sender: IView); virtual; abstract;
    function GetEstadoComprobante(Sender: IView): TEstadoComprobante;
  end;

implementation

{ TComprobanteController }

function TComprobanteController.GetComprobanteModel: TComprobanteDataModule;
begin
  Result := GetModel as TComprobanteDataModule;
end;

procedure TComprobanteController.ActualizarTotales(Sender: IView);
begin
  GetComprobanteModel.ActualizarTotales;
end;

function TComprobanteController.GetEstadoComprobante(Sender: IView): TEstadoComprobante;
begin
  Result := GetComprobanteModel.Estado;
end;

end.
