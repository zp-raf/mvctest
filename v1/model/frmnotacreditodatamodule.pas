unit frmNotaCreditoDataModule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, FileUtil, LR_Class, LR_DBSet, Forms, Controls,
  Graphics, Dialogs, XMLPropStorage, frmquerydatamodule, frmfacturadatamodule2, frmpersonasdatamodule,
  mvc, observerSubject;

//frmquerydatamodule, frmsgcddatamodule, frmpersonasdatamodule, mvc;


resourcestring
  rsGenFacturaID = 'SEQ_NOTA_CREDITO';
  rsGenFacturaDetalleID = 'SEQ_NOTA_CREDITO_DETALLE';
  rsNoHayDeudas = 'No hay deudas para la persona seleccionada';
  rsNoSeEstaCreando = 'No se esta creando una nota de crédito';
  rsYaSeEstaCreando = 'Ya se esta creando una nota de crédito';
  rsPersonaNoEncontrada = 'Persona no encontrada';
  rsNoSeEncontroDoc = 'No se encontro el documento';
  rsNoSePuedeSetFac = 'No se puede completar la accion. Se esta editando una ' +
    'nota de crédito';

  const
  //mientras tanto pongo aca los codigos de los impuestos
  IVA10INC = 1;
  IVA5INC = 2;
  IVA10 = 3;
  IVA5 = 4;
  DELIMITER_IVA = ';';
  //mientras tanto pongo aca el id del talonario
  TALONARIOID = '1';

