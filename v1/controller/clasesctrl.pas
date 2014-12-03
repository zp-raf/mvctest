unit clasesctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmclasesdatamodule;

type

  { TClaseController }

  TClaseController = class(TABMController)
  protected
    function GetCustomModel: TClasesDataModule;
  end;

implementation

{ TClaseController }

function TClaseController.GetCustomModel: TClasesDataModule;
begin
  Result := GetModel as TClasesDataModule;
end;

end.
