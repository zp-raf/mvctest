unit seleccionexamenctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmexamendatamodule;

type

  { TSeleccionExamenController }

  TSeleccionExamenController = class(TController)
  protected
    function GetCustomModel: TExamenesDataModule;
  public
    destructor Destroy; override;
  end;

implementation

{ TSeleccionExamenController }

function TSeleccionExamenController.GetCustomModel: TExamenesDataModule;
begin
  Result := GetModel as TExamenesDataModule;
end;

destructor TSeleccionExamenController.Destroy;
begin
  ClearModelPtr;
  inherited Destroy;
end;

end.
