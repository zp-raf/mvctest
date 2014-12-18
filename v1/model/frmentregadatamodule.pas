unit frmentregadatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, sgcdTypes,
  frmquerydatamodule, sqldb, DB, frmtrabajosdatamodule, frmpersonasdatamodule,
  observerSubject, frmmatriculadatamodule;

type

  { TEntregaDataModule }

  TEntregaDataModule = class(TQueryDataModule)
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    procedure EntregaAfterInsert(DataSet: TDataSet);
    procedure EntregaBeforePost(DataSet: TDataSet);
  private
    FEstado: TEdicionEstado;
    FMatricula: TMatriculaDataModule;
    FAlumnos: TPersonasDataModule;
    FTrabajos: TTrabajosDataModule;
    procedure SetEstado(AValue: TEdicionEstado);
    procedure SetMatricula(AValue: TMatriculaDataModule);
    procedure SetPersonas(AValue: TPersonasDataModule);
    procedure SetTrabajos(AValue: TTrabajosDataModule);
  published
    EntregaALUMNOPERSONAID: TLongintField;
    EntregaCOMENTARIOS: TStringField;
    EntregaFECHAENTREGA: TDateField;
    EntregaPUNTAJEOBTENIDO: TFloatField;
    EntregaTRABAJOID: TLongintField;
    dsEntrega: TDataSource;
    Entrega: TSQLQuery;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DiscardChanges; override;
    procedure PrepararPlanillaTrabajo(ATrabajoID: string);
    procedure SaveChanges; override;
    property Estado: TEdicionEstado read FEstado write SetEstado;
    property Matricula: TMatriculaDataModule read FMatricula write SetMatricula;
    property Alumnos: TPersonasDataModule read FAlumnos write SetPersonas;
    property Trabajos: TTrabajosDataModule read FTrabajos write SetTrabajos;
  end;

var
  EntregaDataModule: TEntregaDataModule;

implementation

{$R *.lfm}

{ TEntregaDataModule }

procedure TEntregaDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  FAlumnos := TPersonasDataModule.Create(Self, MasterDataModule);
  FMatricula := TMatriculaDataModule.Create(Self, MasterDataModule);
  FTrabajos := TTrabajosDataModule.Create(Self, MasterDataModule);
  FAlumnos.FilterData('', roAlumno);
  QryList.Add(TObject(Entrega));
  AuxQryList.Add(TObject(FAlumnos.PersonasRoles));
  AuxQryList.Add(TObject(FTrabajos.TrabajosDetView));
  AuxQryList.Add(TObject(FMatricula.AlumnosMatriculasView));
  Estado := edInicial;
end;

procedure TEntregaDataModule.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FTrabajos) then
    FreeAndNil(FTrabajos);
  if Assigned(FAlumnos) then
    FreeAndNil(FAlumnos);
  if Assigned(FMatricula) then
    FreeAndNil(FMatricula);
end;

procedure TEntregaDataModule.DiscardChanges;
begin
  inherited DiscardChanges;
  Estado := edInicial;
end;

procedure TEntregaDataModule.SetPersonas(AValue: TPersonasDataModule);
begin
  if FAlumnos = AValue then
    Exit;
  FAlumnos := AValue;
end;

procedure TEntregaDataModule.EntregaAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('FECHAENTREGA').AsDateTime := Now;
end;

procedure TEntregaDataModule.EntregaBeforePost(DataSet: TDataSet);
begin
  if DataSet.FieldByName('PUNTAJEOBTENIDO').Value < 0 then
    raise Exception.Create('Puntaje invalido');
end;

procedure TEntregaDataModule.SetEstado(AValue: TEdicionEstado);
begin
  if FEstado = AValue then
    Exit;
  FEstado := AValue;
  (MasterDataModule as ISubject).Notify;
end;

procedure TEntregaDataModule.SetMatricula(AValue: TMatriculaDataModule);
begin
  if FMatricula = AValue then
    Exit;
  FMatricula := AValue;
end;

procedure TEntregaDataModule.SetTrabajos(AValue: TTrabajosDataModule);
begin
  if FTrabajos = AValue then
    Exit;
  FTrabajos := AValue;
end;

procedure TEntregaDataModule.PrepararPlanillaTrabajo(ATrabajoID: string);
begin
  if not Trabajos.TrabajosDetView.Locate('ID', ATrabajoID, []) then
    raise Exception.Create('Trabajo no encontrado');
  Entrega.Close;
  Entrega.ParamByName('TRABAJOID').AsString := ATrabajoID;
  Entrega.Open;
  if Entrega.IsEmpty then
  begin
    Matricula.AlumnosMatriculasView.Close;
    Matricula.AlumnosMatriculasView.ServerFilter :=
      '(DESARROLLOMATERIAID = ' + Trabajos.TrabajosDetView.FieldByName(
      'DESARROLLOMATERIAID').AsString + ')';
    Matricula.AlumnosMatriculasView.ServerFiltered := True;
    Matricula.AlumnosMatriculasView.Open;
    if Matricula.AlumnosMatriculasView.IsEmpty then
    begin
      raise Exception.Create('No hay alumnos inscriptos a la seccion');
    end;
    Matricula.AlumnosMatriculasView.First;
    while not Matricula.AlumnosMatriculasView.EOF do
    begin
      Entrega.Insert;
      EntregaTRABAJOID.AsString := ATrabajoID;
      EntregaALUMNOPERSONAID.AsString :=
        Matricula.AlumnosMatriculasView.FieldByName('ALUMNOPERSONAID').AsString;
      EntregaPUNTAJEOBTENIDO.AsFloat := 0.0;
      Matricula.AlumnosMatriculasView.Next;
    end;
  end;
  Estado := edEditando;
end;

procedure TEntregaDataModule.SaveChanges;
begin
  inherited SaveChanges;
  Estado := edGuardado;
end;

end.
