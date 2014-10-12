unit facturactrl2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmfacturadatamodule2, mvc, db;

type

  { TAsientosController }

  { TFacturaController }

  TFacturaController = class(TABMController)
  private
    { Aca saca el objeto model pero casteado al tipo que necesitamos para poder
      usar los metodos y funciones especificos del modelo y que no estan
      especificados en la interfaz }
    FCustomModel: TFacturasDataModule;
    function GetCustomModel: TFacturasDataModule;
    procedure SetCustomModel(AValue: TFacturasDataModule);
  public

  function GetFacturaEstado(Sender: IView): TEstadoFactura;
  destructor Destroy; override;
  constructor Create(AModel: IModel); overload;
  procedure NuevaFactura(Sender: IView);
  procedure CerrarFactura(Sender: IView);
//  procedure ErrorHandler(E: Exception; Sender: IView); override;
  property CustomModel: TFacturasDataModule read GetCustomModel write SetCustomModel;

  end;

var
  FacturaController: TFacturaController;

implementation

{ TFacturaController }

function TFacturaController.GetCustomModel: TFacturasDataModule;
begin
  Result := (Model as TFacturasDataModule);
end;

procedure TFacturaController.SetCustomModel(AValue: TFacturasDataModule);
begin
     if (AValue = FCustomModel) then
    Exit;
  FCustomModel := AValue;
end;

function TFacturaController.GetFacturaEstado(Sender: IView): TEstadoFactura;
begin
  Result := GetCustomModel.Estado;
end;

destructor TFacturaController.Destroy;
var
   x: Pointer;
begin
     x := Pointer(FCustomModel);
     Model := nil;
     FCustomModel := nil;
     TFacturasDataModule(x).Free;
  inherited;
end;

constructor TFacturaController.Create(AModel: IModel);
begin
  inherited Create(AModel) ;
   if (AModel is TFacturasDataModule) then
     CustomModel := (AModel as TFacturasDataModule)
   else
     raise Exception.Create('Error al crear el ctrl');
end;

procedure TFacturaController.NuevaFactura(Sender: IView);
begin
     // GetCustomModel.NuevaFactura(Sender: TObject);
end;

procedure TFacturaController.CerrarFactura(Sender: IView);
begin
//  GetCustomModel.Cerr;
  Model.SaveChanges;
  Model.RefreshDataSets;
end;

end.

