unit frmcalificaciondatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, frmexamendatamodule,
  frmquerydatamodule, sqldb, DB, frmmatriculadatamodule, observerSubject,
  frmdesarrollodatamodule, sgcdTypes;

type

  { TCalificacionDataModule }

  TCalificacionDataModule = class(TQueryDataModule)
    CalificacionPUNTAJEOBTENIDO: TFloatField;
  private
    FEstado: TEdicionEstado;
    FExamenes: TExamenesDataModule;
    FMatricula: TMatriculaDataModule;
    procedure SetEstado(AValue: TEdicionEstado);
    procedure SetExamenes(AValue: TExamenesDataModule);
    procedure SetMatricula(AValue: TMatriculaDataModule);
  published
    CalificacionCOMENTARIOS: TStringField;
    CalificacionEXAMENID: TLongintField;
    CalificacionMATRICULAID: TLongintField;
    dsCalificacion: TDataSource;
    Calificacion: TSQLQuery;
    FloatField1: TFloatField;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DiscardChanges; override;
    procedure PrepararPlanillaCalificaciones(AExamenID: string);
    procedure SaveChanges; override;
    property Examenes: TExamenesDataModule read FExamenes write SetExamenes;
    property Matricula: TMatriculaDataModule read FMatricula write SetMatricula;
    property Estado: TEdicionEstado read FEstado write SetEstado;
  end;

var
  CalificacionDataModule: TCalificacionDataModule;

implementation

{$R *.lfm}

{ TCalificacionDataModule }

procedure TCalificacionDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  FExamenes := TExamenesDataModule.Create(Self, MasterDataModule);
  FMatricula := TMatriculaDataModule.Create(Self, MasterDataModule);
  QryList.Add(TObject(Calificacion));
  AuxQryList.Add(TObject(FExamenes.Examen));
  AuxQryList.Add(TObject(FMatricula.AlumnosMatriculasView));
  Estado := edInicial;
end;

procedure TCalificacionDataModule.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FExamenes) then
    FreeAndNil(FExamenes);
  if Assigned(FMatricula) then
    FreeAndNil(FMatricula);
end;

procedure TCalificacionDataModule.DiscardChanges;
begin
  inherited DiscardChanges;
  Estado := edInicial;
end;

procedure TCalificacionDataModule.PrepararPlanillaCalificaciones(AExamenID: string);
begin
  if not Examenes.Examen.Locate('ID', AExamenID, []) then
  begin
    raise Exception.Create('No se encuentra el examen');
    Exit;
  end;
  // vemos si ya hay calificaciones cargadas y si no, preparamos el dataset
  // para meter datos
  Calificacion.Close;
  Calificacion.ParamByName('EXAMENID').AsString :=
    Examenes.Examen.FieldByName('ID').AsString;
  Calificacion.Open;
  if Calificacion.IsEmpty then
  begin
    // traemos a todos los alumnos que estan matriculados en la materia
    Matricula.AlumnosMatriculasView.Close;
    Matricula.AlumnosMatriculasView.ServerFilter :=
      '(DESARROLLOMATERIAID = ' + Examenes.Examen.FieldByName(
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
      Calificacion.Insert;
      CalificacionEXAMENID.AsString := AExamenID;
      CalificacionMATRICULAID.AsInteger :=
        Matricula.AlumnosMatriculasView.FieldByName('ID_MATRICULA').AsInteger;
      CalificacionPUNTAJEOBTENIDO.AsFloat := 0.0;
      Matricula.AlumnosMatriculasView.Next;
    end;
  end;
  Estado := edEditando;
end;

procedure TCalificacionDataModule.SaveChanges;
begin
  inherited SaveChanges;
  Estado := edGuardado;
end;

procedure TCalificacionDataModule.SetExamenes(AValue: TExamenesDataModule);
begin
  if FExamenes = AValue then
    Exit;
  FExamenes := AValue;
end;

procedure TCalificacionDataModule.SetEstado(AValue: TEdicionEstado);
begin
  if FEstado = AValue then
    Exit;
  FEstado := AValue;
  (MasterDataModule as ISubject).Notify;
end;

procedure TCalificacionDataModule.SetMatricula(AValue: TMatriculaDataModule);
begin
  if FMatricula = AValue then
    Exit;
  FMatricula := AValue;
end;

end.
