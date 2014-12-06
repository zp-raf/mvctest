unit moduloctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmmodulodatamodule, mvc;

type

  { TModuloController }

  TModuloController = class(TABMController)
  protected
    function GetCustomModel: TModuloDataModule;
  public
    function ModuloGeneralDefinido(Sender: IView): boolean;
  end;

implementation

{ TModuloController }

function TModuloController.GetCustomModel: TModuloDataModule;
begin
  Result := GetModel as TModuloDataModule;
end;

function TModuloController.ModuloGeneralDefinido(Sender: IView): boolean;
begin
  try
    Result := GetCustomModel.ModuloGeneralDefinido;
  except
    on E: Exception do
    begin
      raise;
      Sender.ShowErrorMessage('No se pudo averiguar si hay un modulo general');
    end;
  end;
end;

end.
