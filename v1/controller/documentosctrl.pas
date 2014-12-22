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
  private
    FPagoController: TPagoController;
    procedure SetPagoController(AValue: TPagoController);
  protected
    function GetCustomModel: TDocumentosDataModule;
  public
    constructor Create(AModel: Pointer); overload; override;
    destructor Destroy; override;
    procedure AnularDoc(ATipoDoc: TDocViewerDocType; Sender: IFormView);
    procedure AnularDoc(ATipoDoc: TDocViewerDocType; ADoc: string; Sender: IFormView);
    procedure AnularPago(ATipoDoc: TDocViewerDocType; Sender: IFormView);
    procedure AnularPago(ATipoDoc: TDocViewerDocType; ADoc: string; Sender: IFormView);
    procedure CobrarDoc(ATipoDoc: TDocViewerDocType; Sender: IFormView);
    procedure CobrarDoc(ATipoDoc: TDocViewerDocType; ADoc: string; Sender: IFormView);
    procedure VerDocumento(ATipoDoc: TDocViewerDocType; Sender: IFormView);
    procedure VerDocumento(ATipoDoc: TDocViewerDocType; ADoc: string; Sender: IFormView);
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

constructor TDocumentosController.Create(AModel: Pointer);
begin
  inherited Create(AModel);
  PagoController := TPagoController.Create(GetCustomModel.Pagos);
end;

destructor TDocumentosController.Destroy;
begin
  PagoController.Free;
  inherited Destroy;
end;

procedure TDocumentosController.AnularDoc(ATipoDoc: TDocViewerDocType;
  Sender: IFormView);
begin
  case ATipoDoc of
    dtFacturaNocobrada:
    begin
      AnularDoc(ATipoDoc, GetCustomModel.FacturasViewID.AsString, Sender);
    end;
    dtNotaCredito:
    begin
      AnularDoc(ATipoDoc, GetCustomModel.NotaCreditoViewID.AsString, Sender);
    end;
    dtFacturaCompra:
    begin
      AnularDoc(ATipoDoc, GetCustomModel.FacturasCompraViewID.AsString, Sender);
    end;
    dtReciboCompra:
    begin
      AnularDoc(ATipoDoc, GetCustomModel.RecibosViewID.AsString, Sender);
    end;
    dtNotaCredCompra:
    begin
      AnularDoc(ATipoDoc, GetCustomModel.NCCompraViewID.AsString, Sender);
    end;
  end;
end;

procedure TDocumentosController.AnularDoc(ATipoDoc: TDocViewerDocType;
  ADoc: string; Sender: IFormView);
begin
  try
    case ATipoDoc of
      dtFacturaNocobrada:
      begin
        GetCustomModel.AnularFactura(ADoc);
        Commit(Sender);
        RefreshData(Sender);
      end;
      dtNotaCredito:
      begin
        GetCustomModel.AnularNotaCredito(ADoc);
        Commit(Sender);
        RefreshData(Sender);
      end;
      dtFacturaCompra:
      begin
        GetCustomModel.AnularFactura(ADoc);
        Commit(Sender);
        RefreshData(Sender);
      end;
      dtReciboCompra:
      begin
        GetCustomModel.AnularRecibo(ADoc);
        Commit(Sender);
        RefreshData(Sender);
      end;
      dtNotaCredCompra:
      begin
        GetCustomModel.AnularNotaCredito(ADoc);
        Commit(Sender);
        RefreshData(Sender);
      end;
    end;
    Sender.ShowInfoMessage('Operacion exitosa');
  except
    on e: Exception do
    begin
      raise;
      OpenDataSets(Sender);
    end;
  end;
end;

procedure TDocumentosController.AnularPago(ATipoDoc: TDocViewerDocType;
  Sender: IFormView);
begin
  try
    case ATipoDoc of
      dtFacturaCobrada:
      begin
        AnularPago(ATipoDoc,
          GetCustomModel.FacturasCobradasView.FieldByName('ID').AsString, Sender);
        Commit(Sender);
        Sender.ShowInfoMessage('Operacion exitosa');
        RefreshData(Sender);
      end;
    end;
  except
    on E: Exception do
    begin
      raise;
      OpenDataSets(Sender);
    end;
  end;
end;

procedure TDocumentosController.AnularPago(ATipoDoc: TDocViewerDocType;
  ADoc: string; Sender: IFormView);
begin
  case ATipoDoc of
    dtFacturaCobrada:
    begin
      PagoController.AnularPago(GetCustomModel.GetPagoDoc(ADoc, doFactura));
      RefreshData(Sender);
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
begin
  try
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
        //Connect(Sender);
      end;
      mrCancel:
      begin
        //Connect(Sender);
      end;
    end;
  finally
    (GetModel.MasterDataModule as ISubject).Detach(ProcesoPago as IObserver);
    ProcesoPago.Free;
  end;
  //GetCustomModel.OpenDataSets;
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
