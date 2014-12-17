unit frmexamendatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, sgcdTypes,
  frmquerydatamodule, sqldb, DB, frmdesarrollodatamodule, frmcodigosdatamodule,
  frmpersonasdatamodule;

resourcestring
  rsGenName = 'SEQ_EXAMEN';

const
  INTERVENTOR = 1;
  VEEDOR = 2;

type

  { TExamenesDataModule }

  TExamenesDataModule = class(TQueryDataModule)
    StringField3: TStringField;
    procedure ExamenAfterScroll(DataSet: TDataSet);
    procedure ExamenPersonaExternaAfterInsert(DataSet: TDataSet);
    procedure ExamenPersonaExternaBeforePost(DataSet: TDataSet);
  private
    FCodigos: TCodigosDataModule;
    FDesarrollo: TDesarrolloMateriaDataModule;
    FPersonas: TPersonasDataModule;
    procedure SetCodigos(AValue: TCodigosDataModule);
    procedure SetDesarrollo(AValue: TDesarrolloMateriaDataModule);
    procedure SetPersonas(AValue: TPersonasDataModule);
  published
    dsExamen: TDataSource;
    Examen: TSQLQuery;
    ExamenACTIVO: TSmallintField;
    ExamenDESARROLLOMATERIAID: TLongintField;
    ExamenFECHA: TDateField;
    ExamenID: TLongintField;
    ExamenOBSERVACIONES: TStringField;
    ExamenPersonaExternaEXAMENID: TLongintField;
    ExamenPersonaExternaPERSONAEXTERNAPERSONAID: TLongintField;
    ExamenPESO: TFloatField;
    ExamenPUNTAJEMAX: TFloatField;
    ExamenPersonaExterna: TSQLQuery;
    ExamenPersonaExternaROL: TLongintField;
    dsExamenPersonaExterna: TDataSource;
    StringField1: TStringField;
    StringField2: TStringField;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DoDeleteAction(ADataSet: TDataSet); override;
    procedure ExamenNewRecord(DataSet: TDataSet);
    property Codigos: TCodigosDataModule read FCodigos write SetCodigos;
    property Desarrollo: TDesarrolloMateriaDataModule
      read FDesarrollo write SetDesarrollo;
    property Personas: TPersonasDataModule read FPersonas write SetPersonas;
  end;

var
  ExamenesDataModule: TExamenesDataModule;

implementation

{$R *.lfm}

{ TExamenesDataModule }

procedure TExamenesDataModule.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FDesarrollo) then
    FreeAndNil(FDesarrollo);
  if Assigned(FCodigos) then
    FreeAndNil(FCodigos);
  if Assigned(FPersonas) then
    FreeAndNil(FPersonas);
end;

procedure TExamenesDataModule.DoDeleteAction(ADataSet: TDataSet);
begin
  if not (ADataSet.State in [dsEdit]) then
    ADataSet.Edit;
  ADataSet.FieldByName('ACTIVO').AsString := DB_FALSE;
end;

procedure TExamenesDataModule.SetDesarrollo(AValue: TDesarrolloMateriaDataModule);
begin
  if FDesarrollo = AValue then
    Exit;
  FDesarrollo := AValue;
end;

procedure TExamenesDataModule.SetPersonas(AValue: TPersonasDataModule);
begin
  if FPersonas = AValue then
    Exit;
  FPersonas := AValue;
end;

procedure TExamenesDataModule.ExamenAfterScroll(DataSet: TDataSet);
begin
  ExamenPersonaExterna.Close;
  ExamenPersonaExterna.ParamByName('EXAMENID').AsInteger :=
    DataSet.FieldByName('ID').AsInteger;
  ExamenPersonaExterna.Open;
end;

procedure TExamenesDataModule.ExamenPersonaExternaAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('EXAMENID').AsInteger := Examen.FieldByName('ID').AsInteger;
end;

procedure TExamenesDataModule.ExamenPersonaExternaBeforePost(DataSet: TDataSet);
begin
  if DataSet.FieldByName('PERSONAEXTERNAPERSONAID').IsNull or
    DataSet.FieldByName('ROL').IsNull then
    Abort;
end;

procedure TExamenesDataModule.SetCodigos(AValue: TCodigosDataModule);
begin
  if FCodigos = AValue then
    Exit;
  FCodigos := AValue;
end;

procedure TExamenesDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  FDesarrollo := TDesarrolloMateriaDataModule.Create(Self, MasterDataModule);
  FCodigos := TCodigosDataModule.Create(Self, MasterDataModule);
  FCodigos.SetObject('ROL_EXAMEN');
  FPersonas := TPersonasDataModule.Create(Self, MasterDataModule);
  FPersonas.PersonasRoles.Filter :=
    '(ESPROVEEDOR = 0 AND ESALUMNO = 0 AND ESADMINISTRATIVO = 0)';
  FPersonas.PersonasRoles.Filtered := True;
  QryList.Add(TObject(Examen));
  DetailList.Add(TObject(ExamenPersonaExterna));
  AuxQryList.Add(TObject(FDesarrollo.DesarrolloView));
  AuxQryList.Add(TObject(FCodigos.Codigos));
  AuxQryList.Add(TObject(FPersonas.PersonasRoles));
end;

procedure TExamenesDataModule.ExamenNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenName);
  DataSet.FieldByName('ACTIVO').AsInteger := 1;
end;

end.
