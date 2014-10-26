unit facturactrl2;

{$mode objfpc}{$H+}

interface

uses
  ctrl, frmfacturadatamodule2, mvc, Controls,
  frmcomprobantedatamodule, buscarpersctrl;

type

  { TFacturaController }

  TFacturaController = class(TABMController)
  private
    FBuscarPersonasController: TBuscarPersonasController;
    procedure SetBuscarPersonasController(AValue: TBuscarPersonasController);
  protected
    function GetCustomModel: TFacturasDataModule;
  public
    constructor Create(AModel: Pointer); overload; override;
    //constructor Create(var AModel); overload;
    procedure ActualizarTotales(Sender: IView);
    procedure Cancel(Sender: IView);
    procedure CerrarFactura(Sender: IView);
    procedure NuevaFactura(Sender: IView);
    procedure SetVencimiento(ADate: TDateTime);
    function GetFacturaEstado(Sender: IView): TEstadoComprobante;
    property BuscarPersonasController: TBuscarPersonasController
      read FBuscarPersonasController write SetBuscarPersonasController;
  end;

var
  FacturaController: TFacturaController;

implementation

{ TFacturaController }

function TFacturaController.GetCustomModel: TFacturasDataModule;
begin
  Result := GetModel as TFacturasDataModule;
end;

procedure TFacturaController.SetBuscarPersonasController(
  AValue: TBuscarPersonasController);
begin
  if FBuscarPersonasController = AValue then
    Exit;
  FBuscarPersonasController := AValue;
end;

procedure TFacturaController.ActualizarTotales(Sender: IView);
begin
  GetCustomModel.ActualizarTotales;
end;

procedure TFacturaController.Cancel(Sender: IView);
begin
  GetModel.DiscardChanges;
end;

procedure TFacturaController.NuevaFactura(Sender: IView);
begin
  GetCustomModel.NuevoComprobante;
  GetCustomModel.FetchCabecera;
  GetCustomModel.FetchDetalle;
end;

procedure TFacturaController.CerrarFactura(Sender: IView);
begin
  GetModel.SaveChanges;
  GetModel.Commit;
  //GetModel.RefreshDataSets;
end;

function TFacturaController.GetFacturaEstado(Sender: IView): TEstadoComprobante;
begin
  Result := GetCustomModel.Estado;
end;

procedure TFacturaController.SetVencimiento(ADate: TDateTime);
begin
  GetCustomModel.qryCabeceraFECHA_EMISION.AsDateTime := ADate;
end;

constructor TFacturaController.Create(AModel: Pointer);
begin
  inherited Create(AModel);
  FBuscarPersonasController := TBuscarPersonasController.Create(GetCustomModel.Personas);
end;

end.
