unit frmdocumentosdatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, DB, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmquerydatamodule, frmfacturadatamodule2, frmpagodatamodule, sgcdTypes,
  mensajes, frmNotaCreditoDataModule;

type

  { TDocumentosDataModule }

  TDocumentosDataModule = class(TQueryDataModule)
    dsNotaCredito: TDataSource;
    FacturasCobradasViewCOMPRA: TLongintField;
    FacturasCobradasViewPAGOID: TLongintField;
    FacturasCobradasViewPAGO_VALIDO: TSmallintField;
    FacturasCobradasViewVENCIMIENTO: TDateField;
    FacturasViewCOMPRA: TLongintField;
    FacturasViewPAGOID: TLongintField;
    FacturasViewPAGO_VALIDO: TSmallintField;
    FacturasViewVENCIMIENTO: TDateField;
    NotaCreditoView: TSQLQuery;
    NotaCreditoViewCOMPRA: TLongintField;
    NotaCreditoViewFACTURAID: TLongintField;
    NotaCreditoViewFECHA_EMISION: TDateField;
    NotaCreditoViewID: TLongintField;
    NotaCreditoViewNOMBRE: TStringField;
    NotaCreditoViewNUMERO: TLongintField;
    NotaCreditoViewPERSONAID: TLongintField;
    NotaCreditoViewRUC: TStringField;
    NotaCreditoViewTIMBRADO: TStringField;
    NotaCreditoViewTOTAL: TFloatField;
    NotaCreditoViewVALIDO: TSmallintField;
  private
    FFacturas: TFacturasDataModule;
    FNotaCredito: TNotaCreditoDataModule;
    FPagos: TPagoDataModule;
    procedure SetFacturas(AValue: TFacturasDataModule);
    procedure SetNotaCredito(AValue: TNotaCreditoDataModule);
    procedure SetPagos(AValue: TPagoDataModule);
    //FCodigos: TCodigosDataModule;
    //procedure SetCodigos(AValue: TCodigosDataModule);
  published
    CobrosViewTIPO_COMP: TStringField;
    dsFacturasCobradas: TDataSource;
    FacturasCobradasViewCONTADO: TSmallintField;
    FacturasCobradasViewFECHA_EMISION: TDateField;
    FacturasCobradasViewID: TLongintField;
    FacturasCobradasViewNOMBRE: TStringField;
    FacturasCobradasViewNUMERO: TLongintField;
    FacturasCobradasViewPERSONAID: TLongintField;
    FacturasCobradasViewRUC: TStringField;
    FacturasCobradasViewTIMBRADO: TStringField;
    FacturasCobradasViewTOTAL: TFloatField;
    FacturasCobradasViewVALIDO: TSmallintField;
    FacturasCobradasView: TSQLQuery;
    CobrosViewCOMPROBANTEID: TLongintField;
    CobrosViewESCOBRO: TSmallintField;
    CobrosViewFECHA: TDateField;
    CobrosViewHORA: TTimeField;
    CobrosViewID: TLongintField;
    CobrosViewMONTO: TFloatField;
    CobrosViewTIPO_COMPROBANTE: TLongintField;
    CobrosViewVALIDO: TSmallintField;
    dsFacturas: TDataSource;
    dsCobros: TDataSource;
    FacturasView: TSQLQuery;
    CobrosView: TSQLQuery;
    FacturasViewCONTADO: TSmallintField;
    FacturasViewFECHA_EMISION: TDateField;
    FacturasViewID: TLongintField;
    FacturasViewNOMBRE: TStringField;
    FacturasViewNUMERO: TLongintField;
    FacturasViewPERSONAID: TLongintField;
    FacturasViewRUC: TStringField;
    FacturasViewTIMBRADO: TStringField;
    FacturasViewTOTAL: TFloatField;
    FacturasViewVALIDO: TSmallintField;
    procedure AnularFactura(AFacturaID: string);
    procedure AnularNotaCredito(ANotaID: string);
    procedure AnularPago(APagoID: string);
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DataModuleDestroy(Sender: TObject);
    function GetPagoDoc(ADoc: string; ATipoDoc: TTipoDocumento): string;
    //property Codigos: TCodigosDataModule read FCodigos write SetCodigos;
    property Facturas: TFacturasDataModule read FFacturas write SetFacturas;
    property NotaCredito: TNotaCreditoDataModule read FNotaCredito write SetNotaCredito;
    property Pagos: TPagoDataModule read FPagos write SetPagos;
  end;


