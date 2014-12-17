unit frmmatriculadatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, mensajes,
  XMLPropStorage, frmquerydatamodule, DB, sqldb, frmpersonasdatamodule,
  frmmateriasdatamodule, frmsecciondatamodule, observerSubject, sgcdTypes,
  frmaranceldatamodule, frmgeneradeudadatamodule, frmdesarrollodatamodule,
  frmasignacionarancelesdatamodule, variants;

resourcestring
  rsGenName = 'GENERATOR_MATRICULA';

const
  Delimiter = ',';

type

  { TMatriculaDataModule }

  TMatriculaDataModule = class(TQueryDataModule)
    AlumnosMatriculasView: TSQLQuery;
    AlumnosMatriculasViewACTIVA: TSmallintField;
    AlumnosMatriculasViewALUMNOPERSONAID: TLongintField;
    AlumnosMatriculasViewAPELLIDO: TStringField;
    AlumnosMatriculasViewCEDULA: TStringField;
    AlumnosMatriculasViewCONFIRMADA: TSmallintField;
    AlumnosMatriculasViewCONFIRMADO: TSmallintField;
    AlumnosMatriculasViewDERECHOEXAMEN: TSmallintField;
    AlumnosMatriculasViewDESARROLLOMATERIAID: TLongintField;
    AlumnosMatriculasViewFECHA: TDateField;
    AlumnosMatriculasViewID: TLongintField;
    AlumnosMatriculasViewNOMBRE: TStringField;
    AlumnosMatriculasViewOBSERVACIONES: TStringField;
    AlumnosMatriculasViewSECCION: TStringField;
    MatriculaACTIVA: TSmallintField;
    MatriculaALUMNOPERSONAID: TLongintField;
    MatriculaCONFIRMADA: TSmallintField;
    MatriculaDERECHOEXAMEN: TSmallintField;
    MatriculaDESARROLLOMATERIAID: TLongintField;
    MatriculaFECHA: TDateField;
    MatriculaGRUPOID: TLongintField;
    MatriculaID: TLongintField;
    MatriculaMATERIAID: TLongintField;
    MatriculaMODULOID: TLongintField;
    MatriculaOBSERVACIONES: TStringField;
    MatriculaSECCIONID: TLongintField;
    SQLQueryMatHabID: TLongintField;
    SQLQueryMatHabPERSONAID: TLongintField;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    procedure DesarrolloMatActivoDetViewFilterRecord(DataSet: TDataSet;
      var Accept: boolean);
    procedure MatriculaAfterOpen(DataSet: TDataSet);
  private
    FAsignacion: TAsignacionArancelesDataModule;
    FAutoGenerarDeudas: boolean;
    FDesarrollo: TDesarrolloMateriaDataModule;
    FDeudas: TGeneraDeudaDataModule;
    FEstado: TEdicionEstado;
    FPersonas: TPersonasDataModule;
    procedure SetAsignacion(AValue: TAsignacionArancelesDataModule);
    procedure SetAutoGenerarDeudas(AValue: boolean);
    procedure SetDesarrollo(AValue: TDesarrolloMateriaDataModule);
    procedure SetDeudas(AValue: TGeneraDeudaDataModule);
    procedure SetEstado(AValue: TEdicionEstado);
    procedure SetPersonas(AValue: TPersonasDataModule);
  published
    dsAlumnos: TDataSource;
    dsMatHabView: TDataSource;
    dsMatricula: TDataSource;
    MateriasHabilitadasView: TSQLQuery;
    MateriasHabilitadasViewAREA: TLongintField;
    MateriasHabilitadasViewGRUPO: TStringField;
    MateriasHabilitadasViewGRUPOID: TLongintField;
    MateriasHabilitadasViewMODULOID: TLongintField;
    MateriasHabilitadasViewNOMBRE: TStringField;
    Matricula: TSQLQuery;
    DesarrolloViewACTIVO: TSmallintField;
    DesarrolloViewEMPLEADOPERSONAID: TLongintField;
    DesarrolloViewGRUPOID: TLongintField;
    DesarrolloViewID: TLongintField;
    DesarrolloViewMATERIAID: TLongintField;
    DesarrolloViewMODULOID: TLongintField;
    DesarrolloViewNOMBRE_COMPLETO: TStringField;
    DesarrolloViewNOMBRE_GRUPO: TStringField;
    DesarrolloViewNOMBRE_MATERIA: TStringField;
    DesarrolloViewNOMBRE_MATERIA_DET: TStringField;
    DesarrolloViewNOMBRE_MOD: TStringField;
    DesarrolloViewNOMBRE_PERIODO: TStringField;
    DesarrolloViewNOMBRE_SECCION: TStringField;
    DesarrolloViewPERIODOLECTIVOID: TLongintField;
    DesarrolloViewSECCIONID: TLongintField;
    DesarrolloMatActivoDetViewACTIVO: TSmallintField;
    DesarrolloMatActivoDetViewEMPLEADOPERSONAID: TLongintField;
    DesarrolloMatActivoDetViewGRUPOID: TLongintField;
    DesarrolloMatActivoDetViewID: TLongintField;
    DesarrolloMatActivoDetViewMATERIAID: TLongintField;
    DesarrolloMatActivoDetViewMODULOID: TLongintField;
    DesarrolloMatActivoDetViewNOMBRE_COMPLETO: TStringField;
    DesarrolloMatActivoDetViewNOMBRE_GRUPO: TStringField;
    DesarrolloMatActivoDetViewNOMBRE_MATERIA: TStringField;
    DesarrolloMatActivoDetViewNOMBRE_MATERIA_DET: TStringField;
    DesarrolloMatActivoDetViewNOMBRE_MOD: TStringField;
    DesarrolloMatActivoDetViewNOMBRE_PERIODO: TStringField;
    DesarrolloMatActivoDetViewNOMBRE_SECCION: TStringField;
    DesarrolloMatActivoDetViewPERIODOLECTIVOID: TLongintField;
    DesarrolloMatActivoDetViewSECCIONID: TLongintField;
    dsDesarrolloMatActivoDetView: TDataSource;
    DesarrolloMatActivoDetView: TSQLQuery;
    MateriasHabilitadasViewMODULO: TStringField;
    procedure AgregarMatricula(ADesarrolloID: string);
    procedure Commit; override;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DataModuleDestroy(Sender: TObject);
    procedure EliminarDeuda(AMatriculaID: string);
    procedure EliminarMatricula(AMatriculaID: string);
    procedure GenerarDeuda(AMatriculaID: string);
    procedure MatriculaNewRecord(DataSet: TDataSet);
    procedure Rollback; override;
    procedure SetAlumno(AlumnoID: string);
    property Deudas: TGeneraDeudaDataModule read FDeudas write SetDeudas;
    property Estado: TEdicionEstado read FEstado write SetEstado;
    property Personas: TPersonasDataModule read FPersonas write SetPersonas;
    property Desarrollo: TDesarrolloMateriaDataModule
      read FDesarrollo write SetDesarrollo;
    property Asignacion: TAsignacionArancelesDataModule
      read FAsignacion write SetAsignacion;
    property AutoGenerarDeudas: boolean read FAutoGenerarDeudas
      write SetAutoGenerarDeudas;
  end;

