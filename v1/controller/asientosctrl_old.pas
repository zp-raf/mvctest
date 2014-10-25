unit asientosctrl_old;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmasientosdatamodule, mvc, DB;

resourcestring
  rsFormatoDeMon = 'Formato de monto invalido';
  rsFormatoDeIde = 'Formato de identificador invalido';

type

  { TAsientosController }

  TAsientosController = class(TInterfacedObject, IABMController, IController)
  private
    FABMController: IABMController;
    FController: IController;
    FModel: IModel;
    procedure SetModel(AValue: IModel);
  public
    constructor Create(AModel: IModel); overload;
    function GetCuentaDebeDataSource: TDataSource;
    function GetCuentaHaberDataSource: TDataSource;

    { Aca saca el objeto model pero casteado al tipo que necesitamos para poder
      usar los metodos y funciones especificos del modelo y que no estan
      especificados en la interfaz }
    function GetCustomModel: TAsientosDataModule;
    procedure NuevoAsiento(ACuentaDebeID: string; ACuentaHaberID: string;
      AMonto: string; ADescripcion: string; Sender: IView);
    procedure NuevoAsiento(AMonto: string; ADescripcion: string; Sender: IFormView);
    procedure ReversarAsiento(AAsientoID: string; ADescripcion: string; Sender: IView);
    procedure ReversarAsiento(ADescripcion: string; Sender: IFormView);

     { este objeto implementa la interfaz. Hago asi en vez de usar herencia porque
       este controlador realmente NO es un controlador de ABM, sino que se
       comporta como tal en determinadas situaciones }
    property ABMController: IABMController read FABMController
      implements IABMController;
    property Controller: IController read FController implements IController;

    //{ esta propiedad esta con la unica finalidad de servir de 'atajo' al objeto
    //  Model que esta dentro de ABMController. Para no tener que escribir el
    //  nombre del objeto antes de cada llamada a Model, es muy tedioso }
    property Model: IModel read FModel write SetModel;
  end;

var
  AsientosController: TAsientosController;

implementation

{ TAsientosController }

procedure TAsientosController.SetModel(AValue: IModel);
begin
  if FModel=AValue then Exit;
  FModel:=AValue;
end;

constructor TAsientosController.Create(AModel: IModel);
var
  obj: IController;
begin
  FABMController := TABMController.Create(AModel);
  FABMController.QueryInterface(IController, obj);
  if obj <> nil then
    FController := obj
  else
    FController := TController.Create(AModel);
  FModel := AModel;
end;

function TAsientosController.GetCuentaDebeDataSource: TDataSource;
begin
  Result := GetCustomModel.dsCuentaDebe;
end;

function TAsientosController.GetCuentaHaberDataSource: TDataSource;
begin
  Result := GetCustomModel.dsCuentaHaber;
end;

function TAsientosController.GetCustomModel: TAsientosDataModule;
begin
  Result := (Model as TAsientosDataModule);
end;

procedure TAsientosController.NuevoAsiento(ACuentaDebeID: string;
  ACuentaHaberID: string; AMonto: string; ADescripcion: string; Sender: IView);
var
  pMonto: double;
begin
  if TryStrToFloat(AMonto, pMonto) then // validamos el monto
    GetCustomModel.NuevoAsiento(ACuentaDebeID, ACuentaHaberID, pMonto, ADescripcion)
  else
    Sender.ShowErrorMessage(rsFormatoDeMon);
  Model.SaveChanges;
  Model.RefreshDataSets;
end;

procedure TAsientosController.NuevoAsiento(AMonto: string; ADescripcion: string;
  Sender: IFormView);
var
  pMonto: double;
begin
  if TryStrToFloat(AMonto, pMonto) then // validamos el monto
    GetCustomModel.NuevoAsiento(pMonto, ADescripcion)
  else
    Sender.ShowErrorMessage(rsFormatoDeMon);
  Model.SaveChanges;
  Model.RefreshDataSets;
end;

procedure TAsientosController.ReversarAsiento(AAsientoID: string;
  ADescripcion: string; Sender: IView);
begin
  GetCustomModel.ReversarAsiento(AAsientoID, ADescripcion);
  Model.SaveChanges;
  Model.RefreshDataSets;
end;

procedure TAsientosController.ReversarAsiento(ADescripcion: string; Sender: IFormView);
begin
  GetCustomModel.ReversarAsiento(ADescripcion);
  Model.SaveChanges;
  Model.RefreshDataSets;
end;

end.
