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
    procedure ActualizarDetallesCuenta(Sender: IFormView; var EsCuentaHija: boolean);
  end;

implementation

{ TCuentaController }

function TCuentaController.GetCustomModel: TCuentaDataModule;
begin
  Result := GetModel as TCuentaDataModule;
end;

procedure TCuentaController.ActualizarDetallesCuenta(Sender: IFormView;
  var EsCuentaHija: boolean);
begin
  GetCustomModel.ActualizarDetallesCuenta(Self, EsCuentaHija);
end;

end.
