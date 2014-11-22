unit frmsecciondatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmquerydatamodule, DB, sqldb;

resourcestring
  rsGenName = 'GEN_SECCION';

type

  { TSeccionDataModule }

  TSeccionDataModule = class(TQueryDataModule)
    dsSeccion: TDataSource;
    Seccion: TSQLQuery;
    SeccionDESCRIPCION: TStringField;
    SeccionID: TLongintField;
    SeccionNOMBRE: TStringField;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure SeccionNewRecord(DataSet: TDataSet);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  SeccionDataModule: TSeccionDataModule;

implementation

{$R *.lfm}

{ TSeccionDataModule }

procedure TSeccionDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  QryList.Add(TObject(Seccion));
end;

procedure TSeccionDataModule.SeccionNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenName);
end;

end.
