unit impuestoctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmimpuestodadamodule;

type

  { TImpuestoController }

  TImpuestoController = class(TABMController)
  protected
    function GetCustomModel: TImpuestoDataModule;
  end;

implementation

{ TImpuestoController }

function TImpuestoController.GetCustomModel: TImpuestoDataModule;
begin
  Result := GetModel as TImpuestoDataModule;
end;

end.
