unit frmquerydatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, frmsgcddatamodule, mvc, mensajes, sqldb,
  DB, strutils, sgcdTypes;

type

  { TQueryDataModule }

  TQueryDataModule = class(TDataModule, IModel)
  private
    FAuxQryList: TQryList;
    FOnError: TErrorEvent;
    FSearchFieldList: TSearchFieldList;
    FSearchText: string;
    FQryList: TQryList;
    FDetailList: TQryList;
    function GetAuxQryList: TQryList;
    function GetDetailList: TQryList;
    function GetMasterDataModule: IDBModel;
    function GetOnError: TErrorEvent;
    function GetSearchFieldList: TSearchFieldList;
    function GetSearchText: string;
    function GetQryList: TQryList;
    procedure SetAuxQryList(AValue: TQryList);
    procedure SetDetailList(AValue: TQryList);
    procedure SetMasterDataModule(AValue: IDBModel);
    procedure SetOnError(AValue: TErrorEvent);
    procedure SetSearchText(AValue: string);
  protected
    FMasterDataModule: IDBModel;
    procedure SetQryList(AValue: TQryList);
    procedure SetSearchFieldList(AValue: TSearchFieldList);
  public
    constructor Create(AOwner: TComponent; AMaster: IDBModel); overload;
  published
    procedure BeforeDestruction; override;
    procedure CloseDataSets; virtual;
    procedure Commit; virtual;
    procedure Connect; virtual;
    procedure DataModuleCreate(Sender: TObject); virtual;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DiscardChanges; virtual;
    procedure Disconnect; virtual;
    procedure FilterData(ASearchText: string);
    procedure FilterRecord(DataSet: TDataSet; var Accept: boolean); virtual;
    procedure EditCurrentRecord; virtual;
    procedure NewRecord; virtual;
    procedure NewDetailRecord;
    procedure DoOnErrorEvent(Sender: TObject; {%H-}E: EDatabaseError); virtual;
    procedure OpenDataSets; virtual;
    procedure RefreshDataSets; virtual;
    procedure Rollback; virtual;
    procedure SaveChanges; virtual;
    procedure SetReadOnly(Option: boolean);
    procedure UnfilterData;
    function ArePendingChanges: boolean; virtual;
    function GetCurrentRecordText: string;
    function GetDBStatus: TDBInfo;
    property AuxQryList: TQryList read GetAuxQryList write SetAuxQryList;
    property DetailList: TQryList read GetDetailList write SetDetailList;
    property MasterDataModule: IDBModel read GetMasterDataModule
      write SetMasterDataModule;
    property OnError: TErrorEvent read GetOnError write SetOnError;
    property QryList: TQryList read GetQryList write SetQryList;
    property SearchFieldList: TSearchFieldList
      read GetSearchFieldList write SetSearchFieldList;
    property SearchText: string read GetSearchText write SetSearchText;
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
      if (State in [dsEdit, dsInsert]) then
        Result := True;
    end;
  end;
  for i := 0 to FDetailList.Count - 1 do
  begin
    with TSQLQuery(FDetailList.Items[i]) do
    begin
      if (State in [dsEdit, dsInsert]) then
        Result := True;
    end;
  end;
end;

procedure TQueryDataModule.Connect;
begin
  //primero la conexion a base de datos
  FMasterDataModule.Connect;
  OpenDataSets;
end;

procedure TQueryDataModule.DataModuleCreate(Sender: TObject);
begin
  FQryList := TQryList.Create(False);
  FSearchFieldList := TSearchFieldList.Create;
  FAuxQryList := TQryList.Create(False);
  FDetailList := TQryList.Create(False);
  FSearchText := '';
end;

procedure TQueryDataModule.DataModuleDestroy(Sender: TObject);
begin
  if Assigned(FQryList) then
    FreeAndNil(FQryList);
  if Assigned(FAuxQryList) then
    FreeAndNil(FAuxQryList);
  if Assigned(FSearchFieldList) then
    FreeAndNil(FSearchFieldList);
  if Assigned(FDetailList) then
    FreeAndNil(FDetailList);
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
      if (State in [dsEdit, dsInsert]) or (RowsAffected > 0) and not ReadOnly then
        Cancel;
    end;
  end;
  for i := 0 to FDetailList.Count - 1 do
  begin
    with TSQLQuery(FDetailList.Items[i]) do
    begin
      if (State in [dsEdit, dsInsert]) or (RowsAffected > 0) and not ReadOnly then
        Cancel;
    end;
  end;
end;

procedure TQueryDataModule.Disconnect;
begin
  CloseDataSets;
  //despues la conexion a base de datos
  FMasterDataModule.Disconnect;
end;

procedure TQueryDataModule.FilterData(ASearchText: string);
var
  i: integer;
begin
  FSearchText := ASearchText;
  for i := 0 to Pred(FQryList.Count) do
  begin
    (FQryList.Items[i] as TDataSet).Filtered := True;
  end;
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
  i, FoundFields: integer;
begin
  Accept := False;

  if (Trim(FSearchText) = '') or (FSearchFieldList.Count = 0) then
  begin
    Accept := True;
    Exit;
  end;

  FoundFields := 0;
  for i := 0 to Pred(FSearchFieldList.Count) do
  begin
    if DataSet.FindField(FSearchFieldList[i]) = nil then
      Continue
    else
      Inc(FoundFields);
    if AnsiContainsText(DataSet.FieldByName(FSearchFieldList[i]).AsString,
      FSearchText) then
    begin
      Accept := True;
      Break;
    end;
  end;
  // Check if all searchfields were found in the dataset
  if FoundFields = 0 then
    Accept := True;
