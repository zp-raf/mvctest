unit frmpersonasdatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, frmsgcddatamodule,
  frmquerydatamodule, sqldb, DB, sgcdTypes, variants, observerSubject, strutils,
  frmmodulodatamodule;

resourcestring
  rsGenName = 'GEN_ACADEMIA';
  rsGenNameDir = 'GEN_DIRECCION';
  rsGenNameTel = 'GEN_TEL';
  rsDocTypeNotSelected = 'No se selecciono el tipo de comprobante';

type

  { TPersonasDataModule }

  TPersonasDataModule = class(TQueryDataModule)
    CursaALUMNOPERSONAID: TLongintField;
    CursaMODULOID: TLongintField;
    StringField1: TStringField;
    procedure CursaAfterInsert(DataSet: TDataSet);
    procedure CursaMODULOIDChange(Sender: TField);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FModulo: TModuloDataModule;
    procedure SetModulo(AValue: TModuloDataModule);
  published
    AlumnoACTIVO: TSmallintField;
    AlumnoCONFIRMADO: TSmallintField;
    AlumnoPERSONAID: TLongintField;
    dsAlumnoArea: TDataSource;
    dsPersonasRoles: TDataSource;
    DireccionBARRIO: TStringField;
    DireccionCIUDAD: TStringField;
    DireccionDEPARTAMENTO: TStringField;
    DireccionDESCRIPCION: TStringField;
    DireccionDIRECCION: TStringField;
    DireccionID: TLongintField;
    DireccionIDPERSONA: TLongintField;
    dsTelefono: TDataSource;
    dsDireccion: TDataSource;
    dsPersona: TDataSource;
    EmpleadoACTIVO: TSmallintField;
    EmpleadoESADMINISTRATIVO: TSmallintField;
    EmpleadoESCOORDINADOR: TSmallintField;
    EmpleadoESENCARGADO: TSmallintField;
    EmpleadoESPROFESOR: TSmallintField;
    EmpleadoPERSONAID: TLongintField;
    Persona: TSQLQuery;
    Direccion: TSQLQuery;
    PersonaACTIVO: TSmallintField;
    PersonaAPELLIDO: TStringField;
    PersonaCEDULA: TStringField;
    PersonaExternaACTIVO: TSmallintField;
    PersonaExternaESENCARGADO: TSmallintField;
    PersonaExternaESPROVEEDOR: TSmallintField;
    PersonaExternaPERSONAID: TLongintField;
    PersonaFECHANAC: TDateField;
    PersonaID: TLongintField;
    PersonaNOMBRE: TStringField;
    PersonaNOMBRECOMPLETO: TStringField;
    PersonaRUC: TStringField;
    PersonaSEXO: TStringField;
    PersonasRoles: TSQLQuery;
    PersonasRolesACTIVO: TSmallintField;
    PersonasRolesAPELLIDO: TStringField;
    PersonasRolesCEDULA: TStringField;
    PersonasRolesESADMINISTRATIVO: TLongintField;
    PersonasRolesESALUMNO: TLongintField;
    PersonasRolesESCOORDINADOR: TLongintField;
    PersonasRolesESENCARGADO: TLongintField;
    PersonasRolesESPROFESOR: TLongintField;
    PersonasRolesESPROVEEDOR: TLongintField;
    PersonasRolesFECHANAC: TDateField;
    PersonasRolesID: TLongintField;
    PersonasRolesNOMBRE: TStringField;
    PersonasRolesNOMBRECOMPLETO: TStringField;
    PersonasRolesSEXO: TStringField;
    Alumno: TSQLQuery;
    PersonaExterna: TSQLQuery;
    Empleado: TSQLQuery;
    Cursa: TSQLQuery;
    Telefono: TSQLQuery;
    TelefonoDESCRIPCION: TStringField;
    TelefonoID: TLongintField;
    TelefonoIDPERSONA: TLongintField;
    TelefonoNUMERO: TStringField;
    TelefonoPREFIJO: TStringField;
    procedure FilterAlumno;
    procedure FilterEmpleado;
    procedure FilterExterno;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DireccionAfterInsert(DataSet: TDataSet);
    procedure EditCurrentRecord; override;
    procedure FilterData(ASearchText: string; ARol: TRolPersona); overload;
    procedure PersonaAfterScroll(DataSet: TDataSet);
    procedure PersonaNewRecord(DataSet: TDataSet);
    procedure SaveChanges; override;
    procedure SetAsAlumno;
    procedure SetAsEmpleado;
    procedure SetAsExterno;
    procedure SetRol(ARol: TRolPersona);
    procedure TelefonoAfterInsert(DataSet: TDataSet);
    function GetRoles: TRoles;
    property Modulo: TModuloDataModule read FModulo write SetModulo;
  end;

