unit frmNotaCreditoDataModule;

{$mode objfpc}{$H+}

interface

uses
  frmcomprobantedatamodule, LR_DBSet, LR_Class, XMLPropStorage, IniPropStorage,
  DB, sqldb, mensajes, variants, frmfacturadatamodule2, Classes, sgcdTypes,
  SysUtils, frmasientosdatamodule;

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
    dsCabReport: TDataSource;
    dsDetReport: TDataSource;
    LongintField1: TLongintField;
    NotasCreditoNuevoViewESCOMPRA: TLongintField;
    NotasCreditoNuevoViewFECHA_EMISION: TDateField;
    NotasCreditoNuevoViewID: TLongintField;
    NotasCreditoNuevoViewNOMBRE: TStringField;
    NotasCreditoNuevoViewNUMERO_NOTA_CREDITO: TStringField;
    NotasCreditoNuevoViewPERSONAID: TLongintField;
    NotasCreditoNuevoViewRUC: TStringField;
    NotasCreditoNuevoViewTIMBRADO: TStringField;
    NotasCreditoNuevoViewTOTAL: TFloatField;
    NotasCreditoNuevoViewVALIDO: TSmallintField;
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
    qryCabeceraNUMERO_NOTA_COMPRA: TStringField;
    qryCabeceraPERSONAID: TLongintField;
    qryCabeceraReport: TSQLQuery;
    qryCabeceraReportDIRECCION: TStringField;
    qryCabeceraReportESCOMPRA: TLongintField;
    qryCabeceraReportFECHA_EMISION: TDateField;
    qryCabeceraReportID: TLongintField;
    qryCabeceraReportIVA10: TFloatField;
    qryCabeceraReportIVA5: TFloatField;
    qryCabeceraReportIVA_TOTAL: TFloatField;
    qryCabeceraReportNOMBRE: TStringField;
    qryCabeceraReportNOTA_REMISION: TStringField;
    qryCabeceraReportNUMERO_NOTA_CREDITO: TStringField;
    qryCabeceraReportPERS_DIRECCION: TStringField;
    qryCabeceraReportPERS_NOMBRECOMPLETO: TStringField;
    qryCabeceraReportPERS_RUCCEDULA: TStringField;
    qryCabeceraReportPERS_TELEFONO: TStringField;
    qryCabeceraReportRUC: TStringField;
    qryCabeceraReportSUBTOTAL_EXENTAS: TFloatField;
    qryCabeceraReportSUBTOTAL_IVA10: TFloatField;
    qryCabeceraReportSUBTOTAL_IVA5: TFloatField;
    qryCabeceraReportTAL_DIRECCION: TStringField;
    qryCabeceraReportTAL_NOMBRE: TStringField;
    qryCabeceraReportTAL_RUBRO: TStringField;
    qryCabeceraReportTAL_RUC: TStringField;
    qryCabeceraReportTAL_TELEFONO: TStringField;
    qryCabeceraReportTELEFONO: TStringField;
    qryCabeceraReportTIMBRADO: TStringField;
    qryCabeceraReportTOTAL: TFloatField;
    qryCabeceraReportVALIDO_HASTA: TDateField;
    qryCabeceraRUC: TStringField;
    qryCabeceraSUBTOTAL_EXENTAS: TFloatField;
    qryCabeceraSUBTOTAL_IVA10: TFloatField;
    qryCabeceraSUBTOTAL_IVA5: TFloatField;
    qryCabeceraTALONARIOID: TLongintField;
    qryCabeceraTELEFONO: TStringField;
    qryCabeceraTIMBRADO: TStringField;
    qryCabeceraTOTAL: TFloatField;
    qryCabeceraVALIDO: TSmallintField;
    NotasCreditoNuevoView: TSQLQuery;
    qryDetalleReport: TSQLQuery;
    qryDetalleReportCANTIDAD: TLongintField;
    qryDetalleReportDETALLE: TStringField;
    qryDetalleReportDEUDAID: TLongintField;
    qryDetalleReportEXENTA: TFloatField;
    qryDetalleReportFACTURADETALLEID: TLongintField;
    qryDetalleReportID: TLongintField;
    qryDetalleReportIVA10: TFloatField;
    qryDetalleReportIVA5: TFloatField;
    qryDetalleReportNOTACREDITOID: TLongintField;
    qryDetalleReportPRECIO_UNITARIO: TFloatField;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
  private
    FCheckPrecioUnitario: boolean;
    FFacturas: TFacturasDataModule;
    FIVA10Codigo: string;
    FIVA5Codigo: string;
    procedure SetCheckPrecioUnitario(AValue: boolean);
    procedure SetFacturas(AValue: TFacturasDataModule);
    procedure SetIVA10Codigo(AValue: string);
    procedure SetIVA5Codigo(AValue: string);
  published
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
    dsFacturas: TDataSource;
    procedure ActualizarTotales; override;
    procedure AnularNotaCredito(ANotaID: string);
    procedure CheckNoNegativo(Sender: TField);
    procedure CloseDataSets; override;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DeterminarImpuesto; override;
    procedure FetchCabeceraCompra; override;
    procedure FetchCabeceraFactura(AFacturaID: string);
    procedure FetchCabeceraFactura;
    procedure FetchDetalleFactura;
    procedure FetchDetalleFactura(AFacturaID: string);
    procedure FiltrarFacturas(ACompraVenta: TCompraVenta);
    procedure GetImpuestos; override;
    procedure OpenDataSets; override;
    procedure qryCabeceraAfterScroll(DataSet: TDataSet); override;
    procedure qryCabeceraNewRecord(DataSet: TDataSet); override;
    procedure qryDetalleAfterInsert(DataSet: TDataSet); override;
    procedure qryDetallePRECIO_UNITARIOChange(Sender: TField);
    procedure qryDetalleEXENTAChange(Sender: TField);
    procedure qryDetalleIVA10Change(Sender: TField);
    procedure qryDetalleIVA5Change(Sender: TField);
    procedure RegistrarMovimiento(ANotaID: string; Desc: string = '');
    procedure SaveChanges; override;
    procedure SetNumero; override;
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
  FFacturas := TFacturasDataModule.Create(Self, MasterDataModule);
  dsFacturas.DataSet := FFacturas.FacturasView;
  SetTipoComprobante(doNotaCredito);
  CabeceraGenName := rsGenNotaCredito;
  DetalleGenName := rsGenNotaCreditoDetalle;
  AuxQryList.Add(TObject(FFacturas.FacturasView));
  AuxQryList.Add(TObject(NotasCreditoNuevoView));
  AuxQryList.Add(TObject(qryCabeceraReport));
  AuxQryList.Add(TObject(qryDetalleReport));
  //TalonarioID := TALONARIO_NC;
  IVA10Codigo := IVA10;
  IVA5Codigo := IVA5;
  CheckPrecioUnitario := True;
  ReportFile := 'reportes\reporte-nota-credito.lrf';
  ReportFileCompra := 'reportes\reporte-nota-credito-compra.lrf';
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
  try
    CheckNoNegativo(Sender);
    if CheckPrecioUnitario then
    begin
      montoMaximo := Facturas.qryDetalle.Lookup('ID', qryDetalleFACTURADETALLEID.Value,
        'PRECIO_UNITARIO') * Facturas.qryDetalle.Lookup('ID',
        qryDetalleFACTURADETALLEID.Value, 'CANTIDAD');
      if Sender.AsFloat > montoMaximo then
        try
          Sender.OnChange := nil;
          Sender.AsFloat := montoMaximo;
        finally
          Sender.OnChange := @qryDetallePRECIO_UNITARIOChange;
        end;
    end;
    try
      qryDetalleIVA10.OnChange := nil;
      qryDetalleIVA5.OnChange := nil;
      qryDetalleEXENTA.OnChange := nil;
      // iva 10
      if not ((qryDetalleIVA10.AsFloat = 0) or qryDetalleIVA10.IsNull) then
      begin
        qryDetalleIVA10.AsFloat :=
          qryDetalleCANTIDAD.AsFloat * qryDetallePRECIO_UNITARIO.AsFloat;
      end
      // iva 5
      else if not ((qryDetalleIVA5.AsFloat = 0) or qryDetalleIVA5.IsNull) then
      begin
        qryDetalleIVA5.AsFloat :=
          qryDetalleCANTIDAD.AsFloat * qryDetallePRECIO_UNITARIO.AsFloat;
      end
      // exenta
      else if not ((qryDetalleEXENTA.AsFloat = 0) or qryDetalleEXENTA.IsNull) then
      begin
        qryDetalleEXENTA.AsFloat :=
          qryDetalleCANTIDAD.AsFloat * qryDetallePRECIO_UNITARIO.AsFloat;
      end;
    finally
      qryDetalleIVA10.OnChange := @qryDetalleIVA10Change;
      qryDetalleIVA5.OnChange := @qryDetalleIVA5Change;
      qryDetalleEXENTA.OnChange := @qryDetalleEXENTAChange;
    end;
  except
    on E: Exception do
    begin
      Abort;
      raise;
    end;
  end;
