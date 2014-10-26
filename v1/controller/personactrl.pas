unit personactrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmpersonasdatamodule;

type

  { TPersonaController }

  TPersonaController = class(TABMController)
    function GetCustomModel: TPersonasDataModule;
  end;

var
  PersonaController: TPersonaController;

implementation

{ TPersonaController }

function TPersonaController.GetCustomModel: TPersonasDataModule;
begin
  Result := GetModel as TPersonasDataModule;
end;

end.