var
  PersonasDataModule: TPersonasDataModule;

implementation

{$R *.lfm}

{ TPersonasDataModule }

procedure TPersonasDataModule.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FModulo) then
    FreeAndNil(FModulo);
end;

procedure TPersonasDataModule.CursaAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('ALUMNOPERSONAID').AsInteger :=
    Persona.FieldByName('ID').AsInteger;
end;

procedure TPersonasDataModule.CursaMODULOIDChange(Sender: TField);
begin
  if Cursa.Locate('MODULOID', Sender.AsInteger, []) then
    Cursa.Delete;
end;

procedure TPersonasDataModule.SetModulo(AValue: TModuloDataModule);
begin
  if FModulo = AValue then
    Exit;
  FModulo := AValue;
end;

procedure TPersonasDataModule.FilterAlumno;
begin
  Alumno.Close;
  Alumno.ParamByName('PERSONAID').AsString := PersonaID.AsString;
  Alumno.Open;
end;

procedure TPersonasDataModule.FilterEmpleado;
begin
  Empleado.Close;
  Empleado.ParamByName('PERSONAID').AsString := PersonaID.AsString;
  Empleado.Open;
end;

procedure TPersonasDataModule.FilterExterno;
begin
  PersonaExterna.Close;
  PersonaExterna.ParamByName('PERSONAID').AsString := PersonaID.AsString;
  PersonaExterna.Open;
end;

procedure TPersonasDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  FModulo := TModuloDataModule.Create(Self, MasterDataModule);
  QryList.Add(TObject(Persona));
  DetailList.Add(TObject(Direccion));
  DetailList.Add(TObject(Telefono));
  AuxQryList.Add(TObject(Alumno));
  AuxQryList.Add(TObject(PersonaExterna));
  AuxQryList.Add(TObject(Empleado));
  AuxQryList.Add(TObject(Cursa));
  AuxQryList.Add(TObject(PersonasRoles));
  AuxQryList.Add(TObject(FModulo.ModulosHabilitadosView));
  SearchFieldList.Add('NOMBRE');
  SearchFieldList.Add('APELLIDO');
  SearchFieldList.Add('CEDULA');
  Persona.OnFilterRecord := @FilterRecord;
end;

procedure TPersonasDataModule.DireccionAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('IDPERSONA').Value := Persona.FieldByName('ID').Value;
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenNameDir);
end;

procedure TPersonasDataModule.EditCurrentRecord;
begin
  inherited EditCurrentRecord;
  (MasterDataModule as ISubject).Notify;
end;

procedure TPersonasDataModule.FilterData(ASearchText: string; ARol: TRolPersona);
var
  AFilterStr: string;
  i: integer;
