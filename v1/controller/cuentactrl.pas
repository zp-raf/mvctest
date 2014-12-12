unit cuentactrl;

{$mode objfpc}{$H+}

interface

uses
  ctrl, frmcuentadatamodule, mvc;

type

  { TCuentaController }

  TCuentaController = class(TABMController)
  protected
    function GetCustomModel: TCuentaDataModule;
  public
    function EsCuentaHija: boolean;
  end;

implementation

{ TCuentaController }

function TCuentaController.GetCustomModel: TCuentaDataModule;
begin
  Result := GetModel as TCuentaDataModule;
end;

function TCuentaController.EsCuentaHija: boolean;
begin
  if GetCustomModel.CuentaCUENTA_PADRE.IsNull then
    Result := False
  else
    Result := True;
end;

end.