end;

procedure TNotaCreditoDataModule.RegistrarMovimiento(ANotaID: string; Desc: string);
var
  CuentaID: string;
begin
  try
    if (qryCabecera.State in [dsEdit, dsInsert]) then
      raise Exception.Create(rsCreatingDoc);
    if not qryCabecera.Locate('ID', ANotaID, []) then
      raise EDatabaseError.Create(rsNoSeEncontroDoc);
    // si la factura ya esta cobrada se necesita meter un movimiento de credito
    // caso contrario no se debe ya que puede llevar a inconsistencia de movimientos
    if not Facturas.EstaCobrada(qryCabeceraFACTURAID.AsString) then
      Exit;
    // solucion karape: se le llama al metodo con este parametro desde PagoDatamodule
    if Trim(Desc) = '' then
      desc := 'nota de credito nro ' + tal.FieldByName('SUCURSAL').AsString +
        '-' + tal.FieldByName('CAJA').AsString + '-' +
        qryCabecera.FieldByName('NUMERO').AsString + ' con timbrado ' +
        tal.FieldByName('TIMBRADO').AsString;
    qryDetalle.First;
    // hay que buscar la cuenta que le correponde a la persona
    Asientos.Cuenta.Cuenta.Open;
    if Asientos.Cuenta.Cuenta.Lookup('PERSONAID',
      qryCabecera.FieldByName('PERSONAID').AsString, 'ID') = null then
      raise Exception.Create('Cuenta no encontrada');
    CuentaID := Asientos.Cuenta.Cuenta.Lookup('PERSONAID',
      qryCabecera.FieldByName('PERSONAID').AsString, 'ID');
    Asientos.NuevoAsiento('Emision de ' + desc, doNotaCredito,
      qryCabecera.FieldByName('ID').AsString);
    while not qryDetalle.EOF do
    begin
      Asientos.NuevoAsientoDetalle(CuentaID, mvCredito,
        qryDetalle.FieldByName('CANTIDAD').AsFloat * qryDetalle.FieldByName(
        'PRECIO_UNITARIO').AsFloat, qryDetalle.FieldByName('DEUDAID').AsString, '');
      qryDetalle.Next;
    end;
    Asientos.PostAsiento;

    // REGISTRAR EN CUENTA DE COMPRAS
    qryDetalle.First;
    Asientos.Cuenta.Cuenta.Open;
    if not Asientos.Cuenta.Cuenta.Locate('ID', FCuentaCompras, []) then
      raise Exception.Create('Cuenta invalida');
    Asientos.NuevoAsiento('Emision de ' + desc, doNotaCredito,
      qryCabeceraID.AsString);
    while not qryDetalle.EOF do
    begin
      Asientos.NuevoAsientoDetalle(FCuentaCompras, mvCredito,
        qryDetalle.FieldByName('CANTIDAD').AsFloat * qryDetalle.FieldByName(
        'PRECIO_UNITARIO').AsFloat);
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
  end;
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
end;

