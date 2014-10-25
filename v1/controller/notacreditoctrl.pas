unit notacreditoctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, frmNotaCreditoDataModule, mvc, db, ctrl;


type

  { TNotaCreditoController }

  TNotaCreditoController = class(TABMController)

  private
    FCustomModel: TNotaCreditoDataModule;
    { Aca saca el objeto model pero casteado al tipo que necesitamos para poder
      usar los metodos y funciones especificos del modelo y que no estan
      especificados en la interfaz }
    procedure SetCustomModel(AValue: TNotaCreditoDataModule);
  public
    constructor Create(AModel: IModel); overload;
    destructor Destroy; override;
    procedure ActualizarTotales(Sender: IView);
    procedure NuevaFactura(Sender: IView);
    procedure CerrarFactura(Sender: IView);
    function GetFacturaEstado(Sender: IView):TEstadoNotaCredito;
    procedure SetVencimiento(ADate: TDateTime);
    property CustomModel: TNotaCreditoDataModule read FCustomModel write SetCustomModel;
  end;

var
  NotaCreditoController: TNotaCreditoController;

implementation

{ TNotaCreditoController }

procedure TNotaCreditoController.SetCustomModel(AValue: TNotaCreditoDataModule);
begin
  if FCustomModel = AValue then
    Exit;
  FCustomModel := AValue;
end;


constructor TNotaCreditoController.Create(AModel: IModel);
begin
  inherited Create(AModel);
  if (AModel is TNotaCreditoDataModule) then
    CustomModel := (AModel as TNotaCreditoDataModule)
  else
    raise Exception.Create(rsModelErr);
end;

destructor TNotaCreditoController.Destroy;
begin
  inherited Destroy;
end;

procedure TNotaCreditoController.ActualizarTotales(Sender: IView);
begin
      CustomModel.ActualizarTotales;
end;

procedure TNotaCreditoController.NuevaFactura(Sender: IView);
begin
  CustomModel.NuevaFactura;
  CustomModel.FetchCabecera;
  CustomModel.FetchDeuda;
end;

procedure TNotaCreditoController.CerrarFactura(Sender: IView);
begin
  Model.SaveChanges;
  Model.Commit;
  Model.RefreshDataSets;
end;

function TNotaCreditoController.GetFacturaEstado(Sender: IView): TEstadoNotaCredito;
begin
  Result := CustomModel.Estado;
end;

procedure TNotaCreditoController.SetVencimiento(ADate: TDateTime);
begin
  CustomModel.qryFacturaFECHA_EMISION.AsDateTime := ADate;
end;

end.

