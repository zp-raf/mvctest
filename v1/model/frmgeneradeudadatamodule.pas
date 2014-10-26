unit frmgeneradeudadatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, sqldb, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmquerydatamodule, frmpersonasdatamodule, frmcuotaxarancel,
  frmaranceldatamodule, dateutils, frmasientosdatamodule,
  frmcuentadatamodule;

resourcestring
  rsGenDeuda = 'GENERATOR_DEUDA';
  rsArancelNoEnc = 'Arancel no encontrado';
  rsPersonaNoEnc = 'Persona no encontrada';
  rsMatriculaNoE = 'Matricula no encontrada';

const
  DIAS = 1;
  MESES = 2;
  ANHOS = 3;
  ESPACIO = ' ';
  SEPARADOR_CUOTA = '/';
  SEPARADOR = '. ';

type

  TUnidadFecha = (ufDias = DIAS, ufMeses = MESES, ufAnhos = ANHOS, ufNada = 99);

  { TGeneraDeudaDataModule }

  TGeneraDeudaDataModule = class(TQueryDataModule)
    DeudaMONTO_DEUDA: TFloatField;
    dsAran: TDataSource;
    dsCod: TDataSource;
    dsCuota: TDataSource;
    dsPers: TDataSource;
    DeudaACTIVO: TSmallintField;
    DeudaARANCELID: TLongintField;
    DeudaCANTIDAD_CUOTAS: TLongintField;
    DeudaCUOTA_NRO: TLongintField;
    DeudaDESCRIPCION: TStringField;
    DeudaID: TLongintField;
    DeudaMATRICULAID: TLongintField;
    DeudaVENCIMIENTO: TDateField;
    dsDeuda: TDatasource;
    Deuda: TSQLQuery;
  private
    FArancel: TArancelesDataModule;
    FAsientos: TAsientosDataModule;
    FCuentas: TCuentaDataModule;
    FCuota: TCuotaArancelDataModule;
    FPersonas: TPersonasDataModule;
    procedure SetArancel(AValue: TArancelesDataModule);
    procedure SetAsientos(AValue: TAsientosDataModule);
    procedure SetCuentas(AValue: TCuentaDataModule);
    procedure SetCuota(AValue: TCuotaArancelDataModule);
    procedure SetPersonas(AValue: TPersonasDataModule);
    // el generador de cuotas
    procedure GeneradorCuotas(ACantCuotas: integer; AUnidadFecha: TUnidadFecha = ufNada;
      ACant: integer = 0; AVenc: string = ''; SinVencimiento: boolean = False);
    function GetCuentaPersona(APersonaID: string): variant;
    // para poner el vencimiento
    function GetVencimiento(AFecha: TDateTime; AUnidadFecha: TUnidadFecha;
      ACant: integer; ANroCuota: integer): TDateTime;
  published
    procedure Connect; override;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DeudaBeforePost(DataSet: TDataSet);
    procedure DeudaNewRecord(DataSet: TDataSet);
    procedure Disconnect; override;
    // cuotas por defecto
    procedure GenerarCuotas; overload;
    // sin vencimiento
    procedure GenerarCuotas(ACantCuotas: integer); overload;
    // una cuota con vencimiento manual
    procedure GenerarCuotas(AVenc: string); overload;
    // con vencimiento
    procedure GenerarCuotas(ACantCuotas: integer; AUnidadFecha: TUnidadFecha;
      ACant: integer); overload;
    procedure SaveChanges; override;
    procedure SetArancel(AID: string);
    procedure SetMatricula(AID: string);
    procedure SetPersona(AID: string);
    property Arancel: TArancelesDataModule read FArancel write SetArancel;
    property Asientos: TAsientosDataModule read FAsientos write SetAsientos;
    property Cuentas: TCuentaDataModule read FCuentas write SetCuentas;
    property Cuota: TCuotaArancelDataModule read FCuota write SetCuota;
    property Personas: TPersonasDataModule read FPersonas write SetPersonas;
  end;

var
  GeneraDeudaDataModule: TGeneraDeudaDataModule;
  UnidadesFecha: set of TUnidadFecha;

implementation

{$R *.lfm}

{ TGeneraDeudaDataModule }

procedure TGeneraDeudaDataModule.SetPersonas(AValue: TPersonasDataModule);
begin
  if FPersonas = AValue then
    Exit;
  FPersonas := AValue;
end;

procedure TGeneraDeudaDataModule.SetCuota(AValue: TCuotaArancelDataModule);
begin
  if FCuota = AValue then
    Exit;
  FCuota := AValue;
end;

procedure TGeneraDeudaDataModule.DeudaBeforePost(DataSet: TDataSet);
var
  DescMatricula: string;
  CuentaID: string;
