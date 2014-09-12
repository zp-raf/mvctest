unit frmacademiadatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, DB, FileUtil, frmsgcddatamodule, frmquerydatamodule, mvc;

resourcestring
  rsGenName = 'GEN_ACADEMIA';

type

  { TAcademiaDataModule }

  TAcademiaDataModule = class(TQueryDataModule, IModel)
    DataSource1: TDataSource;
    qry: TSQLQuery;
    qryID: TLongintField;
    qryNOMBRE: TStringField;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure qryNewRecord(DataSet: TDataSet);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  AcademiaDataModule: TAcademiaDataModule;

implementation

{$R *.lfm}
procedure TAcademiaDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  QryList.Add(TObject(qry));
end;

procedure TAcademiaDataModule.qryNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := FMasterDataModule.NextValue(rsGenName);
end;

end.
