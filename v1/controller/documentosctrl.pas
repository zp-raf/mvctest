unit documentosctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmdocumentosdatamodule, mvc, frmfacturadatamodule2,
  frmpagodatamodule, pagoctrl, frmpago, Controls;

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
    procedure AnularDoc(ATipoDoc: TTipoDocumento; Sender: IFormView);
    procedure AnularDoc(ATipoDoc: TTipoDocumento; ADoc: string; Sender: IFormView);
    procedure AnularPago(ATipoDoc: TTipoDocumento; Sender: IFormView);
    procedure AnularPago(ATipoDoc: TTipoDocumento; ADoc: string; Sender: IFormView);
    procedure CobrarDoc(ATipoDoc: TTipoDocumento; Sender: IFormView);
    procedure CobrarDoc(ATipoDoc: TTipoDocumento; ADoc: string; Sender: IFormView);
    procedure VerDocumento(ATipoDoc: TTipoDocumento; Sender: IFormView);
    procedure VerDocumento(ATipoDoc: TTipoDocumento; ADoc: string; Sender: IFormView);
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

procedure TDocumentosController.AnularDoc(ATipoDoc: TTipoDocumento; Sender: IFormView);
begin

end;

procedure TDocumentosController.AnularDoc(ATipoDoc: TTipoDocumento;
  ADoc: string; Sender: IFormView);
begin

end;

procedure TDocumentosController.AnularPago(ATipoDoc: TTipoDocumento; Sender: IFormView);
begin
  //case ATipoDoc of
  //  //doFactura: AnularDoc(ATipoDoc, CustomModel.CobrosView.Lookup('ID', CustomModel.FacturasCobradasViewID., Sender);
  //end;
end;

procedure TDocumentosController.AnularPago(ATipoDoc: TTipoDocumento;
  ADoc: string; Sender: IFormView);
begin
  //case ATipoDoc of
  //  doFactura:
  //  begin
  //    //PagoController.AnularPago();
  //  end;
  //  end;
  //end;
end;

procedure TDocumentosController.CobrarDoc(ATipoDoc: TTipoDocumento; Sender: IFormView);
begin
  case ATipoDoc of
    doFactura: CobrarDoc(ATipoDoc, CustomModel.FacturasViewID.AsString, Sender);
  end;
end;

procedure TDocumentosController.CobrarDoc(ATipoDoc: TTipoDocumento;
  ADoc: string; Sender: IFormView);
//var
//  CobroForm: TProcesoPago;
begin
  try
    //CobroForm := TProcesoPago.Create(Sender, PagoController);
    case ATipoDoc of
      doFactura:
      begin
        PagoController.NuevoPago(True, ADoc, ATipoDoc);
      end;
    end;
    //case CobroForm.ShowModal of
    //  mrOk:
    //  begin
    //    Model.Connect;
    //  end;
    //  mrCancel:
    //  begin
    //    Model.Connect;
    //  end;
    //end;
  finally
    //CobroForm.Free;
    //CobroForm := nil;
  end;
end;

procedure TDocumentosController.VerDocumento(ATipoDoc: TTipoDocumento;
  Sender: IFormView);
begin

end;

procedure TDocumentosController.VerDocumento(ATipoDoc: TTipoDocumento;
  ADoc: string; Sender: IFormView);
begin

end;

end.
