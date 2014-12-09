unit frmNotaCreditoDataModule;

{$mode objfpc}{$H+}

interface

uses
  frmcomprobantedatamodule, LR_DBSet, LR_Class, DB, sqldb, mensajes, variants,
  frmfacturadatamodule2, Classes, sgcdTypes, SysUtils, frmasientosdatamodule;

resourcestring
  rsGenNotaCredito = 'SEQ_NOTA_CREDITO';
  rsGenNotaCreditoDetalle = 'SEQ_NOTA_CREDITO_DETALLE';
  rsDescripcionPorDefecto = 'Emision de nota de credito nro. ';
  rsDescripcionAnulacion = 'Aunlacion de nota de credito nro. ';

const
  TALONARIO_NC = '16';

type

  { TNotaCreditoDataModule }

  TNotaCreditoDataModule = class(TComprobanteDataModule)
    DateField1: TDateField;
    qryCabeceraNUMERO_NOTA_COMPRA: TStringField;
    qryDetalleCANTIDAD: TLongintField;
    qryDetalleDETALLE: TStringField;
    qryDetalleDEUDAID: TLongintField;
    qryDetalleEXENTA: TFloatField;
    qryDetalleFACTURADETALLEID: TLongintField;
    qryDetalleID: TLongintField;
    qryDetalleIVA10: TFloatField;
    qryDetalleIVA5: TFloatField;
    qryDetalleNOTACREDITOID: TLongintField;
    qryDetallePRECIO_UNITARIO: TFloatField;
    StringField2: TStringField;
    StringField3: TStringField;
    procedure qryDetalleEXENTAChange(Sender: TField);
    procedure qryDetalleIVA10Change(Sender: TField);
    procedure qryDetalleIVA5Change(Sender: TField);
  private
    FAsientos: TAsientosDataModule;
    FCheckPrecioUnitario: boolean;
    FFacturas: TFacturasDataModule;
    FIVA10Codigo: string;
    FIVA5Codigo: string;
    procedure SetAsientos(AValue: TAsientosDataModule);
    procedure SetCheckPrecioUnitario(AValue: boolean);
    procedure SetFacturas(AValue: TFacturasDataModule);
    procedure SetIVA10Codigo(AValue: string);
    procedure SetIVA5Codigo(AValue: string);
  published
    dsFacturas: TDataSource;
    qryCabeceraTIMBRADO: TLongintField;
    lookUpNUMERO_FACTURA: TLongintField;
    StringField1: TStringField;
    qryCabeceraDIRECCION: TStringField;
    qryCabeceraFACTURAID: TLongintField;
    qryCabeceraFECHA_EMISION: TDateField;
    qryCabeceraID: TLongintField;
    qryCabeceraIVA10: TFloatField;
    qryCabeceraIVA5: TFloatField;
    qryCabeceraIVA_TOTAL: TFloatField;
    qryCabeceraNOMBRE: TStringField;
    qryCabeceraNOTA_REMISION: TStringField;
    qryCabeceraNUMERO: TLongintField;
    qryCabeceraPERSONAID: TLongintField;
    qryCabeceraRUC: TStringField;
    qryCabeceraSUBTOTAL_EXENTAS: TFloatField;
    qryCabeceraSUBTOTAL_IVA10: TFloatField;
    qryCabeceraSUBTOTAL_IVA5: TFloatField;
    qryCabeceraTALONARIOID: TLongintField;
    qryCabeceraTELEFONO: TStringField;
    qryCabeceraTOTAL: TFloatField;
    qryCabeceraVALIDO: TSmallintField;
    procedure ActualizarTotales; override;
    procedure AnularNotaCredito(ANotaID: string);
    procedure CheckNoNegativo(Sender: TField);
    procedure CloseDataSets; override;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DeterminarImpuesto; override;
    procedure FetchCabeceraFactura(AFacturaID: string);
    procedure FetchCabeceraFactura;
    procedure FetchDetalleFactura;
    procedure FetchDetalleFactura(AFacturaID: string);
    procedure GetImpuestos; override;
    procedure OpenDataSets; override;
    procedure qryCabeceraAfterScroll(DataSet: TDataSet); override;
    procedure qryCabeceraNewRecord(DataSet: TDataSet); override;
    procedure qryDetalleAfterInsert(DataSet: TDataSet); override;
    procedure qryDetallePRECIO_UNITARIOChange(Sender: TField);
    procedure RegistrarMovimiento(EsVenta: boolean; ANotaID: string);
    procedure SaveChanges; override;
    procedure SetNumero; override;
    property Asientos: TAsientosDataModule read FAsientos write SetAsientos;
    property CheckPrecioUnitario: boolean read FCheckPrecioUnitario
      write SetCheckPrecioUnitario;
    property Facturas: TFacturasDataModule read FFacturas write SetFacturas;
    property IVA10Codigo: string read FIVA10Codigo write SetIVA10Codigo;
    property IVA5Codigo: string read FIVA5Codigo write SetIVA5Codigo;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  NotaCreditoDataModule: TNotaCreditoDataModule;
  i5fac, i10fac: double;

