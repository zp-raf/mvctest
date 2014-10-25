unit pagoctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmpagodatamodule, mvc, asientosctrl, sgcdtypes;

type

  { TPagoController }

  TPagoController = class(TController)
  private
    FCustomModel: TPagoDataModule;
    function GetCustomModel: TPagoDataModule;
    procedure SetCustomModel(AValue: TPagoDataModule);
  public
    constructor Create(AModel: TPagoDataModule); overload;
    procedure AnularPago(PagoID: string);
    procedure Cancel(Sender: IView);
    procedure CerrarPago(Sender: IView);
    procedure CloseQuery(Sender: IView; var CanClose: boolean); override;
    procedure NuevoPago(EsCobro: boolean; ADocumentoID: string;
      ATipoDoc: TTipoDocumento);
    function PagoListo: boolean;
    property CustomModel: TPagoDataModule read GetCustomModel write SetCustomModel;
    //property AsientoController: TAsientosController;
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
  Model.OpenDataSets;
  CustomModel.NuevoPago(EsCobro, ADocumentoID, ATipoDoc);
end;

procedure TPagoController.AnularPago(PagoID: string);
begin
  CustomModel.AnularPago(PagoID);
end;

procedure TPagoController.Cancel(Sender: IView);
begin
  Model.DiscardChanges;
  Model.Rollback;
  Sender.ShowInfoMessage('Se descarto el pago no guardado');
end;

procedure TPagoController.CerrarPago(Sender: IView);
begin
  Model.SaveChanges;
  Sender.ShowInfoMessage('Pago registrado con exito');
end;

procedure TPagoController.CloseQuery(Sender: IView; var CanClose: boolean);
begin
  CanClose := True;
  inherited CloseQuery(Sender, CanClose);
end;

constructor TPagoController.Create(AModel: TPagoDataModule);
var
  x: IModel;
begin
  (AModel as IInterface).QueryInterface(IModel, x);
  if x <> nil then
  begin
    inherited Create(AModel);
    FCustomModel := AModel;
  end
  else
    raise Exception.Create(rsModelErr);
  //inherited Create(AModel);
  //if (AModel is TPagoDataModule) then
  //  CustomModel := (AModel as TPagoDataModule)
  //else
  //  raise Exception.Create(rsModelErr);
end;

function TPagoController.PagoListo: boolean;
begin
  Result := CustomModel.Listo;
end;

end.
