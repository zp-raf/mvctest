unit documentosctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmdocumentosdatamodule, mvc, frmpagodatamodule,
  pagoctrl, frmpago, Controls, sgcdTypes, facturactrl2, frmprocesofacturacion,
  frmfacturadatamodule2, reciboctrl, frmprocesorecibo, frmquerydatamodule,
  observerSubject;

type

  { TDocumentosController }

  TDocumentosController = class(TController)
  protected
    function GetCustomModel: TDocumentosDataModule;
  public
    procedure AnularDoc(ATipoDoc: TDocViewerDocType; Sender: IFormView);
    procedure AnularDoc(ATipoDoc: TDocViewerDocType; ADoc: string; Sender: IFormView);
    procedure AnularPago(ATipoDoc: TDocViewerDocType; Sender: IFormView);
    procedure AnularPago(ATipoDoc: TDocViewerDocType; ADoc: string; Sender: IFormView);
    procedure CobrarDoc(ATipoDoc: TDocViewerDocType; Sender: IFormView);
    procedure CobrarDoc(ATipoDoc: TDocViewerDocType; ADoc: string; Sender: IFormView);
    procedure VerDocumento(ATipoDoc: TDocViewerDocType; Sender: IFormView);
    procedure VerDocumento(ATipoDoc: TDocViewerDocType; ADoc: string; Sender: IFormView);
  end;

implementation

{ TDocumentosController }

function TDocumentosController.GetCustomModel: TDocumentosDataModule;
begin
  Result := GetModel as TDocumentosDataModule;
end;

procedure TDocumentosController.AnularDoc(ATipoDoc: TDocViewerDocType;
  Sender: IFormView);
begin

end;

procedure TDocumentosController.AnularDoc(ATipoDoc: TDocViewerDocType;
  ADoc: string; Sender: IFormView);
begin

end;

procedure TDocumentosController.AnularPago(ATipoDoc: TDocViewerDocType;
  Sender: IFormView);
begin
  {
   case ATipoDoc of
     doFactura: AnularDoc(ATipoDoc, GetCustomModel.CobrosView.Lookup('ID', GetCustomModel.FacturasCobradasViewID., Sender);
   end;
  }
end;

procedure TDocumentosController.AnularPago(ATipoDoc: TDocViewerDocType;
  ADoc: string; Sender: IFormView);
begin
  {
   case ATipoDoc of
     doFactura:
     begin
       //PagoController.AnularPago();
     end;
     end;
   end;
  }
end;

procedure TDocumentosController.CobrarDoc(ATipoDoc: TDocViewerDocType;
  Sender: IFormView);
begin
  case ATipoDoc of
    dtFacturaNocobrada: CobrarDoc(ATipoDoc,
        GetCustomModel.FacturasViewID.AsString, Sender);
  end;
end;

procedure TDocumentosController.CobrarDoc(ATipoDoc: TDocViewerDocType;
  ADoc: string; Sender: IFormView);
var
  PagoController: TPagoController;
begin
  try
    PagoController := TPagoController.Create(TPagoDataModule.Create(
      Sender as TComponent, GetModel.MasterDataModule));
    ProcesoPago := TProcesoPago.Create(Sender, PagoController);
    case ATipoDoc of
      dtFacturaNocobrada:
      begin
        PagoController.NuevoPago(True, ADoc, doFactura);
      end;
    end;
    case ProcesoPago.ShowModal of
      mrOk:
      begin
        GetModel.Connect;
      end;
      mrCancel:
      begin
        GetModel.Connect;
      end;
    end;
  finally
    ProcesoPago.Free;
    //PagoController.Free;
  end;
end;

procedure TDocumentosController.VerDocumento(ATipoDoc: TDocViewerDocType;
  Sender: IFormView);
begin
  case ATipoDoc of
    dtRecibo: VerDocumento(ATipoDoc, GetCustomModel.CobrosViewID.AsString, Sender);
    dtFacturaNocobrada: VerDocumento(ATipoDoc,
        GetCustomModel.FacturasViewID.AsString, Sender);
    dtFacturaCobrada: VerDocumento(ATipoDoc,
        GetCustomModel.FacturasCobradasViewID.AsString, Sender);
  end;
end;

procedure TDocumentosController.VerDocumento(ATipoDoc: TDocViewerDocType;
  ADoc: string; Sender: IFormView);
begin

  case ATipoDoc of
    dtFacturaNocobrada:
    begin
      try
        FacturasDataModule :=
          TFacturasDataModule.Create(Sender as TComponent, GetModel.MasterDataModule);
        FacturasDataModule.LocateComprobante(ADoc);
      finally
        FacturasDataModule.Free;
      end;
    end;
    dtFacturaCobrada:
    begin
      try
        FacturasDataModule :=
          TFacturasDataModule.Create(Sender as TComponent, GetModel.MasterDataModule);
        FacturasDataModule.LocateComprobante(ADoc);
      finally
        FacturasDataModule.Free;
      end;
    end;
    dtRecibo:
    begin
      try
        PagoDataModule := TPagoDataModule.Create(Sender as TComponent,
          GetModel.MasterDataModule);
        PagoDataModule.Pago.Locate('ID', ADoc, []);
      finally
        PagoDataModule.Free;
      end;
    end;
  end;
end;

end.
