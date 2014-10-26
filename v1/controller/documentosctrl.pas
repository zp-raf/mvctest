unit documentosctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmdocumentosdatamodule, mvc,
  frmpagodatamodule, pagoctrl, frmpago, Controls, sgcdTypes,
  facturactrl2, frmprocesofacturacion, frmfacturadatamodule2,
  frmrecibodatamodule, reciboctrl, frmprocesorecibo, frmquerydatamodule,
  observerSubject;

type

  { TDocumentosController }

  TDocumentosController = class(TController)
  private
    FCustomModel: TDocumentosDataModule;
    FPagoController: TPagoController;
    procedure SetCustomModel(AValue: TDocumentosDataModule);
    procedure SetPagoController(AValue: TPagoController);
  public
    procedure BeforeDestruction; override;
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

procedure TDocumentosController.BeforeDestruction;
begin
  CustomModel := nil;
  inherited BeforeDestruction;
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

  /// aca ya tengo que hacer el case, y usarle a CustomModel.FacturasViewID.AsString por ejemplo
//     VerDocumento(ATipoDoc, CustomModel.FacturasViewID.AsString,Sender);
end;

procedure TDocumentosController.VerDocumento(ATipoDoc: TTipoDocumento;
  ADoc: string; Sender: IFormView);
begin
  if ADoc = '1'  then
     ADoc:= CustomModel.CobrosViewID.AsString
  else if ADoc = '2' then
    ADoc:= CustomModel.FacturasViewID.AsString
  else if ADoc = '3' then
    ADoc:= CustomModel.FacturasCobradasViewID.AsString;

  try
    case ATipoDoc of
       doFactura:
       Begin
         ProcesoFacturacion := TProcesoFacturacion.Create(Sender,
           TFacturaController.Create(TFacturasDataModule.Create(
           (Sender as TComponent), Model.MasterDataModule)));

        ProcesoFacturacion.Show;
        (Model.MasterDataModule as ISubject).Attach(ProcesoFacturacion as IObserver);

      //   FacturasDataModule.qryCabeceraID.AsInteger:= StrToInt(ADoc);
         {
            ProcesoFacturacion.CustomController.CustomModel.qryCabecera.Active:= True;
          ProcesoFacturacion.CustomController.CustomModel.qryCabecera.Edit;
          ProcesoFacturacion.CustomController.CustomModel.qryCabeceraID.AsInteger:= StrToInt(ADoc);
          ProcesoFacturacion.CustomController.CustomModel.OpenDataSets;
          ProcesoFacturacion.CustomController.CustomModel.EditCurrentRecord;
           }

         ProcesoFacturacion.Edit;
         ProcesoFacturacion.CustomController.CustomModel.qryCabecera.Active:= True;
         ProcesoFacturacion.CustomController.CustomModel.qryCabecera.Edit;
         ProcesoFacturacion.CustomController.CustomModel.qryCabeceraID.AsInteger:= StrToInt(ADoc);

           {
            try
              ProcesoFacturacion.CustomController.CustomModel.qryCabecera.DisableControls;
              try
                ProcesoFacturacion.CustomController.CustomModel.qryCabecera.Close;
                ProcesoFacturacion.CustomController.CustomModel.qryCabecera.SQL.Clear;
                ProcesoFacturacion.CustomController.CustomModel.qryCabecera.SQL.Add
                ('SELECT * FROM FACTURA WHERE ID = '+ ADoc );
                try
                   ProcesoFacturacion.CustomController.CustomModel.qryCabecera.Open;
                finally
                end;

               finally
               ProcesoFacturacion.CustomController.CustomModel.qryCabecera.EnableControls;
               ProcesoFacturacion.Show;
               (Model.MasterDataModule as ISubject).Attach(ProcesoFacturacion as IObserver);

               end;
            finally

            end;

           }




       end;
       doRecibo:
       Begin
       ProcesoPago := TProcesoPago.Create(Sender,
       TPagoController.Create (TPagoDataModule.Create(
       (Sender as TComponent), Model.MasterDataModule)));
       ProcesoPago.Show;
       (Model.MasterDataModule as ISubject).Attach(ProcesoPago as IObserver);
  //     PagoDataModule.Pago.Close;
       PagoDataModule.PagoID.AsInteger:= StrToInt(ADoc);
  //     PagoDataModule.Pago.Open;
      //ProcesoPago.;
       end;
    end;
  finally
  end;



{

ProcesoFacturacion := TProcesoFacturacion.Create(Sender,
  TFacturaController.Create(TFacturasDataModule.Create(
  (Sender as TComponent), Model.MasterDataModule)));
ProcesoFacturacion.Show;
(Model.MasterDataModule as ISubject).Attach(ProcesoFacturacion as IObserver);


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


}



end;

end.
