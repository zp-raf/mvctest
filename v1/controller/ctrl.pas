unit ctrl;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, manejoerrores, mvc, IBConnection, DB, Controls, Forms,
  observerSubject, dateutils, frmquerydatamodule, mensajes;

type

  { TController }

  TController = class abstract(TInterfacedObject, IController)
  private
    { We hold only a pointer to the actual model so we can easily cast it to
      either CustomDataModule or the TQueryDataModule as needed through setters
      and getters. A pointer also gives us more flexibility in memory management
      and circumvents reference counting problems. }
    FModel: Pointer;
  protected
    { In the descendants of this class should be more setters like these
      (SetModel and GetModel) in order to access specific methods of the custom
      datamodule class. For example: function GetCustomModel: TSpecificDataModule,
      etc. }
    procedure SetModel(AValue: TQueryDataModule);
    function GetModel: TQueryDataModule;
  public
    constructor Create(AModel: Pointer); overload; virtual;
    destructor Destroy; override;
    procedure AfterConstruction; override; final;
    procedure Cancel(Sender: IView);
    procedure Close(Sender: IView); virtual;
    procedure Close(Sender: IFormView); virtual; overload;
    procedure CloseDataSets(Sender: IView);
    procedure CloseQuery(Sender: IView; var CanClose: boolean); virtual;
    procedure Commit(Sender: IView);
    procedure Connect(Sender: IView);
    procedure Disconnect(Sender: IView);
    procedure EditCurrentRecord(Sender: IView); virtual;
    procedure ErrorHandler(E: Exception; Sender: IView); virtual;
    procedure ErrorHandler(E: Exception; Sender: IABMView); virtual; overload;
    procedure NewDetailRecord(Sender: IView);
    procedure NewRecord(Sender: IView);
    procedure OpenDataSets(Sender: IView);
    procedure RefreshData(Sender: IView);
    procedure Rollback(Sender: IView);
    procedure ShowHelp(Sender: IView); virtual;
    procedure ShowHelp(Sender: IFormView); virtual;
    procedure Save(Sender: IView); virtual;
    function GetVersion(Sender: IView): string; virtual; final;
    function IsDBConnected(Sender: IView): boolean; virtual;
    function IsValidDate(ADateStr: string): boolean; virtual;
    function IsValidDate(ADate: TDateTime): boolean; virtual;
  end;

  { TABMController }

  TABMController = class abstract(TController, IABMController)
  public
    procedure FilterData(AFilterText: string; Sender: IView);
    function GetCurrentRecordText(Sender: IView): string;
  end;

//var
//  Controller: TController;
//  ABMController: TABMController;

implementation

{ TABMController }

procedure TABMController.FilterData(AFilterText: string; Sender: IView);
begin
  if Trim(AFilterText) = '' then
  begin
    GetModel.UnfilterData;
    GetModel.RefreshDataSets;
  end
  else
  begin
    GetModel.FilterData(AFilterText);
    GetModel.RefreshDataSets;
  end;
end;

function TABMController.GetCurrentRecordText(Sender: IView): string;
begin
  Result := GetModel.GetCurrentRecordText;
end;

{ TController }

procedure TController.NewDetailRecord(Sender: IView);
begin
  GetModel.NewDetailRecord;
end;

procedure TController.NewRecord(Sender: IView);
begin
  GetModel.NewRecord;
end;

procedure TController.RefreshData(Sender: IView);
begin
  GetModel.RefreshDataSets;
end;

procedure TController.Rollback(Sender: IView);
begin
  GetModel.Rollback;
  GetModel.Connect;
end;

procedure TController.Save(Sender: IView);
begin
  GetModel.SaveChanges;
  GetModel.RefreshDataSets;
end;

procedure TController.EditCurrentRecord(Sender: IView);
begin
  GetModel.EditCurrentRecord;
end;

procedure TController.ErrorHandler(E: Exception; Sender: IABMView);
var
  viewObj: IView;
begin
  Sender.QueryInterface(IView, viewObj);
  if viewObj <> nil then
    ErrorHandler(E, viewObj);
  Sender.Cancel;
end;

