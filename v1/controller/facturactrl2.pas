unit facturactrl2;

{$mode objfpc}{$H+}

interface

uses
  ctrl, frmfacturadatamodule2, mvc, Controls, sgcdTypes, comprobantectrl,
  frmcomprobantedatamodule, personactrl;

type

  { TFacturaController }

  TFacturaController = class(TComprobanteController)
  protected
    function GetCustomModel: TFacturasDataModule;
  public
    procedure Cancel(Sender: IView); override;
    procedure CerrarComprobante(Sender: IView); override;
    procedure NuevoComprobante(Sender: IView); override;
    procedure SetVencimiento(ADate: TDateTime);
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
  GetCustomModel.NuevoComprobante;
  GetCustomModel.FetchCabeceraPersona;
  GetCustomModel.FetchDetallePersona;
end;

procedure TFacturaController.CerrarComprobante(Sender: IView);
begin
  GetModel.SaveChanges;
  GetModel.Commit;
  //GetModel.RefreshDataSets;
end;

procedure TFacturaController.SetVencimiento(ADate: TDateTime);
begin
  GetCustomModel.qryCabecera.FieldByName('FECHA_EMISION').AsDateTime := ADate;
end;

end.
