unit frmcomprobantedatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, sqldb, FileUtil, LR_DBSet, LR_Class, Forms, Controls,
  Graphics, Dialogs, XMLPropStorage, IniPropStorage, frmquerydatamodule,
  mensajes, frmpersonasdatamodule, sgcdTypes, observerSubject, IniFiles,
  frmtalonariodatamodule, frmasientosdatamodule;

type

  { TComprobanteDataModule }

  TComprobanteDataModule = class(TQueryDataModule)
  private
    FAsientos: TAsientosDataModule;
    FCabeceraGenName: string;
    FCompra: boolean;
    FDetalleGenName: string;
    FEstado: TEstadoComprobante;
    FPersonas: TPersonasDataModule;
    FReportFile: string;
    FReportFileCompra: string;
    FTalonarios: TTalonarioDataModule;
    procedure RestoreProperties;
    procedure SetAsientos(AValue: TAsientosDataModule);
    procedure SetCabeceraGenName(AValue: string);
    procedure SetCompra(AValue: boolean);
    procedure SetDetalleGenName(AValue: string);
    procedure SetEstado(AValue: TEstadoComprobante);
    procedure SetPersonas(AValue: TPersonasDataModule);
    procedure SetTalonarioID(AValue: string);
    procedure SetTalonarios(AValue: TTalonarioDataModule);
  protected
    FTalonarioID: string;
    FDatosCurso: TDatosCurso;
    FCuentaCompras: string;
    FINIFile: TIniFile;
    //ComprobanteID: Integer;
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
    Propierties: TXMLPropStorage;
    { Procedimiento para calcular los totales de cada comprobante. Cada
      comprobante debe implementar este procedimiento. }
    procedure ActualizarTotales; virtual; abstract;
    function ArePendingChanges: boolean; override;
    procedure CheckTalonario;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DataModuleDestroy(Sender: TObject);
    { Procedimiento para calcular y cargar el monto en el comprobante de acuerdo
      a los impuestos que le corresponden. Debe ser implementado por cada
      comprobante ya que cada uno tiene una forma diferente de calculo}
    procedure DeterminarImpuesto; virtual; abstract;
    procedure DiscardChanges; override;
    procedure FetchCabeceraCompra; virtual;
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
    procedure LocateTalonario;
    procedure NuevoComprobante;
    procedure NuevoComprobanteCompra;
    procedure NuevoComprobanteDetalle;
    procedure OnComprobanteError(Sender: TObject; {%H-}E: EDatabaseError); virtual;
    procedure qryDetalleAfterInsert(DataSet: TDataSet); virtual;
    procedure qryDetalleAfterPost(DataSet: TDataSet);
    procedure qryDetalleBeforePost(DataSet: TDataSet);
    { Procedimiento para mover el dataset de detalle cuando se mueve el de
      cabecera. }
    procedure qryCabeceraAfterScroll(DataSet: TDataSet); virtual; abstract;
    procedure qryCabeceraNewRecord(DataSet: TDataSet); virtual;
    procedure PropiertiesRestoreProperties(Sender: TObject);
    procedure PropiertiesSaveProperties(Sender: TObject);
    procedure RegistrarMovimientoCompra(ADocID: string;
      ATipoDocumento: TTipoDocumento; ADescripcion: string;
      ADescripcionCtaPersonal: string); virtual;
    procedure Rollback; override;
    procedure SaveChanges; override;
    procedure SetNumero; virtual; abstract;
    procedure SetTipoComprobante(ATipoComprobante: TTipoDocumento);
    procedure ShowReport(IComprobanteID: string); virtual;
    //procedure ShowReporte;
    function GetMontoComprobante: double; virtual;
    function GetTalonarioDataSource: TDataSource;
    property Asientos: TAsientosDataModule read FAsientos write SetAsientos;
    property Estado: TEstadoComprobante read FEstado write SetEstado;
    property Personas: TPersonasDataModule read FPersonas write SetPersonas;
    property CabeceraGenName: string read FCabeceraGenName write SetCabeceraGenName;
    property DetalleGenName: string read FDetalleGenName write SetDetalleGenName;
    property Talonarios: TTalonarioDataModule read FTalonarios write SetTalonarios;
    property TalonarioID: string read FTalonarioID write SetTalonarioID;
    property Compra: boolean read FCompra write SetCompra;
    property ReportFile: string read FReportFile write FReportFile;
    property ReportFileCompra: string read FReportFileCompra write FReportFileCompra;
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
  FTalonarios := TTalonarioDataModule.Create(Self, MasterDataModule);
  FAsientos := TAsientosDataModule.Create(Self, MasterDataModule);
  FAsientos.ComprobarAsiento := False;
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
  AuxQryList.Add(TObject(FTalonarios.TalonarioView));
  Compra := False;
  FINIFile := TIniFile.Create('curso.ini');
  RestoreProperties;
