unit registroanecdoticoctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmregistroanecdoticodatamodule;

type

  { TRegistroAnecdoticoController }

  TRegistroAnecdoticoController = class(TController)
  protected
    function GetCustomModel: TRegistroAnecdoticoDataModule;
  end;

implementation

{ TRegistroAnecdoticoController }

function TRegistroAnecdoticoController.GetCustomModel: TRegistroAnecdoticoDataModule;
begin
  Result := GetModel as TRegistroAnecdoticoDataModule;
end;

end.
