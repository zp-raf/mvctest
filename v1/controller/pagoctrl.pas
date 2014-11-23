unit pagoctrl;

{$mode objfpc}{$H+}

interface

uses
  ctrl, frmpagodatamodule, mvc, sgcdtypes, mensajes, SysUtils;

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
  // nada si no se destruye el modelo
end;

procedure TPagoController.NuevoPago(EsCobro: boolean; ADocumentoID: string;
  ATipoDoc: TTipoDocumento);
begin
  GetCustomModel.OpenDataSets;
  GetCustomModel.NuevoPago(EsCobro, ADocumentoID, ATipoDoc);
end;

procedure TPagoController.AnularPago(PagoID: string);
begin
  GetCustomModel.AnularPago(PagoID);
  GetCustomModel.Asientos.SaveChanges;
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
  GetModel.SaveChanges;
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
