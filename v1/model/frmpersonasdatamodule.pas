unit frmpersonasdatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmquerydatamodule, mvc, sqldb, DB;

resourcestring
  rsGenName = 'GEN_ACADEMIA';
  rsGenNameDir = 'GEN_DIRECCION';
  rsGenNameTel = 'GEN_TEL';

type

  { TPersonasDataModule }

  TPersonasDataModule = class(TQueryDataModule, IModel)
    dsTelefono: TDataSource;
    dsDireccion: TDataSource;
    dsPersona: TDataSource;
    Persona: TSQLQuery;
    Direccion: TSQLQuery;
    Telefono: TSQLQuery;
    procedure Connect; override;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DireccionAfterInsert(DataSet: TDataSet);
    procedure Disconnect; override;
    procedure PersonaNewRecord(DataSet: TDataSet);
    procedure TelefonoAfterInsert(DataSet: TDataSet);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  PersonasDataModule: TPersonasDataModule;

implementation

{$R *.lfm}

{ TPersonasDataModule }

procedure TPersonasDataModule.Connect;
begin
  inherited Connect;
  Direccion.Open;
  Telefono.Open;
end;

procedure TPersonasDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  QryList.Add(TObject(Persona));
  SearchFieldList.Add('NOMBRE');
  SearchFieldList.Add('APELLIDO');
  SearchFieldList.Add('CEDULA');
end;

procedure TPersonasDataModule.DireccionAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('IDPERSONA').Value := Persona.FieldByName('ID').Value;
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenNameDir);
end;

procedure TPersonasDataModule.Disconnect;
begin
  Direccion.Close;
  Telefono.Close;
  inherited Disconnect;
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
