unit comprobantectrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mvc, ctrl, frmcomprobantedatamodule;

type

  { TComprobanteController }

  TComprobanteController = class(TABMController)
  private
    FCustomModel: TComprobanteDataModule;
    procedure SetCustomModel(AValue: TComprobanteDataModule);
  public
    constructor Create(AModel: IModel); overload;
    procedure ActualizarTotales(Sender: IView);
    procedure CerrarComprobante(Sender: IView);
    procedure NuevoComprobante(Sender: IView);
    function GetEstadoComprobante(Sender: IView): TEstadoComprobante;
    property CustomModel: TComprobanteDataModule read FCustomModel write SetCustomModel;
  end;

implementation

{ TComprobanteController }

constructor TComprobanteController.Create(AModel: IModel);
begin
  inherited Create(AModel);
  if (AModel is TComprobanteDataModule) then
    CustomModel := (AModel as TComprobanteDataModule)
  else
    raise Exception.Create(rsModelErr);
end;

procedure TComprobanteController.SetCustomModel(AValue: TComprobanteDataModule);
begin
  if FCustomModel = AValue then
    Exit;
  FCustomModel := AValue;
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

end;

end.