implementation

{$R *.lfm}

{ TNotaCreditoDataModule }


procedure TNotaCreditoDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  FAsientos := TAsientosDataModule.Create(Self, MasterDataModule);
  FAsientos.ComprobarAsiento := False;
  FFacturas := TFacturasDataModule.Create(Self, MasterDataModule);
  dsFacturas.DataSet := FFacturas.qryCabecera;
  SetTipoComprobante(doNotaCredito);
  CabeceraGenName := rsGenNotaCredito;
  DetalleGenName := rsGenNotaCreditoDetalle;
  //TalonarioID := TALONARIO_NC;
  IVA10Codigo := IVA10;
  IVA5Codigo := IVA5;
  CheckPrecioUnitario := True;
end;

procedure TNotaCreditoDataModule.qryCabeceraNewRecord(DataSet: TDataSet);
begin
  inherited qryCabeceraNewRecord(DataSet);
  DataSet.FieldByName('IVA5').AsFloat := 0;
  DataSet.FieldByName('IVA10').AsFloat := 0;
  DataSet.FieldByName('IVA_TOTAL').AsFloat := 0;
  DataSet.FieldByName('SUBTOTAL_EXENTAS').AsFloat := 0;
  DataSet.FieldByName('SUBTOTAL_IVA5').AsFloat := 0;
  DataSet.FieldByName('SUBTOTAL_IVA10').AsFloat := 0;
end;

procedure TNotaCreditoDataModule.qryDetalleAfterInsert(DataSet: TDataSet);
begin
  inherited qryDetalleAfterInsert(DataSet);
  DataSet.FieldByName('NOTACREDITOID').AsInteger := qryCabeceraID.AsInteger;
  DataSet.FieldByName('IVA5').AsFloat := 0;
  DataSet.FieldByName('IVA10').AsFloat := 0;
  DataSet.FieldByName('EXENTA').AsFloat := 0;
end;

procedure TNotaCreditoDataModule.qryDetallePRECIO_UNITARIOChange(Sender: TField);
var
  montoMaximo: double;
begin
  if CheckPrecioUnitario then
    try
      montoMaximo := Facturas.qryDetalle.Lookup('ID', qryDetalleFACTURADETALLEID.Value,
        'PRECIO_UNITARIO') * Facturas.qryDetalle.Lookup('ID',
        qryDetalleFACTURADETALLEID.Value, 'CANTIDAD');
      if Sender.AsFloat > montoMaximo then
        Sender.AsFloat := montoMaximo;
    except
      on E: EDatabaseError do
      begin
        Abort;
      end;
    end;

  try
    // iva 10
    if (qryDetalleIVA10.AsFloat = 0) or qryDetalleIVA10.IsNull then
      Exit
    else
      qryDetalleIVA10.AsFloat :=
        qryDetalleCANTIDAD.AsFloat * qryDetallePRECIO_UNITARIO.AsFloat;
    // iva 5
    if (qryDetalleIVA5.AsFloat = 0) or qryDetalleIVA5.IsNull then
      Exit
    else
      qryDetalleIVA5.AsFloat :=
        qryDetalleCANTIDAD.AsFloat * qryDetallePRECIO_UNITARIO.AsFloat;
    // exenta
    if (qryDetalleEXENTA.AsFloat = 0) or qryDetalleEXENTA.IsNull then
      Exit
    else
      qryDetalleEXENTA.AsFloat :=
        qryDetalleCANTIDAD.AsFloat * qryDetallePRECIO_UNITARIO.AsFloat;
  finally
    //qryDetalle.Post;
  end;
end;

procedure TNotaCreditoDataModule.RegistrarMovimiento(EsVenta: boolean; ANotaID: string);
var
  CuentaID: string;
