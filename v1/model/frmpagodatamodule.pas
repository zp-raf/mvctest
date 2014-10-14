unit frmpagodatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, DB, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmquerydatamodule, frmsgcddatamodule, frmfacturadatamodule2, frmcodigosdatamodule;

const
  CREDITO = '1';
  DEBITO = '2';
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

  { TPagoDataModule }

  TPagoDataModule = class(TQueryDataModule)
    dsCodigos: TDataSource;
    procedure PagoDetBeforePost(DataSet: TDataSet);
    procedure PagoDetChequesBeforePost(DataSet: TDataSet);
    procedure PagoDetTarjetasBeforePost(DataSet: TDataSet);
  private
    FCodigos: TCodigosDataModule;
    FFactura: TFacturasDataModule;
    procedure SetCodigos(AValue: TCodigosDataModule);
    procedure SetFactura(AValue: TFacturasDataModule);
  published
    dsCheques: TDataSource;
    dsTarjetas: TDataSource;
    dsPago: TDataSource;
    dsPagoDet: TDataSource;
    Pago: TSQLQuery;
    PagoCHEQUES: TFloatField;
    PagoCOMPROBANTEID: TLongintField;
    PagoDESCRIPCION: TStringField;
    PagoDet: TSQLQuery;
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
    procedure ActualizarTotales;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure NuevoPago(EsCobro: boolean; ADocumentoID: string);
    procedure PagoAfterScroll(DataSet: TDataSet);
    procedure PagoDetAfterInsert(DataSet: TDataSet);
    procedure PagoDetChequesAfterInsert(DataSet: TDataSet);
    procedure PagoDetTarjetasAfterInsert(DataSet: TDataSet);
    procedure PagoNewRecord(DataSet: TDataSet);
    property Factura: TFacturasDataModule read FFactura write SetFactura;
    property Codigos: TCodigosDataModule read FCodigos write SetCodigos;
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

procedure TPagoDataModule.PagoDetBeforePost(DataSet: TDataSet);
begin

end;

procedure TPagoDataModule.PagoDetChequesBeforePost(DataSet: TDataSet);
begin
  if DataSet.FieldByName('MONTO').IsNull or DataSet.FieldByName('NRO_CHEQUE').IsNull or
    DataSet.FieldByName('EMISOR_CHEQUE').IsNull then
    Abort;
end;

procedure TPagoDataModule.PagoDetTarjetasBeforePost(DataSet: TDataSet);
begin

end;

procedure TPagToDataModule.PagoDetTarjetasBeforePost(DataSet: TDataSet);
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

procedure TPagoDataModule.SetCodigos(AValue: TCodigosDataModule);
begin
  if FCodigos = AValue then
    Exit;
  FCodigos := AValue;
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

procedure TPagoDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  QryList.Add(TObject(Pago));
  DetailList.Add(TObject(PagoDet));
  DetailList.Add(TObject(PagoDetCheques));
  DetailList.Add(TObject(PagoDetTarjetas));
  AuxQryList.Add(TObject(Codigos));
  PagoDetCheques.ParamByName('TIPO_PAGO').AsString := CHEQUE;
  PagoDetCheques.ParamByName('TIPO_PAGO').Bound := True;
  PagoDetTarjetas.ParamByName('TIPO_PAGO1').AsString := TARJETA_DEBITO;
  PagoDetTarjetas.ParamByName('TIPO_PAGO1').Bound := True;
  PagoDetTarjetas.ParamByName('TIPO_PAGO2').AsString := TARJETA_CREDITO;
  PagoDetTarjetas.ParamByName('TIPO_PAGO2').Bound := True;
  Factura := TFacturasDataModule.Create(Self, MasterDataModule);
  Factura.SetReadOnly(True);
  Codigos := TCodigosDataModule.Create(Self, MasterDataModule);
  Codigos.SetObject('PAGO_DETALLE.TIPO_PAGO');
end;

procedure TPagoDataModule.NuevoPago(EsCobro: boolean; ADocumentoID: string);
begin
  NewRecord;
  if EsCobro then
    DataSet.FieldByName('ESCOBRO').AsInteger := 1;
  DataSet.FieldByName('DOCUMENTOID').AsInteger := 1;
end;

procedure TPagoDataModule.PagoAfterScroll(DataSet: TDataSet);
begin
  PagoDet.Close;
  PagoDetCheques.Close;
  PagoDetTarjetas.Close;
  PagoDet.ParamByName('ID').Value := Pago.FieldByName('ID').Value;
  PagoDetCheques.ParamByName('ID').Value := Pago.FieldByName('ID').Value;
  PagoDetTarjetas.ParamByName('ID').Value := Pago.FieldByName('ID').Value;
  PagoDet.Open;
  PagoDetCheques.Open;
  PagoDetTarjetas.Open;
end;

procedure TPagoDataModule.PagoDetAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenPagoDet);
  DataSet.FieldByName('PAGOID').Value := Pago.FieldByName('ID').Value;
end;

procedure TPagoDataModule.PagoDetChequesAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenPagoDet);
  DataSet.FieldByName('PAGOID').Value := Pago.FieldByName('ID').Value;
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

end.
