unit frmfacturadatamodule2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, sqldb, FileUtil, LR_DBSet, LR_Class,
  Forms, Controls, observerSubject, Graphics, Dialogs, XMLPropStorage,
  frmquerydatamodule, frmsgcddatamodule, frmpersonasdatamodule;

resourcestring
  rsGenFacturaID = 'SEQ_FACTURA';
  rsGenFacturaDetalleID = 'SEQ_FACTURA_DETALLE';
  rsNoHayDeudas = 'No hay deudas para la persona seleccionada';
  rsNoSeEstaCreando = 'No se esta creando una factura';
  rsYaSeEstaCreando = 'Ya se esta creando una factura';
  rsPersonaNoEncontrada = 'Persona no encontrada';
  rsNoSeEncontroDoc = 'No se encontro el documento';
  rsNoSePuedeSetFac = 'No se puede completar la accion. Se esta editando una ' +
    'factura';

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

  TEstadoFactura = (asInicial, asEditando, asGuardado, asLeyendo);

  { TFacturasDataModule }

  TFacturasDataModule = class(TQueryDataModule)
    ImpuestoACTIVO: TSmallintField;
    ImpuestoFACTOR: TFloatField;
    ImpuestoID: TLongintField;
    ImpuestoINCLUIDO: TSmallintField;
    ImpuestoNOMBRE: TStringField;
    ImpuestoViewINCLUIDO: TSmallintField;
    ModelProps: TApplicationProperties;
    Impuesto: TSQLQuery;
    DeudaView: TSQLQuery;
    DeudaViewACTIVO: TSmallintField;
    DeudaViewARANCELID: TLongintField;
    DeudaViewCANTIDAD_CUOTAS: TLongintField;
    DeudaViewCUENTAID: TLongintField;
    DeudaViewCUOTA_NRO: TLongintField;
    DeudaViewDESCRIPCION: TStringField;
    DeudaViewID: TLongintField;
    DeudaViewMATRICULAID: TLongintField;
    DeudaViewPERSONAID: TLongintField;
    DeudaViewSALDO: TFloatField;
    DeudaViewVENCIMIENTO: TDateField;
    dsDetalle: TDatasource;
    dsFactura: TDatasource;
    dsNum: TDatasource;
    dstal: TDatasource;
    frDBReporteCab: TfrDBDataSet;
    frDBReporteDet: TfrDBDataSet;
    frReport1: TfrReport;
    ImpuestoViewAR_ACT: TSmallintField;
    ImpuestoViewAR_ID: TLongintField;
    ImpuestoViewAR_NOMBRE: TStringField;
    ImpuestoViewEXENTAS: TSmallintField;
    ImpuestoViewFACTOR: TFloatField;
    ImpuestoViewGRUPO_PROD: TStringField;
    ImpuestoViewIMP_ACTIVO: TSmallintField;
    ImpuestoViewIMP_ID: TLongintField;
    ImpuestoViewIMP_NOMBRE: TStringField;
    ImpuestoViewMONTO: TFloatField;
    ImpuestoViewSERVICIOS: TSmallintField;
    qryDetalle: TSQLQuery;
    qryDetalleCANTIDAD: TLongintField;
    qryDetalleDETALLE: TStringField;
    qryDetalleDEUDAID: TLongintField;
    qryDetalleEXENTA: TFloatField;
    qryDetalleFACTURAID: TLongintField;
    qryDetalleID: TLongintField;
    qryDetalleIVA10: TFloatField;
    qryDetalleIVA5: TFloatField;
    qryDetallePRECIO_UNITARIO: TFloatField;
    qryFactura: TSQLQuery;
    qryFacturaCONTADO: TSmallintField;
    qryFacturaDIRECCION: TStringField;
    qryFacturaFECHA_EMISION: TDateField;
    qryFacturaID: TLongintField;
    qryFacturaIVA10: TFloatField;
    qryFacturaIVA5: TFloatField;
    qryFacturaIVA_TOTAL: TFloatField;
    qryFacturaNOMBRE: TStringField;
    qryFacturaNOTA_REMISION: TStringField;
    qryFacturaNUMERO: TLongintField;
    qryFacturaPERSONAID: TLongintField;
    qryFacturaRUC: TStringField;
    qryFacturaSUBTOTAL_EXENTAS: TFloatField;
    qryFacturaSUBTOTAL_IVA10: TFloatField;
    qryFacturaSUBTOTAL_IVA5: TFloatField;
    qryFacturaTALONARIOID: TLongintField;
    qryFacturaTELEFONO: TStringField;
    qryFacturaTOTAL: TFloatField;
    qryFacturaVALIDO: TSmallintField;
    qryFacturaVENCIMIENTO: TDateField;
    qryNumero: TSQLQuery;
    qryNumeroNUM: TLongintField;
    qryPersonaCEDULA: TStringField;
    qryPersonaID: TLongintField;
    qryPersonaNOMBRECOMPLETO: TStringField;
    ImpuestoView: TSQLQuery;
    tal: TSQLQuery;
    talACTIVO: TSmallintField;
    talCAJA: TStringField;
    talCOPIAS: TLongintField;
    talDIRECCION: TStringField;
    talID: TLongintField;
    talNOMBRE: TStringField;
    talNUMERO_FIN: TLongintField;
    talNUMERO_INI: TLongintField;
    talRUBRO: TStringField;
    talRUC: TStringField;
    talSUCURSAL: TStringField;
    talTELEFONO: TStringField;
    talTIMBRADO: TStringField;
    talTIPO: TLongintField;
    talVALIDO_DESDE: TDateField;
    talVALIDO_HASTA: TDateField;
    Props: TXMLPropStorage;
  private
    FEstado: TEstadoFactura;
    FIVA10Cod: TCodigos;
    FIVA5Cod: TCodigos;
    FPersonas: TPersonasDataModule;
    procedure SetIVA10Cod(AValue: TCodigos);
    procedure SetIVA5Cod(AValue: TCodigos);
    procedure SetPersonas(AValue: TPersonasDataModule);
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
    procedure ModelPropsException(Sender: TObject; E: Exception);
    procedure NuevaFactura;
    procedure NuevaFacturaDetalle;
    procedure OnFacturaError;
    procedure PropsRestoreProperties(Sender: TObject);
    procedure PropsRestoringProperties(Sender: TObject);
    procedure PropsSaveProperties(Sender: TObject);
    procedure PropsSavingProperties(Sender: TObject);
    procedure qryDetalleAfterInsert(DataSet: TDataSet);
    procedure qryFacturaAfterScroll(DataSet: TDataSet);
    procedure qryFacturaNewRecord(DataSet: TDataSet);
    procedure SetFactura(AID: string);
    property Estado: TEstadoFactura read FEstado write FEstado;
    property IVA5Cod: TCodigos read FIVA5Cod write SetIVA5Cod;
    property IVA10Cod: TCodigos read FIVA10Cod write SetIVA10Cod;
    property Personas: TPersonasDataModule read FPersonas write SetPersonas;
  end;

