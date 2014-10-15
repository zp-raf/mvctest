unit frmpagodatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, DB, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmquerydatamodule, frmsgcddatamodule, frmfacturadatamodule2,
  frmcodigosdatamodule, observerSubject;

const
  //CREDITO = '1';
  //DEBITO = '2';
  FACTURA = '1';
  RECIBO = '2';
  NOTA_CREDITO = '3';
  EFECTIVO = '1';
  CHEQUE = '2';
  TARJETA_DEBITO = '3';
  TARJETA_CREDITO = '4';
  ITEM_SEPARATOR = ', ';

resourcestring
  rsGenPago = 'GENERATOR_PAGO';
  rsGenPagoDet = 'GENERATOR_PAGO_DETALLE';

type

  TTipoDocumento = (doFactura, doRecibo, doNotaCredito);

  TFormaPago = (paCheque, paEfectivo, paTarjetaDebito, paTarjetaCredito);


  { TPagoDataModule }

  TPagoDataModule = class(TQueryDataModule)
    Codigos: TSQLQuery;
    CodigosOBJETO: TStringField;
    CodigosSIGNIFICADO: TStringField;
    CodigosVALOR: TLongintField;
    dsCodigos: TDataSource;
    PagoDetChequesCOMPROBANTE_TARJETA: TStringField;
    PagoDetChequesEMISOR_CHEQUE: TStringField;
    PagoDetChequesEMISOR_TARJETA: TStringField;
    PagoDetChequesID: TLongintField;
    PagoDetChequesMONTO: TFloatField;
    PagoDetChequesNRO_CHEQUE: TStringField;
    PagoDetChequesNRO_TARJETA: TStringField;
    PagoDetChequesPAGOID: TLongintField;
    PagoDetChequesTIPO_PAGO: TLongintField;
    PagoDetTarjetasCOMPROBANTE_TARJETA: TStringField;
    PagoDetTarjetasEMISOR_CHEQUE: TStringField;
    PagoDetTarjetasEMISOR_TARJETA: TStringField;
    PagoDetTarjetasID: TLongintField;
    PagoDetTarjetasMONTO: TFloatField;
    PagoDetTarjetasNRO_CHEQUE: TStringField;
    PagoDetTarjetasNRO_TARJETA: TStringField;
    PagoDetTarjetasPAGOID: TLongintField;
    PagoDetTarjetasTIPO_PAGO: TLongintField;
    qryCodigos: TSQLQuery;
    qryCodigosOBJETO: TStringField;
    qryCodigosSIGNIFICADO: TStringField;
    qryCodigosVALOR: TLongintField;
    StringFieldTIPOPAGO: TStringField;
    dsCheques: TDataSource;
    dsTarjetas: TDataSource;
    dsPago: TDataSource;
    Pago: TSQLQuery;
    PagoCHEQUES: TFloatField;
    PagoCOMPROBANTEID: TLongintField;
    PagoDESCRIPCION: TStringField;
    PagoDetCOMPROBANTE_TARJETA: TStringField;
    PagoDetEMISOR_CHEQUE: TStringField;
    PagoDetEMISOR_TARJETA: TStringField;
    PagoDetID: TLongintField;
    PagoDetMONTO: TFloatField;
    PagoDetNRO_CHEQUE: TStringField;
    PagoDetNRO_TARJETA: TStringField;
    PagoDetPAGOID: TLongintField;
    PagoDetTIPO_PAGO: TLongintField;
    PagoDetCheques: TSQLQuery;
    PagoDetTarjetas: TSQLQuery;
    PagoEFECTIVO: TFloatField;
    PagoESCOBRO: TSmallintField;
    PagoFECHA: TDateField;
    PagoHORA: TTimeField;
    PagoID: TLongintField;
    PagoMONTO: TFloatField;
    PagoTARJETAS: TFloatField;
    PagoTIPO_COMPROBANTE: TLongintField;
    PagoTOTALPAGADO: TFloatField;
    PagoVALIDO: TSmallintField;
    PagoVUELTO: TFloatField;
  private
    FFactura: TFacturasDataModule;
    procedure SetFactura(AValue: TFacturasDataModule);
  published
    procedure ActualizarTotales;
    procedure Connect; override;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure Disconnect; override;
    procedure NuevoPago(EsCobro: boolean; ADocumentoID: string;
      ATipoDoc: TTipoDocumento);
    procedure PagoAfterScroll(DataSet: TDataSet);
    procedure PagoDetChequesBeforePost(DataSet: TDataSet);
    procedure PagoDetTarjetasBeforePost(DataSet: TDataSet);
    procedure PagoDetChequesAfterInsert(DataSet: TDataSet);
    procedure PagoDetTarjetasAfterInsert(DataSet: TDataSet);
    procedure PagoNewRecord(DataSet: TDataSet);
    procedure OnPagoError(Sender: TObject; E: EDatabaseError);
    property Facturas: TFacturasDataModule read FFactura write SetFactura;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  PagoDataModule: TPagoDataModule;

implementation

{$R *.lfm}

{ TPagoDataModule }

procedure TPagoDataModule.PagoDetChequesBeforePost(DataSet: TDataSet);
begin
  if DataSet.FieldByName('MONTO').IsNull or DataSet.FieldByName('NRO_CHEQUE').IsNull or
    DataSet.FieldByName('EMISOR_CHEQUE').IsNull then
    Abort;
end;

procedure TPagoDataModule.PagoDetTarjetasBeforePost(DataSet: TDataSet);
begin
  if DataSet.FieldByName('MONTO').IsNull or DataSet.FieldByName('NRO_TARJETA').IsNull or
    DataSet.FieldByName('EMISOR_TARJETA').IsNull or
    DataSet.FieldByName('COMPROBANTE_TARJETA').IsNull or
    DataSet.FieldByName('TIPO_PAGO').IsNull then
    Abort;
