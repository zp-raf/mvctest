unit frmaranceldatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, FileUtil, frmsgcddatamodule, frmquerydatamodule;

type

  { TArancelesDataModule }

  TArancelesDataModule = class(TQueryDataModule)
    Arancel: TSQLQuery;
    ArancelACTIVO: TSmallintField;
    ArancelDESCRIPCION: TStringField;
    ArancelGRUPO_PRODUCTOSID: TLongintField;
    ArancelID: TLongintField;
    ArancelMONTO: TFloatField;
    ArancelNOMBRE: TStringField;
    dsAranceles: TDataSource;
    ArancelesDetView: TSQLQuery;
    procedure ArancelFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure DataModuleCreate(Sender: TObject); override;
  end;

var
  ArancelesDataModule: TArancelesDataModule;

implementation

{$R *.lfm}

{ TArancelesDataModule }

procedure TArancelesDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  QryList.Add(TObject(Arancel));
  AuxQryList.Add(TObject(ArancelesDetView));
  SearchFieldList.Add('NOMBRE');
end;

procedure TArancelesDataModule.ArancelFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin

end;

end.

