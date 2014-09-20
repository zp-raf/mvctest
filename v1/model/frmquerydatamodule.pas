unit frmquerydatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, frmsgcddatamodule, mvc, mensajes, sqldb, DB, strutils;

type

  { TQueryDataModule }

  TQueryDataModule = class(TDataModule, IModel)
    procedure DataModuleDestroy(Sender: TObject);
  public
    constructor Create(AOwner: TComponent; AMaster: IDBModel); overload;
  private
    FAuxQryList: TQryList;
    FSearchFieldList: TSearchFieldList;
    FSearchText: string;
    FQryList: TQryList;
    function GetAuxQryList: TQryList;
    function GetMasterDataModule: IDBModel;
    function GetSearchFieldList: TSearchFieldList;
    function GetSearchText: string;
    function GetQryList: TQryList;
    procedure SetAuxQryList(AValue: TQryList);
    procedure SetMasterDataModule(AValue: IDBModel);
    procedure SetSearchText(AValue: string);
  protected
    FMasterDataModule: IDBModel;
    procedure SetQryList(AValue: TQryList);
    procedure SetSearchFieldList(AValue: TSearchFieldList);
  published
    procedure Connect; virtual;
    procedure DataModuleCreate(Sender: TObject); virtual;
    procedure DiscardChanges;
    procedure Disconnect; virtual;
    procedure FilterData(ASearchText: string);
    procedure FilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure EditCurrentRecord;
    procedure NewRecord;
    procedure RefreshDataSets;
    procedure SaveChanges;
    procedure SetReadOnly(Option: boolean);
    procedure UnfilterData;
    function ArePendingChanges: boolean;
    function GetCurrentRecordText: string;
    function GetDBStatus: TDBInfo;
    property QryList: TQryList read GetQryList write SetQryList;
    property SearchFieldList: TSearchFieldList
      read GetSearchFieldList write SetSearchFieldList;
    property SearchText: string read GetSearchText write SetSearchText;
    property AuxQryList: TQryList read GetAuxQryList write SetAuxQryList;
    property MasterDataModule: IDBModel read GetMasterDataModule
      write SetMasterDataModule;
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

  // antes de los principales los auxiliares
  for i := 0 to FAuxQryList.Count - 1 do
  begin
    with TSQLQuery(FAuxQryList.Items[i]) do
    begin
      if not Active then
        Active := True;
    end;
  end;

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
  FQryList := TQryList.Create(True);
  FSearchFieldList := TSearchFieldList.Create;
  FAuxQryList := TQryList.Create(True);
  FSearchText := '';
end;

procedure TQueryDataModule.DataModuleDestroy(Sender: TObject);
begin
  FQryList.Free;
  FSearchFieldList.Free;
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
  // antes de los principales los auxiliares
  for i := 0 to FAuxQryList.Count - 1 do
  begin
    with TSQLQuery(FAuxQryList.Items[i]) do
    begin
      if Active then
        Active := False;
    end;
  end;
  //despues la conexion a base de datos
  FMasterDataModule.Disconnect;
end;

procedure TQueryDataModule.FilterData(ASearchText: string);
var
  i: integer;
begin
  FSearchText := ASearchText;
  //if Trim(FSearchText) = '' then
  //  for i := 0 to (FQryList.Count - 1) do
  //  begin
  //    (FQryList.Items[i] as TDataSet).Filtered := False;
  //  end
  //else
  //  for i := 0 to (FQryList.Count - 1) do
  //  begin
  //    (FQryList.Items[i] as TDataSet).Filtered := True;
  //  end;
end;

procedure TQueryDataModule.FilterRecord(DataSet: TDataSet; var Accept: boolean);
var
  i: integer;
  FirstTime: boolean;
  res: boolean;
begin
  if Trim(FSearchText) = '' then
  begin
    Accept := True;
    Exit;
  end;

  FirstTime := True;
  if FSearchFieldList.Count = 0 then
    Accept := True
  else
    for i := 0 to (FSearchFieldList.Count - 1) do
    begin
      if FirstTime then
      begin
        res := AnsiContainsText(DataSet.FieldByName(FSearchFieldList[i]).AsString,
          FSearchText);
        Accept := res;
      end
      else
      begin
        Accept := res or AnsiContainsText(DataSet.FieldByName(
          FSearchFieldList[i]).AsString, FSearchText);
        res := AnsiContainsText(DataSet.FieldByName(
          FSearchFieldList[i]).AsString, FSearchText);
        FirstTime := False;
      end;
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
  try
    for i := 0 to FQryList.Count - 1 do
    begin
      with TSQLQuery(FQryList.Items[i]) do
      begin
        ApplyUpdates;
      end;
    end;
  finally
    FMasterDataModule.Commit;
  end;
end;

procedure TQueryDataModule.SetReadOnly(Option: boolean);
var
  i: integer;
begin
  for i := 0 to FQryList.Count - 1 do
  begin
    with TSQLQuery(FQryList.Items[i]) do
    begin
      ReadOnly := Option;
    end;
  end;
  for i := 0 to FAuxQryList.Count - 1 do
  begin
    with TSQLQuery(FAuxQryList.Items[i]) do
    begin
      ReadOnly := Option;
    end;
  end;
end;

procedure TQueryDataModule.UnfilterData;
var
  i: integer;
begin
  FSearchText := '';
  for i := 0 to (FQryList.Count - 1) do
  begin
    (FQryList.Items[i] as TDataSet).Filtered := False;
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

function TQueryDataModule.GetSearchText: string;
begin
  Result := FSearchText;
end;

function TQueryDataModule.GetAuxQryList: TQryList;
begin
  Result := FAuxQryList;
end;

function TQueryDataModule.GetMasterDataModule: IDBModel;
begin
  Result := FMasterDataModule;
end;

function TQueryDataModule.GetSearchFieldList: TSearchFieldList;
begin
  Result := FSearchFieldList;
end;

procedure TQueryDataModule.SetAuxQryList(AValue: TQryList);
begin
  if AValue = FAuxQryList then
    Exit;
  FAuxQryList := AValue;
end;

procedure TQueryDataModule.SetMasterDataModule(AValue: IDBModel);
begin
  if FMasterDataModule = AValue then
    Exit;
  FMasterDataModule := AValue;
end;

procedure TQueryDataModule.SetSearchText(AValue: string);
begin
  if AValue = FSearchText then
    Exit;
  FSearchText := AValue;
end;

end.
