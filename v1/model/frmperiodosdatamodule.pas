unit frmperiodosdatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, sgcdTypes,
  frmquerydatamodule, sqldb, DB;

resourcestring
  rsGenName = 'SEQ_PERIODOLECTIVO';

type

  { TPeriodosDataModule }

  TPeriodosDataModule = class(TQueryDataModule)
    dsPeriodo: TDataSource;
    PeriodoLectivo: TSQLQuery;
    PeriodoLectivoACTIVO: TSmallintField;
    PeriodoLectivoDESCRIPCION: TStringField;
    PeriodoLectivoFECHAFIN: TDateField;
    PeriodoLectivoFECHAINICIO: TDateField;
    PeriodoLectivoID: TLongintField;
    PeriodoLectivoNOMBRE: TStringField;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure PeriodoLectivoNewRecord(DataSet: TDataSet);
    function GetPeriodoActualID: string;
    function HayPeriodoActivo: boolean;
  end;

var
  PeriodosDataModule: TPeriodosDataModule;

implementation

{$R *.lfm}

{ TPeriodosDataModule }

procedure TPeriodosDataModule.PeriodoLectivoNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenName);
  DataSet.FieldByName('ACTIVO').AsString:= DB_FALSE;
end;

function TPeriodosDataModule.GetPeriodoActualID: string;
begin
  if PeriodoLectivo.State = dsInactive then
    Exit;
  Result := PeriodoLectivo.Lookup('ACTIVO', '1', 'ID');
end;

function TPeriodosDataModule.HayPeriodoActivo: boolean;
begin
  if PeriodoLectivo.State = dsInactive then
    raise Exception.Create('Datos no disponibles');
  if PeriodoLectivo.Lookup('ACTIVO', DB_TRUE, 'ID') <> null then
    Result := True
  else
    Result := False;
end;

procedure TPeriodosDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  QryList.Add(TObject(PeriodoLectivo));
  SearchFieldList.Add('NOMBRE');
  SearchFieldList.Add('DESCRIPCION');
end;

end.
