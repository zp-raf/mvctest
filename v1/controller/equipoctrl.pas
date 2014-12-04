unit equipoctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmequiposdatamodule;

type

  { TEquiposController }

  TEquiposController = class(TABMController)
  protected
    function GetCustomModel: TEquiposDataModule;
  end;

implementation

{ TEquiposController }

function TEquiposController.GetCustomModel: TEquiposDataModule;
begin
  Result := GetModel as TEquiposDataModule;
end;

end.
