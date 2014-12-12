unit frmasignacionarancelesdatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmquerydatamodule, sqldb, DB, frmaranceldatamodule, frmmodulodatamodule,
  frmmateriasdatamodule, frmdesarrollodatamodule;

const
  ASIGNACIONES_NULL_VALUE = -99;

type

  { TAsignacionArancelesDataModule }

  TAsignacionArancelesDataModule = class(TQueryDataModule)
    ArancelesAsigandosView: TSQLQuery;
    ArancelesAsigandosViewACTIVO: TSmallintField;
    ArancelesAsigandosViewARANCELID: TLongintField;
    ArancelesAsigandosViewDESARROLLOMATERIAID: TLongintField;
    ArancelesAsigandosViewMATERIAID: TLongintField;
    ArancelesAsigandosViewMODULOID: TLongintField;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    StringField5: TStringField;
    StringField6: TStringField;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DesarrolloArancelesBeforePost(DataSet: TDataSet);
    procedure MateriaArancelesBeforePost(DataSet: TDataSet);
    procedure ModuloArancelesBeforePost(DataSet: TDataSet);
  private
    FAranceles: TArancelesDataModule;
    FDesarrollos: TDesarrolloMateriaDataModule;
    FMaterias: TMateriasDataModule;
    FModulos: TModuloDataModule;
    procedure SetAranceles(AValue: TArancelesDataModule);
    procedure SetDesarrollos(AValue: TDesarrolloMateriaDataModule);
    procedure SetMaterias(AValue: TMateriasDataModule);
    procedure SetModulos(AValue: TModuloDataModule);
  published
    DesarrolloArancelesACTIVO: TSmallintField;
    DesarrolloArancelesARANCELID: TLongintField;
    DesarrolloArancelesDESARROLLOMATERIAID: TLongintField;
    dsModuloAranceles: TDataSource;
    dsMateriaAranceles: TDataSource;
    dsDesarrolloAranceles: TDataSource;
    MateriaArancelesACTIVO: TSmallintField;
    MateriaArancelesARANCELID: TLongintField;
    MateriaArancelesMATERIAID: TLongintField;
    ModuloAranceles: TSQLQuery;
    MateriaAranceles: TSQLQuery;
    DesarrolloAranceles: TSQLQuery;
    ModuloArancelesACTIVO: TSmallintField;
    ModuloArancelesARANCELID: TLongintField;
    ModuloArancelesMODULOID: TLongintField;
    procedure DataModuleCreate(Sender: TObject); override;
    property Aranceles: TArancelesDataModule read FAranceles write SetAranceles;
    property Modulos: TModuloDataModule read FModulos write SetModulos;
    property Materias: TMateriasDataModule read FMaterias write SetMaterias;
    property Desarrollos: TDesarrolloMateriaDataModule
      read FDesarrollos write SetDesarrollos;
  end;

var
  AsignacionArancelesDataModule: TAsignacionArancelesDataModule;

implementation

{$R *.lfm}

{ TAsignacionArancelesDataModule }

procedure TAsignacionArancelesDataModule.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FAranceles) then
    FreeAndNil(FAranceles);
  if Assigned(FModulos) then
    FreeAndNil(FModulos);
  if Assigned(FMaterias) then
    FreeAndNil(FMaterias);
  if Assigned(FDesarrollos) then
    FreeAndNil(FDesarrollos);
end;

procedure TAsignacionArancelesDataModule.DesarrolloArancelesBeforePost(
  DataSet: TDataSet);
begin
  if DataSet.FieldByName('ARANCELID').IsNull or DataSet.FieldByName('ACTIVO').IsNull or
    DataSet.FieldByName('DESARROLLOMATERIAID').IsNull then
    Abort;
end;

procedure TAsignacionArancelesDataModule.MateriaArancelesBeforePost(DataSet: TDataSet);
begin
  if DataSet.FieldByName('ARANCELID').IsNull or DataSet.FieldByName('ACTIVO').IsNull or
    DataSet.FieldByName('MATERIAID').IsNull then
    Abort;
end;

procedure TAsignacionArancelesDataModule.ModuloArancelesBeforePost(DataSet: TDataSet);
begin
  if DataSet.FieldByName('ARANCELID').IsNull or DataSet.FieldByName('ACTIVO').IsNull or
    DataSet.FieldByName('MODULOID').IsNull then
    Abort;
end;

procedure TAsignacionArancelesDataModule.SetAranceles(AValue: TArancelesDataModule);
begin
  if FAranceles = AValue then
    Exit;
  FAranceles := AValue;
end;

procedure TAsignacionArancelesDataModule.SetDesarrollos(
  AValue: TDesarrolloMateriaDataModule);
begin
  if FDesarrollos = AValue then
    Exit;
  FDesarrollos := AValue;
end;

procedure TAsignacionArancelesDataModule.SetMaterias(AValue: TMateriasDataModule);
begin
  if FMaterias = AValue then
    Exit;
  FMaterias := AValue;
end;

procedure TAsignacionArancelesDataModule.SetModulos(AValue: TModuloDataModule);
begin
  if FModulos = AValue then
    Exit;
  FModulos := AValue;
end;

procedure TAsignacionArancelesDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited DataModuleCreate(Sender);
  FAranceles := TArancelesDataModule.Create(Self, MasterDataModule);
  FModulos := TModuloDataModule.Create(Self, MasterDataModule);
  FMaterias := TMateriasDataModule.Create(Self, MasterDataModule);
  FDesarrollos := TDesarrolloMateriaDataModule.Create(Self, MasterDataModule);
  QryList.Add(TObject(ModuloAranceles));
  QryList.Add(TObject(MateriaAranceles));
  QryList.Add(TObject(DesarrolloAranceles));
  AuxQryList.Add(TObject(FModulos.Modulo));
  AuxQryList.Add(TObject(FMaterias.MateriasDetView));
  AuxQryList.Add(TObject(FDesarrollos.DesarrolloView));
  AuxQryList.Add(TObject(FAranceles.ArancelesDetView));
end;

end.
