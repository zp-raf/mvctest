unit frmgrupodatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmquerydatamodule, sqldb, DB;

resourcestring
  rsGenName = 'GEN_GRUPO';

type

  { TGrupoDataModule }

  TGrupoDataModule = class(TQueryDataModule)
    dsGruposHabilitadosView: TDataSource;
    dsGrupo: TDataSource;
    Grupo: TSQLQuery;
    GrupoANTERIOR: TLongintField;
    GrupoAuxANTERIOR: TLongintField;
    GrupoAuxDESCRIPCION: TStringField;
    GrupoAuxHABILITADO: TLongintField;
    GrupoAuxID: TLongintField;
    GrupoAuxNOMBRE: TStringField;
    GrupoDESCRIPCION: TStringField;
    GrupoHABILITADO: TLongintField;
    GrupoID: TLongintField;
    GrupoNOMBRE: TStringField;
    GruposHabilitadosView: TSQLQuery;
    GruposHabilitadosViewANTERIOR: TLongintField;
    GruposHabilitadosViewDESCRIPCION: TStringField;
    GruposHabilitadosViewHABILITADO: TLongintField;
    GruposHabilitadosViewID: TLongintField;
    GruposHabilitadosViewNOMBRE: TStringField;
    GrupoAux: TSQLQuery;
    StringField1: TStringField;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure GrupoAfterScroll(DataSet: TDataSet);
    procedure GrupoNewRecord(DataSet: TDataSet);
  end;

var
  GrupoDataModule: TGrupoDataModule;

implementation

{$R *.lfm}

{ TGrupoDataModule }

procedure TGrupoDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  QryList.Add(TObject(Grupo));
  AuxQryList.Add(TObject(GruposHabilitadosView));
  AuxQryList.Add(TObject(GrupoAux));
  SearchFieldList.Add('NOMBRE');
  SearchFieldList.Add('DESCRIPCION');
end;

procedure TGrupoDataModule.GrupoAfterScroll(DataSet: TDataSet);
begin
  GruposHabilitadosView.Close;
  GruposHabilitadosView.ParamByName('IDGRUPO').AsInteger :=
    DataSet.FieldByName('ID').AsInteger;
  GruposHabilitadosView.Open;
end;

procedure TGrupoDataModule.GrupoNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenName);
  DataSet.FieldByName('HABILITADO').AsInteger := 1;
  GruposHabilitadosView.Close;
  GruposHabilitadosView.ParamByName('IDGRUPO').AsInteger :=
    DataSet.FieldByName('ID').AsInteger;
  GruposHabilitadosView.Open;
end;

end.
