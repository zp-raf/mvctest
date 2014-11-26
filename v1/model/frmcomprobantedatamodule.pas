unit frmcomprobantedatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, sqldb, FileUtil, LR_DBSet, LR_Class, Forms, Controls,
  Graphics, Dialogs, XMLPropStorage, frmquerydatamodule, mensajes,
  frmpersonasdatamodule, sgcdTypes, observerSubject;

type

  { TComprobanteDataModule }

  TComprobanteDataModule = class(TQueryDataModule)
  private
    FCabeceraGenName: string;
    FDetalleGenName: string;
    FEstado: TEstadoComprobante;
    FPersonas: TPersonasDataModule;
    FTalonarioID: string;
    procedure SetCabeceraGenName(AValue: string);
    procedure SetDetalleGenName(AValue: string);
    procedure SetEstado(AValue: TEstadoComprobante);
    procedure SetPersonas(AValue: TPersonasDataModule);
    procedure SetTalonarioID(AValue: string);
  public
    procedure AfterConstruction; override;
  published
    AuxTalonarioACTIVO: TSmallintField;
    AuxTalonarioCAJA: TStringField;
    AuxTalonarioCOPIAS: TLongintField;
    AuxTalonarioDIRECCION: TStringField;
    AuxTalonarioID: TLongintField;
    AuxTalonarioNOMBRE: TStringField;
    AuxTalonarioNUMERO_FIN: TLongintField;
    AuxTalonarioNUMERO_INI: TLongintField;
    AuxTalonarioRUBRO: TStringField;
    AuxTalonarioRUC: TStringField;
    AuxTalonarioSUCURSAL: TStringField;
    AuxTalonarioTELEFONO: TStringField;
    AuxTalonarioTIMBRADO: TStringField;
    AuxTalonarioTIPO: TLongintField;
    AuxTalonarioVALIDO_DESDE: TDateField;
    AuxTalonarioVALIDO_HASTA: TDateField;
    dsPersonasRoles: TDataSource;
    DeudaView: TSQLQuery;
    dsDetalle: TDataSource;
    dsCabecera: TDataSource;
    dsNum: TDataSource;
    dstal: TDataSource;
    frDBReporteCab: TfrDBDataSet;
    frDBReporteDet: TfrDBDataSet;
    frReport1: TfrReport;
    ImpuestoViewAR_ACT: TSmallintField;
    ImpuestoViewAR_ID: TLongintField;
    ImpuestoViewAR_NOMBRE: TStringField;
    ImpuestoViewFACTOR: TFloatField;
    ImpuestoViewIMP_ACTIVO: TSmallintField;
    ImpuestoViewIMP_ID: TLongintField;
    ImpuestoViewIMP_NOMBRE: TStringField;
    ImpuestoViewINCLUIDO: TSmallintField;
    ImpuestoViewMONTO: TFloatField;
    qryDetalle: TSQLQuery;
    qryCabecera: TSQLQuery;
    qryNumero: TSQLQuery;
    qryNumeroNUM: TLongintField;
    AuxTalonario: TSQLQuery;
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
    Impuesto: TSQLQuery;
    ImpuestoACTIVO: TSmallintField;
    ImpuestoFACTOR: TFloatField;
    ImpuestoID: TLongintField;
    ImpuestoNOMBRE: TStringField;
    ImpuestoView: TSQLQuery;
    { Procedimiento para calcular los totales de cada comprobante. Cada
      comprobante debe implementar este procedimiento. }
    procedure ActualizarTotales; virtual; abstract;
    function ArePendingChanges: boolean; override;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DataModuleDestroy(Sender: TObject);
    { Procedimiento para calcular y cargar el monto en el comprobante de acuerdo
      a los impuestos que le corresponden. Debe ser implementado por cada
      comprobante ya que cada uno tiene una forma diferente de calculo}
    procedure DeterminarImpuesto; virtual; abstract;
    procedure DiscardChanges; override;
    { Procedimiento para traer informacion para la cabecera del comrpobante,
      en el caso de rellenar la informacion a partir de los datos de una persona.
      Este procedimiento no recibe parametros; actua como intermediario de
      FetchCabeceraPersona(APersonaID: string) pasandole el ID del registro del
      cursor actual del dataset de personas.}
    procedure FetchCabeceraPersona; virtual;
    { Procedimiento para traer informacion para la cabecera del comrpobante,
      en el caso de rellenar la informacion a partir de los datos de una persona.
      En caso de no encontrarse la persona levanta un excepcion EDatabaseError.}
    procedure FetchCabeceraPersona(APersonaID: string); virtual;
    { Procedimiento para llenar el detalle del comprobante con la deuda de la
      persona especidifacda.
      Este procedimiento no recibe parametros; actua como intermediario de
      FetchDetalle(APersonaID: string) pasandole el ID del registro del
      cursor actual del dataset de personas.}
    procedure FetchDetallePersona; virtual;
    { Procedimiento para llenar el detalle del comprobante con la deuda de la
      persona especidifacda.
      En caso de no encontrarse la persona levanta un excepcion EDatabaseError.}
    procedure FetchDetallePersona(APersonaID: string); virtual;
    { Este procedimiento debe traer los factores de impuesto de su lugar de
      almacenamiento. Cada comprobante debe implementarlo. }
    procedure GetImpuestos; virtual; abstract;
    { Busca y pone el cursor en el registro de la cabecera del comprobante
      especificado.
      Si no se encuentra el comprobante levanta una excepcion EDatabaseError. }
    procedure LocateComprobante(AID: string);
    procedure NuevoComprobante;
    procedure NuevoComprobanteCompra;
    procedure NuevoComprobanteDetalle;
    procedure OnComprobanteError(Sender: TObject; {%H-}E: EDatabaseError); virtual;
    procedure qryDetalleAfterInsert(DataSet: TDataSet); virtual;
    procedure qryDetalleBeforePost(DataSet: TDataSet);
    { Procedimiento para mover el dataset de detalle cuando se mueve el de
      cabecera. }
    procedure qryCabeceraAfterScroll(DataSet: TDataSet); virtual; abstract;
    procedure qryCabeceraNewRecord(DataSet: TDataSet); virtual;
    procedure Rollback; override;
    procedure SaveChanges; override;
    procedure SetNumero; virtual; abstract;
    procedure SetTipoComprobante(ATipoComprobante: TTipoDocumento);
    function GetMontoComprobante: double;
    property Estado: TEstadoComprobante read FEstado write SetEstado;
    property Personas: TPersonasDataModule read FPersonas write SetPersonas;
    property CabeceraGenName: string read FCabeceraGenName write SetCabeceraGenName;
    property DetalleGenName: string read FDetalleGenName write SetDetalleGenName;
    property TalonarioID: string read FTalonarioID write SetTalonarioID;
  end;