end;

procedure TQueryDataModule.EditCurrentRecord;
var
  i: integer;
begin
  Connect;
  for i := 0 to FQryList.Count - 1 do
  begin
    with TSQLQuery(FQryList.Items[i]) do
    begin
      try
        DisableControls;
        if ReadOnly then
          Continue;
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
  Connect;
  for i := 0 to FQryList.Count - 1 do
  begin
    with TSQLQuery(FQryList.Items[i]) do
    begin
      try
        DisableControls;
        if ReadOnly then
          Continue;
        if Active and not (State in [dsEdit]) then
          Append
        else if (State in [dsEdit]) and (RowsAffected > 0) then
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

procedure TQueryDataModule.NewDetailRecord;
var
  i: integer;
begin
  if not ArePendingChanges then
    Exit;
  for i := 0 to FDetailList.Count - 1 do
  begin
    with TSQLQuery(FDetailList.Items[i]) do
    begin
      try
        DisableControls;
        if ReadOnly then
          Continue;
        if Active and not (State in [dsEdit]) then
          Append
        else if (State in [dsEdit]) and (RowsAffected > 0) then
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

procedure TQueryDataModule.DoOnErrorEvent(Sender: TObject; E: EDatabaseError);
begin
  if Assigned(FOnError) then
    FOnError(Sender, E);
end;

procedure TQueryDataModule.OpenDataSets;
var
  i: integer;
begin
  // antes de los principales los auxiliares
  for i := 0 to FAuxQryList.Count - 1 do
  begin
    with TSQLQuery(FAuxQryList.Items[i]) do
    begin
      Open;
    end;
  end;

  //segundo se abren los datasets
  for i := 0 to FQryList.Count - 1 do
  begin
    with TSQLQuery(FQryList.Items[i]) do
    begin
      Open;
    end;
  end;
  // detalles
  for i := 0 to FDetailList.Count - 1 do
  begin
    with TSQLQuery(FDetailList.Items[i]) do
    begin
      Open;
    end;
  end;
end;

procedure TQueryDataModule.RefreshDataSets;
begin
  CloseDataSets;
  OpenDataSets;
end;

procedure TQueryDataModule.Rollback;
begin
  FMasterDataModule.Rollback;
  Connect;
end;

procedure TQueryDataModule.SaveChanges;
var
  i: integer;
begin

  for i := 0 to FQryList.Count - 1 do
  begin
    with TSQLQuery(FQryList.Items[i]) do
    begin
      if ReadOnly or not Active then
        Continue;
      ApplyUpdates;
    end;
  end;

  for i := 0 to FDetailList.Count - 1 do
  begin
    with TSQLQuery(FDetailList.Items[i]) do
    begin
      if ReadOnly or not Active then
        Continue;
      ApplyUpdates;
    end;
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
      Close;
      ReadOnly := Option;
      Open;
    end;
  end;
  for i := 0 to FDetailList.Count - 1 do
  begin
    with TSQLQuery(FDetailList.Items[i]) do
    begin
      Close;
      ReadOnly := Option;
      Open;
    end;
  end;
  for i := 0 to FAuxQryList.Count - 1 do
  begin
    with TSQLQuery(FAuxQryList.Items[i]) do
    begin
      Close;
      ReadOnly := Option;
      Open;
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
  Connect;
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

procedure TQueryDataModule.BeforeDestruction;
begin
  DiscardChanges;
  CloseDataSets;
  inherited BeforeDestruction;
end;

procedure TQueryDataModule.CloseDataSets;
var
  i: integer;
begin
  //primero se cierran los datasets
  for i := 0 to FQryList.Count - 1 do
  begin
    with TSQLQuery(FQryList.Items[i]) do
    begin
      Close;
    end;
  end;
  // antes de los principales los auxiliares
  for i := 0 to FAuxQryList.Count - 1 do
  begin
    with TSQLQuery(FAuxQryList.Items[i]) do
    begin
      Close;
    end;
  end;

  for i := 0 to FDetailList.Count - 1 do
  begin
    with TSQLQuery(FDetailList.Items[i]) do
    begin
      Close;
    end;
  end;
end;

procedure TQueryDataModule.Commit;
begin
  FMasterDataModule.Commit;
  Connect;
end;

function TQueryDataModule.GetSearchText: string;
begin
  Result := FSearchText;
end;

function TQueryDataModule.GetAuxQryList: TQryList;
begin
  Result := FAuxQryList;
end;

function TQueryDataModule.GetDetailList: TQryList;
begin
  Result := FDetailList;
end;

function TQueryDataModule.GetMasterDataModule: IDBModel;
begin
  Result := FMasterDataModule;
end;

function TQueryDataModule.GetOnError: TErrorEvent;
begin
  Result := FOnError;
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

procedure TQueryDataModule.SetDetailList(AValue: TQryList);
begin
  if AValue = FDetailList then
    Exit;
  FDetailList := AValue;
end;

procedure TQueryDataModule.SetMasterDataModule(AValue: IDBModel);
begin
  if FMasterDataModule = AValue then
    Exit;
  FMasterDataModule := AValue;
end;

procedure TQueryDataModule.SetOnError(AValue: TErrorEvent);
begin
  if FOnError = AValue then
    Exit;
  FOnError := AValue;
end;

procedure TQueryDataModule.SetSearchText(AValue: string);
begin
  if AValue = FSearchText then
    Exit;
  FSearchText := AValue;
end;

end.
