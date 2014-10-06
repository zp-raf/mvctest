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
    { Aca saca el objeto model pero casteado al tipo que necesitamos para poder
      usar los metodos y funciones especificos del modelo y que no estan
      especificados en la interfaz }
    function GetCustomModel: TAsientosDataModule;
    function GetCuentaDebeDataSource: TDataSource;
    function GetCuentaHaberDataSource: TDataSource;
  public
    //constructor Create(AModel: IModel); overload;
    procedure NuevoAsiento(ADescripcion: string; Sender: IView);
    procedure ErrorHandler(E: Exception; Sender: IView); override;
    procedure ReversarAsiento(AAsientoID: string; ADescripcion: string; Sender: IView);
    procedure ReversarAsiento(ADescripcion: string; Sender: IView);
  end;

var
  AsientosController: TAsientosController;

implementation

{ TAsientosController }

function TAsientosController.GetCuentaDebeDataSource: TDataSource;
begin
  Result := GetCustomModel.dsCuentaDebe;
end;

function TAsientosController.GetCuentaHaberDataSource: TDataSource;
begin
  Result := GetCustomModel.dsCuentaHaber;
end;

//constructor TAsientosController.Create(AModel: IModel);
//begin
//  inherited Create(AModel);
//end;

function TAsientosController.GetCustomModel: TAsientosDataModule;
begin
  Result := (Model as TAsientosDataModule);
end;

procedure TAsientosController.NuevoAsiento(ADescripcion: string; Sender: IView);
begin
  GetCustomModel.NuevoAsiento(ADescripcion);
end;

procedure TAsientosController.ErrorHandler(E: Exception; Sender: IView);
begin
  //para avisar si se metio mal el nro de asiento
  inherited ErrorHandler(E, Sender);
end;

procedure TAsientosController.ReversarAsiento(AAsientoID: string;
  ADescripcion: string; Sender: IView);
begin
  GetCustomModel.ReversarAsiento(AAsientoID, ADescripcion);
  Model.SaveChanges;
  Model.RefreshDataSets;
end;

procedure TAsientosController.ReversarAsiento(ADescripcion: string; Sender: IView);
begin
  GetCustomModel.ReversarAsiento(ADescripcion);
  Model.SaveChanges;
  Model.RefreshDataSets;
end;

end.
