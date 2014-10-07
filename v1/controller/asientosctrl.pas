unit asientosctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmasientosdatamodule, mvc, DB, manejoerrores;

resourcestring
  rsFormatoDeMon = 'Formato de monto invalido';
  rsFormatoDeIde = 'Formato de identificador invalido';

type

  { TAsientosController }

  TAsientosController = class(TABMController)
  private
    FCustomModel: TAsientosDataModule;
    { Aca saca el objeto model pero casteado al tipo que necesitamos para poder
      usar los metodos y funciones especificos del modelo y que no estan
      especificados en la interfaz }
    function GetCustomModel: TAsientosDataModule;
    function GetCuentaDataSource: TDataSource;
    procedure SetCustomModel(AValue: TAsientosDataModule);
  public
    destructor Destroy; override;
    constructor Create(AModel: IModel); overload;
    function GetAsientoEstado(Sender: IView): TEstadoAsiento;
    procedure NuevoAsiento(ADescripcion: string; Sender: IView);
    procedure NuevoAsientoDetalle(ACuentaID: string; ATipoMov: TTipoMovimiento;
      AMonto: string; Sender: IView);
    procedure NuevoAsientoDetalle(ATipoMov: TTipoMovimiento; AMonto: string;
      Sender: IView);
    procedure CerrarAsiento(Sender: IView);
    procedure ErrorHandler(E: Exception; Sender: IView); override;
    procedure ReversarAsiento(AAsientoID: string; ADescripcion: string; Sender: IView);
    procedure ReversarAsiento(ADescripcion: string; Sender: IView);
    property CustomModel: TAsientosDataModule read GetCustomModel write SetCustomModel;
  end;

var
  AsientosController: TAsientosController;

implementation

{ TAsientosController }

function TAsientosController.GetCuentaDataSource: TDataSource;
begin
  Result := GetCustomModel.dsCuenta;
end;

procedure TAsientosController.SetCustomModel(AValue: TAsientosDataModule);
begin
  if AValue = FCustomModel then
    Exit;
  FCustomModel := AValue;
end;

destructor TAsientosController.Destroy;
var
  x: Pointer;
begin
  x := Pointer(FCustomModel);
  Model := nil;
  FCustomModel := nil;
  TAsientosDataModule(x).Free;
  inherited;
end;

constructor TAsientosController.Create(AModel: IModel);
begin
  inherited Create(AModel);
  if (AModel is TAsientosDataModule) then
    CustomModel := (AModel as TAsientosDataModule)
  else
    raise Exception.Create(rsModelErr);
end;

function TAsientosController.GetAsientoEstado(Sender: IView): TEstadoAsiento;
begin
  Result := GetCustomModel.Estado;
end;

function TAsientosController.GetCustomModel: TAsientosDataModule;
begin
  Result := FCustomModel;
end;

procedure TAsientosController.NuevoAsiento(ADescripcion: string; Sender: IView);
begin
  GetCustomModel.NuevoAsiento(ADescripcion);
end;

procedure TAsientosController.NuevoAsientoDetalle(ACuentaID: string;
  ATipoMov: TTipoMovimiento; AMonto: string; Sender: IView);
var
  id: integer;
  mon: double;
begin
  if TryStrToInt(ACuentaID, id) then
    if TryStrToFloat(AMonto, mon) then
    begin
      GetCustomModel.NuevoAsientoDetalle(ACuentaID, ATipoMov, mon);
    end
    else
      Sender.ShowInfoMessage(rsFormatoDeMon)
  else
    Sender.ShowInfoMessage(rsFormatoDeIde);
end;

procedure TAsientosController.NuevoAsientoDetalle(ATipoMov: TTipoMovimiento;
  AMonto: string; Sender: IView);
var
  mon: double;
begin
  if TryStrToFloat(AMonto, mon) then
    NuevoAsientoDetalle(GetCustomModel.Cuenta.CuentaID.AsString,
      ATipoMov, AMonto, Sender)
  else
    Sender.ShowInfoMessage(rsFormatoDeMon);
end;

procedure TAsientosController.CerrarAsiento(Sender: IView);
begin
  GetCustomModel.CerrarAsiento;
  Model.SaveChanges;
  Model.RefreshDataSets;
end;

procedure TAsientosController.ErrorHandler(E: Exception; Sender: IView);
begin
  //para avisar si se metio mal el nro de asiento
  inherited ErrorHandler(E, Sender);
  Model.DiscardChanges;
  Model.Rollback;
end;

procedure TAsientosController.ReversarAsiento(AAsientoID: string;
  ADescripcion: string; Sender: IView);
var
  id: integer;
begin
  if TryStrToInt(AAsientoID, id) then
  begin
    GetCustomModel.ReversarAsiento(AAsientoID, ADescripcion);
    Model.SaveChanges;
    Model.RefreshDataSets;
  end
  else
    Sender.ShowInfoMessage(rsFormatoDeIde);
end;

procedure TAsientosController.ReversarAsiento(ADescripcion: string; Sender: IView);
begin
  GetCustomModel.ReversarAsiento(ADescripcion);
  Model.SaveChanges;
  Model.RefreshDataSets;
end;

end.