var
  FacturasDataModule: TFacturasDataModule;
  impIVA10: TIVA10 = [IVA10INC, IVA10];
  impIVA5: TIVA5 = [IVA5INC, IVA5];
  i5fac, i10fac: double;

implementation

{$R *.lfm}

{ TFacturasDataModule }

procedure TFacturasDataModule.SetPersonas(AValue: TPersonasDataModule);
begin
  if FPersonas = AValue then
    Exit;
  FPersonas := AValue;
end;

procedure TFacturasDataModule.ActualizarTotales;
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
    // sumatoria de iva5 e iva10
    qryFacturaIVA_TOTAL.AsFloat :=
      qryFacturaIVA_TOTAL.AsFloat + qryFacturaIVA10.AsFloat + qryFacturaIVA5.AsFloat;
    // gran total
    qryFacturaTOTAL.AsFloat :=
      qryFacturaTOTAL.AsFloat + qryFacturaSUBTOTAL_EXENTAS.AsFloat +
      qryFacturaSUBTOTAL_IVA5.AsFloat + qryFacturaSUBTOTAL_IVA10.AsFloat;
    qryDetalle.Next;
  end;
end;

procedure TFacturasDataModule.PropsRestoringProperties(Sender: TObject);
begin
  FIVA10Cod.Clear;
  FIVA5Cod.Clear;
end;

procedure TFacturasDataModule.PropsSaveProperties(Sender: TObject);
begin
  Props.StoredValue['codigosiva10'] := FIVA10Cod.DelimitedText;
  Props.StoredValue['codigosiva5'] := FIVA5Cod.DelimitedText;
