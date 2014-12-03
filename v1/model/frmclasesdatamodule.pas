unit frmclasesdatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmquerydatamodule, sqldb, DB, frmdesarrollodatamodule;

resourcestring
  rsGenName = 'GEN_CLASE';

type

  { TClasesDataModule }

  TClasesDataModule = class(TQueryDataModule)
    StringField1: TStringField;
    procedure ClaseNewRecord(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DataModuleDestroy(Sender: TObject);
  private
    FDesarrollo: TDesarrolloMateriaDataModule;
    procedure SetDesarrollo(AValue: TDesarrolloMateriaDataModule);
  published
    ClaseACTIVIDADES: TStringField;
    ClaseDESARROLLOMATERIAID: TLongintField;
    ClaseEVALUACION: TStringField;
    ClaseFECHA: TDateField;
    ClaseID: TLongintField;
    ClaseMATERIALES: TStringField;
    ClaseOBJETIVOGENERAL: TStringField;
    ClaseOBJETIVOSESPECIFICOS: TStringField;
    ClaseTEMA: TStringField;
    dsClase: TDataSource;
    Clase: TSQLQuery;
    property Desarrollo: TDesarrolloMateriaDataModule
      read FDesarrollo write SetDesarrollo;
  end;

var
  ClasesDataModule: TClasesDataModule;

implementation

{$R *.lfm}

{ TClasesDataModule }

procedure TClasesDataModule.ClaseNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger:=MasterDataModule.NextValue(rsGenName);
end;

procedure TClasesDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  FDesarrollo := TDesarrolloMateriaDataModule.Create(Self, MasterDataModule);
  QryList.Add(TObject(Clase));
  AuxQryList.Add(FDesarrollo.DesarrolloView);
  SearchFieldList.Add('TEMA');
end;

procedure TClasesDataModule.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FDesarrollo) then
    FreeAndNil(FDesarrollo);
end;

procedure TClasesDataModule.SetDesarrollo(AValue: TDesarrolloMateriaDataModule);
begin
  if FDesarrollo = AValue then
    Exit;
  FDesarrollo := AValue;
end;

end.