var
  ComprobanteDataModule: TComprobanteDataModule;

implementation

{$R *.lfm}

{ TComprobanteDataModule }

procedure TComprobanteDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  FPersonas := TPersonasDataModule.Create(Self, MasterDataModule);
  //FPersonas.SetReadOnly(True);
  dsPersonasRoles.DataSet := FPersonas.PersonasRoles;
  OnError := @OnComprobanteError;
  QryList.Add(TObject(qryCabecera));
  DetailList.Add(TObject(qryDetalle));
  AuxQryList.Add(TObject(AuxTalonario));
  AuxQryList.Add(TObject(tal));
  AuxQryList.Add(TObject(ImpuestoView));
  AuxQryList.Add(TObject(DeudaView));
  AuxQryList.Add(TObject(Impuesto));
  AuxQryList.Add(TObject(FPersonas.PersonasRoles));
  AuxQryList.Add(TObject(FPersonas.Persona));
  AuxQryList.Add(TObject(FPersonas.Direccion));
  AuxQryList.Add(TObject(FPersonas.Telefono));
  // ponemos en el menu de talonarios los talonarios

end;

procedure TComprobanteDataModule.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FPersonas) then
    FreeAndNil(FPersonas);
end;

procedure TComprobanteDataModule.qryDetalleAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger :=
    MasterDataModule.NextValue(DetalleGenName);
end;

procedure TComprobanteDataModule.qryCabeceraNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(CabeceraGenName);
  DataSet.FieldByName('FECHA_EMISION').AsDateTime := Now;
  DataSet.FieldByName('VALIDO').AsInteger := 1;
  DataSet.FieldByName('TOTAL').AsFloat := 0;
end;

procedure TComprobanteDataModule.Rollback;
begin
  Estado := asInicial;
  inherited Rollback;
end;

procedure TComprobanteDataModule.SaveChanges;
begin
  inherited SaveChanges;
  Estado := asGuardado;
  (MasterDataModule as ISubject).Notify;
end;

procedure TComprobanteDataModule.LocateComprobante(AID: string);
begin
  OpenDataSets;
  try
    if (Estado in [asEditando]) then
      raise Exception.Create(rsNoSePuedeSetFac)
    else if not qryCabecera.Locate('ID', AID, [loCaseInsensitive]) then
      raise Exception.Create(rsNoSeEncontroDoc);
    Estado := asLeyendo;
  except
    on E: EDatabaseError do
    begin
      DoOnErrorEvent(Self, E);
      raise;
    end;
  end;
