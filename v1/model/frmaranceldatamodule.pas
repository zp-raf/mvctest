unit frmaranceldatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, FileUtil, frmsgcddatamodule, frmquerydatamodule;

type

  { TArancelesDataModule }

  TArancelesDataModule = class(TQueryDataModule)
    Arancel: TSQLQuery;
    dsAranceles: TDataSource;
    procedure ArancelFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure DataModuleCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ArancelesDataModule: TArancelesDataModule;

implementation

{$R *.lfm}

{ TArancelesDataModule }

procedure TArancelesDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  QryList.Add(Arancel);
  SearchFieldList.Add('NOMBRE');
end;

procedure TArancelesDataModule.ArancelFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin

end;

end.

