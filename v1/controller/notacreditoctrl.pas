unit notacreditoctrl;

{$mode objfpc}{$H+}

interface

uses
  comprobantectrl, frmNotaCreditoDataModule, mvc, DB;

type

  { TNotaCreditoController }

  TNotaCreditoController = class(TComprobanteController)
  protected
    function GetCustomModel: TNotaCreditoDataModule;
  public
    procedure Cancel(Sender: IView);
    procedure CerrarComprobante(Sender: IView); override;
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
  try
    GetModel.SaveChanges;
    GetCustomModel.RegistrarMovimiento;
    GetModel.Commit;
  except
    on E: EDatabaseError do
      Rollback(Sender);
  end;
end;

procedure TNotaCreditoController.NuevoComprobante(Sender: IView);
begin
  GetCustomModel.NuevoComprobante;
  GetCustomModel.FetchCabeceraFactura;
  GetCustomModel.FetchDetalleFactura;
end;

end.