var
  MatriculaDataModule: TMatriculaDataModule;

implementation

{$R *.lfm}

{ TMatriculaDataModule }

procedure TMatriculaDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  FPersonas := TPersonasDataModule.Create(Self, MasterDataModule);
  FPersonas.PersonasRoles.Filter := 'ESALUMNO = 1';
  FPersonas.PersonasRoles.Filtered := True;
  FDeudas := TGeneraDeudaDataModule.Create(Self, MasterDataModule);
  FDesarrollo := TDesarrolloMateriaDataModule.Create(Self, MasterDataModule);
  FAsignacion := TAsignacionArancelesDataModule.Create(Self, MasterDataModule);
  dsAlumnos.DataSet := FPersonas.PersonasRoles;
  QryList.Add(TObject(Matricula));
  AuxQryList.Add(TObject(MateriasHabilitadasView));
  AuxQryList.Add(TObject(DesarrolloMatActivoDetView));
  AuxQryList.Add(TObject(FDesarrollo.DesarrolloView));
  AuxQryList.Add(TObject(FPersonas.PersonasRoles));
  AuxQryList.Add(TObject(FAsignacion.ArancelesAsigandosView));
  Estado := edInicial;
  AutoGenerarDeudas := True;
end;

procedure TMatriculaDataModule.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FPersonas) then
    FreeAndNil(FPersonas);
  if Assigned(FDeudas) then
    FreeAndNil(FDeudas);
  if Assigned(FDesarrollo) then
    FreeAndNil(FDesarrollo);
  if Assigned(FAsignacion) then
    FreeAndNil(FAsignacion);