procedure TNotaCreditoDataModule.SetFacturas(AValue: TFacturasDataModule);
begin
  if FFacturas = AValue then
    Exit;
  FFacturas := AValue;
end;

procedure TNotaCreditoDataModule.qryDetalleEXENTAChange(Sender: TField);
begin
  try
    CheckNoNegativo(Sender);
    if (qryDetalleEXENTA.AsFloat > 0) then
    begin
      if (qryDetalleIVA5.AsFloat > 0) then
        try
          qryDetalleIVA5.OnChange := nil;
          qryDetalleIVA5.AsFloat := 0
        finally
          qryDetalleIVA5.OnChange := @qryDetalleIVA5Change;
        end
      else if (qryDetalleIVA10.AsFloat > 0) then
        try
          qryDetalleIVA10.OnChange := nil;
          qryDetalleIVA10.AsFloat := 0
        finally
          qryDetalleIVA10.OnChange := @qryDetalleIVA10Change;
        end;
    end;
  except
    on E: Exception do
      raise;
  end;
end;

procedure TNotaCreditoDataModule.qryDetalleIVA10Change(Sender: TField);
begin
  try
    CheckNoNegativo(Sender);
    if (qryDetalleIVA10.AsFloat > 0) then
    begin
      if (qryDetalleIVA5.AsFloat > 0) then
        try
          qryDetalleIVA5.OnChange := nil;
          qryDetalleIVA5.AsFloat := 0
        finally
          qryDetalleIVA5.OnChange := @qryDetalleIVA5Change;
        end
      else if (qryDetalleEXENTA.AsFloat > 0) then
        try
          qryDetalleEXENTA.OnChange := nil;
          qryDetalleEXENTA.AsFloat := 0
        finally
          qryDetalleEXENTA.OnChange := @qryDetalleEXENTAChange;
        end;
    end;
  except
    on E: Exception do
      raise;
  end;
