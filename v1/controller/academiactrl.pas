unit academiactrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmacademiadatamodule;

type

  { TAcademiaController }

  TAcademiaController = class(TABMController)
  protected
    function GetCustomModel: TAcademiaDataModule;
  end;

var
  AcademiaController: TAcademiaController;

implementation

{ TAcademiaController }

function TAcademiaController.GetCustomModel: TAcademiaDataModule;
begin
  Result := GetModel as TAcademiaDataModule;
end;

end.
