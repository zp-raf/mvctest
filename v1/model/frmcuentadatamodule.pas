unit frmcuentadatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, DB, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmquerydatamodule, mvc, observerSubject, frmpersonasdatamodule;

resourcestring
  rsGenName = 'GEN_CUENTA';

type

  { TCuentaDataModule }

  TCuentaDataModule = class(TQueryDataModule)
    StringField1: TStringField;
    procedure DataModuleDestroy(Sender: TObject);
  private
    FPersonas: TPersonasDataModule;
    procedure SetPersonas(AValue: TPersonasDataModule);
  published
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
    CuentaPERSONAID: TLongintField;
    CuentasContablesCODIGO: TStringField;
    CuentasContablesCODIGO_NOMBRE: TStringField;
    CuentasContablesCUENTA_PADRE: TLongintField;
    CuentasContablesID: TLongintField;
    CuentasContablesNATURALEZA: TStringField;
    CuentasContablesNOMBRE: TStringField;
    dsCuentasContables: TDataSource;
    dsCuentaAux: TDataSource;
    dsCuenta: TDataSource;
    Cuenta: TSQLQuery;
    CuentasContables: TSQLQuery;
    procedure CuentaCalcFields(DataSet: TDataSet);
    procedure CuentaCUENTA_PADREChange(Sender: TField);
    procedure CuentaNewRecord(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject); override;
    property Personas: TPersonasDataModule read FPersonas write SetPersonas;
  end;

var
  CuentaDataModule: TCuentaDataModule;

implementation

{$R *.lfm}

{ TCuentaDataModule }

procedure TCuentaDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  FPersonas := TPersonasDataModule.Create(Self, MasterDataModule);
  FPersonas.Persona.Filter := 'ACTIVO = 1';
  FPersonas.Persona.Filtered := True;
  FPersonas.SetReadOnly(True);
  QryList.Add(TObject(Cuenta));
  AuxQryList.Add(TObject(CuentaAux));
  AuxQryList.Add(TObject(CuentasContables));
  AuxQryList.Add(TObject(FPersonas.Persona));
  SearchFieldList.Add('NOMBRE');
  SearchFieldList.Add('CODIGO');
  Cuenta.OnFilterRecord:=@FilterRecord;
end;

procedure TCuentaDataModule.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FPersonas) then
    FreeAndNil(FPersonas);
end;

procedure TCuentaDataModule.SetPersonas(AValue: TPersonasDataModule);
begin
  if FPersonas = AValue then
    Exit;
  FPersonas := AValue;
end;

procedure TCuentaDataModule.CuentaCalcFields(DataSet: TDataSet);
begin
  DataSet.FieldByName('NOMBRE_CODIGO').AsString :=
    DataSet.FieldByName('CODIGO').AsString + '. ' +
    DataSet.FieldByName('NOMBRE').AsString;
end;

procedure TCuentaDataModule.CuentaCUENTA_PADREChange(Sender: TField);
begin
  // si se selecciona una cuenta padre se tiene que cambiar el codigo de la
  // cuenta y su naturaleza
  if Sender.IsNull or (Trim(Sender.AsString) = '') then
    CuentaCODIGO.Clear
  else
  begin
    CuentaCODIGO.Value := CuentaAuxCODIGO.Value;
    CuentaNATURALEZA.Value := CuentaAuxNATURALEZA.Value;
  end;
  (MasterDataModule as ISubject).Notify;
end;

procedure TCuentaDataModule.CuentaNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenName);
end;

end.