var
  DocumentosDataModule: TDocumentosDataModule;

implementation

{$R *.lfm}

{ TDocumentosDataModule }

procedure TDocumentosDataModule.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FFacturas) then
    FreeAndNil(FFacturas);
  if Assigned(FPagos) then
    FreeAndNil(FPagos);
  if Assigned(FNotaCredito) then
    FreeAndNil(FNotaCredito);
end;

function TDocumentosDataModule.GetPagoDoc(ADoc: string;
  ATipoDoc: TTipoDocumento): string;
var
  PTipoComp: string;
begin
  try
    case ATipoDoc of
      doFactura: PTipoComp := FACTURA;
      doRecibo: PTipoComp := RECIBO;
      doNotaCredito: PTipoComp := NOTA_CREDITO;
      else
        raise Exception.Create(rsUnsupportedDocType);
    end;
    Pagos.Pago.Close;
    Pagos.Pago.ServerFilter :=
      'TIPO_COMPROBANTE = ' + PTipoComp + ' AND COMPROBANTEID = ' + ADoc;
    Pagos.Pago.ServerFiltered := True;
    Pagos.Pago.Open;
    if Pagos.Pago.RecordCount <> 1 then
      raise Exception.Create('No se encuentra el asiento del pago o hay inconsistencia');
    Result := Pagos.Pago.FieldByName('ID').AsString;
  except
    on E: EDatabaseError do
      DoOnErrorEvent(Self, E);
  end;
end;

procedure TDocumentosDataModule.SetFacturas(AValue: TFacturasDataModule);
begin
  if FFacturas = AValue then
    Exit;
  FFacturas := AValue;
end;

procedure TDocumentosDataModule.SetNotaCredito(AValue: TNotaCreditoDataModule);
begin
  if FNotaCredito = AValue then
    Exit;
  FNotaCredito := AValue;
end;

procedure TDocumentosDataModule.SetPagos(AValue: TPagoDataModule);
begin
  if FPagos = AValue then
    Exit;
  FPagos := AValue;
end;

procedure TDocumentosDataModule.AnularFactura(AFacturaID: string);
begin
  try
    Facturas.Connect;
    Facturas.AnularFactura(AFacturaID);
  except
    on E: EDatabaseError do
    begin
      Rollback;
      Connect;
    end;
  end;
end;

procedure TDocumentosDataModule.AnularNotaCredito(ANotaID: string);
begin
  try
    NotaCredito.Connect;
    NotaCredito.AnularNotaCredito(ANotaID);
  except
    on E: EDatabaseError do
    begin
      Rollback;
      Connect;
    end;
  end;
end;

procedure TDocumentosDataModule.AnularPago(APagoID: string);
begin
  try
    Pagos.Connect;
    Pagos.AnularPago(APagoID);
  except
    on E: EDatabaseError do
    begin
      Rollback;
      Connect;
    end;
  end;
end;

procedure TDocumentosDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  //FCodigos := TCodigosDataModule.Create(Self, MasterDataModule);
  //FCodigos.SetObject('TIPO_COMPROBANTE');
  //AuxQryList.Add(TObject(FCodigos.Codigos));
  Facturas := TFacturasDataModule.Create(Self, MasterDataModule);
  NotaCredito := TNotaCreditoDataModule.Create(Self, MasterDataModule);
  Pagos := TPagoDataModule.Create(Self, MasterDataModule);
  AuxQryList.Add(TObject(FacturasView));
  AuxQryList.Add(TObject(CobrosView));
  AuxQryList.Add(TObject(FacturasCobradasView));
  AuxQryList.Add(TObject(NotaCreditoView));
end;

//procedure TDocumentosDataModule.SetCodigos(AValue: TCodigosDataModule);
//begin
//  if FCodigos = AValue then
//    Exit;
//  FCodigos := AValue;
//end;

end.
