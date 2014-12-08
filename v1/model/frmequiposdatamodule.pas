unit frmequiposdatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, sgcdTypes,
  frmquerydatamodule, sqldb, DB;

resourcestring
  rsGenName = 'SEQ_EQUIPO';

type

  { TEquiposDataModule }

  TEquiposDataModule = class(TQueryDataModule)
    dsEquipo: TDataSource;
    Equipo: TSQLQuery;
    EquipoACTIVO: TSmallintField;
    EquipoDESCRIPCION: TStringField;
    EquipoFECHAINGRESO: TDateField;
    EquipoID: TLongintField;
    EquipoNOMBRE: TStringField;
    EquipoNROSERIE: TStringField;
    PrestamoEQUIPOID: TLongintField;
    PrestamoFECHAFIN: TDateField;
    PrestamoFECHAINICIO: TDateField;
    PrestamoID: TLongintField;
    PrestamoPERSONAID: TLongintField;
    StringField1: TStringField;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DoDeleteAction(ADataSet: TDataSet); override;
    procedure EquipoNewRecord(DataSet: TDataSet);
  end;

var
  EquiposDataModule: TEquiposDataModule;

implementation

{$R *.lfm}

{ TEquiposDataModule }

procedure TEquiposDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  QryList.Add(TObject(Equipo));
  SearchFieldList.Add('NOMBRE');
  SearchFieldList.Add('NROSERIE');
  Equipo.OnFilterRecord := @FilterRecord;
end;

procedure TEquiposDataModule.DoDeleteAction(ADataSet: TDataSet);
begin
  if not (ADataSet.State in [dsEdit]) then
    ADataSet.Edit;
  ADataSet.FieldByName('ACTIVO').AsString := DB_FALSE;
end;

procedure TEquiposDataModule.EquipoNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenName);
  DataSet.FieldByName('ACTIVO').AsInteger := 1;
end;

end.
