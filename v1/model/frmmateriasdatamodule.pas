unit frmmateriasdatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmquerydatamodule, sqldb, DB;

resourcestring
  rsGenName = 'GEN_MATERIAS';

type

  { TMateriasDataModule }

  TMateriasDataModule = class(TQueryDataModule)
    dsMateriasDetView: TDataSource;
    dsMateria: TDataSource;
    Materia: TSQLQuery;
    MateriaBIBLIOGRAFIA: TStringField;
    MateriaCONTENIDO: TStringField;
    MateriaDESCRIPCION: TStringField;
    MateriaDURACION: TStringField;
    MateriaESTRATEGIAS: TStringField;
    MateriaEVALUACION: TStringField;
    MateriaGRUPOID: TLongintField;
    MateriaHABILITADA: TSmallintField;
    MateriaID: TLongintField;
    MateriaJUSTIFICACION: TStringField;
    MateriaMATERIALES: TStringField;
    MateriaMODULOID: TLongintField;
    MateriaNOMBRE: TStringField;
    MateriaOBJETIVOS: TStringField;
    MateriasDetView: TSQLQuery;
    MateriasDetViewBIBLIOGRAFIA: TStringField;
    MateriasDetViewCONTENIDO: TStringField;
    MateriasDetViewDESCRIPCION: TStringField;
    MateriasDetViewDURACION: TStringField;
    MateriasDetViewESTRATEGIAS: TStringField;
    MateriasDetViewEVALUACION: TStringField;
    MateriasDetViewGRUPOID: TLongintField;
    MateriasDetViewHABILITADA: TSmallintField;
    MateriasDetViewID: TLongintField;
    MateriasDetViewJUSTIFICACION: TStringField;
    MateriasDetViewMATERIALES: TStringField;
    MateriasDetViewNOMBRE: TStringField;
    MateriasDetViewNOMBRE_DETALLE: TStringField;
    MateriasDetViewNOMBRE_GRUPO: TStringField;
    MateriasDetViewNOMBRE_MODULO: TStringField;
    MateriasDetViewOBJETIVOS: TStringField;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure MateriaNewRecord(DataSet: TDataSet);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  MateriasDataModule: TMateriasDataModule;

implementation

{$R *.lfm}

{ TMateriasDataModule }

procedure TMateriasDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  QryList.Add(TObject(Materia));
  AuxQryList.Add(TObject(MateriasDetView));
end;

procedure TMateriasDataModule.MateriaNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenName);
end;

end.