end;

procedure TComprobanteDataModule.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FPersonas) then
    FreeAndNil(FPersonas);
  if Assigned(FTalonarios) then
    FreeAndNil(FTalonarios);
  if Assigned(FAsientos) then
    FreeAndNil(FAsientos);
end;

procedure TComprobanteDataModule.qryDetalleAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger :=
    MasterDataModule.NextValue(DetalleGenName);
end;

procedure TComprobanteDataModule.qryCabeceraNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(CabeceraGenName);
  //ComprobanteID := DataSet.FieldByName('ID').AsInteger;
  DataSet.FieldByName('FECHA_EMISION').AsDateTime := Now;
  DataSet.FieldByName('VALIDO').AsInteger := 1;
  DataSet.FieldByName('TOTAL').AsFloat := 0;
end;

procedure TComprobanteDataModule.RegistrarMovimientoCompra(ADocID: string;
  ATipoDocumento: TTipoDocumento; ADescripcion: string; ADescripcionCtaPersonal: string);
var
  CuentaID: string;
  mov: TTipoMovimiento;
begin
  try
    if (qryCabecera.State in [dsEdit, dsInsert]) then
      raise Exception.Create(rsCreatingDoc);
    if not qryCabecera.Locate('ID', ADocID, []) then
      raise EDatabaseError.Create(rsNoSeEncontroDoc);

    // REGISTRAR EN CUENTA PERSONAL
    qryDetalle.First;
    // hay que buscar la cuenta que le correponde a la persona
    Asientos.Cuenta.Cuenta.Open;
    if Asientos.Cuenta.Cuenta.Lookup('PERSONAID',
      qryCabecera.FieldByName('PERSONAID').AsString, 'ID') = null then
      raise Exception.Create('Cuenta no encontrada');
    CuentaID := Asientos.Cuenta.Cuenta.Lookup('PERSONAID',
      qryCabecera.FieldByName('PERSONAID').AsString, 'ID');
    Asientos.NuevoAsiento(ADescripcionCtaPersonal, ATipoDocumento,
      qryCabecera.FieldByName('ID').AsString);
    while not qryDetalle.EOF do
    begin
      case ATipoDocumento of
        doFactura: mov := mvDebito;
        doNotaCredito: mov := mvCredito;
        doRecibo: mov := mvDebito;
      end;
      Asientos.NuevoAsientoDetalle(CuentaID, mov,
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
    Asientos.NuevoAsiento(ADescripcion, ATipoDocumento,
      qryCabecera.FieldByName('ID').AsString);
    while not qryDetalle.EOF do
    begin
      case ATipoDocumento of
        doFactura: mov := mvCredito;
        doNotaCredito: mov := mvDebito;
        doRecibo: mov := mvCredito;
      end;
      Asientos.NuevoAsientoDetalle(FCuentaCompras, mov,
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

procedure TComprobanteDataModule.Rollback;
begin
  Estado := csInicial;
  inherited Rollback;
end;

procedure TComprobanteDataModule.SaveChanges;
begin
  inherited SaveChanges;
  Estado := csGuardado;
  (MasterDataModule as ISubject).Notify;
end;

procedure TComprobanteDataModule.LocateComprobante(AID: string);
begin
  OpenDataSets;
  try
    if (Estado in [csEditando]) then
      raise Exception.Create(rsNoSePuedeSetFac)
    else if AID = '' then
      raise Exception.Create(rsNoSeEncontroDoc)
    else if not qryCabecera.Locate('ID', AID, [loCaseInsensitive]) then
      raise Exception.Create(rsNoSeEncontroDoc);
    Estado := csLeyendo;
  except
    on E: EDatabaseError do
    begin
      DoOnErrorEvent(Self, E);
      raise;
    end;
  end;
end;

procedure TComprobanteDataModule.LocateTalonario;
begin
  FTalonarios.OpenDataSets;
  if (FTalonarioID = '') or FTalonarios.TalonarioView.Locate('ID', FTalonarioID, []) then
    FTalonarios.TalonarioView.First;
end;

procedure TComprobanteDataModule.DiscardChanges;
begin
  inherited DiscardChanges;
  Estado := csInicial;
  (MasterDataModule as ISubject).Notify;
end;

procedure TComprobanteDataModule.FetchCabeceraCompra;
begin
  if not (Estado in [csEditando]) then
    raise EDatabaseError.Create(rsNoSeEstaCreando);
  if qryCabecera.FindField('RUC') = nil then
    qryCabecera.FieldByName('CEDULA').AsString := FDatosCurso.ruc
  else
    qryCabecera.FieldByName('RUC').AsString := FDatosCurso.ruc;
  qryCabecera.FieldByName('NOMBRE').AsString := FDatosCurso.nombre;
  qryCabecera.FieldByName('DIRECCION').AsString := FDatosCurso.direccion;
  qryCabecera.FieldByName('TELEFONO').AsString := FDatosCurso.telefono;
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
    if not (Estado in [csEditando]) then
      raise EDatabaseError.Create(rsNoSeEstaCreando);
    // traer nombre, ruc
    if not FPersonas.Persona.Locate('ID', APersonaID, [loCaseInsensitive]) then
      raise Exception.Create(rsPersonaNoEncontrada);
    if not (qryCabecera.State in dsEditModes) then
      qryCabecera.Edit;
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
    if not (Estado in [csEditando]) then
      raise EDatabaseError.Create(rsNoSeEstaCreando);

    DeudaView.Close;
    DeudaView.ParamByName('personaid').AsString := APersonaID;
    DeudaView.Open;
    if DeudaView.IsEmpty then
      raise EDatabaseError.Create(rsNoHayDeudas);
    // recorremos y cargamos la deuda
    try
      qryDetalle.AfterPost := nil;
      DeudaView.First;
      while not DeudaView.EOF do
      begin
        ImpuestoView.Close;
        ImpuestoView.ParamByName('arancelid').AsString := DeudaViewARANCELID.AsString;
        ImpuestoView.Open;
        ImpuestoView.First;

        NuevoComprobanteDetalle;
        qryDetalle.FieldByName('CANTIDAD').AsInteger := 1;
        qryDetalle.FieldByName('DEUDAID').AsString := DeudaViewID.AsString;
        qryDetalle.FieldByName('DETALLE').AsString := DeudaViewDESCRIPCION.AsString;
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
    finally
      qryDetalle.AfterPost := @qryDetalleAfterPost;
    end;
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
  with Talonarios do
  begin
    TalonarioView.Close;
    TalonarioView.ServerFilter := 'TIPO = ' + x;
    TalonarioView.ServerFiltered := True;
    TalonarioView.Open;
  end;
end;

procedure TComprobanteDataModule.ShowReport(IComprobanteID: string);
begin
  {
  qryDetalle.Close;
  qryCabecera.Close;
  }
  LocateComprobante(IComprobanteID);
  // Te salia campo requerido porque aca vos estabas editando el comprobante jeje
  {
   qryCabecera.FieldByName('ID').AsInteger:= IComprobanteID;
   if (qryDetalle.Filtered = False ) then
   qryDetalle.Filtered:=True;
   qryCabecera.Open;
  }
  if qryCabecera.FieldByName('TALONARIOID').IsNull then
  begin
    if Trim(ReportFileCompra) = '' then
      raise Exception.Create('Archivo de comprobante no valido');
    frReport1.LoadFromFile(ReportFileCompra);
    frReport1.ShowReport;
  end
  else
  begin
    if Trim(ReportFile) = '' then
      raise Exception.Create('Archivo de comprobante no valido');
    frReport1.LoadFromFile(ReportFile);
    frReport1.ShowReport;
  end;
end;

//procedure TComprobanteDataModule.ShowReporte;
//begin
//  ShowReport(ComprobanteID);
//end;

function TComprobanteDataModule.GetMontoComprobante: double;
begin
  if not (Estado in [csLeyendo]) then
    raise  Exception.Create(rsNoSePuedeSetFac);
  Result := qryCabecera.FieldByName('TOTAL').AsFloat;
end;

function TComprobanteDataModule.GetTalonarioDataSource: TDataSource;
begin
  Result := Talonarios.dsTalonarioView;
end;

procedure TComprobanteDataModule.NuevoComprobante;
begin
  try
    if (Estado in [csEditando]) then
      raise EDatabaseError.Create(rsYaSeEstaCreando);
    CheckTalonario;
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
    Estado := csEditando;
    (MasterDataModule as ISubject).Notify;
  except
    on E: EDatabaseError do
    begin
      raise;
      DoOnErrorEvent(Self, E);
    end;
  end;
end;

procedure TComprobanteDataModule.NuevoComprobanteCompra;
begin
  try
    if (Estado in [csEditando]) then
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
    Estado := csEditando;
    (MasterDataModule as ISubject).Notify;
  except
    on E: EDatabaseError do
    begin
      raise;
      DoOnErrorEvent(Self, E);
    end;
  end;
end;

procedure TComprobanteDataModule.NuevoComprobanteDetalle;
begin
  try
    if (Estado in [csInicial, csGuardado]) then
      raise EDatabaseError.Create(rsNoSeEstaCreando);

    qryDetalle.Insert;
    //(MasterDataModule as ISubject).Notify;
  except
    on E: EDatabaseError do
    begin
      raise;
      DoOnErrorEvent(Self, E);
    end;
  end;
end;

procedure TComprobanteDataModule.OnComprobanteError(Sender: TObject; E: EDatabaseError);
begin
  DiscardChanges;
  Rollback;
  Estado := csInicial;
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
  Propierties.Restore;
end;

procedure TComprobanteDataModule.qryDetalleAfterPost(DataSet: TDataSet);
begin
  ActualizarTotales;
end;

procedure TComprobanteDataModule.PropiertiesSaveProperties(Sender: TObject);
begin
  Propierties.StoredValues.Items[0].Value := FTalonarioID;
end;

procedure TComprobanteDataModule.PropiertiesRestoreProperties(Sender: TObject);
begin
  FTalonarioID := Propierties.StoredValues.Items[0].Value;
end;

procedure TComprobanteDataModule.SetCabeceraGenName(AValue: string);
begin
  if FCabeceraGenName = AValue then
    Exit;
  FCabeceraGenName := AValue;
end;

procedure TComprobanteDataModule.SetCompra(AValue: boolean);
begin
  if FCompra = AValue then
    Exit;
  FCompra := AValue;
end;

procedure TComprobanteDataModule.RestoreProperties;
begin
  with FDatosCurso do
  begin
    ruc := FINIFile.ReadString('datos', 'ruc', '');
    nombre := FINIFile.ReadString('datos', 'nombre', '');
    direccion := FINIFile.ReadString('datos', 'direccion', '');
    telefono := FINIFile.ReadString('datos', 'telefono', '');
  end;
  FCuentaCompras := FINIFile.ReadString('datos', 'cuentaCompras', '');
end;

procedure TComprobanteDataModule.SetAsientos(AValue: TAsientosDataModule);
begin
  if FAsientos = AValue then
    Exit;
  FAsientos := AValue;
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

procedure TComprobanteDataModule.SetTalonarios(AValue: TTalonarioDataModule);
begin
  if FTalonarios = AValue then
    Exit;
  FTalonarios := AValue;
end;

function TComprobanteDataModule.ArePendingChanges: boolean;
begin
  if (Estado in [csInicial, csGuardado]) then
    Result := False
  else
    Result := True;
end;

procedure TComprobanteDataModule.CheckTalonario;
begin
  if FTalonarioID = '' then
    raise Exception.Create('Talonario no seleccionado. Por favor seleccione uno');
end;

end.
