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
  end;

implementation

{ TPeriodoController }

function TPeriodoController.GetCustomModel: TPeriodosDataModule;
begin
  Result := GetModel as TPeriodosDataModule;
end;

end.
