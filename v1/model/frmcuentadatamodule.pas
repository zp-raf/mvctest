unit frmcuentadatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, DB, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmquerydatamodule, mvc;

resourcestring
  rsGenName = 'GEN_CUENTA';

type

  { TCuentaDataModule }

  TCuentaDataModule = class(TQueryDataModule)
    CuentaAux: TSQLQuery;
    CuentaAuxCODIGO: TStringField;
    CuentaAuxID: TLongintField;
    CuentaAuxNATURALEZA: TStringField;
    CuentaAuxNOMBRE: TStringField;
    CuentaCODIGO: TStringField;
    CuentaCUENTA_PADRE: TLongintField;
    CuentaID: TLongintField;
    CuentaNATURALEZA: TStringField;
    CuentaNOMBRE: TStringField;
    CuentaNOMBRE_CODIGO: TStringField;
    dsCuentaAux: TDataSource;
    dsCuenta: TDataSource;
    Cuenta: TSQLQuery;
    CuentasContables: TSQLQuery;
    procedure ActualizarDetallesCuenta(Sender: IController; var EsCuentaHija: boolean);
    procedure CuentaCalcFields(DataSet: TDataSet);
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
  AuxQryList.Add(TObject(CuentaAux));
  AuxQryList.Add(TObject(CuentasContables));
  SearchFieldList.Add('NOMBRE');
  SearchFieldList.Add('CODIGO');
end;

procedure TCuentaDataModule.ActualizarDetallesCuenta(Sender: IController;
  var EsCuentaHija: boolean);
begin
  // si se selecciona una cuenta padre se tiene que cambiar el codigo de la
  // cuenta y su naturaleza
  if CuentaCUENTA_PADRE.IsNull or (Trim(CuentaCUENTA_PADRE.AsString) = '') then
  begin
    CuentaCODIGO.Clear;
    EsCuentaHija := False;
  end
  else
  begin
    CuentaCODIGO.Value := CuentaAuxCODIGO.Value;
    CuentaNATURALEZA.Value := CuentaAuxNATURALEZA.Value;
    EsCuentaHija := True;
  end;
end;

procedure TCuentaDataModule.CuentaCalcFields(DataSet: TDataSet);
begin
  DataSet.FieldByName('NOMBRE_CODIGO').AsString :=
    DataSet.FieldByName('CODIGO').AsString + '. ' +
    DataSet.FieldByName('NOMBRE').AsString;
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
