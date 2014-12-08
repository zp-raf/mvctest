unit frmdesarrollodatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, sgcdTypes,
  frmquerydatamodule, sqldb, DB, frmsecciondatamodule, frmmateriasdatamodule,
  frmperiodosdatamodule, frmpersonasdatamodule;

resourcestring
  rsGenName = 'GENERATOR_DESARROLLO';

type

  { TDesarrolloMateriaDataModule }

  TDesarrolloMateriaDataModule = class(TQueryDataModule)
  private
    FMaterias: TMateriasDataModule;
    FPeriodos: TPeriodosDataModule;
    FPersonas: TPersonasDataModule;
    FSecciones: TSeccionDataModule;
    procedure SetMaterias(AValue: TMateriasDataModule);
    procedure SetPeriodos(AValue: TPeriodosDataModule);
    procedure SetPersonas(AValue: TPersonasDataModule);
    procedure SetSecciones(AValue: TSeccionDataModule);
  published
    DesarrolloMateriaACTIVO: TSmallintField;
    DesarrolloMateriaEMPLEADOPERSONAID: TLongintField;
    DesarrolloMateriaID: TLongintField;
    DesarrolloMateriaMATERIAID: TLongintField;
    DesarrolloMateriaPERIODOLECTIVOID: TLongintField;
    DesarrolloMateriaSECCIONID: TLongintField;
    DesarrolloView: TSQLQuery;
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
    DesarrolloViewNOMBRE_MAT_DETALLADO: TStringField;
    DesarrolloViewNOMBRE_MOD: TStringField;
    DesarrolloViewNOMBRE_PERIODO: TStringField;
    DesarrolloViewNOMBRE_SECCION: TStringField;
    DesarrolloViewPERIODOLECTIVOID: TLongintField;
    DesarrolloViewSECCIONID: TLongintField;
    dsDesarrolloMateria: TDataSource;
    DesarrolloMateria: TSQLQuery;
    dsDesarrolloView: TDataSource;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DesarrolloMateriaNewRecord(DataSet: TDataSet);
    procedure DiscardChanges; override;
    procedure DoDeleteAction(ADataSet: TDataSet); override;
    procedure EditCurrentRecord; override;
    procedure NewRecord; override;
    procedure SaveChanges; override;
    property Secciones: TSeccionDataModule read FSecciones write SetSecciones;
    property Materias: TMateriasDataModule read FMaterias write SetMaterias;
    property Periodos: TPeriodosDataModule read FPeriodos write SetPeriodos;
    property Personas: TPersonasDataModule read FPersonas write SetPersonas;
  end;

var
  DesarrolloMateriaDataModule: TDesarrolloMateriaDataModule;

implementation

{$R *.lfm}

{ TDesarrolloMateriaDataModule }

procedure TDesarrolloMateriaDataModule.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FSecciones) then
    FreeAndNil(FSecciones);
  if Assigned(FMaterias) then
    FreeAndNil(FMaterias);
  if Assigned(FPeriodos) then
    FreeAndNil(FPeriodos);
  if Assigned(FPersonas) then
    FreeAndNil(FPersonas);
end;

procedure TDesarrolloMateriaDataModule.SetMaterias(AValue: TMateriasDataModule);
begin
  if FMaterias = AValue then
    Exit;
  FMaterias := AValue;
end;

procedure TDesarrolloMateriaDataModule.SetPeriodos(AValue: TPeriodosDataModule);
begin
  if FPeriodos = AValue then
    Exit;
  FPeriodos := AValue;
end;

procedure TDesarrolloMateriaDataModule.SetPersonas(AValue: TPersonasDataModule);
begin
  if FPersonas = AValue then
    Exit;
  FPersonas := AValue;
end;

procedure TDesarrolloMateriaDataModule.SetSecciones(AValue: TSeccionDataModule);
begin
  if FSecciones = AValue then
    Exit;
  FSecciones := AValue;
end;