end;

procedure TComprobanteDataModule.DiscardChanges;
begin
  inherited DiscardChanges;
  Estado := asInicial;
  (MasterDataModule as ISubject).Notify;
end;

procedure TComprobanteDataModule.qryDetalleBeforePost(DataSet: TDataSet);
begin
  if DataSet.FieldByName('PRECIO_UNITARIO').ISNULL then
    Abort;
end;

procedure TComprobanteDataModule.FetchCabeceraPersona;
begin
  FetchCabeceraPersona(FPersonas.PersonasRoles.FieldByName('ID').AsString);
end;

procedure TComprobanteDataModule.FetchCabeceraPersona(APersonaID: string);
begin
  try
    // si no se esta haciendo una factura
    if not (Estado in [asEditando]) then
      raise EDatabaseError.Create(rsNoSeEstaCreando);
    // traer nombre, ruc
    if not FPersonas.Persona.Locate('ID', APersonaID, [loCaseInsensitive]) then
      raise Exception.Create(rsPersonaNoEncontrada);

    qryCabecera.FieldByName('PERSONAID').AsString :=
      FPersonas.PersonasRoles.FieldByName('ID').AsString;
    qryCabecera.FieldByName('NOMBRE').AsString :=
      FPersonas.PersonaNOMBRECOMPLETO.AsString;
    // traer direccion, telefono
    qryCabecera.FieldByName('DIRECCION').AsString :=
      FPersonas.DireccionDIRECCION.AsString;
    qryCabecera.FieldByName('TELEFONO').AsString :=
      FPersonas.TelefonoPREFIJO.AsString + fpersonas.TelefonoNUMERO.AsString;
  except
    on E: EDatabaseError do
    begin
      DoOnErrorEvent(Self, E);
      raise;
    end;
  end;
end;

procedure TComprobanteDataModule.FetchDetallePersona;
begin
  FetchDetallePersona(FPersonas.PersonasRoles.FieldByName('ID').AsString);
end;

procedure TComprobanteDataModule.FetchDetallePersona(APersonaID: string);
begin
  // si no se esta haciendo una factura
  try
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

      NuevoComprobanteDetalle;
      qryDetalle.FieldByName('CANTIDAD').AsInteger := 1;
      qryDetalle.FieldByName('DEUDAID').Value := DeudaViewID.Value;
      qryDetalle.FieldByName('DETALLE').Value := DeudaViewDESCRIPCION.Value;
      // por ahora se maneja que tiene un solo impuesto pero en el futuro
      // puede tener mas por eso se hace el loop
      while not ImpuestoView.EOF do
      begin
        // revisamos si es un impuesto incluido y segun eso ponemos el precio unitario
        if (ImpuestoViewINCLUIDO.AsInteger = 1) or (ImpuestoView.IsEmpty) then
          qryDetalle.FieldByName('PRECIO_UNITARIO').AsFloat :=
            (DeudaViewMONTO_DEUDA.AsFloat - DeudaViewMONTO_FACTURADO.AsFloat)
        else if ImpuestoViewINCLUIDO.AsInteger = 0 then
          qryDetalle.FieldByName('PRECIO_UNITARIO').AsFloat :=
            (DeudaViewMONTO_DEUDA.AsFloat - DeudaViewMONTO_FACTURADO.AsFloat) +
            (DeudaViewMONTO_DEUDA.AsFloat - DeudaViewMONTO_FACTURADO.AsFloat) *
            ImpuestoViewFACTOR.AsFloat;
        // vemos que factor de impuesto tiene para poner en el campo apropiado del comprobante
        DeterminarImpuesto;
        Break; // ???: sacar esto en el futuro cuando se resuelva el tema de impuestos
        ImpuestoView.Next;
      end;
      DeudaView.Next;
    end;
    ActualizarTotales;
    (MasterDataModule as ISubject).Notify;
  except
    on E: EDatabaseError do
    begin
      DoOnErrorEvent(Self, E);
      raise;
    end;
  end;
end;

procedure TComprobanteDataModule.SetTipoComprobante(ATipoComprobante: TTipoDocumento);
var
  x: string;
begin
  case ATipoComprobante of
    doFactura: x := FACTURA;
    doRecibo: x := RECIBO;
    doNotaCredito: x := NOTA_CREDITO;
  end;
  tal.Close;
  tal.ParamByName('tipocomprobante').AsString := x;
  tal.Open;
