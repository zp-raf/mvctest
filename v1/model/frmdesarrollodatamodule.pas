unit frmdesarrollodatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmquerydatamodule, sqldb, DB;

resourcestring
  rsGenName = 'GENERATOR_DESARROLLO';

type

  { TDesarrolloMateriaDataModule }

  TDesarrolloMateriaDataModule = class(TQueryDataModule)
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
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DesarrolloMateriaNewRecord(DataSet: TDataSet);
  end;

var
  DesarrolloMateriaDataModule: TDesarrolloMateriaDataModule;

implementation

{$R *.lfm}

{ TDesarrolloMateriaDataModule }

procedure TDesarrolloMateriaDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  QryList.Add(TObject(DesarrolloMateria));
  AuxQryList.Add(TObject(DesarrolloView));
end;

procedure TDesarrolloMateriaDataModule.DesarrolloMateriaNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenName);
end;

end.
