unit frmacademiadatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, DB, FileUtil, frmsgcddatamodule, frmquerydatamodule;

resourcestring
  rsGenName = 'SEQ_ACADEMIA';

type

  { TAcademiaDataModule }

  TAcademiaDataModule = class(TQueryDataModule)
    DataSource1: TDataSource;
    qry: TSQLQuery;
    qryID: TLongintField;
    qryNOMBRE: TStringField;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure qryNewRecord(DataSet: TDataSet);
  end;

var
  AcademiaDataModule: TAcademiaDataModule;

implementation

{$R *.lfm}
procedure TAcademiaDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  QryList.Add(TObject(qry));
  SearchFieldList.Add('NOMBRE');
  qry.OnFilterRecord:=@FilterRecord;
end;

procedure TAcademiaDataModule.qryNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := FMasterDataModule.NextValue(rsGenName);
end;

end.
