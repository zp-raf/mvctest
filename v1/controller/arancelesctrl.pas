unit arancelesctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmaranceldatamodule;

type

  { TArancelesController }

  TArancelesController = class(TABMController)
  protected
    function GetCustomModel: TArancelesDataModule;
  public
    procedure SetCuotas(option: boolean);
    procedure SetImpuesos(option: boolean);
    function HayCuotas: boolean;
    function HayImpuestos: boolean;
  end;

implementation

{ TArancelesController }

function TArancelesController.GetCustomModel: TArancelesDataModule;
begin
  Result := GetModel as TArancelesDataModule;
end;

procedure TArancelesController.SetCuotas(option: boolean);
begin
  if option and HayCuotas then
    GetCustomModel.CuotaXArancel.Edit
  else if option then
    GetCustomModel.CuotaXArancel.Insert
  else if HayCuotas then
    GetCustomModel.CuotaXArancel.Delete
  else
    GetCustomModel.CuotaXArancel.Cancel;
end;

procedure TArancelesController.SetImpuesos(option: boolean);
begin
  if option and HayImpuestos then
    GetCustomModel.ArancelImpuesto.Edit
  else if option then
    GetCustomModel.ArancelImpuesto.Insert
  else if HayImpuestos then
    GetCustomModel.ArancelImpuesto.Delete
  else
    GetCustomModel.ArancelImpuesto.Cancel;
end;

function TArancelesController.HayCuotas: boolean;
begin
  //Result := GetCustomModel.HayCuotas(GetCustomModel.ArancelID.AsString);
  Result := GetCustomModel.HayCuotas;
end;

function TArancelesController.HayImpuestos: boolean;
begin
  //Result := GetCustomModel.HayImpuestos(GetCustomModel.ArancelID.AsString);
  Result := GetCustomModel.HayImpuestos;
end;

end.
