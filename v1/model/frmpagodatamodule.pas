unit frmpagodatamodule;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, sqldb, DB, frmquerydatamodule, frmfacturadatamodule2,
  observerSubject, frmasientosdatamodule, sgcdTypes;

const
  ITEM_SEPARATOR = ', ';
  DESCRIPCION_DEFAULT = 'PAGO DE FACTURA NRO ';
  DESCRIPCION_REVERSION = 'ANULACION DE PAGO NRO ';

resourcestring
  rsGenPago = 'GENERATOR_PAGO';
  rsGenPagoDet = 'GENERATOR_PAGO_DETALLE';

type


  { TPagoDataModule }

  TPagoDataModule = class(TQueryDataModule)
  private
    FAsientos: TAsientosDataModule;
    FFactura: TFacturasDataModule;
    FListo: boolean;
    function GetEstado: boolean;
    procedure SetAsientos(AValue: TAsientosDataModule);
    procedure SetFactura(AValue: TFacturasDataModule);
  published
    Codigos: TSQLQuery;
    CodigosOBJETO: TStringField;
    CodigosSIGNIFICADO: TStringField;
    CodigosVALOR: TLongintField;
    DeudaView: TSQLQuery;
    DeudaViewACTIVO: TSmallintField;
    DeudaViewARANCELID: TLongintField;
    DeudaViewCANTIDAD_CUOTAS: TLongintField;
    DeudaViewCUENTAID: TLongintField;
    DeudaViewCUOTA_NRO: TLongintField;
    DeudaViewDESCRIPCION: TStringField;
    DeudaViewID: TLongintField;
    DeudaViewMATRICULAID: TLongintField;
    DeudaViewMONTO_DEUDA: TFloatField;
    DeudaViewMONTO_FACTURADO: TFloatField;
    DeudaViewPERSONAID: TLongintField;
    DeudaViewSALDO: TFloatField;
    DeudaViewVENCIMIENTO: TDateField;
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
    PagoDetCheques: TSQLQuery;
    PagoDetTarjetas: TSQLQuery;
    Pago: TSQLQuery;
    StringFieldTIPOPAGO: TStringField;
    dsCheques: TDataSource;
    dsTarjetas: TDataSource;
    dsPago: TDataSource;
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
    procedure AnularPago(APagoID: string);
    procedure Connect; override;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DataModuleDestroy(Sender: TObject);
    procedure Disconnect; override;
    procedure NuevoPago(EsCobro: boolean; ADocumentoID: string;
      ATipoDoc: TTipoDocumento);
    procedure PagoDetChequesAfterPost(DataSet: TDataSet);
    procedure PagoDetTarjetasAfterPost(DataSet: TDataSet);
    procedure PagoEFECTIVOChange(Sender: TField);
    procedure PagoAfterScroll(DataSet: TDataSet);
    procedure PagoDetChequesBeforePost(DataSet: TDataSet);
    procedure PagoDetTarjetasBeforePost(DataSet: TDataSet);
    procedure PagoDetChequesAfterInsert(DataSet: TDataSet);
    procedure PagoDetTarjetasAfterInsert(DataSet: TDataSet);
    procedure PagoNewRecord(DataSet: TDataSet);
    procedure RegistrarMovimiento(EsCobro: boolean; APagoID: string);
    procedure SaveChanges; override;
    procedure OnPagoError(Sender: TObject; E: EDatabaseError);
    property Asientos: TAsientosDataModule read FAsientos write SetAsientos;
    property Facturas: TFacturasDataModule read FFactura write SetFactura;
    property Listo: boolean read GetEstado write FListo;
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

procedure TPagoDataModule.PagoEFECTIVOChange(Sender: TField);
begin
  ActualizarTotales;
end;

procedure TPagoDataModule.PagoDetChequesAfterPost(DataSet: TDataSet);
begin
  ActualizarTotales;
end;

procedure TPagoDataModule.PagoDetTarjetasAfterPost(DataSet: TDataSet);
begin
  ActualizarTotales;
end;

procedure TPagoDataModule.SetFactura(AValue: TFacturasDataModule);
begin
  if FFactura = AValue then
    Exit;
  FFactura := AValue;