type

  TIVA10 = set of byte;
  TIVA5 = set of byte;

  TCodigos = TStringList;

  TEstadoNotaCredito = (asInicial, asEditando, asGuardado, asLeyendo);

  { TNotaCreditoDataModule }

  TNotaCreditoDataModule = class(TQueryDataModule)
    DeudaView: TSQLQuery;
    DeudaViewACTIVO: TSmallintField;
    DeudaViewARANCELID: TLongintField;
    DeudaViewCANTIDAD_CUOTAS: TLongintField;
    DeudaViewCUENTAID: TLongintField;
    DeudaViewCUOTA_NRO: TLongintField;
    DeudaViewDESCRIPCION: TStringField;
    DeudaViewFACTURAID: TLongintField;
    DeudaViewID: TLongintField;
    DeudaViewMATRICULAID: TLongintField;
    DeudaViewPERSONAID: TLongintField;
    DeudaViewSALDO: TFloatField;
    DeudaViewVENCIMIENTO: TDateField;
    dsDetalle: TDatasource;
    dsDetalle1: TDatasource;
    dsFactura: TDatasource;
    dsFactura1: TDatasource;
    dsNum: TDatasource;
    dsNum1: TDatasource;
    dstal: TDatasource;
    dstal1: TDatasource;
    FacturasDataModule: TFacturasDataModule;
    frDBReporteCab: TfrDBDataSet;
    frDBReporteDet: TfrDBDataSet;
    frReport1: TfrReport;
    frReport2: TfrReport;
    Impuesto: TSQLQuery;
    Impuesto1: TSQLQuery;
    ImpuestoACTIVO: TSmallintField;
    ImpuestoACTIVO1: TSmallintField;
    ImpuestoFACTOR: TFloatField;
    ImpuestoFACTOR1: TFloatField;
    ImpuestoID: TLongintField;
    ImpuestoID1: TLongintField;
    ImpuestoINCLUIDO: TSmallintField;
    ImpuestoINCLUIDO1: TSmallintField;
    ImpuestoNOMBRE: TStringField;
    ImpuestoNOMBRE1: TStringField;
    ImpuestoView: TSQLQuery;
    ImpuestoView1: TSQLQuery;
    ImpuestoViewAR_ACT: TSmallintField;
    ImpuestoViewAR_ACT1: TSmallintField;
    ImpuestoViewAR_ID: TLongintField;
    ImpuestoViewAR_ID1: TLongintField;
    ImpuestoViewAR_NOMBRE: TStringField;
    ImpuestoViewAR_NOMBRE1: TStringField;
    ImpuestoViewEXENTAS: TSmallintField;
    ImpuestoViewEXENTAS1: TSmallintField;
    ImpuestoViewFACTOR: TFloatField;
    ImpuestoViewFACTOR1: TFloatField;
    ImpuestoViewGRUPO_PROD: TStringField;
    ImpuestoViewGRUPO_PROD1: TStringField;
    ImpuestoViewIMP_ACTIVO: TSmallintField;
    ImpuestoViewIMP_ACTIVO1: TSmallintField;
    ImpuestoViewIMP_ID: TLongintField;
    ImpuestoViewIMP_ID1: TLongintField;
    ImpuestoViewIMP_NOMBRE: TStringField;
    ImpuestoViewIMP_NOMBRE1: TStringField;
    ImpuestoViewINCLUIDO: TSmallintField;
    ImpuestoViewINCLUIDO1: TSmallintField;
    ImpuestoViewMONTO: TFloatField;
    ImpuestoViewMONTO1: TFloatField;
    ImpuestoViewSERVICIOS: TSmallintField;
    ImpuestoViewSERVICIOS1: TSmallintField;
    Props: TXMLPropStorage;
    qryDetalle: TSQLQuery;
    qryDetalle1: TSQLQuery;
    qryDetalleCANTIDAD: TLongintField;
    qryDetalleCANTIDAD1: TLongintField;
    qryDetalleCONTRA_FACTURA: TLongintField;
    qryDetalleDETALLE: TStringField;
    qryDetalleDETALLE1: TStringField;
    qryDetalleDEUDAID: TLongintField;
    qryDetalleDEUDAID1: TLongintField;
    qryDetalleEXENTA: TFloatField;
    qryDetalleEXENTA1: TFloatField;
    qryDetalleFACTURAID1: TLongintField;
    qryDetalleID: TLongintField;
    qryDetalleID1: TLongintField;
    qryDetalleIVA10: TFloatField;
    qryDetalleIVA11: TFloatField;
    qryDetalleIVA5: TFloatField;
    qryDetalleIVA6: TFloatField;
    qryDetalleNOTACREDITOID: TLongintField;
    qryDetallePRECIO_UNITARIO: TFloatField;
    qryDetallePRECIO_UNITARIO1: TFloatField;
    qryFactura: TSQLQuery;
    qryFactura1: TSQLQuery;
    qryFacturaCONTADO1: TSmallintField;
    qryFacturaDIRECCION: TStringField;
    qryFacturaDIRECCION1: TStringField;
    qryFacturaFECHA_EMISION: TDateField;
    qryFacturaFECHA_EMISION1: TDateField;
    qryFacturaID: TLongintField;
    qryFacturaID1: TLongintField;
    qryFacturaIVA10: TFloatField;
    qryFacturaIVA11: TFloatField;
    qryFacturaIVA5: TFloatField;
    qryFacturaIVA6: TFloatField;
    qryFacturaIVA_TOTAL: TFloatField;
    qryFacturaIVA_TOTAL1: TFloatField;
    qryFacturaNOMBRE: TStringField;
    qryFacturaNOMBRE1: TStringField;
    qryFacturaNOTA_REMISION: TStringField;
    qryFacturaNOTA_REMISION1: TStringField;
    qryFacturaNUMERO: TLongintField;
    qryFacturaNUMERO1: TLongintField;
    qryFacturaPERSONAID: TLongintField;
    qryFacturaPERSONAID1: TLongintField;
    qryFacturaRUC: TStringField;
    qryFacturaRUC1: TStringField;
    qryFacturaSUBTOTAL_EXENTAS: TFloatField;
    qryFacturaSUBTOTAL_EXENTAS1: TFloatField;
    qryFacturaSUBTOTAL_IVA10: TFloatField;
    qryFacturaSUBTOTAL_IVA11: TFloatField;
    qryFacturaSUBTOTAL_IVA5: TFloatField;
    qryFacturaSUBTOTAL_IVA6: TFloatField;
    qryFacturaTALONARIOID: TLongintField;
    qryFacturaTALONARIOID1: TLongintField;
    qryFacturaTELEFONO: TStringField;
    qryFacturaTELEFONO1: TStringField;
    qryFacturaTOTAL: TFloatField;
    qryFacturaTOTAL1: TFloatField;
    qryFacturaVALIDO1: TSmallintField;
    qryFacturaVENCIMIENTO1: TDateField;
    qryNumero: TSQLQuery;
    qryNumero1: TSQLQuery;
    qryNumeroNUM: TLongintField;
    qryNumeroNUM1: TLongintField;
    tal: TSQLQuery;
    tal1: TSQLQuery;
    talACTIVO: TSmallintField;
    talACTIVO1: TSmallintField;
    talCAJA: TStringField;
    talCAJA1: TStringField;
    talCOPIAS: TLongintField;
    talCOPIAS1: TLongintField;
    talDIRECCION: TStringField;
    talDIRECCION1: TStringField;
    talID: TLongintField;
    talID1: TLongintField;
    talNOMBRE: TStringField;
    talNOMBRE1: TStringField;
    talNUMERO_FIN: TLongintField;
    talNUMERO_FIN1: TLongintField;
    talNUMERO_INI: TLongintField;
    talNUMERO_INI1: TLongintField;
    talRUBRO: TStringField;
    talRUBRO1: TStringField;
    talRUC: TStringField;
    talRUC1: TStringField;
    talSUCURSAL: TStringField;
    talSUCURSAL1: TStringField;
    talTELEFONO: TStringField;
    talTELEFONO1: TStringField;
    talTIMBRADO: TStringField;
    talTIMBRADO1: TStringField;
    talTIPO: TLongintField;
    talTIPO1: TLongintField;
    talVALIDO_DESDE: TDateField;
    talVALIDO_DESDE1: TDateField;
    talVALIDO_HASTA: TDateField;
    talVALIDO_HASTA1: TDateField;
    procedure qryDetalleBeforePost(DataSet: TDataSet);
    procedure qryDetallePRECIO_UNITARIOChange(Sender: TField);
  private
    { private declarations }
     FEstado: TEstadoNotaCredito;
    FIVA10Cod: TCodigos;
    FIVA5Cod: TCodigos;
    FPersonas: TPersonasDataModule;
    procedure SetIVA10Cod(AValue: TCodigos);
    procedure SetIVA5Cod(AValue: TCodigos);
    procedure SetPersonas(AValue: TPersonasDataModule);
  public
    { public declarations }
  published
        procedure ActualizarTotales;
    procedure Connect; override;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DataModuleDestroy(Sender: TObject);
    procedure Disconnect; override;
    procedure FetchCabecera;
    procedure FetchCabecera(APersonaID: string);
    procedure FetchDeuda;
    procedure FetchDeuda(APersonaID: string);
    function GetDeudaMontoFacturado: double;
    function GetMontoFactura: double;
    procedure NuevaFactura;
    procedure NuevaFacturaDetalle;
    procedure OnFacturaError(Sender: TObject; E: EDatabaseError);
    procedure PropsRestoreProperties(Sender: TObject);
    procedure PropsRestoringProperties(Sender: TObject);
    procedure PropsSaveProperties(Sender: TObject);
    procedure PropsSavingProperties(Sender: TObject);
    procedure qryDetalleAfterInsert(DataSet: TDataSet);
    procedure qryFacturaAfterScroll(DataSet: TDataSet);
    procedure qryFacturaNewRecord(DataSet: TDataSet);
    procedure SaveChanges; override;
    procedure SetFactura(AID: string);
    property Estado: TEstadoNotaCredito read FEstado write FEstado;
    property IVA5Cod: TCodigos read FIVA5Cod write SetIVA5Cod;
    property IVA10Cod: TCodigos read FIVA10Cod write SetIVA10Cod;
    property Personas: TPersonasDataModule read FPersonas write SetPersonas;

  end;

