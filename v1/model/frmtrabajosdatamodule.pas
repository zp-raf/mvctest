unit frmtrabajosdatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, sgcdTypes,
  frmquerydatamodule, sqldb, DB, frmdesarrollodatamodule;

resourcestring
  rsGenName = 'GEN_TRABAJO';

type

  { TTrabajosDataModule }

  TTrabajosDataModule = class(TQueryDataModule)
  private
    FDesarrollo: TDesarrolloMateriaDataModule;
    procedure SetDesarrollo(AValue: TDesarrolloMateriaDataModule);
  published
    dsTrabajosDetView: TDataSource;
    TrabajosDetView: TSQLQuery;
    StringField1: TStringField;
    TrabajosDetViewACTIVO: TSmallintField;
    TrabajosDetViewDESARROLLOMATERIAID: TLongintField;
    TrabajosDetViewDESCRIPCION: TStringField;
    TrabajosDetViewFECHAFIN: TDateField;
    TrabajosDetViewFECHAINICIO: TDateField;
    TrabajosDetViewID: TLongintField;
    TrabajosDetViewMATERIA: TStringField;
    TrabajosDetViewNOMBRE: TStringField;
    TrabajosDetViewPESO: TFloatField;
    TrabajosDetViewPROFESOR: TStringField;
    TrabajosDetViewPUNTAJEMAX: TFloatField;
    TrabajosDetViewSECCION: TStringField;
    dsTrabajo: TDataSource;
    Trabajo: TSQLQuery;
    TrabajoACTIVO: TSmallintField;
    TrabajoDESARROLLOMATERIAID: TLongintField;
    TrabajoDESCRIPCION: TStringField;
    TrabajoFECHAFIN: TDateField;
    TrabajoFECHAINICIO: TDateField;
    TrabajoID: TLongintField;
    TrabajoNOMBRE: TStringField;
    TrabajoPESO: TFloatField;
    TrabajoPUNTAJEMAX: TFloatField;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DoDeleteAction(ADataSet: TDataSet); override;
    procedure TrabajoNewRecord(DataSet: TDataSet);
    property Desarrollo: TDesarrolloMateriaDataModule
      read FDesarrollo write SetDesarrollo;
  end;

var
  TrabajosDataModule: TTrabajosDataModule;

implementation

{$R *.lfm}

{ TTrabajosDataModule }

procedure TTrabajosDataModule.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FDesarrollo) then
    FreeAndNil(FDesarrollo);
end;

procedure TTrabajosDataModule.DoDeleteAction(ADataSet: TDataSet);
begin
  if not (ADataSet.State in [dsEdit]) then
    ADataSet.Edit;
  ADataSet.FieldByName('ACTIVO').AsString := DB_FALSE;
end;

procedure TTrabajosDataModule.SetDesarrollo(AValue: TDesarrolloMateriaDataModule);
begin
  if FDesarrollo = AValue then
    Exit;
  FDesarrollo := AValue;
end;

procedure TTrabajosDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  FDesarrollo := TDesarrolloMateriaDataModule.Create(Self, MasterDataModule);
  QryList.Add(TObject(Trabajo));
  AuxQryList.Add(TObject(FDesarrollo.DesarrolloView));
  AuxQryList.Add(TObject(TrabajosDetView));
  SearchFieldList.Add('NOMBRE');
  SearchFieldList.Add('NOMBRE_MAT_DETALLADO');
end;

procedure TTrabajosDataModule.TrabajoNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenName);
  DataSet.FieldByName('ACTIVO').AsInteger := 1;
end;

end.