end;

procedure TPagoDataModule.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  FFactura.Free;
  FAsientos.Free;
end;

function TPagoDataModule.GetEstado: boolean;
begin
  Result := FListo;
end;

procedure TPagoDataModule.SetAsientos(AValue: TAsientosDataModule);
begin
  if FAsientos = AValue then
    Exit;
  FAsientos := AValue;
end;

procedure TPagoDataModule.ActualizarTotales;
begin
  // el total de cheques
  PagoCHEQUES.AsFloat := 0;
  PagoDetCheques.First;
  while not PagoDetCheques.EOF do
  begin
    PagoCHEQUES.AsFloat := PagoCHEQUES.AsFloat + PagoDetChequesMONTO.AsFloat;
    PagoDetCheques.Next;
  end;
  // el total de tarjetas
  PagoTARJETAS.AsFloat := 0;
  PagoDetTarjetas.First;
  while not PagoDetTarjetas.EOF do
  begin
    PagoTARJETAS.AsFloat := PagoTARJETAS.AsFloat + PagoDetTarjetasMONTO.AsFloat;
    PagoDetTarjetas.Next;
  end;
  // total pagado
  PagoTOTALPAGADO.AsFloat := 0;
  PagoTOTALPAGADO.AsFloat :=
    PagoEFECTIVO.AsFloat + PagoCHEQUES.AsFloat + PagoTARJETAS.AsFloat;
  if PagoTOTALPAGADO.AsFloat > PagoMONTO.AsFloat then
    PagoVUELTO.AsFloat :=
      PagoTOTALPAGADO.AsFloat - PagoMONTO.AsFloat
  else
    PagoVUELTO.AsFloat := 0;
  if PagoTOTALPAGADO.AsFloat < PagoMONTO.AsFloat then
    Listo := False
  else
    Listo := True;
  (MasterDataModule as ISubject).Notify;
end;

procedure TPagoDataModule.AnularPago(APagoID: string);
begin
  if not Pago.Locate('ID', APagoID, [loCaseInsensitive]) then
    raise Exception.Create('No se encontro el pago');
  try
    Asientos.MovimientoDet.Filter := 'PAGOID = ' + PagoID.AsString;
    Asientos.MovimientoDet.Filtered := True;
    Asientos.MovimientoDet.Refresh;
    Asientos.MovimientoDet.First;
  finally
    // le sacamos el filtro
    Asientos.MovimientoDet.Filter := '';
    Asientos.MovimientoDet.Filtered := False;
    Asientos.MovimientoDet.Refresh;
  end;
end;

procedure TPagoDataModule.Connect;
begin
  Facturas.Connect;
  Asientos.Connect;
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
  //PagoDetCheques.ParamByName('TIPO_PAGO').AsString := CHEQUE;
  //PagoDetCheques.ParamByName('TIPO_PAGO').Bound := True;
  //PagoDetTarjetas.ParamByName('TIPO_PAGO1').AsString := TARJETA_DEBITO;
  //PagoDetTarjetas.ParamByName('TIPO_PAGO1').Bound := True;
  //PagoDetTarjetas.ParamByName('TIPO_PAGO2').AsString := TARJETA_CREDITO;
  //PagoDetTarjetas.ParamByName('TIPO_PAGO2').Bound := True;
  //objetos auxiliares
  Facturas := TFacturasDataModule.Create(Self, MasterDataModule);
  //Facturas.SetReadOnly(True);
  Asientos := TAsientosDataModule.Create(Self, MasterDataModule);
  Asientos.ComprobarAsiento := False; // cuando se arregle el tema contable sacar
  // obviamente no esta listo el pago jeje
  Listo := False;
end;

procedure TPagoDataModule.Disconnect;
begin
  Facturas.Disconnect;
  Asientos.Disconnect;
  inherited Disconnect;
end;

procedure TPagoDataModule.NuevoPago(EsCobro: boolean; ADocumentoID: string;
  ATipoDoc: TTipoDocumento);
