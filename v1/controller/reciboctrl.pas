unit reciboctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, comprobantectrl, frmrecibodatamodule, mvc, db;

type

  { TReciboController }

  TReciboController = class(TComprobanteController)
  protected
    function GetCustomModel: TReciboDataModule;
  public
    procedure CerrarComprobante(Sender: IView); override;
    procedure NuevoComprobante(Sender: IView); override;
    procedure NuevoComprobante(Sender: IView; APagoID: string); overload;
  end;

implementation

{ TReciboController }

function TReciboController.GetCustomModel: TReciboDataModule;
begin
  Result := GetModel as TReciboDataModule;
end;

procedure TReciboController.CerrarComprobante(Sender: IView);
begin
  try
    GetModel.SaveChanges;
    GetModel.Commit;
  except
    on E: EDatabaseError do
      Rollback(Sender);
  end;
end;

procedure TReciboController.NuevoComprobante(Sender: IView);
begin
  GetCustomModel.NuevoComprobante;
  GetCustomModel.FetchCabeceraFactura;
  GetCustomModel.FetchDetalleFactura;
end;

procedure TReciboController.NuevoComprobante(Sender: IView; APagoID: string);
begin
  GetCustomModel.NuevoComprobante(APagoID);
  GetCustomModel.FetchCabeceraFactura;
  GetCustomModel.FetchDetalleFactura;
end;

end.

