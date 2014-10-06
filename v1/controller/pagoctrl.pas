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

constructor TPagoController.Create(AModel: IModel);
begin
  inherited Create(AModel);
  if (AModel is TPagoDataModule) then
    CustomModel := (AModel as TPagoDataModule)
  else
    raise Exception.Create(rsModelErr);
end;

end.