begin
  Facturas.LocateComprobante(ADocumentoID);
  NewRecord;
  if EsCobro then
    Pago.FieldByName('ESCOBRO').AsInteger := 1
  else
    Pago.FieldByName('ESCOBRO').AsInteger := 0;
  Pago.FieldByName('COMPROBANTEID').AsString := ADocumentoID;
  case ATipoDoc of
    doFactura:
    begin
      Pago.FieldByName('TIPO_COMPROBANTE').AsString := FACTURA;
    end;
    doNotaCredito:
    begin
      Pago.FieldByName('TIPO_COMPROBANTE').AsString := NOTA_CREDITO;
    end;
    doRecibo:
    begin
      Pago.FieldByName('TIPO_COMPROBANTE').AsString := RECIBO;
    end;
  end;
  Pago.FieldByName('MONTO').AsFloat := Facturas.GetMontoComprobante;
  Listo := False;
  (MasterDataModule as ISubject).Notify;
end;

procedure TPagoDataModule.PagoAfterScroll(DataSet: TDataSet);
begin
  PagoDetCheques.Close;
  PagoDetTarjetas.Close;
  PagoDetCheques.ParamByName('PAGOID').Value := Pago.FieldByName('ID').Value;
  PagoDetTarjetas.ParamByName('PAGOID').Value := Pago.FieldByName('ID').Value;
  PagoDetCheques.Open;
  PagoDetTarjetas.Open;
end;

procedure TPagoDataModule.PagoDetChequesAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenPagoDet);
  DataSet.FieldByName('PAGOID').AsInteger := Pago.FieldByName('ID').AsInteger;
  DataSet.FieldByName('TIPO_PAGO').AsString := CHEQUE;
end;

procedure TPagoDataModule.PagoDetTarjetasAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenPagoDet);
  DataSet.FieldByName('PAGOID').AsInteger := Pago.FieldByName('ID').AsInteger;
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

procedure TPagoDataModule.RegistrarMovimiento(EsCobro: boolean; APagoID: string);
begin
  // creamos un nuevo asiento
  Asientos.NuevoAsiento(DESCRIPCION_DEFAULT +
    Facturas.qryCabeceraNUMERO.AsString, '', APagoID);
  // recorrer la factura y poner los detales de los asientos
  Facturas.qryDetalle.First;
  while not facturas.qryDetalle.EOF do
  begin
    DeudaView.Close;
    DeudaView.ParamByName('DEUDAID').AsString := Facturas.qryDetalleDEUDAID.AsString;
    DeudaView.Open;
    if EsCobro then
      Asientos.NuevoAsientoDetalle(DeudaViewCUENTAID.AsString, mvCredito,
        Facturas.qryDetallePRECIO_UNITARIO.AsFloat * Facturas.qryDetalleCANTIDAD.AsFloat,
        Facturas.qryDetalleDEUDAID.AsString, '')
    else
      Asientos.NuevoAsientoDetalle(DeudaViewCUENTAID.AsString, mvDebito,
        Facturas.qryDetallePRECIO_UNITARIO.AsFloat * Facturas.qryDetalleCANTIDAD.AsFloat,
        Facturas.qryDetalleDEUDAID.AsString, '');
    Facturas.qryDetalle.Next;
  end;
  Asientos.CerrarAsiento;
end;

procedure TPagoDataModule.SaveChanges;
var
  co: boolean;
  pa: string;
begin
  // para pasarle los parametros a registrarmovimiento
  if PagoESCOBRO.AsInteger = 1 then
    co := True
  else if PagoESCOBRO.AsInteger = 0 then
    co := False;
  pa := PagoID.AsString;
  // guardamos el pago
  Pago.ApplyUpdates;
  PagoDetCheques.ApplyUpdates;
  PagoDetTarjetas.ApplyUpdates;
  // y reigstramos el movimiento
  RegistrarMovimiento(co, pa);
  // y comiteamos
  MasterDataModule.Commit;
  Listo := False;
end;

procedure TPagoDataModule.OnPagoError(Sender: TObject; E: EDatabaseError);
begin
  DiscardChanges;
  Connect;
  (MasterDataModule as ISubject).Notify;
end;

end.
