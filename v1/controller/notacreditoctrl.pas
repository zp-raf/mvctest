unit notacreditoctrl;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, comprobantectrl, frmNotaCreditoDataModule, mvc, DB,
  sgcdTypes, observerSubject;

type

  { TNotaCreditoController }

  TNotaCreditoController = class(TComprobanteController)
  protected
    function GetCustomModel: TNotaCreditoDataModule;
  public
    procedure Cancel(Sender: IView); override;
    procedure CerrarComprobante(Sender: IView); override;
    procedure CerrarComprobanteCompra(Sender: IView);
    procedure FetchCabeceraPersona(Sender: IView);
    procedure FiltrarFacturas(ACompraVenta: TCompraVenta; Sender: IView);
    function GetPersonasDataSource: TDataSource;
    procedure NuevoComprobanteCompra(Sender: IView);
    procedure SetPrecioTotal(AField: string; Sender: IFormView);
    procedure NuevoComprobante(Sender: IView); override;
  end;

var
  NotaCreditoController: TNotaCreditoController;

implementation

{ TNotaCreditoController }

function TNotaCreditoController.GetCustomModel: TNotaCreditoDataModule;
begin
  Result := GetModel as TNotaCreditoDataModule;
end;

procedure TNotaCreditoController.Cancel(Sender: IView);
begin
  GetModel.DiscardChanges;
end;

procedure TNotaCreditoController.CerrarComprobante(Sender: IView);
var
  NotaID: string;
begin
  if EsCompra then
    CerrarComprobanteCompra(Sender)
  else
    try
      NotaID := GetCustomModel.qryCabecera.FieldByName('ID').AsString;
      GetCustomModel.qryCabecera.ApplyUpdates;
      GetCustomModel.qryDetalle.ApplyUpdates;
      GetCustomModel.RegistrarMovimiento(NotaID);
      GetCustomModel.SaveChanges;
      GetModel.Commit;
      //GetModel.RefreshDataSets;
      with GetCustomModel do
      begin
        Estado := csGuardado;
        (MasterDataModule as ISubject).Notify;
      end;
    except
      on E: EDatabaseError do
      begin
        Rollback(Sender);
        raise;
      end;
    end;
end;

procedure TNotaCreditoController.CerrarComprobanteCompra(Sender: IView);
var
  CompID, desc, descCtaPers: string;
begin
  try
    if GetCustomModel.qryCabeceraNUMERO_NOTA_COMPRA.IsNull or
      GetCustomModel.qryCabeceraTIMBRADO.IsNull then
    begin
      Sender.ShowErrorMessage('Complete los campos de numero y timbrado');
      Exit;
    end;
    desc := 'Nota de credito ' + GetCustomModel.qryCabecera.FieldByName(
      'NUMERO_NOTA_COMPRA').AsString + ' con timbrado ' +
      GetCustomModel.qryCabecera.FieldByName('TIMBRADO').AsString;
    descCtaPers := 'Emision de nota de credito nro ' +
      GetCustomModel.qryCabecera.FieldByName('NUMERO_NOTA_COMPRA').AsString +
      ' con timbrado ' + GetCustomModel.qryCabecera.FieldByName('TIMBRADO').AsString;
    CompID := GetCustomModel.qryCabecera.FieldByName('ID').AsString;
    GetCustomModel.qryCabecera.ApplyUpdates;
    GetCustomModel.qryDetalle.ApplyUpdates;
    GetCustomModel.RegistrarMovimientoCompra(CompID, doNotaCredito, desc, descCtaPers);
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

procedure TNotaCreditoController.FetchCabeceraPersona(Sender: IView);
begin
  GetCustomModel.FetchCabeceraPersona;
end;

procedure TNotaCreditoController.FiltrarFacturas(ACompraVenta: TCompraVenta;
  Sender: IView);
begin
  GetCustomModel.FiltrarFacturas(ACompraVenta);
end;

function TNotaCreditoController.GetPersonasDataSource: TDataSource;
begin
  Result := GetCustomModel.dsPersonasRoles;
end;

procedure TNotaCreditoController.NuevoComprobanteCompra(Sender: IView);
begin
  GetCustomModel.CheckPrecioUnitario := True;
  GetCustomModel.NuevoComprobanteCompra;
  GetCustomModel.FetchCabeceraFactura;
  GetCustomModel.FetchCabeceraCompra;
  GetCustomModel.FetchDetalleFactura;
end;

procedure TNotaCreditoController.SetPrecioTotal(AField: string; Sender: IFormView);
begin
  if GetEstadoComprobante(Sender) = csEditando then
  begin
    if not (GetCustomModel.qryDetalle.State in dsEditModes) then
      GetCustomModel.qryDetalle.Edit;
    GetCustomModel.qryDetalle.FieldByName(AField).AsFloat :=
      GetCustomModel.qryDetalle.FieldByName('CANTIDAD').AsFloat *
      GetCustomModel.qryDetalle.FieldByName('PRECIO_UNITARIO').AsFloat;
    //GetCustomModel.ActualizarTotales;
    GetCustomModel.qryDetalle.Post;
  end;
end;

procedure TNotaCreditoController.NuevoComprobante(Sender: IView);
begin
  GetCustomModel.CheckPrecioUnitario := True;
  GetCustomModel.NuevoComprobante;
  GetCustomModel.FetchCabeceraFactura;
  GetCustomModel.FetchDetalleFactura;
end;

end.