var
  NotaCreditoDataModule: TNotaCreditoDataModule;
  // xD
  impIVA10: TIVA10 = [IVA10INC, IVA10];
  impIVA5: TIVA5 = [IVA5INC, IVA5];
  i5fac, i10fac: double;

implementation

{$R *.lfm}

{ TNotaCreditoDataModule }

procedure TNotaCreditoDataModule.qryDetalleBeforePost(DataSet: TDataSet);
begin
  if DataSet.FieldByName('PRECIO_UNITARIO').ISNULL then
    Abort;
end;

procedure TNotaCreditoDataModule.qryDetallePRECIO_UNITARIOChange(Sender: TField
  );
begin
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
end;

procedure TNotaCreditoDataModule.SetIVA10Cod(AValue: TCodigos);
begin
  if FIVA10Cod = AValue then
    Exit;
  FIVA10Cod := AValue;
end;

procedure TNotaCreditoDataModule.SetIVA5Cod(AValue: TCodigos);
begin
   if FIVA5Cod = AValue then
    Exit;
  FIVA5Cod := AValue;
end;

procedure TNotaCreditoDataModule.SetPersonas(AValue: TPersonasDataModule);
begin
  if FPersonas = AValue then
    Exit;
  FPersonas := AValue;
end;

procedure TNotaCreditoDataModule.ActualizarTotales;
begin
  if not (qryFactura.State in [dsEdit, dsInsert]) then
    qryFactura.Edit;
  qryFacturaIVA5.AsFloat := 0;
  qryFacturaIVA10.AsFloat := 0;
  qryFacturaIVA_TOTAL.AsFloat := 0;
  qryFacturaSUBTOTAL_EXENTAS.AsFloat := 0;
  qryFacturaSUBTOTAL_IVA5.AsFloat := 0;
  qryFacturaSUBTOTAL_IVA10.AsFloat := 0;
  qryFacturaTOTAL.AsFloat := 0;
  qryDetalle.First;
  while not qryDetalle.EOF do
  begin
    // subtotales
    qryFacturaSUBTOTAL_EXENTAS.AsFloat :=
      qryFacturaSUBTOTAL_EXENTAS.AsFloat + qryDetalleEXENTA.AsFloat;
    qryFacturaSUBTOTAL_IVA5.AsFloat :=
      qryFacturaSUBTOTAL_IVA5.AsFloat + qryDetalleIVA5.AsFloat;
    qryFacturaSUBTOTAL_IVA10.AsFloat :=
      qryFacturaSUBTOTAL_IVA10.AsFloat + qryDetalleIVA10.AsFloat;
    // totales iva
    qryFacturaIVA5.AsFloat := qryFacturaIVA5.AsFloat +
      qryFacturaSUBTOTAL_IVA5.AsFloat * I5Fac;
    qryFacturaIVA10.AsFloat :=
      qryFacturaIVA10.AsFloat + qryFacturaSUBTOTAL_IVA10.AsFloat * I10Fac;
    qryDetalle.Next;
  end;
  // sumatoria de iva5 e iva10
  qryFacturaIVA_TOTAL.AsFloat :=
    qryFacturaIVA_TOTAL.AsFloat + qryFacturaIVA10.AsFloat + qryFacturaIVA5.AsFloat;
  // gran total
  qryFacturaTOTAL.AsFloat :=
    qryFacturaTOTAL.AsFloat + qryFacturaSUBTOTAL_EXENTAS.AsFloat +
    qryFacturaSUBTOTAL_IVA5.AsFloat + qryFacturaSUBTOTAL_IVA10.AsFloat;
