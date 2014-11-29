unit notacreditoctrl;

{$mode objfpc}{$H+}

interface

uses
  comprobantectrl, frmNotaCreditoDataModule, mvc, DB, sgcdTypes;

type

  { TNotaCreditoController }

  TNotaCreditoController = class(TComprobanteController)
  protected
    function GetCustomModel: TNotaCreditoDataModule;
  public
    procedure Cancel(Sender: IView); override;
    procedure CerrarComprobante(Sender: IView); override;
    procedure CerrarComprobante(EsVenta: boolean; Sender: IView); overload;
    procedure FetchCabeceraPersona(Sender: IView);
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
begin
  CerrarComprobante(True, Sender);
end;

procedure TNotaCreditoController.CerrarComprobante(EsVenta: boolean; Sender: IView);
var
  NotaID: string;
begin
  try
    NotaID := GetCustomModel.qryCabecera.FieldByName('ID').AsString;
    GetCustomModel.qryCabecera.ApplyUpdates;
    GetCustomModel.qryDetalle.ApplyUpdates;
    GetCustomModel.RegistrarMovimiento(EsVenta, NotaID);
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

procedure TNotaCreditoController.FetchCabeceraPersona(Sender: IView);
begin
  GetCustomModel.FetchCabeceraPersona;
end;

function TNotaCreditoController.GetPersonasDataSource: TDataSource;
begin
  Result := GetCustomModel.dsPersonasRoles;
end;

procedure TNotaCreditoController.NuevoComprobanteCompra(Sender: IView);
begin
  GetCustomModel.CheckPrecioUnitario := True;
  GetCustomModel.NuevoComprobanteCompra;
  GetCustomModel.NuevoComprobanteDetalle;
end;

procedure TNotaCreditoController.SetPrecioTotal(AField: string; Sender: IFormView);
begin
  if GetEstadoComprobante(Sender) = asEditando then
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
