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
    constructor Create(AModel: Pointer); overload; override;
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

constructor TDocumentosController.Create(AModel: Pointer);
begin
  inherited Create(AModel);
end;

procedure TDocumentosController.AnularDoc(ATipoDoc: TDocViewerDocType;
  Sender: IFormView);
begin
  case ATipoDoc of
    dtFacturaNocobrada:
    begin
      AnularDoc(ATipoDoc, GetCustomModel.FacturasViewID.AsString, Sender);
    end;
  end;
end;

procedure TDocumentosController.AnularDoc(ATipoDoc: TDocViewerDocType;
  ADoc: string; Sender: IFormView);
begin
  case ATipoDoc of
    dtFacturaNocobrada:
    begin
      GetCustomModel.AnularFactura(ADoc);
      Sender.ShowInfoMessage('Operacion exitosa');
      Commit(Sender);
      RefreshData(Sender);
    end;
  end;
end;

procedure TDocumentosController.AnularPago(ATipoDoc: TDocViewerDocType;
  Sender: IFormView);
begin
  try
    case ATipoDoc of
      dtFacturaCobrada: AnularDoc(ATipoDoc,
          GetCustomModel.FacturasCobradasView.FieldByName('ID').AsString, Sender);
    end;
  except
    on E: Exception do
      raise;
  end;
end;

procedure TDocumentosController.AnularPago(ATipoDoc: TDocViewerDocType;
  ADoc: string; Sender: IFormView);
begin
  case ATipoDoc of
    dtFacturaCobrada:
    begin
      GetCustomModel.AnularPago(GetCustomModel.GetPagoDoc(ADoc, doFactura));
    end;
  end;
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
  ProcesoPago: TProcesoPago;
  PagoController: TPagoController;
begin
  try
    PagoController := TPagoController.Create(GetCustomModel.Pagos);
    ProcesoPago := TProcesoPago.Create(Sender, PagoController);
    (GetModel.MasterDataModule as ISubject).Attach(ProcesoPago as IObserver);
    case ATipoDoc of
      dtFacturaNocobrada:
      begin
        PagoController.NuevoPago(True, ADoc, doFactura);
      end;
    end;
    case ProcesoPago.ShowModal of
      mrOk:
      begin
        GetCustomModel.Connect;
      end;
      mrCancel:
      begin
        GetCustomModel.Connect;
      end;
    end;
  finally
    (GetModel.MasterDataModule as ISubject).Detach(ProcesoPago as IObserver);
    ProcesoPago.Free;
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
  // ???: en esta parte se posiciona el cursor del documento correspondiente
  //      para poder mostrar el reporte pero todavia no se muestra nada
  case ATipoDoc of
    dtFacturaNocobrada:
    begin
      GetCustomModel.Facturas.LocateComprobante(ADoc);
    end;
    dtFacturaCobrada:
    begin
      GetCustomModel.Facturas.LocateComprobante(ADoc);
    end;
    dtRecibo:
    begin
      GetCustomModel.Pagos.Pago.Locate('ID', ADoc, []);
    end;
  end;
end;

end.