end;

procedure TNotaCreditoDataModule.Connect;
begin
     FPersonas.Connect;
     inherited Connect;
end;

procedure TNotaCreditoDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited DataModuleCreate(Sender);
  OnError := @OnFacturaError;
  QryList.Add(TObject(qryFactura));
  DetailList.Add(TObject(qryDetalle));
  AuxQryList.Add(TObject(tal));
  AuxQryList.Add(TObject(ImpuestoView));
  AuxQryList.Add(TObject(DeudaView));
  AuxQryList.Add(TObject(Impuesto));
  FPersonas := TPersonasDataModule.Create(Self, MasterDataModule);
  FPersonas.SetReadOnly(True);
  FIVA10Cod := TCodigos.Create;
  FIVA10Cod.Delimiter := DELIMITER_IVA;
  FIVA10Cod.StrictDelimiter := True;
  FIVA5Cod := TCodigos.Create;
  FIVA5Cod.Delimiter := DELIMITER_IVA;
  FIVA5Cod.StrictDelimiter := True;
  // esta parta hay que modificar despues
  // asi podemos poner dinamicamente que aranceles corresponden a los campos
  // IVA5 e IVA10 de la factura
  Props.Restore;
  //FIVA10Cod.Add(IVA10);
  //FIVA10Cod.Add(IVA10INC);
  //FIVA5Cod.Add(IVA5);
  //FIVA5Cod.Add(IVA5INC);
end;

procedure TNotaCreditoDataModule.DataModuleDestroy(Sender: TObject);
begin
  Props.Save;
  FIVA5Cod.Free;
  FIVA10Cod.Free;
  FPersonas.Free;
  inherited;
end;

procedure TNotaCreditoDataModule.Disconnect;
begin
    FPersonas.Connect;
  inherited Disconnect;
end;

procedure TNotaCreditoDataModule.FetchCabecera;
begin
  FetchCabecera(FPersonas.PersonasRoles.FieldByName('ID').AsString);
end;