procedure TController.ErrorHandler(E: Exception; Sender: IView);
begin
  if E is EDatabaseError then
  begin
    Sender.ShowErrorMessage(GetErrorMessage(E as EDatabaseError));
    //GetModel.DoOnErrorEvent(Sender as TObject, E as EDatabaseError);
    (GetModel.MasterDataModule as ISubject).Notify;
  end
  else if E is EIBDatabaseError then
    Sender.ShowErrorMessage(GetErrorMessage(E as EIBDatabaseError))
  else
    Sender.ShowErrorMessage(GetErrorMessage(E));
end;

procedure TController.Cancel(Sender: IView);
begin
  GetModel.DiscardChanges;
  Rollback(Sender);
  GetModel.RefreshDataSets;
end;

procedure TController.CloseQuery(Sender: IView; var CanClose: boolean);
begin
  if GetModel.ArePendingChanges then
    case Sender.ShowConfirmationMessage(rsExitText, rsPendingChanges +
        #13#10 + rsExitQuestion) of
      mrYes:
      begin
        CanClose := True;
        GetModel.DiscardChanges;
        (GetModel.MasterDataModule as ISubject).Detach(Sender as IObserver);
        Exit;
      end;
      mrNo:
      begin
        CanClose := False;
        Exit;
      end;
    end
  else
  if CanClose then
  begin
    (GetModel.MasterDataModule as ISubject).Detach(Sender as IObserver);
    Exit;
    case Sender.ShowConfirmationMessage(rsExitText, rsExitQuestion) of
      mrYes:
      begin
        CanClose := True;
        (GetModel.MasterDataModule as ISubject).Detach(Sender as IObserver);
        Exit;
      end;
      mrNo:
      begin
        CanClose := False;
        Exit;
      end;
    end;
  end;
end;

procedure TController.Commit(Sender: IView);
begin
  GetModel.Commit;
  GetModel.Connect;
end;

procedure TController.Connect(Sender: IView);
begin
  GetModel.Connect;
end;

procedure TController.Disconnect(Sender: IView);
begin
  GetModel.Disconnect;
end;

function TController.IsDBConnected(Sender: IView): boolean;
begin
  Result := GetModel.GetDBStatus.Connected;
end;

function TController.IsValidDate(ADateStr: string): boolean;
var
  x: TDateTime;
begin
  if TryStrToDate(ADateStr, x) and (x > StrToDate('01/01/1900')) then
    Result := True
  else
    Result := False;
end;

function TController.IsValidDate(ADate: TDateTime): boolean;
begin
  if ADate < StrToDate('01/01/1900') then
    Result := False
  else
    Result := True;
end;

procedure TController.SetModel(AValue: TQueryDataModule);
begin
  if FModel = Pointer(AValue) then
    Exit;
  FModel := Pointer(AValue);
end;

function TController.GetModel: TQueryDataModule;
begin
  Result := TQueryDataModule(FModel);
end;

constructor TController.Create(AModel: Pointer);
begin
  if Assigned(AModel) and (TObject(AModel) is TQueryDataModule) then
    FModel := AModel
  else
    raise Exception.Create(rsCreateErrorInvalidCont);
end;

destructor TController.Destroy;
begin
  inherited Destroy;
  if Assigned(FModel) then
  begin
    GetModel.Free;
    FModel := nil;
  end;
end;

{ TController.AfterConstruction

  This procedure test for proper assignment of the model to the FModel field.
  It raises an exception if an error is detected. }

procedure TController.AfterConstruction;
begin
  inherited AfterConstruction;
  if not Assigned(FModel) then
    raise Exception.Create(rsModelAsgnErr);
end;

procedure TController.OpenDataSets(Sender: IView);
begin
  GetModel.OpenDataSets;
end;

function TController.GetVersion(Sender: IView): string;
begin
  Result := rsProductName + #13#10 + rsProductVersion + #13#10 + rsProductCopyright;
end;

procedure TController.Close(Sender: IView);
begin
  { TODO : aca tiene que ir codigo para cerrar la vista de texto }
end;

procedure TController.Close(Sender: IFormView);
begin
  (Sender as TForm).Close;
end;

procedure TController.CloseDataSets(Sender: IView);
begin
  GetModel.CloseDataSets;
end;

procedure TController.ShowHelp(Sender: IView);
begin
  { TODO : Mostrar la ayuda para linea de comandos }
end;

procedure TController.ShowHelp(Sender: IFormView);
begin
  { TODO : Mostrar la ayuda }
end;

end.
