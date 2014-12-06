unit frmmateriasdatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmquerydatamodule, sqldb, DB, frmgrupodatamodule, frmmodulodatamodule;

resourcestring
  rsGenName = 'GEN_MATERIA';

type

  { TMateriasDataModule }

  TMateriasDataModule = class(TQueryDataModule)
    dsGetMateriasPrerreq: TDataSource;
    dsPrerrequisitos: TDataSource;
    GetMateriasPrerreqGRUPOID: TLongintField;
    GetMateriasPrerreqID: TLongintField;
    GetMateriasPrerreqMODULOGENERAL: TSmallintField;
    GetMateriasPrerreqMODULOID: TLongintField;
    GetMateriasPrerreqNOMBRE: TStringField;
    GetMateriasPrerreqNOMBRE_GRUPO: TStringField;
    GetMateriasPrerreqNOMBRE_MAT: TStringField;
    GetMateriasPrerreqNOMBRE_MOD: TStringField;
    JerarquiaGruposANTERIOR: TLongintField;
    JerarquiaGruposGRUPOID: TLongintField;
    Prerrequisitos: TSQLQuery;
    PrerrequisitosMATERIAID: TLongintField;
    PrerrequisitosMATERIAID_PRE: TLongintField;
    GetMateriasPrerreq: TSQLQuery;
    StringField1: TStringField;
    StringField2: TStringField;
    StringFieldMateria: TStringField;
    procedure DataModuleDestroy(Sender: TObject);
    procedure MateriaAfterScroll(DataSet: TDataSet);
    procedure MateriaGRUPOIDChange(Sender: TField);
    procedure PrerrequisitosAfterInsert(DataSet: TDataSet);
    procedure PrerrequisitosAfterPost(DataSet: TDataSet);
  private
    FGrupos: TGrupoDataModule;
    FModulos: TModuloDataModule;
    procedure SetGrupos(AValue: TGrupoDataModule);
    procedure SetModulos(AValue: TModuloDataModule);
  published
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
    procedure DiscardChanges; override;
    procedure MateriaNewRecord(DataSet: TDataSet);
    procedure SaveChanges; override;
    property Modulos: TModuloDataModule read FModulos write SetModulos;
    property Grupos: TGrupoDataModule read FGrupos write SetGrupos;
  end;

var
  MateriasDataModule: TMateriasDataModule;

implementation

{$R *.lfm}

{ TMateriasDataModule }

procedure TMateriasDataModule.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FGrupos) then
    FreeAndNil(FGrupos);
  if Assigned(FModulos) then
    FreeAndNil(FModulos);
end;

procedure TMateriasDataModule.MateriaAfterScroll(DataSet: TDataSet);
begin
  if not (DataSet.State in [dsInsert]) then
  begin
    GetMateriasPrerreq.Close;
    GetMateriasPrerreq.ParamByName('GID').AsString :=
      DataSet.FieldByName('GRUPOID').AsString;
    GetMateriasPrerreq.Open;
  end;

  Prerrequisitos.Close;
  Prerrequisitos.ParamByName(
    'MATERIAID').AsInteger :=
    DataSet.FieldByName('ID').AsInteger;
  Prerrequisitos.Open;
end;

procedure TMateriasDataModule.MateriaGRUPOIDChange(Sender: TField);
begin
  GetMateriasPrerreq.Close;
  GetMateriasPrerreq.ParamByName('GID').AsInteger :=
    Sender.AsInteger;
  GetMateriasPrerreq.Open;
end;

procedure TMateriasDataModule.PrerrequisitosAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('MATERIAID').AsInteger := Materia.FieldByName('ID').AsInteger;
end;

procedure TMateriasDataModule.PrerrequisitosAfterPost(DataSet: TDataSet);
begin

end;

procedure TMateriasDataModule.SetGrupos(AValue: TGrupoDataModule);
begin
  if FGrupos = AValue then
    Exit;
  FGrupos := AValue;
end;

procedure TMateriasDataModule.SetModulos(AValue: TModuloDataModule);
begin
  if FModulos = AValue then
    Exit;
  FModulos := AValue;
end;

procedure TMateriasDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  FGrupos := TGrupoDataModule.Create(Self, MasterDataModule);
  FModulos := TModuloDataModule.Create(Self, MasterDataModule);
  QryList.Add(TObject(Materia));
  AuxQryList.Add(TObject(MateriasDetView));
  AuxQryList.Add(TObject(FGrupos.Grupo));
  AuxQryList.Add(TObject(FModulos.Modulo));
  AuxQryList.Add(TObject(Prerrequisitos));
  SearchFieldList.Add('NOMBRE');
  Materia.OnFilterRecord := @FilterRecord;
  FGrupos.Grupo.Filter := 'HABILITADO = 1';
  FGrupos.Grupo.Filtered := True;
  FModulos.Modulo.Filter := 'HABILITADO = 1';
  FModulos.Modulo.Filtered := True;
end;

procedure TMateriasDataModule.DiscardChanges;
begin
  Prerrequisitos.Cancel;
  inherited DiscardChanges;
end;

procedure TMateriasDataModule.MateriaNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenName);
  DataSet.FieldByName('HABILITADA').AsInteger := 1;
end;

procedure TMateriasDataModule.SaveChanges;
begin
  inherited SaveChanges;
  Prerrequisitos.ApplyUpdates;
end;

end.