procedure TNotaCreditoDataModule.FetchCabecera(APersonaID: string);
begin
  // si no se esta haciendo una factura
  if not (Estado in [asEditando]) then
    raise EDatabaseError.Create(rsNoSeEstaCreando);
  // traer nombre, ruc
  if not FPersonas.Persona.Locate('ID', APersonaID, [loCaseInsensitive]) then
    raise Exception.Create(rsPersonaNoEncontrada);
  qryFacturaNOMBRE.AsString := FPersonas.PersonaNOMBRECOMPLETO.AsString;
  qryFacturaRUC.AsString := FPersonas.PersonaRUC.AsString;
  // traer direccion, telefono
  qryFacturaDIRECCION.AsString := FPersonas.DireccionDIRECCION.AsString;
  qryFacturaTELEFONO.AsString :=
    FPersonas.TelefonoPREFIJO.AsString + fpersonas.TelefonoNUMERO.AsString;

end;

procedure TNotaCreditoDataModule.FetchDeuda;
begin
  FetchDeuda(FPersonas.PersonasRoles.FieldByName('ID').AsString);
end;

procedure TNotaCreditoDataModule.FetchDeuda(APersonaID: string);
begin
  // si no se esta haciendo una factura
  if not (Estado in [asEditando]) then
    raise EDatabaseError.Create(rsNoSeEstaCreando);
  DeudaView.Close;
  DeudaView.ParamByName('personaid').AsString := APersonaID;
  DeudaView.Open;
  if DeudaView.IsEmpty then
    raise EDatabaseError.Create(rsNoHayDeudas);
  // recorremos y cargamos la deuda
  DeudaView.First;
  while not DeudaView.EOF do
  begin
    ImpuestoView.Close;
    ImpuestoView.ParamByName('arancelid').AsString := DeudaViewARANCELID.AsString;
    ImpuestoView.Open;
    ImpuestoView.First;
    // por ahora se maneja que tiene un solo impuesto pero en el futuro
    // puede tener mas por eso se hace el loop
    while not ImpuestoView.EOF do
    begin
      NuevaFacturaDetalle;
      qryDetalleCANTIDAD.AsInteger := 1;
      qryDetalleDEUDAID.Value := DeudaViewID.Value;
      qryDetalleDETALLE.Value := DeudaViewDESCRIPCION.Value;
      if (ImpuestoViewINCLUIDO.AsInteger = 1) or (ImpuestoView.IsEmpty) then
        qryDetallePRECIO_UNITARIO.AsFloat := DeudaViewSALDO.AsFloat
      else if ImpuestoViewINCLUIDO.AsInteger = 0 then
        qryDetallePRECIO_UNITARIO.AsFloat :=
          DeudaViewSALDO.AsFloat + DeudaViewSALDO.AsFloat * ImpuestoViewFACTOR.AsFloat;
      // determinamos que impuesto tiene y lo ponemos en el campo apropiado
      if ImpuestoViewIMP_ID.AsInteger in impIVA10 then
        qryDetalleIVA10.AsFloat :=
          qryDetalleCANTIDAD.AsFloat * qryDetallePRECIO_UNITARIO.AsFloat
      else if ImpuestoViewIMP_ID.AsInteger in impIVA5 then
        qryDetalleIVA5.AsFloat :=
          qryDetalleCANTIDAD.AsFloat * qryDetallePRECIO_UNITARIO.AsFloat
      else
        qryDetalleEXENTA.AsFloat :=
          qryDetalleCANTIDAD.AsFloat * qryDetallePRECIO_UNITARIO.AsFloat;
      ImpuestoView.Next;
    end;
    DeudaView.Next;
  end;
  ActualizarTotales;
  (MasterDataModule as ISubject).Notify;
end;

function TNotaCreditoDataModule.GetDeudaMontoFacturado: double;
begin
  if not (Estado in [asLeyendo]) then
    raise  Exception.Create(rsNoSePuedeSetFac);
  Result := qryDetallePRECIO_UNITARIO.AsFloat * qryDetalleCANTIDAD.AsFloat;

end;

function TNotaCreditoDataModule.GetMontoFactura: double;
begin
  if not (Estado in [asLeyendo]) then
    raise  Exception.Create(rsNoSePuedeSetFac);
  Result := qryFacturaTOTAL.AsFloat;

end;