end;

procedure TPagoDataModule.SetFactura(AValue: TFacturasDataModule);
begin
  if FFactura = AValue then
    Exit;
  FFactura := AValue;
end;

procedure TPagoDataModule.ActualizarTotales;
begin
  //try
  //  //qryDetCh.Refresh;
  //  qryCabeceraCHEQUES.AsFloat := 0;
  //  qryDetCh.First;
  //  while not qryDetCh.EOF do
  //  begin
  //    qryCabeceraCHEQUES.AsFloat := qryCabeceraCHEQUES.AsFloat + qryDetChMONTO.AsFloat;
  //    qryDetCh.Next;
  //  end;
  //  //qryDetTa.Refresh;
  //  qryCabeceraTARJETAS.AsFloat := 0;
  //  qryDetTa.First;
  //  while not qryDetTa.EOF do
  //  begin
  //    qryCabeceraTARJETAS.AsFloat := qryCabeceraTARJETAS.AsFloat + qryDetTaMONTO.AsFloat;
  //    qryDetTa.Next;
  //  end;
  //  qryCabeceraTOTALPAGADO.AsFloat := 0;
  //  qryCabeceraTOTALPAGADO.AsFloat :=
  //    qryCabeceraEFECTIVO.AsFloat + qryCabeceraCHEQUES.AsFloat +
  //    qryCabeceraTARJETAS.AsFloat;
  //  if qryCabeceraTOTALPAGADO.AsFloat > qryCabeceraMONTO.AsFloat then
  //    qryCabeceraVUELTO.AsFloat :=
  //      qryCabeceraTOTALPAGADO.AsFloat - qryCabeceraMONTO.AsFloat
  //  else
  //    qryCabeceraVUELTO.AsFloat := 0;
  //except
  //  on e: EDatabaseError do
  //  begin
  //    ManejoErrores(e);
  //    AbrirCursor;
  //  end;
  //end;
end;

procedure TPagoDataModule.Connect;
begin
  Facturas.Connect;
  inherited Connect;
end;

procedure TPagoDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  OnError := @OnPagoError;
  QryList.Add(TObject(Pago));
  DetailList.Add(TObject(PagoDetCheques));
  DetailList.Add(TObject(PagoDetTarjetas));
  //parametros para los datasets
  PagoDetCheques.ParamByName('TIPO_PAGO').AsString := CHEQUE;
  PagoDetCheques.ParamByName('TIPO_PAGO').Bound := True;
  PagoDetTarjetas.ParamByName('TIPO_PAGO1').AsString := TARJETA_DEBITO;
  PagoDetTarjetas.ParamByName('TIPO_PAGO1').Bound := True;
  PagoDetTarjetas.ParamByName('TIPO_PAGO2').AsString := TARJETA_CREDITO;
  PagoDetTarjetas.ParamByName('TIPO_PAGO2').Bound := True;
  //objetos auxiliares
  Facturas := TFacturasDataModule.Create(Self, MasterDataModule);
  Facturas.SetReadOnly(True);
end;

procedure TPagoDataModule.Disconnect;
begin
  Facturas.Disconnect;
  inherited Disconnect;
end;

procedure TPagoDataModule.NuevoPago(EsCobro: boolean; ADocumentoID: string;
  ATipoDoc: TTipoDocumento);
var
  TipoComp: string;
begin
  if ATipoDoc = doFactura then
  begin
    Facturas.SetFactura(ADocumentoID);
    TipoComp := FACTURA;
  end
  else
    Exit; // por el momento solo factura, despues agregar mas condiciones if
  NewRecord;
  if EsCobro then
    Pago.FieldByName('ESCOBRO').AsInteger := 1
  else
    Pago.FieldByName('ESCOBRO').AsInteger := 0;
  Pago.FieldByName('COMPROBANTEID').AsString := ADocumentoID;
  Pago.FieldByName('TIPO_COMPROBANTE').AsString := TipoComp;
end;

procedure TPagoDataModule.PagoAfterScroll(DataSet: TDataSet);
begin
  PagoDetCheques.Close;
  PagoDetTarjetas.Close;
  PagoDetCheques.ParamByName('ID').Value := Pago.FieldByName('ID').Value;
  PagoDetTarjetas.ParamByName('ID').Value := Pago.FieldByName('ID').Value;
  PagoDetCheques.Open;
  PagoDetTarjetas.Open;
end;

procedure TPagoDataModule.PagoDetChequesAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenPagoDet);
  DataSet.FieldByName('PAGOID').Value := Pago.FieldByName('ID').Value;
  DataSet.FieldByName('TIPO_PAGO').AsString := CHEQUE;
end;

procedure TPagoDataModule.PagoDetTarjetasAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenPagoDet);
  DataSet.FieldByName('PAGOID').Value := Pago.FieldByName('ID').Value;
end;

procedure TPagoDataModule.PagoNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenPago);

  DataSet.FieldByName('FECHA').AsDateTime := Now;
  DataSet.FieldByName('HORA').AsDateTime := Now;

  DataSet.FieldByName('VALIDO').AsInteger := 1;

  DataSet.FieldByName('EFECTIVO').AsFloat := 0;
  DataSet.FieldByName('CHEQUES').AsFloat := 0;
  DataSet.FieldByName('TARJETAS').AsFloat := 0;
  DataSet.FieldByName('TOTALPAGADO').AsFloat := 0;
  DataSet.FieldByName('VUELTO').AsFloat := 0;
end;

procedure TPagoDataModule.OnPagoError(Sender: TObject; E: EDatabaseError);
begin
  DiscardChanges;
  Connect;
  (MasterDataModule as ISubject).Notify;
end;

end.
