unit facturactrl2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmfacturadatamodule2, mvc, DB, Forms,
  frmbuscaralumnos, buscaralctrl, Controls;

type

  { TFacturaController }

  TFacturaController = class(TABMController)
  private
    FCustomModel: TFacturasDataModule;
    { Aca saca el objeto model pero casteado al tipo que necesitamos para poder
      usar los metodos y funciones especificos del modelo y que no estan
      especificados en la interfaz }
    procedure SetCustomModel(AValue: TFacturasDataModule);
  public
    constructor Create(AModel: IModel); overload;
    destructor Destroy; override;
    procedure ActualizarTotales(Sender: IView);
    procedure NuevaFactura(Sender: IView);
    procedure CerrarFactura(Sender: IView);
    procedure OpenBuscarPersForm(Sender: IFormView);
    function GetFacturaEstado(Sender: IView): TEstadoFactura;
    procedure SetVencimiento(ADate: TDateTime);
    property CustomModel: TFacturasDataModule read FCustomModel write SetCustomModel;
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

destructor TFacturaController.Destroy;
var
  x: Pointer;
begin
  x := Pointer(FCustomModel);
  Model := nil;
  FCustomModel := nil;
  TFacturasDataModule(x).Free;
  inherited Destroy;
end;

procedure TFacturaController.ActualizarTotales(Sender: IView);
begin
  CustomModel.ActualizarTotales;
end;

procedure TFacturaController.NuevaFactura(Sender: IView);
begin
  CustomModel.NuevaFactura;
end;

procedure TFacturaController.CerrarFactura(Sender: IView);
begin
  Model.SaveChanges;
  Model.Commit;
  Model.RefreshDataSets;
end;

procedure TFacturaController.OpenBuscarPersForm(Sender: IFormView);
begin
  case TPopupSeleccionAlumnos.Create(Sender, TBuscarAlumnosController.Create(Model)).ShowModal of
    mrOk:
    begin
      // si ya se esta editando la factura simplemente la cancelamos y hacemos otra
      Cancel(Sender);
      NuevaFactura(Sender);
      CustomModel.FetchCabecera;
      CustomModel.FetchDeuda;
    end
    else
    begin
      Exit;
    end;
  end;
end;

function TFacturaController.GetFacturaEstado(Sender: IView): TEstadoFactura;
begin
  Result := CustomModel.Estado;
end;

procedure TFacturaController.SetVencimiento(ADate: TDateTime);
begin
  CustomModel.qryFacturaFECHA_EMISION.AsDateTime := ADate;
end;

constructor TFacturaController.Create(AModel: IModel);
begin
  inherited Create(AModel);
  if (AModel is TFacturasDataModule) then
    CustomModel := (AModel as TFacturasDataModule)
  else
    raise Exception.Create(rsModelErr);
end;

end.
