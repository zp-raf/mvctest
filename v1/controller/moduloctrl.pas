unit moduloctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmmodulodatamodule;

type

  { TModuloController }

  TModuloController = class(TABMController)
  protected
    function GetCustomModel: TModuloDataModule;
  end;

implementation

{ TModuloController }

function TModuloController.GetCustomModel: TModuloDataModule;
begin
  Result := GetModel as TModuloDataModule;
end;

end.
