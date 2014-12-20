unit pagoctrl;

{$mode objfpc}{$H+}

interface

uses
  ctrl, frmpagodatamodule, mvc, sgcdtypes, mensajes, SysUtils, DB;

type

  { TPagoController }

  TPagoController = class(TController)
  protected
    function GetCustomModel: TPagoDataModule;
  public
    destructor Destroy; override;
    procedure AnularPago(PagoID: string);
    procedure Cancel(Sender: IView); override;
    procedure CerrarPago(Sender: IView);
    procedure CloseQuery(Sender: IView; var CanClose: boolean); override;
    procedure ImprimirRecibo(Sender: IView);
    procedure NuevoPago(EsCobro: boolean; ADocumentoID: string;
      ATipoDoc: TTipoDocumento);
    function GetDetallesDataSource: TDataSource;
    function GetNCTotalText: string;
    function HayNotasCredito: boolean;
    function PagoListo: boolean;
  end;

implementation

{ TPagoController }

function TPagoController.GetCustomModel: TPagoDataModule;
begin
  Result := GetModel as TPagoDataModule;
end;

destructor TPagoController.Destroy;
begin
  ClearModelPtr;
  inherited;
end;

procedure TPagoController.NuevoPago(EsCobro: boolean; ADocumentoID: string;
  ATipoDoc: TTipoDocumento);
begin
  GetCustomModel.OpenDataSets;
  GetCustomModel.NuevoPago(EsCobro, ADocumentoID, ATipoDoc);
end;

function TPagoController.GetDetallesDataSource: TDataSource;
begin
  Result := GetCustomModel.Facturas.dsNCView;
end;

function TPagoController.GetNCTotalText: string;
begin
  if GetCustomModel.Facturas.FacTotal.IsEmpty or
    (GetCustomModel.Facturas.FacTotal.State = dsInactive) then
    Result := '0'
  else
    Result := GetCustomModel.Facturas.FacTotal.FieldByName('NC').AsString;
end;

function TPagoController.HayNotasCredito: boolean;
begin
  if (GetCustomModel.Facturas.NCView.State = dsInactive) or
    GetCustomModel.Facturas.NCView.IsEmpty then
    Result := False
  else
    Result := True;
end;

procedure TPagoController.AnularPago(PagoID: string);
begin
  GetCustomModel.AnularPago(PagoID);
  GetCustomModel.Asientos.SaveChanges;
  GetCustomModel.Pago.ApplyUpdates;
  GetModel.Commit;
end;

procedure TPagoController.Cancel(Sender: IView);
begin
  GetModel.DiscardChanges;
  GetModel.Rollback;
  Sender.ShowInfoMessage(rsPaymntDiscrd);
end;

procedure TPagoController.CerrarPago(Sender: IView);
begin
  GetCustomModel.SaveChanges;
  Sender.ShowInfoMessage(rsPaymentRegistered);
end;

procedure TPagoController.CloseQuery(Sender: IView; var CanClose: boolean);
begin
  CanClose := True;
  inherited CloseQuery(Sender, CanClose);
end;

procedure TPagoController.ImprimirRecibo(Sender: IView);
begin
  GetCustomModel.PuedeImprimirRecibo := True;
end;

function TPagoController.PagoListo: boolean;
begin
  Result := GetCustomModel.Listo;
end;

end.
