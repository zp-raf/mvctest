unit derechoexamenctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmderechoexamendatamodule;

type

  { TDerechoExamenController }

  TDerechoExamenController = class(TController)
  protected
    function GetCustomModel: TDerechoExamenDataModule;
  end;

implementation

{ TDerechoExamenController }

function TDerechoExamenController.GetCustomModel: TDerechoExamenDataModule;
begin
  Result := GetModel as TDerechoExamenDataModule;
end;

end.
