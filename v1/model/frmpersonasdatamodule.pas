unit frmpersonasdatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, frmsgcddatamodule,
  frmquerydatamodule, sqldb, DB;

resourcestring
  rsGenName = 'GEN_ACADEMIA';
  rsGenNameDir = 'GEN_DIRECCION';
  rsGenNameTel = 'GEN_TEL';

type

  { TPersonasDataModule }

  TPersonasDataModule = class(TQueryDataModule)
  private
    { private declarations }
  public
    { public declarations }
  published
    dsPersonasRoles: TDataSource;
    DireccionBARRIO: TStringField;
    DireccionCIUDAD: TStringField;
    DireccionDEPARTAMENTO: TStringField;
    DireccionDESCRIPCION: TStringField;
    DireccionDIRECCION: TStringField;
    DireccionID: TLongintField;
    DireccionIDPERSONA: TLongintField;
    dsTelefono: TDataSource;
    dsDireccion: TDataSource;
    dsPersona: TDataSource;
    Persona: TSQLQuery;
    Direccion: TSQLQuery;
    PersonaACTIVO: TSmallintField;
    PersonaAPELLIDO: TStringField;
    PersonaCEDULA: TStringField;
    PersonaFECHANAC: TDateField;
    PersonaID: TLongintField;
    PersonaNOMBRE: TStringField;
    PersonaNOMBRECOMPLETO: TStringField;
    PersonaRUC: TStringField;
    PersonaSEXO: TStringField;
    PersonasRoles: TSQLQuery;
    Telefono: TSQLQuery;
    TelefonoDESCRIPCION: TStringField;
    TelefonoID: TLongintField;
    TelefonoIDPERSONA: TLongintField;
    TelefonoNUMERO: TStringField;
    TelefonoPREFIJO: TStringField;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DireccionAfterInsert(DataSet: TDataSet);
    procedure PersonaAfterScroll(DataSet: TDataSet);
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
  inherited;
  QryList.Add(TObject(Persona));
  QryList.Add(TObject(Direccion));
  QryList.Add(TObject(Telefono));
  AuxQryList.Add(TObject(PersonasRoles));
  SearchFieldList.Add('NOMBRE');
  SearchFieldList.Add('APELLIDO');
  SearchFieldList.Add('CEDULA');
  Persona.OnFilterRecord:=@FilterRecord;
end;

procedure TPersonasDataModule.DireccionAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('IDPERSONA').Value := Persona.FieldByName('ID').Value;
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenNameDir);
end;

procedure TPersonasDataModule.PersonaAfterScroll(DataSet: TDataSet);
begin
  Telefono.Close;
  Direccion.Close;
  Telefono.ParamByName('ID').Value := DataSet.FieldByName('ID').Value;
  Direccion.ParamByName('ID').Value := DataSet.FieldByName('ID').Value;
  Telefono.Open;
  Direccion.Open;
end;

procedure TPersonasDataModule.PersonaNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenName);
end;

procedure TPersonasDataModule.TelefonoAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('IDPERSONA').Value := Persona.FieldByName('ID').Value;
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenNameTel);
end;

end.
