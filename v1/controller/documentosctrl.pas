unit documentosctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmdocumentosdatamodule, mvc, frmfacturadatamodule2,
  frmpagodatamodule, pagoctrl;

type

  { TDocumentosController }

  TDocumentosController = class(TController)
  private
    FCustomModel: TDocumentosDataModule;
    FPagoController: TPagoController;
    procedure SetCustomModel(AValue: TDocumentosDataModule);
    procedure SetPagoController(AValue: TPagoController);
  public
    constructor Create(AModel: IModel);
    procedure AnularDoc(ATipoDoc: TTipoDocumento);
    procedure AnularDoc(ATipoDoc: TTipoDocumento; ADoc: string);
    procedure AnularPago(ATipoDoc: TTipoDocumento);
    procedure AnularPago(ATipoDoc: TTipoDocumento; ADoc: string);
    procedure CobrarDoc(ATipoDoc: TTipoDocumento);
    procedure CobrarDoc(ATipoDoc: TTipoDocumento; ADoc: string);
    procedure VerDocumento(ATipoDoc: TTipoDocumento);
    procedure VerDocumento(ATipoDoc: TTipoDocumento; ADoc: string);
    property CustomModel: TDocumentosDataModule read FCustomModel write SetCustomModel;
    property PagoController: TPagoController read FPagoController
      write SetPagoController;
  end;

implementation

{ TDocumentosController }

procedure TDocumentosController.SetCustomModel(AValue: TDocumentosDataModule);
begin
  if FCustomModel = AValue then
    Exit;
  FCustomModel := AValue;
end;

procedure TDocumentosController.SetPagoController(AValue: TPagoController);
begin
  if FPagoController = AValue then
    Exit;
  FPagoController := AValue;
end;

constructor TDocumentosController.Create(AModel: IModel);
begin
  inherited Create(AModel);
  if (AModel is TDocumentosDataModule) then
    CustomModel := (AModel as TDocumentosDataModule)
  else
    raise Exception.Create(rsModelErr);
  // el controlador para los pagos
  FPagoController := TPagoController.Create(CustomModel.Pagos);
end;

procedure TDocumentosController.AnularDoc(ATipoDoc: TTipoDocumento);
begin

end;

procedure TDocumentosController.AnularDoc(ATipoDoc: TTipoDocumento; ADoc: string);
begin

end;

procedure TDocumentosController.AnularPago(ATipoDoc: TTipoDocumento);
begin

end;

procedure TDocumentosController.AnularPago(ATipoDoc: TTipoDocumento; ADoc: string);
begin

end;

procedure TDocumentosController.CobrarDoc(ATipoDoc: TTipoDocumento);
begin
  case ATipoDoc of
    doFactura: CobrarDoc(ATipoDoc, CustomModel.FacturasViewID.AsString);
  end;
end;

procedure TDocumentosController.CobrarDoc(ATipoDoc: TTipoDocumento; ADoc: string);
begin
  case ATipoDoc of
    doFactura:
    begin
      PagoController.NuevoPago(True, ADoc, ATipoDoc);
    end;
  end;
end;

procedure TDocumentosController.VerDocumento(ATipoDoc: TTipoDocumento);
begin

end;

procedure TDocumentosController.VerDocumento(ATipoDoc: TTipoDocumento; ADoc: string);
begin

end;

end.
