unit documentosctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmdocumentosdatamodule, mvc,
  frmpagodatamodule, pagoctrl, frmpago, Controls, sgcdTypes,
  facturactrl2, frmprocesofacturacion, frmfacturadatamodule2,
  reciboctrl, frmprocesorecibo, frmquerydatamodule,
  observerSubject;

type

  { TDocumentosController }

  TDocumentosController = class(TController)
  private
    FPagoController: TPagoController;
    procedure SetPagoController(AValue: TPagoController);
  protected
    function GetCustomModel: TDocumentosDataModule;
  public
    constructor Create(AModel: Pointer); overload; override;
    destructor Destroy; override;
    procedure AnularDoc(ATipoDoc: TTipoDocumento; Sender: IFormView);
    procedure AnularDoc(ATipoDoc: TTipoDocumento; ADoc: string; Sender: IFormView);
    procedure AnularPago(ATipoDoc: TTipoDocumento; Sender: IFormView);
    procedure AnularPago(ATipoDoc: TTipoDocumento; ADoc: string; Sender: IFormView);
    procedure CobrarDoc(ATipoDoc: TTipoDocumento; Sender: IFormView);
    procedure CobrarDoc(ATipoDoc: TTipoDocumento; ADoc: string; Sender: IFormView);
    procedure VerDocumento(ATipoDoc: TTipoDocumento; Sender: IFormView);
    procedure VerDocumento(ATipoDoc: TTipoDocumento; ADoc: string; Sender: IFormView);
    property PagoController: TPagoController read FPagoController
      write SetPagoController;
  end;

implementation

{ TDocumentosController }

procedure TDocumentosController.SetPagoController(AValue: TPagoController);
begin
  if FPagoController = AValue then
    Exit;
  FPagoController := AValue;
end;

function TDocumentosController.GetCustomModel: TDocumentosDataModule;
begin
  Result := GetModel as TDocumentosDataModule;
end;

destructor TDocumentosController.Destroy;
begin
  PagoController.Free;
  inherited Destroy;
end;

constructor TDocumentosController.Create(AModel: Pointer);
begin
  inherited Create(AModel);
  // el controlador para los pagos
  FPagoController := TPagoController.Create(GetCustomModel.Pagos);
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
  //  //doFactura: AnularDoc(ATipoDoc, GetCustomModel.CobrosView.Lookup('ID', GetCustomModel.FacturasCobradasViewID., Sender);
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
    doFactura: CobrarDoc(ATipoDoc, GetCustomModel.FacturasViewID.AsString, Sender);
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

  /// aca ya tengo que hacer el case, y usarle a GetCustomModel.FacturasViewID.AsString por ejemplo
  //     VerDocumento(ATipoDoc, GetCustomModel.FacturasViewID.AsString,Sender);
end;

procedure TDocumentosController.VerDocumento(ATipoDoc: TTipoDocumento;
  ADoc: string; Sender: IFormView);
begin
  if ADoc = '1' then
    ADoc := GetCustomModel.CobrosViewID.AsString
  else if ADoc = '2' then
    ADoc := GetCustomModel.FacturasViewID.AsString
  else if ADoc = '3' then
    ADoc := GetCustomModel.FacturasCobradasViewID.AsString;

  try
    case ATipoDoc of
      doFactura:
      begin
        ProcesoFacturacion :=
          TProcesoFacturacion.Create(Sender, TFacturaController.Create(
          TFacturasDataModule.Create((Sender as TComponent), GetModel.MasterDataModule)));

        ProcesoFacturacion.Show;
        (GetModel.MasterDataModule as ISubject).Attach(ProcesoFacturacion as IObserver);

        //   FacturasDataModule.qryCabeceraID.AsInteger:= StrToInt(ADoc);
         {
            ProcesoFacturacion.GetCustomController.GetCustomModel.qryCabecera.Active:= True;
          ProcesoFacturacion.GetCustomController.GetCustomModel.qryCabecera.Edit;
          ProcesoFacturacion.GetCustomController.GetCustomModel.qryCabeceraID.AsInteger:= StrToInt(ADoc);
          ProcesoFacturacion.GetCustomController.GetCustomModel.OpenDataSets;
          ProcesoFacturacion.GetCustomController.GetCustomModel.EditCurrentRecord;
           }

        //ProcesoFacturacion.Edit;
        //ProcesoFacturacion.GetCustomController.GetCustomModel.qryCabecera.Active := True;
        //ProcesoFacturacion.GetCustomController.GetCustomModel.qryCabecera.Edit;
        //ProcesoFacturacion.GetCustomController.GetCustomModel.qryCabeceraID.AsInteger :=
        //  StrToInt(ADoc);
        //
           {
            try
              ProcesoFacturacion.GetCustomController.GetCustomModel.qryCabecera.DisableControls;
              try
                ProcesoFacturacion.GetCustomController.GetCustomModel.qryCabecera.Close;
                ProcesoFacturacion.GetCustomController.GetCustomModel.qryCabecera.SQL.Clear;
                ProcesoFacturacion.GetCustomController.GetCustomModel.qryCabecera.SQL.Add
                ('SELECT * FROM FACTURA WHERE ID = '+ ADoc );
                try
                   ProcesoFacturacion.GetCustomController.GetCustomModel.qryCabecera.Open;
                finally
                end;

               finally
               ProcesoFacturacion.GetCustomController.GetCustomModel.qryCabecera.EnableControls;
               ProcesoFacturacion.Show;
               (Model.MasterDataModule as ISubject).Attach(ProcesoFacturacion as IObserver);

               end;
            finally

            end;

           }

      end;
      doRecibo:
      begin
        ProcesoPago := TProcesoPago.Create(Sender,
          TPagoController.Create(TPagoDataModule.Create(
          (Sender as TComponent), GetModel.MasterDataModule)));
        ProcesoPago.Show;
        (GetModel.MasterDataModule as ISubject).Attach(ProcesoPago as IObserver);
        //     PagoDataModule.Pago.Close;
        PagoDataModule.PagoID.AsInteger := StrToInt(ADoc);
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