begin
  DescMatricula := '';
  // aca ponemos la descripcion de la deuda
  DataSet.FieldByName('DESCRIPCION').AsString :=
    Arancel.ArancelNOMBRE.AsString + ESPACIO +
    DataSet.FieldByName('CUOTA_NRO').AsString + SEPARADOR_CUOTA +
    DataSet.FieldByName('CANTIDAD_CUOTAS').AsString + SEPARADOR +
    Personas.Persona.FieldByName('NOMBRECOMPLETO').AsString + DescMatricula;
  // ponemos el monto de la deuda
  DataSet.FieldByName('MONTO_DEUDA').AsFloat :=
    Arancel.ArancelMONTO.AsFloat / DataSet.FieldByName('CANTIDAD_CUOTAS').AsFloat;
  // insertamos el detalle del asiento
  CuentaID := GetCuentaPersona(Personas.PersonaID.AsString);
  Asientos.NuevoAsientoDetalle(CuentaID, mvDebito,
    Arancel.ArancelMONTO.AsFloat / DataSet.FieldByName('CANTIDAD_CUOTAS').AsFloat,
    DeudaID.AsString);
end;

procedure TGeneraDeudaDataModule.SetArancel(AValue: TArancelesDataModule);
begin
  if FArancel = AValue then
    Exit;
  FArancel := AValue;
end;

procedure TGeneraDeudaDataModule.SetAsientos(AValue: TAsientosDataModule);
begin
  if FAsientos = AValue then
    Exit;
  FAsientos := AValue;
end;

procedure TGeneraDeudaDataModule.SetCuentas(AValue: TCuentaDataModule);
begin
  if FCuentas = AValue then
    Exit;
  FCuentas := AValue;
end;

procedure TGeneraDeudaDataModule.Connect;
begin
  FPersonas.Connect;
  FCuota.Connect;
  FArancel.Connect;
  FAsientos.Connect;
  FCuentas.Connect;
  inherited Connect;
end;

procedure TGeneraDeudaDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  QryList.Add(TObject(Deuda));
  FPersonas := TPersonasDataModule.Create(Self, FMasterDataModule);
  FPersonas.SetReadOnly(True);
  FPersonas.UnfilterData;
  FCuota := TCuotaArancelDataModule.Create(Self, FMasterDataModule);
  FCuota.SetReadOnly(True);
  FArancel := TArancelesDataModule.Create(Self, FMasterDataModule);
  FArancel.SetReadOnly(True);
  dsCod.DataSet := FCuota.Codigos.Codigos;
  FAsientos := TAsientosDataModule.Create(Self, FMasterDataModule);
  // para no comprobar el asiento antes de guardar
  FAsientos.ComprobarAsiento := False;
  FCuentas := TCuentaDataModule.Create(Self, FMasterDataModule);
end;

procedure TGeneraDeudaDataModule.DeudaNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenDeuda);
  DataSet.FieldByName('ACTIVO').AsInteger := 1;
end;

procedure TGeneraDeudaDataModule.Disconnect;
begin
  FPersonas.Disconnect;
  FCuota.Disconnect;
  FArancel.Disconnect;
  FAsientos.Disconnect;
  FCuentas.Disconnect;
  inherited Disconnect;
end;

procedure TGeneraDeudaDataModule.GenerarCuotas;
var
  CantCuotas, CantVenc: integer;
  UnidadVenc: integer;
  pUnidadVenc: TUnidadFecha;
begin
  // traemos los valores por defecto para el arancel
  CantCuotas := Cuota.GetCantCuotas(DeudaARANCELID.AsString);
  CantVenc := Cuota.GetVencimientoCantidad(DeudaARANCELID.AsString);
  UnidadVenc := Cuota.GetVencimientoUnidad(DeudaARANCELID.AsString);
  // si no hay nigun registro se devuelve -1 y se toma como una cuota unica y sin vencimiento
  if (CantCuotas = -1) or (CantVenc = -1) or (UnidadVenc = -1) then
  begin
    DeudaCANTIDAD_CUOTAS.AsInteger := 1;
    DeudaCUOTA_NRO.AsInteger := 1;
    DeudaVENCIMIENTO.Clear;
  end;
  case UnidadVenc of
    DIAS: pUnidadVenc := ufDias;
    MESES: pUnidadVenc := ufMeses;
    ANHOS: pUnidadVenc := ufAnhos;
    else
      raise Exception.Create('Unidad de fecha no definida');
  end;
  GeneradorCuotas(CantCuotas, pUnidadVenc, CantVenc);
end;

procedure TGeneraDeudaDataModule.GenerarCuotas(ACantCuotas: integer);
begin
  GeneradorCuotas(ACantCuotas, ufNada, 0, '', True);
end;

procedure TGeneraDeudaDataModule.GenerarCuotas(AVenc: string);
begin
  GeneradorCuotas(1, ufNada, 0, AVenc);
end;