end;

procedure TFacturasDataModule.PropsSavingProperties(Sender: TObject);
begin
  FIVA10Cod.Clear;
  FIVA5Cod.Clear;
end;

procedure TFacturasDataModule.qryDetalleAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger :=
    MasterDataModule.NextValue(rsGenFacturaDetalleID);
  DataSet.FieldByName('FACTURAID').AsInteger := qryFacturaID.AsInteger;
  DataSet.FieldByName('IVA5').AsFloat := 0;
  DataSet.FieldByName('IVA10').AsFloat := 0;
  DataSet.FieldByName('EXENTA').AsFloat := 0;
end;

procedure TFacturasDataModule.qryFacturaNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenFacturaID);
  DataSet.FieldByName('FECHA_EMISION').AsDateTime := Now;
  DataSet.FieldByName('VALIDO').AsInteger := 1;
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

procedure TFacturasDataModule.SetFactura(AID: string);
begin
  if (Estado in [asEditando]) then
    raise Exception.Create(rsNoSePuedeSetFac)
  else if not qryFactura.Locate('ID', AID, [loCaseInsensitive]) then
    raise Exception.Create(rsNoSeEncontroDoc);
  Estado := asLeyendo;
end;

procedure TFacturasDataModule.PropsRestoreProperties(Sender: TObject);
begin
  FIVA10Cod.DelimitedText := Props.StoredValue['codigosiva10'];
  FIVA5Cod.DelimitedText := Props.StoredValue['codigosiva5'];
end;

procedure TFacturasDataModule.DataModuleDestroy(Sender: TObject);
begin
  Props.Save;
  FIVA5Cod.Free;
  FIVA10Cod.Free;
  FPersonas.Free;
  inherited;
end;

procedure TFacturasDataModule.ModelPropsException(Sender: TObject; E: Exception);
begin
  OnFacturaError;
end;

procedure TFacturasDataModule.qryFacturaAfterScroll(DataSet: TDataSet);
begin
  qryDetalle.Close;
  qryDetalle.ParamByName('FACTURAID').Value := qryFactura.FieldByName('ID').Value;
  qryDetalle.Open;
end;

procedure TFacturasDataModule.SetIVA10Cod(AValue: TCodigos);
begin
  if FIVA10Cod = AValue then
    Exit;
  FIVA10Cod := AValue;
end;

procedure TFacturasDataModule.SetIVA5Cod(AValue: TCodigos);
begin
  if FIVA5Cod = AValue then
    Exit;
  FIVA5Cod := AValue;
end;

procedure TFacturasDataModule.Connect;
begin
  FPersonas.Connect;
  inherited Connect;
end;

procedure TFacturasDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited DataModuleCreate(Sender);
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

procedure TFacturasDataModule.Disconnect;
begin
  FPersonas.Connect;
  inherited Disconnect;
end;

procedure TFacturasDataModule.FetchCabecera;
begin
  FetchCabecera(FPersonas.PersonasRoles.FieldByName('ID').AsString);
end;

procedure TFacturasDataModule.FetchCabecera(APersonaID: string);
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

procedure TFacturasDataModule.FetchDeuda;
begin
  FetchDeuda(FPersonas.PersonasRoles.FieldByName('ID').AsString);
end;

procedure TFacturasDataModule.FetchDeuda(APersonaID: string);
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

function TFacturasDataModule.GetDeudaMontoFacturado: double;
begin
  if not (Estado in [asLeyendo]) then
    raise  Exception.Create(rsNoSePuedeSetFac);
  Result := qryDetallePRECIO_UNITARIO.AsFloat * qryDetalleCANTIDAD.AsFloat;
end;

procedure TFacturasDataModule.NuevaFactura;
begin
  Connect;
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

procedure TFacturasDataModule.NuevaFacturaDetalle;
begin
  if (Estado in [asInicial, asGuardado]) then
    raise EDatabaseError.Create(rsNoSeEstaCreando);
  qryDetalle.Append;
  // TODO: cada uno de los campos del detalle (?)
  (MasterDataModule as ISubject).Notify;
end;

procedure TFacturasDataModule.OnFacturaError;
begin
  DiscardChanges;
  Rollback;
  Estado := asInicial;
end;

end.
