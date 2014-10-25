unit facturactrl2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmfacturadatamodule2, mvc, DB, Controls,
  frmcomprobantedatamodule, buscarpersctrl;

type

  { TFacturaController }

  TFacturaController = class(TABMController)
  private
    FBuscarPersonasController: TBuscarPersonasController;
    FCustomModel: TFacturasDataModule;
    { Aca saca el objeto model pero casteado al tipo que necesitamos para poder
      usar los metodos y funciones especificos del modelo y que no estan
      especificados en la interfaz }
    procedure SetBuscarPersonasController(AValue: TBuscarPersonasController);
    procedure SetCustomModel(AValue: TFacturasDataModule);
  public
    procedure BeforeDestruction; override;
    constructor Create(AModel: IModel); overload;
    //constructor Create(var AModel); overload;
    procedure ActualizarTotales(Sender: IView);
    procedure Cancel(Sender: IView);
    procedure CerrarFactura(Sender: IView);
    procedure NuevaFactura(Sender: IView);
    procedure SetVencimiento(ADate: TDateTime);
    function GetFacturaEstado(Sender: IView): TEstadoComprobante;
    property CustomModel: TFacturasDataModule read FCustomModel write SetCustomModel;
    property BuscarPersonasController: TBuscarPersonasController
      read FBuscarPersonasController write SetBuscarPersonasController;
  end;

var
  FacturaController: TFacturaController;

implementation

{ TFacturaController }

procedure TFacturaController.SetCustomModel(AValue: TFacturasDataModule);
begin
  if FCustomModel = AValue then
    Exit;
  FCustomModel := AValue;
end;

procedure TFacturaController.BeforeDestruction;
begin
  Model := nil;
  CustomModel.Free;
  CustomModel := nil;
  inherited BeforeDestruction;
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
  CustomModel.ActualizarTotales;
end;

procedure TFacturaController.Cancel(Sender: IView);
begin
  Model.DiscardChanges;
end;

procedure TFacturaController.NuevaFactura(Sender: IView);
begin
  CustomModel.NuevoComprobante;
  CustomModel.FetchCabecera;
  CustomModel.FetchDetalle;
end;

procedure TFacturaController.CerrarFactura(Sender: IView);
begin
  Model.SaveChanges;
  Model.Commit;
  //Model.RefreshDataSets;
end;

function TFacturaController.GetFacturaEstado(Sender: IView): TEstadoComprobante;
begin
  Result := CustomModel.Estado;
end;

procedure TFacturaController.SetVencimiento(ADate: TDateTime);
begin
  CustomModel.qryCabeceraFECHA_EMISION.AsDateTime := ADate;
end;

constructor TFacturaController.Create(AModel: IModel);
begin
  inherited Create(AModel);
  if (AModel is TFacturasDataModule) then
    CustomModel := (AModel as TFacturasDataModule)
  else
    raise Exception.Create(rsModelErr);
  FBuscarPersonasController := TBuscarPersonasController.Create(Model);
end;

//constructor TFacturaController.Create(var AModel);
//begin
//  CustomModel := TFacturasDataModule(AModel);
//  FBuscarPersonasController := TBuscarPersonasController.Create(Model);
//end;

end.
