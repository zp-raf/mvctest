unit facturactrl2;

{$mode objfpc}{$H+}

interface

uses
  ctrl, frmfacturadatamodule2, mvc, Controls, sgcdTypes, comprobantectrl,
  frmcomprobantedatamodule, personactrl, DB;

type

  { TFacturaController }

  TFacturaController = class(TComprobanteController)
  protected
    function GetCustomModel: TFacturasDataModule;
  public
    procedure Cancel(Sender: IView); override;
    procedure CerrarComprobante(Sender: IView); override;
    procedure FetchCabeceraPersona(Sender: IView);
    procedure NuevoComprobante(Sender: IView); override;
    procedure NuevoComprobanteCompra(Sender: IView);
    procedure SetVencimiento(ADate: TDateTime);
    procedure SetPrecioTotal(AField: string; Sender: IFormView);
    function GetPersonasDataSource: TDataSource;
  end;

var
  FacturaController: TFacturaController;

implementation

{ TFacturaController }

function TFacturaController.GetCustomModel: TFacturasDataModule;
begin
  Result := GetModel as TFacturasDataModule;
end;

procedure TFacturaController.Cancel(Sender: IView);
begin
  GetModel.DiscardChanges;
end;

procedure TFacturaController.NuevoComprobante(Sender: IView);
begin
  GetCustomModel.CheckPrecioUnitario := True;
  GetCustomModel.NuevoComprobante;
  GetCustomModel.FetchCabeceraPersona;
  GetCustomModel.FetchDetallePersona;
end;

procedure TFacturaController.NuevoComprobanteCompra(Sender: IView);
begin
  GetCustomModel.CheckPrecioUnitario := False;
  GetCustomModel.NuevoComprobanteCompra;
  GetCustomModel.NuevoComprobanteDetalle;
end;

procedure TFacturaController.CerrarComprobante(Sender: IView);
begin
  GetModel.SaveChanges;
  GetModel.Commit;
  //GetModel.RefreshDataSets;
end;

procedure TFacturaController.FetchCabeceraPersona(Sender: IView);
begin
  GetCustomModel.FetchCabeceraPersona;
end;

function TFacturaController.GetPersonasDataSource: TDataSource;
begin
  Result := GetCustomModel.dsPersonasRoles;
end;

procedure TFacturaController.SetVencimiento(ADate: TDateTime);
begin
  GetCustomModel.qryCabecera.FieldByName('FECHA_EMISION').AsDateTime := ADate;
end;

procedure TFacturaController.SetPrecioTotal(AField: string; Sender: IFormView);
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

end.