end;

procedure TMatriculaDataModule.EliminarDeuda(AMatriculaID: string);
var
  i: integer;
  x: TStringList;
begin
  x := TStringList.Create;
  try
    Deudas.Connect;
    if Deudas.Deuda.Lookup('MATRICULAID', AMatriculaID, 'ID') = null then
      Exit;
    Deudas.Deuda.Close;
    Deudas.Deuda.ServerFilter := '(ACTIVO = 1) AND (MATRICULAID = ' + AMatriculaID + ')';
    Deudas.Deuda.ServerFiltered := True;
    Deudas.Deuda.Open;
    Deudas.Deuda.First;
    while not Deudas.Deuda.EOF do
    begin
      x.Add(Deudas.Deuda.FieldByName('ID').AsString);
      Deudas.Deuda.Next;
    end;
    for i := 0 to Pred(x.Count) do
    begin
      Deudas.EliminarDeuda(x[i]);
    end;
  finally
    x.Free;
    Deudas.Deuda.Close;
    Deudas.Deuda.ServerFilter := '';
    Deudas.Deuda.ServerFiltered := False;
    Deudas.Deuda.Open;
  end;
end;

procedure TMatriculaDataModule.EliminarMatricula(AMatriculaID: string);
begin
  if Matricula.IsEmpty then
    Exit;
  if not Matricula.Locate('ID', AMatriculaID, []) then
    raise Exception.Create('Matricula no encontrada');
  Matricula.Edit;
  Matricula.FieldByName('ACTIVA').AsInteger := 0;
  Matricula.Post;
  EliminarDeuda(AMatriculaID);
end;

procedure TMatriculaDataModule.GenerarDeuda(AMatriculaID: string);
begin
  if not AutoGenerarDeudas then
    Exit;
  try
    if not Matricula.Locate('ID', AMatriculaID, []) then
      raise Exception.Create('No se encuentra la matricula');
    Desarrollo.OpenDataSets;
    if not Desarrollo.DesarrolloView.Locate('ID',
      Matricula.FieldByName('DESARROLLOMATERIAID').AsString, []) then
      raise Exception.Create('No se encuentra la seccion');
    Asignacion.ArancelesAsigandosView.Close;
    if Desarrollo.DesarrolloView.FieldByName('MODULOID').IsNull then
      Asignacion.ArancelesAsigandosView.ParamByName('MODULOID').AsInteger :=
        ASIGNACIONES_NULL_VALUE
    else
      Asignacion.ArancelesAsigandosView.ParamByName('MODULOID').AsString :=
        Desarrollo.DesarrolloView.FieldByName('MODULOID').AsString;
    Asignacion.ArancelesAsigandosView.ParamByName('MATERIAID').AsString :=
      Desarrollo.DesarrolloView.FieldByName('MATERIAID').AsString;
    Asignacion.ArancelesAsigandosView.ParamByName('DESARROLLOMATERIAID').AsString :=
      Desarrollo.DesarrolloView.FieldByName('ID').AsString;
    //Asignacion.ArancelesAsigandosView.Filter := 'ACTIVO = 1';
    //Asignacion.ArancelesAsigandosView.Filtered := True;
    Asignacion.ArancelesAsigandosView.Open;
    Asignacion.ArancelesAsigandosView.First;
    Deudas.Connect;
    while not Asignacion.ArancelesAsigandosView.EOF do
    begin
      if Deudas.Deuda.Locate('ARANCELID;MATRICULAID',
        VarArrayOf([Asignacion.ArancelesAsigandosView.FieldByName(
        'ARANCELID').AsString, AMatriculaID]), []) then
      begin
        Asignacion.ArancelesAsigandosView.Next;
        Continue;
      end;
      Deudas.SetPersona(Personas.PersonasRolesID.AsString);
      Deudas.SetArancel(Asignacion.ArancelesAsigandosView.FieldByName(
        'ARANCELID').AsString);
      Deudas.SetMatricula(AMatriculaID);
      Deudas.NewRecord;
      Deudas.Deuda.FieldByName('MATRICULAID').AsString :=
        AMatriculaID;
      Deudas.Deuda.FieldByName('ARANCELID').AsString :=
        Asignacion.ArancelesAsigandosView.FieldByName('ARANCELID').AsString;
      Deudas.Deuda.FieldByName('DESCRIPCION').AsString :=
        Desarrollo.DesarrolloView.FieldByName('NOMBRE_MATERIA_DET').AsString +
        ' / Periodo ' + Desarrollo.DesarrolloView.FieldByName('NOMBRE_PERIODO').AsString;
      Deudas.GenerarCuotas;
      Asignacion.ArancelesAsigandosView.Next;
    end;
    Deudas.SaveChanges;
  except
    on e: EDatabaseError do
    begin
      Deudas.DiscardChanges;
      raise;
    end;
    on e: Exception do
      raise;
  end;
