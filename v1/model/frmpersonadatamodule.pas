unit frmpersonadatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmsgcddatamodule, IBConnection, sqldb, DB, mvc, frmquerydatamodule;

resourcestring
  rsGenName = 'GEN_ACADEMIA';

type

  { TPersonasDataModule }

  TPersonasDataModule = class(TQueryDataModule)
    DireccionBARRIO: TStringField;
    DireccionCIUDAD: TStringField;
    DireccionDEPARTAMENTO: TStringField;
    DireccionDESCRIPCION: TStringField;
    DireccionDIRECCION: TStringField;
    DireccionID: TLongintField;
    DireccionIDPERSONA: TLongintField;
    dsDireccion: TDatasource;
    dsPersonas: TDatasource;
    dsTelefono: TDatasource;
    Persona: TSQLQuery;
    Direccion: TSQLQuery;
    PersonaAPELLIDO: TStringField;
    PersonaCEDULA: TStringField;
    PersonaFECHANAC: TDateField;
    PersonaID: TLongintField;
    PersonaNOMBRE: TStringField;
    PersonaSEXO: TStringField;
    Telefono: TSQLQuery;
    TelefonoDESCRIPCION: TStringField;
    TelefonoID: TLongintField;
    TelefonoIDPERSONA: TLongintField;
    TelefonoNUMERO: TStringField;
    TelefonoPREFIJO: TStringField;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DireccionAfterInsert(DataSet: TDataSet);
    procedure PersonaNewRecord(DataSet: TDataSet);
    procedure TelefonoAfterInsert(DataSet: TDataSet);
  end;

var
  PersonasDataModule: TPersonasDataModule;

implementation

{$R *.lfm}

{ TPersonasDataModule }

procedure TPersonasDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited DataModuleCreate(Sender);
  QryList.Add(TObject(Persona));
  QryList.Add(TObject(Direccion));
  QryList.Add(TObject(Telefono));
end;

procedure TPersonasDataModule.DireccionAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('IDPERSONA').AsInteger := Persona.FieldByName('ID').AsInteger;
end;

procedure TPersonasDataModule.PersonaNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := FMasterDataModule.NextValue(rsGenName);
end;

procedure TPersonasDataModule.TelefonoAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('IDPERSONA').AsInteger := Persona.FieldByName('ID').AsInteger;
end;

end.