procedure TGeneraDeudaDataModule.GenerarCuotas(ACantCuotas: integer;
  AUnidadFecha: TUnidadFecha; ACant: integer);
begin
  GeneradorCuotas(ACantCuotas, AUnidadFecha, ACant);
end;

function TGeneraDeudaDataModule.GetCuentaPersona(APersonaID: string): variant;
begin
  if Cuentas.Cuenta.Lookup('PERSONAID', APersonaID, 'ID') = null then
    raise Exception.Create('No se encontro la cuenta de la persona seleccionada')
  else
    Result := Cuentas.Cuenta.Lookup('PERSONAID', APersonaID, 'ID');
end;

procedure TGeneraDeudaDataModule.SaveChanges;
begin
  inherited SaveChanges;
  // ahora cuando se guardo todo se cierra el asiento tambien
  Asientos.CerrarAsiento;
end;

procedure TGeneraDeudaDataModule.SetArancel(AID: string);
begin
  if not Arancel.Arancel.Locate('ID', AID, [loCaseInsensitive]) then
    raise Exception.Create(rsArancelNoEnc);
end;

procedure TGeneraDeudaDataModule.SetPersona(AID: string);
begin
  if not Personas.Persona.Locate('ID', AID, [loCaseInsensitive]) then
    raise Exception.Create(rsPersonaNoEnc);
end;

procedure TGeneraDeudaDataModule.SetMatricula(AID: string);
begin
  //if AID = '' then
  //  Exit;
  //if not Matriculas.Matricula.Locate('ID', AID, [loCaseInsensitive]) then
  //  raise Exception.Create(rsMatriculaNoE);
end;

procedure TGeneraDeudaDataModule.GeneradorCuotas(ACantCuotas: integer;
  AUnidadFecha: TUnidadFecha; ACant: integer; AVenc: string; SinVencimiento: boolean);
var
  i: integer;
  ArancelID, matriculaID, cuentaID: string;
begin
  // para meter las siguientes cuotas guardamos los valores
  ArancelID := DeudaARANCELID.AsString;
  if not DeudaMATRICULAID.IsNull then
    matriculaID := DeudaMATRICULAID.AsString
  else
    matriculaID := '';

  // se modifica el registro actual que es la primera cuota
  DeudaCANTIDAD_CUOTAS.AsInteger := ACantCuotas;
  DeudaCUOTA_NRO.AsInteger := 1;

  // ponemos el vencimiento para la primera cuota
  if (ACantCuotas > 0) and (AUnidadFecha <> ufNada) and (ACant <> 0) and
    (AVenc = '') and not SinVencimiento then
    DeudaVENCIMIENTO.AsDateTime := GetVencimiento(Now, AUnidadFecha, ACant, 1)
  else if (AVenc <> '') and (ACantCuotas = 1) and not SinVencimiento then
    DeudaVENCIMIENTO.AsString := AVenc
  else if SinVencimiento then
    DeudaVENCIMIENTO.Clear
  else
    raise Exception.Create('Parametros no validos');

  // insertar un movimiento para registrar la deuda
  cuentaID := GetCuentaPersona(Personas.PersonaID.AsString);
  Asientos.NuevoAsiento('Generacion de deuda. Cuenta: ' + cuentaID +
    SEPARADOR + 'Arancel: ' + DeudaARANCELID.AsString);

  // desde la segunda cuota
  for i := 2 to ACantCuotas do
  begin
    Deuda.Append;
    DeudaCUOTA_NRO.AsInteger := i;
    DeudaCANTIDAD_CUOTAS.AsInteger := ACantCuotas;
    // obviamente es el mismo arancel para todas las cuotas!
    DeudaARANCELID.AsString := ArancelID;
    if matriculaID <> '' then
      DeudaMATRICULAID.AsString := matriculaID
    else
      DeudaMATRICULAID.Clear;
    // Ponemos el vencimiento. Aca ya no se necesita tantos chequeos porque ya se
    // cheqeuo mas arriba.
    if not SinVencimiento then
      DeudaVENCIMIENTO.AsDateTime := GetVencimiento(Now, AUnidadFecha, ACant, i)
    else if SinVencimiento then
      DeudaVENCIMIENTO.Clear
    else
      raise Exception.Create('Parametros no validos');
  end;
end;

function TGeneraDeudaDataModule.GetVencimiento(AFecha: TDateTime;
  AUnidadFecha: TUnidadFecha; ACant: integer; ANroCuota: integer): TDateTime;
begin
  case AUnidadFecha of
    ufDias:
    begin
      Result := IncDay(AFecha, ACant * ANroCuota);
    end;
    ufMeses:
    begin
      Result := IncMonth(AFecha, ACant * ANroCuota);
    end;
    ufAnhos:
    begin
      Result := IncYear(AFecha, ACant * ANroCuota);
    end;
    else
      Result := null;
  end;
end;

end.