begin
  try
    if (qryCabecera.State in [dsEdit, dsInsert]) then
      raise Exception.Create(rsCreatingDoc);
    if not qryCabecera.Locate('ID', ANotaID, []) then
      raise EDatabaseError.Create(rsNoSeEncontroDoc);
    qryDetalle.First;
    // hay que buscar la cuenta que le correponde a la persona
    Asientos.Cuenta.Cuenta.Open;
    CuentaID := Asientos.Cuenta.Cuenta.Lookup('PERSONAID',
      qryCabecera.FieldByName('PERSONAID').AsString, 'ID');
    Asientos.NuevoAsiento(rsDescripcionPorDefecto +
      qryCabecera.FieldByName('NUMERO').AsString, doNotaCredito,
      qryCabecera.FieldByName('ID').AsString);
    while not qryDetalle.EOF do
    begin
      if EsVenta then
        Asientos.NuevoAsientoDetalle(CuentaID, mvCredito,
          qryDetalle.FieldByName('CANTIDAD').AsFloat * qryDetalle.FieldByName(
          'PRECIO_UNITARIO').AsFloat, qryDetalle.FieldByName('DEUDAID').AsString, '')
      else
        Asientos.NuevoAsientoDetalle(CuentaID, mvDebito,
          qryDetalle.FieldByName('CANTIDAD').AsFloat * qryDetalle.FieldByName(
          'PRECIO_UNITARIO').AsFloat, qryDetalle.FieldByName('DEUDAID').AsString, '');
      qryDetalle.Next;
    end;
    Asientos.PostAsiento;
  except
    on E: Exception do
    begin
      raise;
      Rollback;
    end;
    on E: EDatabaseError do
    begin
      raise;
      Rollback;
    end;
  end;
end;

procedure TNotaCreditoDataModule.SaveChanges;
begin
  inherited SaveChanges;
  if (Asientos.Estado in [asGuardado]) then
  begin
    Asientos.Movimiento.ApplyUpdates;
    Asientos.MovimientoDet.ApplyUpdates;
  end
  else
    raise EDatabaseError.Create('Error al registrar movimiento');
end;

procedure TNotaCreditoDataModule.SetNumero;
begin
  try
    qryNumero.Close;
    qryNumero.ParamByName('TALONARIOID').AsString := TalonarioID;
    qryNumero.Open;
    qryCabecera.FieldByName('TALONARIOID').AsString := TalonarioID; // por si acaso...
    qryCabecera.FieldByName('NUMERO').AsString := qryNumeroNUM.AsString;
  except
    on E: EDatabaseError do
      DoOnErrorEvent(Self, E);
  end;
end;

procedure TNotaCreditoDataModule.SetIVA10Codigo(AValue: string);
begin
  if FIVA10Codigo = AValue then
    Exit;
  FIVA10Codigo := AValue;
end;

procedure TNotaCreditoDataModule.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FFacturas) then
    FreeAndNil(FFacturas);
  if Assigned(FAsientos) then
    FreeAndNil(FAsientos);
end;

procedure TNotaCreditoDataModule.SetFacturas(AValue: TFacturasDataModule);
begin
  if FFacturas = AValue then
    Exit;
  FFacturas := AValue;
end;

procedure TNotaCreditoDataModule.qryDetalleEXENTAChange(Sender: TField);
begin
   CheckNoNegativo(Sender);
  if (qryDetalleEXENTA.AsFloat > 0) then
  begin
  if (qryDetalleIVA5.AsFloat > 0) then
      qryDetalleIVA5.AsFloat:= 0
  else if (qryDetalleIVA10.AsFloat > 0) then
    qryDetalleIVA10.AsFloat:= 0;
  end;
end;

procedure TNotaCreditoDataModule.qryDetalleIVA10Change(Sender: TField);
begin
    CheckNoNegativo(Sender);
   if (qryDetalleIVA10.AsFloat > 0) then
  begin
  if (qryDetalleIVA5.AsFloat > 0) then
      qryDetalleIVA5.AsFloat:= 0
  else if (qryDetalleEXENTA.AsFloat > 0) then
    qryDetalleEXENTA.AsFloat:= 0;
  end;
end;

procedure TNotaCreditoDataModule.qryDetalleIVA5Change(Sender: TField);
begin
  CheckNoNegativo(Sender);
  if (qryDetalleIVA5.AsFloat > 0) then
  begin
  if (qryDetalleIVA10.AsFloat > 0) then
      qryDetalleIVA10.AsFloat:= 0
  else if (qryDetalleEXENTA.AsFloat > 0) then
    qryDetalleEXENTA.AsFloat:= 0;
  end;
end;

procedure TNotaCreditoDataModule.SetAsientos(AValue: TAsientosDataModule);
begin
  if FAsientos = AValue then
    Exit;
  FAsientos := AValue;
end;

