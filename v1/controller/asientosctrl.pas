unit asientosctrl;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, ctrl, frmasientosdatamodule, mvc, DB;

resourcestring
  rsFormatoDeMon = 'Formato de monto invalido';
  rsFormatoDeIde = 'Formato de identificador invalido';

type

  { TAsientosController }

  TAsientosController = class(TABMController)
  private
    function GetCuentaDataSource: TDataSource;
  protected
    function GetCustomModel: TAsientosDataModule;
  public
    function GetAsientoEstado(Sender: IView): TEstadoAsiento;
    procedure NuevoAsiento(ADescripcion: string; Sender: IView);
    procedure NuevoAsientoDetalle(ACuentaID: string; ATipoMov: TTipoMovimiento;
      AMonto: string; Sender: IView);
    procedure NuevoAsientoDetalle(ATipoMov: TTipoMovimiento; AMonto: string;
      Sender: IView);
    procedure CerrarAsiento(Sender: IView);
    procedure ReversarAsiento(AAsientoID: string; ADescripcion: string; Sender: IView);
    procedure ReversarAsiento(ADescripcion: string; Sender: IView);
  end;

var
  AsientosController: TAsientosController;

implementation

{ TAsientosController }

function TAsientosController.GetCuentaDataSource: TDataSource;
begin
  Result := GetCustomModel.dsCuenta;
end;

function TAsientosController.GetAsientoEstado(Sender: IView): TEstadoAsiento;
begin
  Result := GetCustomModel.Estado;
end;

function TAsientosController.GetCustomModel: TAsientosDataModule;
begin
  Result := GetModel as TAsientosDataModule;
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
  GetModel.SaveChanges;
  GetModel.RefreshDataSets;
end;

procedure TAsientosController.ReversarAsiento(AAsientoID: string;
  ADescripcion: string; Sender: IView);
var
  id: integer;
begin
  if TryStrToInt(AAsientoID, id) then
  begin
    GetCustomModel.ReversarAsiento(AAsientoID, ADescripcion);
    GetModel.SaveChanges;
    GetModel.RefreshDataSets;
  end
  else
    Sender.ShowInfoMessage(rsFormatoDeIde);
end;

procedure TAsientosController.ReversarAsiento(ADescripcion: string; Sender: IView);
begin
  GetCustomModel.ReversarAsiento(ADescripcion);
  GetModel.SaveChanges;
  GetModel.RefreshDataSets;
end;

end.