end;

procedure TMatriculaDataModule.Rollback;
begin
  MasterDataModule.Rollback;
  MasterDataModule.Connect;
  Estado := edInicial;
  //CloseDataSets;
end;

procedure TMatriculaDataModule.SetAlumno(AlumnoID: string);
begin
  if not Personas.PersonasRoles.Locate('ID', AlumnoID, []) then
    raise Exception.Create('El alumno no existe');
  Matricula.Close;
  DesarrolloMatActivoDetView.Close;
  MateriasHabilitadasView.Close;
  MateriasHabilitadasView.ParamByName('ALUMNOID').AsString := AlumnoID;
  Matricula.ParamByName('ALUMNOID').AsString := AlumnoID;
  Matricula.Open;
  MateriasHabilitadasView.Open;
  DesarrolloMatActivoDetView.Open;
end;

procedure TMatriculaDataModule.SetPersonas(AValue: TPersonasDataModule);
begin
  if FPersonas = AValue then
    Exit;
  FPersonas := AValue;
end;

procedure TMatriculaDataModule.SetEstado(AValue: TEdicionEstado);
begin
  if FEstado = AValue then
    Exit;
  FEstado := AValue;
  (MasterDataModule as ISubject).Notify;
end;

procedure TMatriculaDataModule.SetDeudas(AValue: TGeneraDeudaDataModule);
begin
  if FDeudas = AValue then
    Exit;
  FDeudas := AValue;
end;

procedure TMatriculaDataModule.MatriculaNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenName);
end;

procedure TMatriculaDataModule.SetDesarrollo(AValue: TDesarrolloMateriaDataModule);
begin
  if FDesarrollo = AValue then
    Exit;
  FDesarrollo := AValue;
end;

procedure TMatriculaDataModule.SetAutoGenerarDeudas(AValue: boolean);
begin
  if FAutoGenerarDeudas = AValue then
    Exit;
  FAutoGenerarDeudas := AValue;
  (MasterDataModule as ISubject).Notify;
end;

procedure TMatriculaDataModule.DesarrolloMatActivoDetViewFilterRecord(
  DataSet: TDataSet;
  var Accept: boolean);
begin
  if (Matricula.State in [dsInactive, dsInsert, dsEdit]) then
    Accept := True
  else
  begin
    Accept := not Matricula.Locate('MATERIAID',
      DataSet.FieldByName('MATERIAID').AsString, []);
  end;
end;

procedure TMatriculaDataModule.MatriculaAfterOpen(DataSet: TDataSet);
begin
  DesarrolloMatActivoDetView.Close;
  DesarrolloMatActivoDetView.Open;
end;

procedure TMatriculaDataModule.SetAsignacion(AValue: TAsignacionArancelesDataModule);
begin
  if FAsignacion = AValue then
    Exit;
  FAsignacion := AValue;
end;


procedure TMatriculaDataModule.AgregarMatricula(ADesarrolloID: string);
begin
  if not DesarrolloMatActivoDetView.Locate('ID', ADesarrolloID, []) then
    raise Exception.Create('Seccion no encontrada');
  if Matricula.Locate('DESARROLLOMATERIAID', ADesarrolloID, []) then
    Exit;
  NewRecord;
  Matricula.FieldByName('DESARROLLOMATERIAID').AsString := ADesarrolloID;
  Matricula.FieldByName('ALUMNOPERSONAID').AsString :=
    Personas.PersonasRoles.FieldByName('ID').AsString;
  Matricula.FieldByName('FECHA').AsDateTime := Now;
  Matricula.FieldByName('ACTIVA').AsString := DB_TRUE;
  Matricula.FieldByName('CONFIRMADA').AsString := DB_FALSE;
  Matricula.FieldByName('DERECHOEXAMEN').AsString := DB_FALSE;
  Matricula.ApplyUpdates;
  MateriasHabilitadasView.Refresh;
end;

procedure TMatriculaDataModule.Commit;
begin
  inherited Commit;
  Estado := edGuardado;
end;

end.
