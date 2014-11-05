unit facturactrl2;

{$mode objfpc}{$H+}

interface

uses
  ctrl, frmfacturadatamodule2, mvc, Controls, sgcdTypes, comprobantectrl,
  frmcomprobantedatamodule, buscarpersctrl;

type

  { TFacturaController }

  TFacturaController = class(TComprobanteController)
  private
    FBuscarPersonasController: TBuscarPersonasController;
    procedure SetBuscarPersonasController(AValue: TBuscarPersonasController);
  protected
    function GetCustomModel: TFacturasDataModule;
  public
    constructor Create(AModel: Pointer); overload; override;
    //constructor Create(var AModel); overload;
    procedure Cancel(Sender: IView);
    procedure CerrarComprobante(Sender: IView); override;
    procedure NuevoComprobante(Sender: IView); override;
    procedure SetVencimiento(ADate: TDateTime);
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
  GetCustomModel.qryCabeceraFECHA_EMISION.AsDateTime := ADate;
end;

constructor TFacturaController.Create(AModel: Pointer);
begin
  inherited Create(AModel);
  FBuscarPersonasController := TBuscarPersonasController.Create(GetCustomModel.Personas);
end;

end.