procedure TNotaCreditoDataModule.SetCheckPrecioUnitario(AValue: boolean);
begin
  if FCheckPrecioUnitario = AValue then
    Exit;
  FCheckPrecioUnitario := AValue;
end;

procedure TNotaCreditoDataModule.SetIVA5Codigo(AValue: string);
begin
  if FIVA5Codigo = AValue then
    Exit;
  FIVA5Codigo := AValue;
end;

procedure TNotaCreditoDataModule.ActualizarTotales;
begin
  if not (qryCabecera.State in [dsEdit, dsInsert]) then
    qryCabecera.Edit;
  qryCabeceraIVA5.AsFloat := 0;
  qryCabeceraIVA10.AsFloat := 0;
  qryCabeceraIVA_TOTAL.AsFloat := 0;
  qryCabeceraSUBTOTAL_EXENTAS.AsFloat := 0;
  qryCabeceraSUBTOTAL_IVA5.AsFloat := 0;
  qryCabeceraSUBTOTAL_IVA10.AsFloat := 0;
  qryCabeceraTOTAL.AsFloat := 0;
  qryDetalle.First;
  while not qryDetalle.EOF do
  begin
    // subtotales
    qryCabeceraSUBTOTAL_EXENTAS.AsFloat :=
      qryCabeceraSUBTOTAL_EXENTAS.AsFloat + qryDetalleEXENTA.AsFloat;
    qryCabeceraSUBTOTAL_IVA5.AsFloat :=
      qryCabeceraSUBTOTAL_IVA5.AsFloat + qryDetalleIVA5.AsFloat;
    qryCabeceraSUBTOTAL_IVA10.AsFloat :=
      qryCabeceraSUBTOTAL_IVA10.AsFloat + qryDetalleIVA10.AsFloat;
    qryDetalle.Next;
  end;
  // totales iva
  qryCabeceraIVA5.AsFloat := Round((qryCabeceraSUBTOTAL_IVA5.AsFloat * I5Fac) /
    (1 + I5Fac));
  qryCabeceraIVA10.AsFloat :=
    Round((qryCabeceraSUBTOTAL_IVA10.AsFloat * I10Fac) / (1 + I10Fac));
  // sumatoria de iva5 e iva10
  qryCabeceraIVA_TOTAL.AsFloat :=
    qryCabeceraIVA_TOTAL.AsFloat + qryCabeceraIVA10.AsFloat + qryCabeceraIVA5.AsFloat;
  // gran total
  qryCabeceraTOTAL.AsFloat :=
    qryCabeceraTOTAL.AsFloat + qryCabeceraSUBTOTAL_EXENTAS.AsFloat +
    qryCabeceraSUBTOTAL_IVA5.AsFloat + qryCabeceraSUBTOTAL_IVA10.AsFloat;
end;

procedure TNotaCreditoDataModule.AnularNotaCredito(ANotaID: string);
var
  NCNum: string;
begin
  try
    if not qryCabecera.Locate('ID', ANotaID, []) then
      raise EDatabaseError.Create('No se encuentra la nota de credito');
    NCNum := qryCabecera.FieldByName('NUMERO').AsString;
    qryCabecera.Edit;
    qryCabecera.FieldByName('VALIDO').AsString := DB_FALSE;
    qryCabecera.Post;
    if not Asientos.Movimiento.Locate('DOCUMENTOID;TIPO_DOCUMENTO',
      VarArrayOf([ANotaID, NOTA_CREDITO]), []) then
      raise EDatabaseError.Create(
        'No se puede revertir el movimiento. Movimiento no encontrado');
    Asientos.ReversarAsiento(rsDescripcionAnulacion + NCNum);
    Asientos.PostAsiento;
    SaveChanges;
  except
    on E: EDatabaseError do
    begin
      Rollback;
      raise;
    end;
  end;
end;

procedure TNotaCreditoDataModule.CheckNoNegativo(Sender: TField);
begin
  if Sender.AsFloat < 0 then
  begin
    Sender.Clear;
    raise Exception.Create('El campo ' + Sender.FieldName +
      ' no permite valores negativos');
  end;
end;

procedure TNotaCreditoDataModule.CloseDataSets;
begin
  inherited CloseDataSets;
  Facturas.CloseDataSets;
end;

procedure TNotaCreditoDataModule.DeterminarImpuesto;
begin
  // no hace falta
end;

procedure TNotaCreditoDataModule.FetchCabeceraFactura;
begin
  FetchCabeceraFactura(FFacturas.qryCabeceraID.AsString);
end;

