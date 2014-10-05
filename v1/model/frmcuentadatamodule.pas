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
    CuentaAux: TSQLQuery;
    CuentaAuxCODIGO: TStringField;
    CuentaAuxCUENTA_PADRE: TLongintField;
    CuentaAuxID: TLongintField;
    CuentaAuxNATURALEZA: TStringField;
    CuentaAuxNOMBRE: TStringField;
    CuentaCODIGO: TStringField;
    CuentaCUENTA_PADRE: TLongintField;
    CuentaID: TLongintField;
    CuentaNATURALEZA: TStringField;
    CuentaNOMBRE: TStringField;
    dsCuentaAux: TDataSource;
    dsCuenta: TDataSource;
    Cuenta: TSQLQuery;
    procedure CuentaFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure CuentaNewRecord(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject); override;
    procedure SaveChanges; override;
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
  //AuxQryList.Add(TObject(CuentaAux));
  SearchFieldList.Add('NOMBRE');
  SearchFieldList.Add('CODIGO');
end;

procedure TCuentaDataModule.SaveChanges;
begin
  inherited SaveChanges;
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