begin
  if (SearchFieldList.Count > 0) and (Trim(ASearchText) <> '') then
  begin
    AFilterStr := '(UPPER(' + SearchFieldList[0] + ') LIKE ' +
      QuotedStr('%' + UpperCase(ASearchText) + '%');
    for i := 1 to Pred(SearchFieldList.Count) do
    begin
      AFilterStr := AFilterStr + ' OR UPPER(' + SearchFieldList[i] +
        ') LIKE ' + QuotedStr('%' + UpperCase(ASearchText) + '%');
    end;
    AFilterStr := AFilterStr + ')';
    // ???: sacar esto cuando se halle mejor solucion a este problema
    if not (ARol in [roCualquiera]) then
      AFilterStr := AFilterStr + ' AND ';
  end;
  case ARol of
    roCualquiera:
    begin
      // nada
    end;
    roExterno:
    begin
      AFilterStr := AFilterStr + '(ESENCARGADO = 1 OR ESPROVEEDOR = 1)';
    end;
    roAlumno:
    begin
      AFilterStr := AFilterStr + '(ESALUMNO = 1)';
    end;
    roProveedor:
    begin
      AFilterStr := AFilterStr + '(ESPROVEEDOR = 1)';
    end;
  end;
  //ShowMessage(AFilterStr);
  PersonasRoles.Close;
  PersonasRoles.ServerFilter := AFilterStr;
  if not (Trim(AFilterStr) = '') then
    PersonasRoles.ServerFiltered := True
  else
    PersonasRoles.ServerFiltered := False;
  PersonasRoles.Open;
end;

procedure TPersonasDataModule.PersonaAfterScroll(DataSet: TDataSet);
begin
  Telefono.Close;
  Direccion.Close;
  Cursa.Close;
  Telefono.ParamByName('ID').Value := DataSet.FieldByName('ID').Value;
  Direccion.ParamByName('ID').Value := DataSet.FieldByName('ID').Value;
  Cursa.ParamByName('ALUMNOPERSONAID').Value := DataSet.FieldByName('ID').Value;
  Telefono.Open;
  Direccion.Open;
  Cursa.Open;
end;

procedure TPersonasDataModule.PersonaNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenName);
end;

procedure TPersonasDataModule.SaveChanges;
begin
  inherited SaveChanges;
  Alumno.ApplyUpdates;
  Empleado.ApplyUpdates;
  PersonaExterna.ApplyUpdates;
  Cursa.ApplyUpdates;
end;

procedure TPersonasDataModule.SetAsAlumno;
begin
  Alumno.Insert;
  AlumnoPERSONAID.AsString := PersonaID.AsString;
  AlumnoACTIVO.AsString := DB_TRUE;
  AlumnoCONFIRMADO.AsString := DB_FALSE;
  Alumno.Post;
end;

procedure TPersonasDataModule.SetAsEmpleado;
begin
  Empleado.Insert;
  EmpleadoPERSONAID.AsString := PersonaID.AsString;
  EmpleadoACTIVO.AsString := DB_TRUE;
  EmpleadoESADMINISTRATIVO.AsString := DB_FALSE;
  EmpleadoESCOORDINADOR.AsString := DB_FALSE;
  EmpleadoESENCARGADO.AsString := DB_FALSE;
  EmpleadoESPROFESOR.AsString := DB_FALSE;
  Empleado.Post;
end;

procedure TPersonasDataModule.SetAsExterno;
begin
  PersonaExterna.Insert;
  PersonaExternaPERSONAID.AsString := PersonaID.AsString;
  PersonaExternaACTIVO.AsString := DB_TRUE;
  PersonaExternaESENCARGADO.AsString := DB_FALSE;
  PersonaExternaESPROVEEDOR.AsString := DB_FALSE;
  PersonaExterna.Post;
end;

