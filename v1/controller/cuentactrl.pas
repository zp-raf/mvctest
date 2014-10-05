unit cuentactrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmcuentadatamodule, mvc;

type

  { TCuentaController }

  TCuentaController = class(TABMController)
  private
    FCustomModel: TCuentaDataModule;
    procedure SetCustomModel(AValue: TCuentaDataModule);
  public
    constructor Create(AModel: IModel); overload;
    property CustomModel: TCuentaDataModule read FCustomModel write SetCustomModel;
  end;

implementation

{ TCuentaController }

procedure TCuentaController.SetCustomModel(AValue: TCuentaDataModule);
begin
  if FCustomModel = AValue then
    Exit;
  FCustomModel := AValue;
end;

constructor TCuentaController.Create(AModel: IModel);
begin
  inherited Create(AModel);
  if (AModel is TCuentaDataModule) then
    CustomModel := (AModel as TCuentaDataModule)
  else
    raise Exception.Create(rsModelErr);
end;

end.

