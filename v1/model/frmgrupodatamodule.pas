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
  GruposHabilitadosView.Close;
  GruposHabilitadosView.ParamByName('IDGRUPO').AsInteger :=
    DataSet.FieldByName('ID').AsInteger;
  GruposHabilitadosView.Open;
end;

end.
