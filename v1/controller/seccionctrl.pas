unit seccionctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmsecciondatamodule;

type

  { TSeccionController }

  TSeccionController = class(TABMController)
  protected
    function GetCustomModel: TSeccionDataModule;
  end;

implementation

{ TSeccionController }

function TSeccionController.GetCustomModel: TSeccionDataModule;
begin
  Result := GetModel as TSeccionDataModule;
end;

end.