end;

procedure TNotaCreditoDataModule.qryDetalleIVA5Change(Sender: TField);
begin
  try
    CheckNoNegativo(Sender);
    if (qryDetalleIVA5.AsFloat > 0) then
    begin
      if (qryDetalleIVA10.AsFloat > 0) then
        try
          qryDetalleIVA5.OnChange := nil;
          qryDetalleIVA5.AsFloat := 0
        finally
          qryDetalleIVA5.OnChange := @qryDetalleIVA5Change;
        end
      else if (qryDetalleEXENTA.AsFloat > 0) then
        try
          qryDetalleEXENTA.OnChange := nil;
          qryDetalleEXENTA.AsFloat := 0
        finally
          qryDetalleEXENTA.OnChange := @qryDetalleEXENTAChange;
        end;
    end;
  except
    on E: Exception do
      raise;
  end;
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
  c, desc: string;
begin
  try
    //if not qryCabecera.Locate('ID', ANotaID, []) then
    //  raise EDatabaseError.Create('No se encuentra la nota de credito');
    LocateComprobante(ANotaID);
    if qryCabeceraVALIDO.AsString = DB_FALSE then
      raise Exception.Create('La nota ya esta anulada');
    qryCabecera.Edit;
    qryCabecera.FieldByName('VALIDO').AsString := DB_FALSE;
    qryCabecera.ApplyUpdates;
    if not NotasCreditoNuevoView.Locate('ID', ANotaID, []) then
      raise Exception.Create('No se pudo obtener numero y timbrado');

    // si es nota credito de venta
    if not qryCabeceraTALONARIOID.IsNull then
    begin
      NotasCreditoNuevoView.Locate('ID', ANotaID, []);
      Facturas.LocateComprobante(qryCabeceraFACTURAID.AsString);
      Asientos.OpenDataSets;
      // si fue una NC generada antes de cobrar la factura
      if Facturas.EstaCobrada(qryCabeceraFACTURAID.AsString) and not
        Asientos.Movimiento.Locate('DOCUMENTOID;TIPO_DOCUMENTO',
        VarArrayOf([ANotaID, NOTA_CREDITO]), []) then
      begin
        c := MasterDataModule.DevuelveValor(
          'select c.id from cuenta c join nota_credito n on n.personaid = c.personaid where n.id = '
          + ANotaID, 'ID');
        desc := 'nota de credito nro ' +
          NotasCreditoNuevoViewNUMERO_NOTA_CREDITO.AsString +
          ' con timbrado ' + NotasCreditoNuevoViewTIMBRADO.AsString;
        Asientos.NuevoAsiento('Anulacion de ' + desc,
          doNotaCredito, ANotaID);
        while not qryDetalle.EOF do
        begin
          Asientos.NuevoAsientoDetalle(c, mvDebito, qryDetalleCANTIDAD.AsFloat *
            qryDetallePRECIO_UNITARIO.AsFloat, qryDetalleDEUDAID.AsString, '');
          qryDetalle.Next;
        end;
        Asientos.SaveChanges;
        // ahora en la cuenta de ingresos egresos
        Asientos.NuevoAsiento('Anulacion de ' + desc,
          doNotaCredito, ANotaID);
        while not qryDetalle.EOF do
        begin
          Asientos.NuevoAsientoDetalle(FCuentaCompras, mvCredito,
            qryDetalleCANTIDAD.AsFloat * qryDetallePRECIO_UNITARIO.AsFloat,
            qryDetalleDEUDAID.AsString, '');
          qryDetalle.Next;
        end;
        Asientos.SaveChanges;
      end
      // si se genero despues de cobrar
      else if Facturas.EstaCobrada(qryCabeceraFACTURAID.AsString) and
        Asientos.Movimiento.Locate('DOCUMENTOID;TIPO_DOCUMENTO',
        VarArrayOf([ANotaID, NOTA_CREDITO]), []) then

      begin
        Asientos.ReversarAsientoComprobante(doNotaCredito, ANotaID,
          'Anulacion de nota de credito nro ' +
          NotasCreditoNuevoViewNUMERO_NOTA_CREDITO.AsString +
          ' con timbrado ' + NotasCreditoNuevoViewTIMBRADO.AsString);
      end
      // si no se cobro todavia la factura
      else if not Facturas.EstaCobrada(qryCabeceraFACTURAID.AsString) then
        Exit;
    end
    else
      Asientos.ReversarAsientoComprobante(doNotaCredito, ANotaID,
        'Anulacion de nota de credito nro ' +
        NotasCreditoNuevoViewNUMERO_NOTA_CREDITO.AsString + ' con timbrado ' +
        NotasCreditoNuevoViewTIMBRADO.AsString);
  except
    on E: Exception do
    begin
      raise;
      Rollback;
    end;
  end;
