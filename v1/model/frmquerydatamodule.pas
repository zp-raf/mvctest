unit frmquerydatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, frmsgcddatamodule, mvc, mensajes, sqldb, DB;

type
  TSearchFieldList = class(TStringList)
  end;

  { TQueryDataModule }

  TQueryDataModule = class(TDataModule, IModel)
  public
    constructor Create(AOwner: TComponent; AMaster: IDBModel); overload;
    function GetQryList: TQryList;
  private
    FQryList: TQryList;
    FSearchFieldList: TSearchFieldList;
    procedure SetSearchFieldList(AValue: TSearchFieldList);
  protected
    FMasterDataModule: IDBModel;
    procedure SetQryList(AValue: TQryList);
  published
    procedure Connect; virtual;
    procedure DataModuleCreate(Sender: TObject); virtual;
    procedure DiscardChanges;
    procedure Disconnect; virtual;
    procedure FilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure EditCurrentRecord;
    procedure NewRecord;
    procedure RefreshDataSets;
    procedure SaveChanges;
    function ArePendingChanges: boolean;
    function GetCurrentRecordText: string;
    function GetDBStatus: TDBInfo;
    property QryList: TQryList read GetQryList write SetQryList;
    property SearchFieldList: TSearchFieldList
      read FSearchFieldList write SetSearchFieldList;
  end;

var
  QueryDataModule: TQueryDataModule;

implementation

{$R *.lfm}

function TQueryDataModule.ArePendingChanges: boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to FQryList.Count - 1 do
  begin
    with TSQLQuery(FQryList.Items[i]) do
    begin
      if (State in [dsEdit, dsInsert]) or (RowsAffected > 0) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;
end;

procedure TQueryDataModule.Connect;
var
  i: integer;
begin

  //primero la conexion a base de datos
  FMasterDataModule.Connect;

  //segundo se abren los datasets
  for i := 0 to FQryList.Count - 1 do
  begin
    with TSQLQuery(FQryList.Items[i]) do
    begin
      if not Active then
        Active := True;
    end;
  end;
end;

procedure TQueryDataModule.DataModuleCreate(Sender: TObject);
begin
  FQryList := TQryList.Create(False);
  FSearchFieldList := TSearchFieldList.Create;
end;

constructor TQueryDataModule.Create(AOwner: TComponent; AMaster: IDBModel);
begin
  inherited Create(AOwner);
  FMasterDataModule := AMaster;
end;

procedure TQueryDataModule.DiscardChanges;
var
  i: integer;
begin
  for i := 0 to FQryList.Count - 1 do
  begin
    with TSQLQuery(FQryList.Items[i]) do
    begin
      if (State in [dsEdit, dsInsert]) or (RowsAffected > 0) then
        CancelUpdates;
    end;
  end;
end;

procedure TQueryDataModule.Disconnect;
var
  i: integer;
begin
  //primero se cierran los datasets
  for i := 0 to FQryList.Count - 1 do
  begin
    with TSQLQuery(FQryList.Items[i]) do
    begin
      if Active then
        Active := False;
    end;
  end;

  //despues la conexion a base de datos
  FMasterDataModule.Disconnect;
end;

procedure TQueryDataModule.FilterRecord(DataSet: TDataSet; var Accept: boolean);
var
  i: integer;
begin
  for i := 0 to (FSearchFieldList.Count -1) do
  begin

  end;
end;

procedure TQueryDataModule.EditCurrentRecord;
var
  i: integer;
begin
  for i := 0 to FQryList.Count - 1 do
  begin
    with TSQLQuery(FQryList.Items[i]) do
    begin
      try
        DisableControls;
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
        EnableControls;
      end;
    end;
  end;
end;

procedure TQueryDataModule.NewRecord;
var
  i: integer;
begin
  for i := 0 to FQryList.Count - 1 do
  begin
    with TSQLQuery(FQryList.Items[i]) do
    begin
      try
        DisableControls;
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
        EnableControls;
      end;
    end;
  end;
end;

procedure TQueryDataModule.RefreshDataSets;
var
  i: integer;
begin
  for i := 0 to FQryList.Count - 1 do
  begin
    with TSQLQuery(FQryList.Items[i]) do
    begin
      try
        DisableControls;
        if not (State in [dsEdit, dsInsert]) then
        begin
          Close;
          Open;
        end;
      finally
        EnableControls;
      end;
    end;
  end;
end;

procedure TQueryDataModule.SaveChanges;
var
  i: integer;
begin
  for i := 0 to FQryList.Count - 1 do
  begin
    with TSQLQuery(FQryList.Items[i]) do
    begin
      try
        //DisableControls;
        ApplyUpdates;
        FMasterDataModule.Commit;
      finally
        //EnableControls;
      end;
    end;
  end;
end;

procedure TQueryDataModule.SetQryList(AValue: TQryList);
begin
  if FQryList = AValue then
    Exit;
  FQryList := AValue;
end;

function TQueryDataModule.GetCurrentRecordText: string;
var
  i, j: integer;
  msg: TStringList;
begin
  try
    msg := TStringList.Create();
    for i := 0 to FQryList.Count - 1 do
    begin
      for j := 0 to TSQLQuery(FQryList.Items[i]).Fields.Count - 1 do
      begin
        msg.Add(TSQLQuery(FQryList.Items[i]).Fields.Fields[j].FieldName +
          ': ' + TSQLQuery(FQryList.Items[i]).Fields.Fields[j].AsString);
      end;
    end;
    Result := msg.Text;
  finally
    msg.Free
  end;
end;

function TQueryDataModule.GetDBStatus: TDBInfo;
begin
  Result := FMasterDataModule.GetDBStatus;
end;

function TQueryDataModule.GetQryList: TQryList;
begin
  Result := FQryList;
end;

procedure TQueryDataModule.SetSearchFieldList(AValue: TSearchFieldList);
begin
  if FSearchFieldList = AValue then
    Exit;
  FSearchFieldList := AValue;
end;

end.
