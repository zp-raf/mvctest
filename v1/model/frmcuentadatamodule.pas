unit frmcuentadatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, DB, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmquerydatamodule;

resourcestring
  rsGenName = 'GEN_CUENTA';

type

  { TCuentaDataModule }

  TCuentaDataModule = class(TQueryDataModule)
    Cuenta: TSQLQuery;
    CuentaCODIGO: TStringField;
    CuentaID: TLongintField;
    CuentaNOMBRE: TStringField;
    CuentaTIPO_CUENTA: TStringField;
    dsCuenta: TDataSource;
    procedure CuentaFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure CuentaNewRecord(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject); override;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  CuentaDataModule: TCuentaDataModule;

implementation

{$R *.lfm}

{ TCuentaDataModule }

procedure TCuentaDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  QryList.Add(TObject(Cuenta));
  SearchFieldList.Add('NOMBRE');
  SearchFieldList.Add('CODIGO');
end;

procedure TCuentaDataModule.CuentaFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin
  FilterRecord(DataSet, Accept);
end;

procedure TCuentaDataModule.CuentaNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenName);
end;

end.
