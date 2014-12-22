unit reciboctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, comprobantectrl, frmrecibodatamodule, mvc, DB, sgcdTypes,
  observerSubject;

type

  { TReciboController }

  TReciboController = class(TComprobanteController)
  protected
    function GetCustomModel: TReciboDataModule;
  public
    procedure Cancel(Sender: IView); override;
    procedure CerrarComprobante(Sender: IView); override;
    procedure CerrarComprobanteCompra(Sender: IView);
    procedure FetchCabeceraPersona(Sender: IView);
    function GetFacturaDataSource: TDataSource;
    function GetPersonasDataSource: TDataSource;
    procedure NuevoComprobante(Sender: IView); override;
    procedure NuevoComprobante(Sender: IView; APagoID: string); overload;
    procedure NuevoComprobanteCompra(Sender: IView);
    procedure NuevoComprobanteCompraFac(Sender: IView);
    procedure SetPrecioTotal(Sender: IFormView);
    procedure SetCompra(Option: boolean); override;
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
  if EsCompra then
    CerrarComprobanteCompra(Sender)
  else
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

procedure TReciboController.CerrarComprobanteCompra(Sender: IView);
var
  CompID, desc, descCtaPers: string;
begin
  try
    if GetCustomModel.qryCabeceraNUMERO_REC_COMPRA.IsNull or
      GetCustomModel.qryCabeceraTIMBRADO.IsNull then
    begin
      Sender.ShowErrorMessage('Complete los campos de numero y timbrado');
      Exit;
    end;
    desc := 'Compra segun recibo nro ' + GetCustomModel.qryCabecera.FieldByName(
      'NUMERO_REC_COMPRA').AsString + ' con timbrado ' +
      GetCustomModel.qryCabecera.FieldByName('TIMBRADO').AsString;
    descCtaPers := 'Venta segun recibo nro ' +
      GetCustomModel.qryCabecera.FieldByName('NUMERO_REC_COMPRA').AsString +
      ' con timbrado ' + GetCustomModel.qryCabecera.FieldByName('TIMBRADO').AsString;
    CompID := GetCustomModel.qryCabecera.FieldByName('ID').AsString;
    GetCustomModel.qryCabecera.ApplyUpdates;
    GetCustomModel.qryDetalle.ApplyUpdates;
    GetCustomModel.RegistrarMovimientoCompra(CompID, doRecibo, desc, descCtaPers);
    GetCustomModel.Asientos.SaveChanges;
    GetModel.Commit;
    with GetCustomModel do
    begin
      Estado := csGuardado;
      (MasterDataModule as ISubject).Notify;
    end;
  except
    on E: Exception do
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

function TReciboController.GetFacturaDataSource: TDataSource;
begin
  Result := GetCustomModel.dsFacturas;
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
  GetCustomModel.FetchCabeceraPersona;
  GetCustomModel.FetchCabeceraCompra;
  GetCustomModel.NuevoComprobanteDetalle;
end;

procedure TReciboController.NuevoComprobanteCompraFac(Sender: IView);
begin
  GetCustomModel.CheckPrecioUnitario := False;
  GetCustomModel.NuevoComprobanteCompra;
  GetCustomModel.FetchCabeceraFactura;
  GetCustomModel.FetchCabeceraCompra;
  GetCustomModel.FetchDetalleFactura;
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

procedure TReciboController.SetCompra(Option: boolean);
begin
  inherited SetCompra(Option);
  GetCustomModel.Facturas.FacturasView.Close;
  if Option then
    GetCustomModel.Facturas.FacturasView.ServerFilter := 'CONTADO = 0 AND ESCOMPRA = 1'
  else
    GetCustomModel.Facturas.FacturasView.ServerFilter := 'CONTADO = 0 AND ESCOMPRA = 0';
  GetCustomModel.Facturas.FacturasView.ServerFiltered := True;
end;

end.