end;

function TComprobanteDataModule.GetMontoComprobante: double;
begin
  try
    if not (Estado in [asLeyendo]) then
      raise  Exception.Create(rsNoSePuedeSetFac);
    Result := qryCabecera.FieldByName('TOTAL').AsFloat;
  except
    on E: EDatabaseError do
    begin
      DoOnErrorEvent(Self, E);
      raise;
    end;
  end;
end;

procedure TComprobanteDataModule.NuevoComprobante;
begin
  try
    if (Estado in [asEditando]) then
      raise EDatabaseError.Create(rsYaSeEstaCreando);
    // antes que nada traemos los factores para iva10 e iva5
    GetImpuestos;
    NewRecord;
    // ponemos el numero de comprobante y talonario
    tal.Close;
    tal.ParamByName('TALONARIOID').AsString := TalonarioID;
    tal.Open;
    if not tal.Locate('ID', TalonarioID, [loCaseInsensitive]) then
      raise EDatabaseError.Create(rsTalonarioNoEncontrado);
    qryCabecera.FieldByName('TALONARIOID').AsString := TalonarioID;
    SetNumero;
    Estado := asEditando;
    (MasterDataModule as ISubject).Notify;
  except
    on E: EDatabaseError do
    begin
      DoOnErrorEvent(Self, E);
      raise;
    end;
  end;
end;

procedure TComprobanteDataModule.NuevoComprobanteCompra;
begin
  try
    if (Estado in [asEditando]) then
      raise EDatabaseError.Create(rsYaSeEstaCreando);
    // antes que nada traemos los factores para iva10 e iva5
    GetImpuestos;
    NewRecord;
    //// ponemos el numero de comprobante y talonario
    //tal.Close;
    //tal.ParamByName('TALONARIOID').AsString := TalonarioID;
    //tal.Open;
    //if not tal.Locate('ID', TalonarioID, [loCaseInsensitive]) then
    //  raise EDatabaseError.Create(rsTalonarioNoEncontrado);
    //qryCabecera.FieldByName('TALONARIOID').AsString := TalonarioID;
    //SetNumero;
    Estado := asEditando;
    (MasterDataModule as ISubject).Notify;
  except
    on E: EDatabaseError do
    begin
      DoOnErrorEvent(Self, E);
      raise;
    end;
  end;
end;

procedure TComprobanteDataModule.NuevoComprobanteDetalle;
begin
  try
    if (Estado in [asInicial, asGuardado]) then
      raise EDatabaseError.Create(rsNoSeEstaCreando);

    qryDetalle.Append;
    (MasterDataModule as ISubject).Notify;
  except
    on E: EDatabaseError do
    begin
      DoOnErrorEvent(Self, E);
      raise;
    end;
  end;
end;

procedure TComprobanteDataModule.OnComprobanteError(Sender: TObject; E: EDatabaseError);
begin
  DiscardChanges;
  Rollback;
  Estado := asInicial;
  (MasterDataModule as ISubject).Notify;
end;

procedure TComprobanteDataModule.SetEstado(AValue: TEstadoComprobante);
begin
  if FEstado = AValue then
    Exit;
  FEstado := AValue;
end;

procedure TComprobanteDataModule.AfterConstruction;
begin
  inherited AfterConstruction;
  if tal.ParamByName('TIPOCOMPROBANTE').IsNull {or not
    (tal.ParamByName('TIPOCOMPROBANTE').AsInteger in TipoDoc)} then
    raise Exception.Create(rsDocTypeNotSelected);
  if (Trim(CabeceraGenName) = '') or (Trim(DetalleGenName) = '') then
    raise Exception.Create(rsGenNotDefined);
end;

procedure TComprobanteDataModule.SetCabeceraGenName(AValue: string);
begin
  if FCabeceraGenName = AValue then
    Exit;
  FCabeceraGenName := AValue;
end;

procedure TComprobanteDataModule.SetDetalleGenName(AValue: string);
begin
  if FDetalleGenName = AValue then
    Exit;
  FDetalleGenName := AValue;
end;

procedure TComprobanteDataModule.SetPersonas(AValue: TPersonasDataModule);
begin
  if FPersonas = AValue then
    Exit;
  FPersonas := AValue;
end;

procedure TComprobanteDataModule.SetTalonarioID(AValue: string);
begin
  if FTalonarioID = AValue then
    Exit;
  FTalonarioID := AValue;
end;

function TComprobanteDataModule.ArePendingChanges: boolean;
begin
  if (Estado in [asInicial, asGuardado]) then
    Result := False
  else
    Result := True;
end;

end.