procedure TPersonasDataModule.SetRol(ARol: TRolPersona);
begin
  if (Persona.State in [dsInactive, dsBrowse]) then
    raise Exception.Create('Imposible cambiar el rol: datos no disponibles');
  {
    ver si esta ya la persona en la tabla del rol
    si no esta añadir el registro
    si ya esta poner el flag correspondiente
    atender que no todos lo roles son combinables (ej no tiene sentido que el
    coordinador pueda ser tambien alumno!)
  }
  case ARol of
    // tabla alumno
    roAlumno:
    begin
      FilterAlumno;
      if Alumno.IsEmpty then
        SetAsAlumno;
    end;
    //tabla empleado
    roCoordinador:
    begin
      FilterEmpleado;
      if Empleado.IsEmpty then
        SetAsEmpleado;
      Empleado.Edit;
      EmpleadoESCOORDINADOR.AsString := DB_TRUE;
      Empleado.Post;
    end;
    roAdministrativo:
    begin
      FilterEmpleado;
      if Empleado.IsEmpty then
        SetAsEmpleado;
      Empleado.Edit;
      EmpleadoESADMINISTRATIVO.AsString := DB_TRUE;
      Empleado.Post;
    end;
    roProfesor:
    begin
      FilterEmpleado;
      if Empleado.IsEmpty then
        SetAsEmpleado;
      Empleado.Edit;
      EmpleadoESPROFESOR.AsString := DB_TRUE;
      Empleado.Post;
    end;
    // las tablas empleado y externo
    roEncargado:
    begin
      FilterExterno;
      FilterEmpleado;
      if PersonaExterna.IsEmpty and Empleado.IsEmpty then
      begin
        SetAsExterno;
        PersonaExterna.Edit;
        PersonaExternaESENCARGADO.AsString := DB_TRUE;
        PersonaExterna.Post;
      end
      // si ya esta como externo nomas
      else if Empleado.IsEmpty then
      begin
        PersonaExterna.Edit;
        PersonaExternaESENCARGADO.AsString := DB_TRUE;
        PersonaExterna.Post;
      end
      // si ya esta como empleado nomas
      else if PersonaExterna.IsEmpty then
      begin
        Empleado.Edit;
        EmpleadoESENCARGADO.AsString := DB_TRUE;
        Empleado.Post;
      end
      else
      begin
        PersonaExterna.Edit;
        PersonaExternaESENCARGADO.AsString := DB_TRUE;
        PersonaExterna.Post;
        Empleado.Edit;
        EmpleadoESENCARGADO.AsString := DB_TRUE;
        Empleado.Post;
      end;
    end;
    // tabla externo
    roProveedor:
    begin
      FilterExterno;
      if PersonaExterna.IsEmpty then
        SetAsExterno;
      PersonaExterna.Edit;
      PersonaExternaESPROVEEDOR.AsString := DB_TRUE;
      PersonaExterna.Post;
    end;
  end;
end;

procedure TPersonasDataModule.TelefonoAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('IDPERSONA').Value := Persona.FieldByName('ID').Value;
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenNameTel);
end;

function TPersonasDataModule.GetRoles: TRoles;
var
  ARoles: array of TRolPersona;
  ATemp: variant;
  i, j: integer;
  RolCount: integer = 0;
begin
  if (Persona.State in [dsInactive]) then
    raise Exception.Create('Datos no disponibles');
  PersonasRoles.Open;
  if PersonasRoles.Locate('ID', Persona.FieldByName('ID').AsString, []) <> null then
    ATemp := PersonasRoles.Lookup('ID', Persona.FieldByName('ID').AsString,
      'ESALUMNO;ESENCARGADO;ESPROVEEDOR;ESCOORDINADOR;ESADMINISTRATIVO;ESPROFESOR');
  { tenemos que ver cuantos roles hay; para eso contamos la cantidad de unos
    que hay en el array }
  for j := VarArrayLowBound(ATemp, 1) to VarArrayHighBound(ATemp, 1) do
  begin
    if ATemp[j] = DB_TRUE then
      Inc(RolCount);
  end;
  if RolCount = 0 then
  begin
    raise Exception.Create('Error al leer los roles');
    Exit;
  end;
  // cargamos el array con los roles
  SetLength(ARoles, RolCount);
  i := 0;
  for j := VarArrayLowBound(ATemp, 1) to VarArrayHighBound(ATemp, 1) do
  begin
    if ATemp[j] = DB_TRUE then
    begin
      case j of
        // alumno
        0: ARoles[i] := roAlumno;
        // encargado
        1: ARoles[i] := roEncargado;
        // proveedor
        2: ARoles[i] := roProveedor;
        // coordinador
        3: ARoles[i] := roCoordinador;
        // administrativo
        4: ARoles[i] := roAdministrativo;
        // profesor
        5: ARoles[i] := roProfesor;
        else
          Continue;
      end;
      Inc(i);
    end;
  end;
  Result := ARoles;
end;

end.