procedure TNotaCreditoDataModule.FetchCabeceraFactura(AFacturaID: string);
begin
  Facturas.LocateComprobante(AFacturaID);
  qryCabeceraFACTURAID.Value := Facturas.qryCabecera.FieldByName('ID').Value;
  qryCabeceraPERSONAID.Value := Facturas.qryCabecera.FieldByName('PERSONAID').Value;
  qryCabeceraNOMBRE.AsString := Facturas.qryCabecera.FieldByName('NOMBRE').AsString;
  qryCabeceraNOTA_REMISION.AsString :=
    Facturas.qryCabecera.FieldByName('NOTA_REMISION').AsString;
  qryCabeceraRUC.AsString := Facturas.qryCabecera.FieldByName('RUC').AsString;
  qryCabeceraTELEFONO.AsString := Facturas.qryCabecera.FieldByName('TELEFONO').AsString;
  qryCabeceraDIRECCION.AsString :=
    Facturas.qryCabecera.FieldByName('DIRECCION').AsString;
  qryCabeceraSUBTOTAL_EXENTAS.Value :=
    Facturas.qryCabecera.FieldByName('SUBTOTAL_EXENTAS').Value;
  qryCabeceraSUBTOTAL_IVA10.Value :=
    Facturas.qryCabecera.FieldByName('SUBTOTAL_IVA10').Value;
  qryCabeceraSUBTOTAL_IVA5.Value :=
    Facturas.qryCabecera.FieldByName('SUBTOTAL_IVA5').Value;
  qryCabeceraIVA10.Value := Facturas.qryCabecera.FieldByName('IVA10').Value;
  qryCabeceraIVA5.Value := Facturas.qryCabecera.FieldByName('IVA5').Value;
  qryCabeceraIVA_TOTAL.Value := Facturas.qryCabecera.FieldByName('IVA_TOTAL').Value;
  qryCabeceraTOTAL.Value := Facturas.qryCabecera.FieldByName('TOTAL').Value;
end;

procedure TNotaCreditoDataModule.FetchDetalleFactura;
begin
  FetchDetalleFactura(FFacturas.qryCabeceraID.AsString);
end;

procedure TNotaCreditoDataModule.FetchDetalleFactura(AFacturaID: string);
begin
  try
    qryDetalle.AfterPost := nil;
    Facturas.qryDetalle.First;
    while not Facturas.qryDetalle.EOF do
    begin
      NuevoComprobanteDetalle;
      qryDetalleFACTURADETALLEID.AsString :=
        Facturas.qryDetalle.FieldByName('ID').AsString;
      qryDetalleDEUDAID.AsString := Facturas.qryDetalle.FieldByName('DEUDAID').AsString;
      qryDetalleCANTIDAD.AsInteger :=
        Facturas.qryDetalle.FieldByName('CANTIDAD').AsInteger;
      qryDetalleDETALLE.AsString := Facturas.qryDetalle.FieldByName('DETALLE').AsString;
      qryDetalle.FieldByName('PRECIO_UNITARIO').AsFloat :=
        Facturas.qryDetalle.FieldByName('PRECIO_UNITARIO').AsFloat;
      qryDetalleEXENTA.AsFloat := Facturas.qryDetalle.FieldByName('EXENTA').AsFloat;
      qryDetalleIVA5.AsFloat := Facturas.qryDetalle.FieldByName('IVA5').AsFloat;
      qryDetalleIVA10.AsFloat := Facturas.qryDetalle.FieldByName('IVA10').AsFloat;
      Facturas.qryDetalle.Next;
    end;
  finally
    //qryDetalle.AfterPost := @qryDetalleAfterPost;
  end;
  ActualizarTotales;
end;

procedure TNotaCreditoDataModule.GetImpuestos;
begin
  if (Impuesto.Lookup('ID', IVA10, 'FACTOR') = null) or
    (Impuesto.Lookup('ID', IVA5, 'FACTOR') = null) then
    raise Exception.Create('Impuestos no encontrados')
  else
  begin
    I10Fac := Impuesto.Lookup('ID', IVA10, 'FACTOR');
    I5Fac := Impuesto.Lookup('ID', IVA5, 'FACTOR');
  end;
end;

procedure TNotaCreditoDataModule.OpenDataSets;
begin
  Facturas.OpenDataSets;
  inherited OpenDataSets;
end;

procedure TNotaCreditoDataModule.qryCabeceraAfterScroll(DataSet: TDataSet);
begin
  qryDetalle.Close;
  qryDetalle.ParamByName('NOTACREDITOID').Value := DataSet.FieldByName('ID').Value;
  qryDetalle.Open;
end;

end.