procedure TDesarrolloMateriaDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  FSecciones := TSeccionDataModule.Create(Self, MasterDataModule);
  FMaterias := TMateriasDataModule.Create(Self, MasterDataModule);
  FPeriodos := TPeriodosDataModule.Create(Self, MasterDataModule);
  FPersonas := TPersonasDataModule.Create(Self, MasterDataModule);
  QryList.Add(TObject(DesarrolloMateria));
  AuxQryList.Add(TObject(DesarrolloView));
  AuxQryList.Add(TObject(FSecciones.Seccion));
  AuxQryList.Add(TObject(FMaterias.MateriasDetView));
  AuxQryList.Add(TObject(FPeriodos.PeriodoLectivo));
  AuxQryList.Add(TObject(FPersonas.PersonasRoles));
  FPersonas.FilterData('', roProfesor);
end;

procedure TDesarrolloMateriaDataModule.DesarrolloMateriaNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenName);
  DataSet.FieldByName('ACTIVO').AsInteger := 1;
  DataSet.FieldByName('PERIODOLECTIVOID').AsString := Periodos.GetPeriodoActualID;
end;

procedure TDesarrolloMateriaDataModule.DiscardChanges;
begin
  DesarrolloMateria.DisableControls;
  DesarrolloView.DisableControls;
  FSecciones.Seccion.DisableControls;
  FMaterias.MateriasDetView.DisableControls;
  //FPeriodos.PeriodoLectivo.DisableControls;
  FPersonas.PersonasRoles.DisableControls;
  try
    inherited DiscardChanges;
  finally
    DesarrolloMateria.EnableControls;
    DesarrolloView.EnableControls;
    FSecciones.Seccion.EnableControls;
    FMaterias.MateriasDetView.EnableControls;
    //FPeriodos.PeriodoLectivo.EnableControls;
    FPersonas.PersonasRoles.EnableControls;
  end;
end;

procedure TDesarrolloMateriaDataModule.DoDeleteAction(ADataSet: TDataSet);
begin
  if not (ADataSet.State in [dsEdit]) then
    ADataSet.Edit;
  ADataSet.FieldByName('ACTIVO').AsString := DB_FALSE;
end;

procedure TDesarrolloMateriaDataModule.EditCurrentRecord;
begin
  DesarrolloMateria.DisableControls;
  DesarrolloView.DisableControls;
  FSecciones.Seccion.DisableControls;
  FMaterias.MateriasDetView.DisableControls;
  //FPeriodos.PeriodoLectivo.DisableControls;
  FPersonas.PersonasRoles.DisableControls;
  try
    inherited EditCurrentRecord;
  finally
    DesarrolloMateria.EnableControls;
    DesarrolloView.EnableControls;
    FSecciones.Seccion.EnableControls;
    FMaterias.MateriasDetView.EnableControls;
    //FPeriodos.PeriodoLectivo.EnableControls;
    FPersonas.PersonasRoles.EnableControls;
  end;
end;

procedure TDesarrolloMateriaDataModule.NewRecord;
begin
  DesarrolloMateria.DisableControls;
  DesarrolloView.DisableControls;
  FSecciones.Seccion.DisableControls;
  FMaterias.MateriasDetView.DisableControls;
  //FPeriodos.PeriodoLectivo.DisableControls;
  FPersonas.PersonasRoles.DisableControls;
  try
    inherited NewRecord;
  finally
    DesarrolloMateria.EnableControls;
    DesarrolloView.EnableControls;
    FSecciones.Seccion.EnableControls;
    FMaterias.MateriasDetView.EnableControls;
    //FPeriodos.PeriodoLectivo.EnableControls;
    FPersonas.PersonasRoles.EnableControls;
  end;
end;

procedure TDesarrolloMateriaDataModule.SaveChanges;
begin
  DesarrolloMateria.DisableControls;
  DesarrolloView.DisableControls;
  FSecciones.Seccion.DisableControls;
  FMaterias.MateriasDetView.DisableControls;
  //FPeriodos.PeriodoLectivo.DisableControls;
  FPersonas.PersonasRoles.DisableControls;
  try
    inherited SaveChanges;
  finally
    DesarrolloMateria.EnableControls;
    DesarrolloView.EnableControls;
    FSecciones.Seccion.EnableControls;
    FMaterias.MateriasDetView.EnableControls;
    //FPeriodos.PeriodoLectivo.EnableControls;
    FPersonas.PersonasRoles.EnableControls;
  end;
end;

end.
