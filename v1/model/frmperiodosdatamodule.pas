unit frmperiodosdatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
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
  end;

var
  PeriodosDataModule: TPeriodosDataModule;

implementation

{$R *.lfm}

{ TPeriodosDataModule }

procedure TPeriodosDataModule.PeriodoLectivoNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenName);
end;

function TPeriodosDataModule.GetPeriodoActualID: string;
begin
  if PeriodoLectivo.State = dsInactive then
    Exit;
  Result := PeriodoLectivo.Lookup('ACTIVO', '1', 'ID');
end;

procedure TPeriodosDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  QryList.Add(TObject(PeriodoLectivo));
  SearchFieldList.Add('NOMBRE');
  SearchFieldList.Add('DESCRIPCION');
end;

end.
