unit periodoctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmperiodosdatamodule;

type

  { TPeriodoController }

  TPeriodoController = class(TABMController)
  protected
    function GetCustomModel: TPeriodosDataModule;
  public
    function HayPeriodoActivo: boolean;
  end;

implementation

{ TPeriodoController }

function TPeriodoController.GetCustomModel: TPeriodosDataModule;
begin
  Result := GetModel as TPeriodosDataModule;
end;

function TPeriodoController.HayPeriodoActivo: boolean;
begin
  Result := GetCustomModel.HayPeriodoActivo;
end;

end.