procedure TNotaCreditoDataModule.NuevaFactura;
begin
  if (Estado in [asEditando]) then
    raise EDatabaseError.Create(rsYaSeEstaCreando);
  // antes que nada traemos los factores para iva10 e iva5
  if (Impuesto.Lookup('ID', IntToStr(IVA10), 'FACTOR') = null) or
    (Impuesto.Lookup('ID', IntToStr(IVA5), 'FACTOR') = null) then
    raise Exception.Create('Impuestos no encontrados')
  else
  begin
    I10Fac := Impuesto.Lookup('ID', IntToStr(IVA10), 'FACTOR');
    I5Fac := Impuesto.Lookup('ID', IntToStr(IVA5), 'FACTOR');
  end;
  NewRecord;
  Estado := asEditando;
  (MasterDataModule as ISubject).Notify;

end;

procedure TNotaCreditoDataModule.NuevaFacturaDetalle;
begin
  if (Estado in [asInicial, asGuardado]) then
    raise EDatabaseError.Create(rsNoSeEstaCreando);
  qryDetalle.Append;
  // TODO: cada uno de los campos del detalle (?)
  (MasterDataModule as ISubject).Notify;
end;

procedure TNotaCreditoDataModule.OnFacturaError(Sender: TObject;
  E: EDatabaseError);
begin
  DiscardChanges;
  Rollback;
  Estado := asInicial;
  (MasterDataModule as ISubject).Notify;
end;

procedure TNotaCreditoDataModule.PropsRestoreProperties(Sender: TObject);
begin
  FIVA10Cod.DelimitedText := Props.StoredValue['codigosiva10'];
  FIVA5Cod.DelimitedText := Props.StoredValue['codigosiva5'];
end;

procedure TNotaCreditoDataModule.PropsRestoringProperties(Sender: TObject);
begin
  FIVA10Cod.Clear;
  FIVA5Cod.Clear;
end;

procedure TNotaCreditoDataModule.PropsSaveProperties(Sender: TObject);
begin
  Props.StoredValue['codigosiva10'] := FIVA10Cod.DelimitedText;
  Props.StoredValue['codigosiva5'] := FIVA5Cod.DelimitedText;
end;

procedure TNotaCreditoDataModule.PropsSavingProperties(Sender: TObject);
begin
  FIVA10Cod.Clear;
  FIVA5Cod.Clear;
end;

procedure TNotaCreditoDataModule.qryDetalleAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger :=
    MasterDataModule.NextValue(rsGenFacturaDetalleID);
  DataSet.FieldByName('NOTACREDITOID').AsInteger := qryFacturaID.AsInteger;
  DataSet.FieldByName('IVA5').AsFloat := 0;
  DataSet.FieldByName('IVA10').AsFloat := 0;
  DataSet.FieldByName('EXENTA').AsFloat := 0;

end;

procedure TNotaCreditoDataModule.qryFacturaAfterScroll(DataSet: TDataSet);
begin
  qryDetalle.Close;
  qryDetalle.ParamByName('NOTACREDITOID').Value := qryFactura.FieldByName('ID').Value;
  qryDetalle.Open;
end;

procedure TNotaCreditoDataModule.qryFacturaNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenFacturaID);
  DataSet.FieldByName('FECHA_EMISION').AsDateTime := Now;
 // DataSet.FieldByName('VALIDO').AsInteger := 1;
  DataSet.FieldByName('IVA5').AsFloat := 0;
  DataSet.FieldByName('IVA10').AsFloat := 0;
  DataSet.FieldByName('IVA_TOTAL').AsFloat := 0;
  DataSet.FieldByName('SUBTOTAL_EXENTAS').AsFloat := 0;
  DataSet.FieldByName('SUBTOTAL_IVA5').AsFloat := 0;
  DataSet.FieldByName('SUBTOTAL_IVA10').AsFloat := 0;
  DataSet.FieldByName('TOTAL').AsFloat := 0;
  tal.Close;
  tal.ParamByName('TALONARIOID').AsString := TALONARIOID;
  tal.Open;
  if not tal.Locate('ID', TALONARIOID, [loCaseInsensitive]) then
    raise EDatabaseError.Create('Talonario no encontrado');
  DataSet.FieldByName('TALONARIOID').AsString := TALONARIOID;
end;

procedure TNotaCreditoDataModule.SaveChanges;
begin
  inherited SaveChanges;
    Estado := asInicial;
  (MasterDataModule as ISubject).Notify;

end;

procedure TNotaCreditoDataModule.SetFactura(AID: string);
begin
  if (Estado in [asEditando]) then
    raise Exception.Create(rsNoSePuedeSetFac)
  else if not qryFactura.Locate('ID', AID, [loCaseInsensitive]) then
    raise Exception.Create(rsNoSeEncontroDoc);
  Estado := asLeyendo;
end;

end.

