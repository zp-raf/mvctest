unit frmsgcddatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IBConnection, sqldb, FileUtil, Forms,
  observerSubject, DB, Dialogs, mvc, mensajes;

resourcestring
  rsFromRdbDatab = ' from rdb$database';
  rsGEN_ID = 'GEN_ID';
  rsSelectNextVa = 'select next value for ';

type

  { TSgcdDataModule }

  { para que pueda mandar actualizaciones a las vistas añadidas tiene que
    implementar la interfaz ISubject que tiene todos los metodos pertinentes }
  TSgcdDataModule = class(TDataModule, ISubject, IDBModel)
    procedure DataModuleDestroy(Sender: TObject);
  private
    FSubject: ISubject;
  published
    qryAux: TSQLQuery;
    db: TIBConnection;
    tran: TSQLTransaction;
    procedure Commit;
    procedure Connect;
    procedure DataModuleCreate(Sender: TObject);
    procedure dbAfterConnect(Sender: TObject);
    procedure dbAfterDisconnect(Sender: TObject);
    procedure Disconnect;
    function DevuelveValor(AQry: string; NombreCampoADevolver: string): string;
    function GetDBStatus: TDBInfo;
    function NextValue(gen: string): integer;
    procedure Rollback;

    { En la arquitectura Observer-Subject el sujeto notifica a los observadores
      (en nuestro caso las vistas) para que se actualicen. }
    property Subject: ISubject read FSubject implements ISubject;
  end;

var
  SgcdDataModule: TSgcdDataModule;
  DBInfo: TDBInfo;

implementation

{$R *.lfm}

{ TAcademiaDataModule }

procedure TSgcdDataModule.DataModuleDestroy(Sender: TObject);
begin

end;

procedure TSgcdDataModule.Commit;
begin
  tran.Commit;
end;

procedure TSgcdDataModule.Connect;
begin
  if DB.Connected then
    Exit
  else
    DB.Connected := True;
end;

procedure TSgcdDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  FSubject := TSubject.Create(Self);
end;

procedure TSgcdDataModule.dbAfterConnect(Sender: TObject);
begin
  if Subject <> nil then
    Subject.Notify; // mandar una notificacion a los observadores para que ejecuten el Update
end;

procedure TSgcdDataModule.dbAfterDisconnect(Sender: TObject);
begin
  if Subject <> nil then
    Subject.Notify; // mandar una notificacion a los observadores para que ejecuten el Update
end;

procedure TSgcdDataModule.Disconnect;
begin
  if DB.Connected and tran.Active then
  begin
    //tran.CloseDataSets;
    //tran.Rollback;
    DB.Connected := False;
  end
  else if not DB.Connected then
  begin
    DB.Connected := False;
  end;
end;

function TSgcdDataModule.DevuelveValor(AQry: string;
  NombreCampoADevolver: string): string;
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  with qryAux do
  begin
    Close;
    SQL.Clear;
    sl.AddStrings(SQL);
    SQL.Add(AQry);
    Open;
    ExecSQL;

    Result := FieldByName(NombreCampoADevolver).AsString;
    Close;
    SQL.Clear;
    SQL.AddStrings(sl);
  end;
  sl.Free;
end;

function TSgcdDataModule.GetDBStatus: TDBInfo;
begin
  with DBInfo do
  begin
    if DB.Connected then
    begin
      Connected := True;
      User := DB.UserName;
      Host := DB.HostName;
    end
    else
    begin
      Connected := False;
      User := '';
      Host := '';
    end;
  end;
  Result := DBInfo;
end;

function TSgcdDataModule.NextValue(gen: string): integer;
begin
  Result := StrToInt(DevuelveValor(rsSelectNextVa + gen + rsFromRdbDatab, rsGEN_ID));
end;

procedure TSgcdDataModule.Rollback;
begin
  tran.Rollback;
end;

end.
