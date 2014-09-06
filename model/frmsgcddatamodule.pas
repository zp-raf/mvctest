unit frmsgcddatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IBConnection, sqldb, FileUtil, Forms, mvc,
  observerSubject, contnrs, DB, Dialogs;

resourcestring
  rsFromRdbDatab = ' from rdb$database';
  rsGEN_ID = 'GEN_ID';
  rsSelectNextVa = 'select next value for ';

type

  { TQryList }

  TQryList = class(TFPObjectList)
  end;

  { TsgcdDataModule }

  { Aca se implementa la interfaz de modelo. Ponemos virtual para que los
    descendientes puedan abrir y cerrar los datasets cuando ocurra las
    desconexiones }

  TSgcdDataModule = class(TDataModule, IModel, ISubject)
  private
    FSubject: ISubject;
  published
    qryAux: TSQLQuery;
    db: TIBConnection;
    tran: TSQLTransaction;
    function ArePendingChanges(Sender: IController): boolean;
    procedure Connect(Sender: IController);
    procedure DataModuleCreate(Sender: TObject); virtual;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DiscardChanges(Sender: IController);
    procedure Disconnect(Sender: IController);
    procedure EditCurrentRecord(Sender: IController);
    function GetCurrentRecordText(Sender: IController): string;
    function GetDBStatus(Sender: IController): TDBStatus;
    procedure NewRecord(Sender: IController);
    function NextValue(gen: string): integer;
    procedure RefreshDataSets(Sender: IController);
    procedure SaveChanges(Sender: IController);
    procedure dbAfterConnect(Sender: TObject);
    procedure dbAfterDisconnect(Sender: TObject);
    function DevuelveValor(qry: string; NombreCampoADevolver: string): string;
    property Subject: ISubject read FSubject implements ISubject;

    { En la arquitectura Observer-Subject el sujeto notifica a los observadores
      (en nuestro caso las vistas) para que se actualicen. }

  end;

var
  SgcdDataModule: TSgcdDataModule;
  QryList: TQryList;

implementation

{$R *.lfm}

{ TSgcdDataModule }

procedure TSgcdDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;

  { creamos una lista donde ponemos en orden los datasets para que sean
  operados automaticamente }
  QryList := TQryList.Create(False);
  FSubject := TSubject.Create(Self);
end;

procedure TSgcdDataModule.DataModuleDestroy(Sender: TObject);
begin
  QryList.Free;
  inherited;
end;

function TSgcdDataModule.ArePendingChanges(Sender: IController): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to QryList.Count - 1 do
  begin
    with TSQLQuery(QryList.Items[i]) do
    begin
      if (State in [dsEdit, dsInsert]) or (RowsAffected > 0) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;
end;

procedure TSgcdDataModule.Connect(Sender: IController);
var
  i: integer;
begin

  //primero la conexion a base de datos
  if not DB.Connected then
    DB.Connected := True;

  //segundo se abren los datasets
  for i := 0 to QryList.Count - 1 do
  begin
    with TSQLQuery(QryList.Items[i]) do
    begin
      if not Active then
        Active := True;
    end;
  end;
end;

procedure TSgcdDataModule.DiscardChanges(Sender: IController);
var
  i: integer;
begin
  for i := 0 to QryList.Count - 1 do
  begin
    with TSQLQuery(QryList.Items[i]) do
    begin
      if (State in [dsEdit, dsInsert]) or (RowsAffected > 0) then
        CancelUpdates;
    end;
  end;
end;

procedure TSgcdDataModule.SaveChanges(Sender: IController);
var
  i: integer;
begin
  for i := 0 to QryList.Count - 1 do
  begin
    with TSQLQuery(QryList.Items[i]) do
    begin
      try
        //DisableControls;
        ApplyUpdates;
        tran.Commit;
      finally
        //EnableControls;
      end;
    end;
  end;
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

function TSgcdDataModule.DevuelveValor(qry: string;
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
    SQL.Add(qry);
    Open;
    ExecSQL;

    Result := FieldByName(NombreCampoADevolver).AsString;
    Close;
    SQL.Clear;
    SQL.AddStrings(sl);
  end;
  sl.Free;
end;

procedure TSgcdDataModule.Disconnect(Sender: IController);
var
  i: integer;
begin
  //primero se cierran los datasets
  for i := 0 to QryList.Count - 1 do
  begin
    with TSQLQuery(QryList.Items[i]) do
    begin
      if Active then
        Active := False;
    end;
  end;

  //despues la conexion a base de datos
  if DB.Connected and tran.Active then
  begin
    tran.CloseDataSets;
    tran.Rollback;
    DB.Connected := False;
  end
  else
  begin
    DB.Connected := False;
  end;
end;

procedure TSgcdDataModule.EditCurrentRecord(Sender: IController);
var
  i: integer;
begin
  for i := 0 to QryList.Count - 1 do
  begin
    with TSQLQuery(QryList.Items[i]) do
    begin
      try
        //DisableControls;
        if Active and not (State in [dsInsert]) then
          Edit
        else if (State in [dsInsert]) or (RowsAffected > 0) then
        begin
          Cancel;
          Edit;
        end
        else if not Active then
          Abort;
      finally
        //EnableControls;
      end;
    end;
  end;
end;

function TSgcdDataModule.GetCurrentRecordText(Sender: IController): string;
var
  i, j: integer;
  msg: TStringList;
begin
  try
    msg := TStringList.Create();
    for i := 0 to QryList.Count - 1 do
    begin
      for j := 0 to TSQLQuery(QryList.Items[i]).Fields.Count - 1 do
      begin
        msg.Add(TSQLQuery(QryList.Items[i]).Fields.Fields[j].FieldName +
          ': ' + TSQLQuery(QryList.Items[i]).Fields.Fields[j].AsString);
      end;
    end;
    Result := msg.Text;
  finally
    msg.Free
  end;
end;

function TSgcdDataModule.GetDBStatus(Sender: IController): TDBStatus;
begin
  if DB.Connected then
    Result := Connected
  else
    Result := Disconnected;
end;

procedure TSgcdDataModule.NewRecord(Sender: IController);
var
  i: integer;
begin
  for i := 0 to QryList.Count - 1 do
  begin
    with TSQLQuery(QryList.Items[i]) do
    begin
      try
        //DisableControls;
        if Active and not (State in [dsEdit]) then
          Append
        else if (State in [dsEdit]) or (RowsAffected > 0) then
        begin
          Cancel;
          Append;
        end
        else if not Active then
          Abort;
      finally
        //EnableControls;
      end;
    end;
  end;
end;

function TSgcdDataModule.NextValue(gen: string): integer;
begin
  Result := StrToInt(DevuelveValor(rsSelectNextVa + gen + rsFromRdbDatab, rsGEN_ID));
end;

procedure TSgcdDataModule.RefreshDataSets(Sender: IController);
var
  i: integer;
begin
  for i := 0 to QryList.Count - 1 do
  begin
    with TSQLQuery(QryList.Items[i]) do
    begin
      try
        //DisableControls;
        if not (State in [dsEdit, dsInsert]) then
          Refresh;
      finally
        //EnableControls;
      end;
    end;
  end;
end;

end.
