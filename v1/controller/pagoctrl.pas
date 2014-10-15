unit pagoctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmpagodatamodule, mvc;

type

  { TPagoController }

  TPagoController = class(TController)
  private
    FCustomModel: TPagoDataModule;
    function GetCustomModel: TPagoDataModule;
    procedure SetCustomModel(AValue: TPagoDataModule);
  public
    procedure NuevoPago(EsCobro: boolean; ADocumentoID: string;
      ATipoDoc: TTipoDocumento);
    constructor Create(AModel: IModel); overload;
    property CustomModel: TPagoDataModule read GetCustomModel write SetCustomModel;
  end;

implementation

{ TPagoController }

procedure TPagoController.SetCustomModel(AValue: TPagoDataModule);
begin
  if FCustomModel = AValue then
    Exit;
  FCustomModel := AValue;
end;

function TPagoController.GetCustomModel: TPagoDataModule;
begin
  Result := FCustomModel;
end;

procedure TPagoController.NuevoPago(EsCobro: boolean; ADocumentoID: string;
  ATipoDoc: TTipoDocumento);
begin
  CustomModel.NuevoPago(EsCobro, ADocumentoID, ATipoDoc);
end;

constructor TPagoController.Create(AModel: IModel);
begin
  inherited Create(AModel);
  if (AModel is TPagoDataModule) then
    CustomModel := (AModel as TPagoDataModule)
  else
    raise Exception.Create(rsModelErr);
end;

end.
