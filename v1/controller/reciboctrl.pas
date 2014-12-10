unit reciboctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, comprobantectrl, frmrecibodatamodule, mvc, DB, sgcdTypes;

type

  { TReciboController }

  TReciboController = class(TComprobanteController)
  protected
    function GetCustomModel: TReciboDataModule;
  public
    procedure Cancel(Sender: IView); override;
    procedure CerrarComprobante(Sender: IView); override;
    procedure FetchCabeceraPersona(Sender: IView);
    function GetPersonasDataSource: TDataSource;
    procedure NuevoComprobante(Sender: IView); override;
    procedure NuevoComprobante(Sender: IView; APagoID: string); overload;
    procedure NuevoComprobanteCompra(Sender: IView);
    procedure SetPrecioTotal(Sender: IFormView);
  end;

implementation

{ TReciboController }

function TReciboController.GetCustomModel: TReciboDataModule;
begin
  Result := GetModel as TReciboDataModule;
end;

procedure TReciboController.Cancel(Sender: IView);
begin
  GetModel.DiscardChanges;
end;

procedure TReciboController.CerrarComprobante(Sender: IView);
begin
  try
    GetModel.SaveChanges;
    GetModel.Commit;
  except
    on E: EDatabaseError do
    begin
      Rollback(Sender);
      raise;
    end;
  end;
end;

procedure TReciboController.FetchCabeceraPersona(Sender: IView);
begin
  GetCustomModel.FetchCabeceraPersona;
end;

function TReciboController.GetPersonasDataSource: TDataSource;
begin
  Result := GetCustomModel.dsPersonasRoles;
end;

procedure TReciboController.NuevoComprobante(Sender: IView);
begin
  GetCustomModel.CheckPrecioUnitario := True;
  GetCustomModel.NuevoComprobante;
  GetCustomModel.FetchCabeceraPersona;
  GetCustomModel.FetchDetallePersona;
end;

procedure TReciboController.NuevoComprobante(Sender: IView; APagoID: string);
begin
  GetCustomModel.CheckPrecioUnitario := True;
  GetCustomModel.NuevoComprobante(APagoID);
  GetCustomModel.FetchCabeceraFactura;
  GetCustomModel.FetchDetalleFactura;
end;

procedure TReciboController.NuevoComprobanteCompra(Sender: IView);
begin
  GetCustomModel.CheckPrecioUnitario := False;
  GetCustomModel.NuevoComprobanteCompra;
  GetCustomModel.NuevoComprobanteDetalle;
end;

procedure TReciboController.SetPrecioTotal(Sender: IFormView);
begin
  if GetEstadoComprobante(Sender) = csEditando then
  begin
    if not (GetCustomModel.qryDetalle.State in dsEditModes) then
      GetCustomModel.qryDetalle.Edit;
    GetCustomModel.qryDetalle.FieldByName('TOTAL').AsFloat :=
      GetCustomModel.qryDetalle.FieldByName('CANTIDAD').AsFloat *
      GetCustomModel.qryDetalle.FieldByName('PRECIO_UNITARIO').AsFloat;
    //GetCustomModel.ActualizarTotales;
    GetCustomModel.qryDetalle.Post;
  end;
end;

end.