end;

procedure TNotaCreditoDataModule.CheckNoNegativo(Sender: TField);
begin
  if Sender.AsFloat < 0 then
  begin
    //Sender.Clear;
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

procedure TNotaCreditoDataModule.FetchCabeceraCompra;
begin
  inherited FetchCabeceraCompra;
end;

procedure TNotaCreditoDataModule.FetchCabeceraFactura;
begin
  FetchCabeceraFactura(FFacturas.FacturasViewID.AsString);
end;

procedure TNotaCreditoDataModule.FetchCabeceraFactura(AFacturaID: string);
begin
  Facturas.LocateComprobante(AFacturaID);
  if not (qryCabecera.State in dsEditModes) then
    qryCabecera.Edit;
  qryCabeceraFACTURAID.Value := Facturas.qryCabecera.FieldByName('ID').Value;
  qryCabeceraPERSONAID.AsString :=
    Facturas.qryCabecera.FieldByName('PERSONAID').AsString;
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
    qryDetallePRECIO_UNITARIO.OnChange := nil;
    qryDetalleEXENTA.OnChange := nil;
    qryDetalleIVA5.OnChange := nil;
    qryDetalleIVA10.OnChange := nil;
    qryDetalle.AfterPost := nil;
    Facturas.qryDetalle.First;
    DeudaView.Close;
    DeudaView.ParamByName('personaid').AsString :=
      Facturas.qryCabeceraPERSONAID.AsString;
    DeudaView.Open;
    while not Facturas.qryDetalle.EOF do
    begin
      NuevoComprobanteDetalle;
      qryDetalleDEUDAID.AsString :=
        Facturas.qryDetalle.FieldByName('DEUDAID').AsString;
      qryDetalleFACTURADETALLEID.AsString :=
        Facturas.qryDetalle.FieldByName('ID').AsString;
      qryDetalleCANTIDAD.AsInteger :=
        Facturas.qryDetalle.FieldByName('CANTIDAD').AsInteger;
      qryDetalleDETALLE.AsString := Facturas.qryDetalle.FieldByName('DETALLE').AsString;
      if DeudaView.Locate('ID', Facturas.qryDetalle.FieldByName(
        'DEUDAID').AsString, []) then
      begin
        qryDetalle.FieldByName('PRECIO_UNITARIO').AsFloat :=
          //DeudaView.FieldByName('MONTO_DEUDA').AsFloat -
          DeudaView.FieldByName('MONTO_FACTURADO').AsFloat;
        if Facturas.qryDetalle.FieldByName('EXENTA').AsFloat <> 0 then
          qryDetalleEXENTA.AsFloat :=
            qryDetalleCANTIDAD.AsFloat * qryDetallePRECIO_UNITARIO.AsFloat
        else if Facturas.qryDetalle.FieldByName('IVA5').AsFloat <> 0 then
          qryDetalleIVA5.AsFloat :=
            qryDetalleCANTIDAD.AsFloat * qryDetallePRECIO_UNITARIO.AsFloat
        else if Facturas.qryDetalle.FieldByName('IVA10').AsFloat <> 0 then
          qryDetalleIVA10.AsFloat :=
            qryDetalleCANTIDAD.AsFloat * qryDetallePRECIO_UNITARIO.AsFloat;
      end
      else
      begin
        qryDetalle.FieldByName('PRECIO_UNITARIO').AsFloat :=
          Facturas.qryDetalle.FieldByName('PRECIO_UNITARIO').AsFloat;
        qryDetalleEXENTA.AsFloat :=
          Facturas.qryDetalle.FieldByName('EXENTA').AsFloat;
        qryDetalleIVA5.AsFloat := Facturas.qryDetalle.FieldByName('IVA5').AsFloat;
        qryDetalleIVA10.AsFloat := Facturas.qryDetalle.FieldByName('IVA10').AsFloat;
      end;
      Facturas.qryDetalle.Next;
    end;
    ActualizarTotales;
  finally
    qryDetallePRECIO_UNITARIO.OnChange := @qryDetallePRECIO_UNITARIOChange;
    qryDetalleEXENTA.OnChange := @qryDetalleEXENTAChange;
    qryDetalleIVA5.OnChange := @qryDetalleIVA5Change;
    qryDetalleIVA10.OnChange := @qryDetalleIVA10Change;
    qryDetalle.AfterPost := @qryDetalleAfterPost;
  end;
end;

procedure TNotaCreditoDataModule.FiltrarFacturas(ACompraVenta: TCompraVenta);
begin
  Facturas.FacturasView.Close;
  case ACompraVenta of
    cvCompra: Facturas.FacturasView.ServerFilter := 'ESCOMPRA = 1';
    cvVenta: Facturas.FacturasView.ServerFilter :=
        'ESCOMPRA = 0';
    cvCualquiera: Facturas.FacturasView.ServerFilter :=
        'ESCOMPRA IN (1,0)';
  end;
  Facturas.FacturasView.ServerFiltered := True;
  Facturas.FacturasView.Open;
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
  qryCabeceraReport.Close;
  qryDetalleReport.Close;
  qryDetalle.ParamByName('NOTACREDITOID').Value := DataSet.FieldByName('ID').Value;
  qryCabeceraReport.ParamByName('ID').Value := DataSet.FieldByName('ID').Value;
  qryDetalleReport.ParamByName('ID').Value := DataSet.FieldByName('ID').Value;
  qryCabeceraReport.Open;
  qryDetalleReport.Open;
  qryDetalle.Open;
end;

end.
