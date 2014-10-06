unit ctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, manejoerrores, mvc, frmsgcddatamodule,
  IBConnection, DB, Controls, Forms, observerSubject;

// para modificar mas facilmente los textos de mensajes
resourcestring
  rsExitQuestion = '¿Está seguro que desea salir?';
  rsExitSalir = 'Salir';
  rsProductCopyright = '© 2014 Rafael Aquino - Federico Pérez';
  rsProductInitials = 'SGCD';
  rsProductName = 'Sistema de Gestión de Cursos de Danza ';
  rsProductVersion = 'Versión 0.0.0.1';
  rsPendingChanges = 'Hay cambios sin guardar.';
  rsModelErr = 'El modelo no es del tipo apropiado';

type

  { TController }

  TController = class(TInterfacedObject, IController)
  private
    FModel: IModel;
    procedure SetModel(AValue: IModel);
    function GetModel: IModel;
  public
    constructor Create(AModel: IModel);
    destructor Destroy; override;
    procedure Close(Sender: IView);
    procedure Close(Sender: IFormView);
    procedure CloseQuery(Sender: IView; var CanClose: boolean); virtual;
    procedure Connect(Sender: IView);
    procedure Disconnect(Sender: IView);
    procedure ErrorHandler(E: Exception; Sender: IView); virtual;
    procedure ShowHelp(Sender: IView);
    procedure ShowHelp(Sender: IFormView);
    function GetVersion(Sender: IView): string;
    function IsDBConnected(Sender: IView): boolean;
    property Model: IModel read GetModel write SetModel;
  end;

  { TABMController }

  TABMController = class(TController, IABMController)
  private
    //FController: IController;
  public
    procedure Cancel(Sender: IView);
    procedure CloseQuery(Sender: IView; var CanClose: boolean); override;
    procedure Commit(Sender: IView);
    procedure EditCurrentRecord(Sender: IView);
    procedure FilterData(AFilterText: string; Sender: IView);
    procedure NewRecord(Sender: IView);
    procedure RefreshData(Sender: IView);
    procedure Rollback(Sender: IView);
    procedure Save(Sender: IView);
    function GetCurrentRecordText(Sender: IView): string;
    //property Controller: IController read FController implements IController;
  end;

var
  Controller: TController;
  ABMController: TABMController;

implementation

{ TABMController }

procedure TABMController.FilterData(AFilterText: string; Sender: IView);
begin
  if Trim(AFilterText) = '' then
  begin
    Model.UnfilterData;
    Model.RefreshDataSets;
  end
  else
  begin
    Model.FilterData(AFilterText);
    Model.RefreshDataSets;
  end;
end;

function TABMController.GetCurrentRecordText(Sender: IView): string;
begin
  Result := Model.GetCurrentRecordText;
end;

procedure TABMController.NewRecord(Sender: IView);
begin
  Model.NewRecord;
end;

procedure TABMController.RefreshData(Sender: IView);
begin
  Model.RefreshDataSets;
end;

procedure TABMController.Rollback(Sender: IView);
begin
  Model.Rollback;
  Model.Connect;
end;

procedure TABMController.Save(Sender: IView);
begin
  Model.SaveChanges;
  Model.RefreshDataSets;
end;

procedure TABMController.EditCurrentRecord(Sender: IView);
begin
  Model.EditCurrentRecord;
end;

procedure TABMController.Cancel(Sender: IView);
begin
  Model.DiscardChanges;
  Model.RefreshDataSets;
end;

procedure TABMController.CloseQuery(Sender: IView; var CanClose: boolean);
begin
  if Model.ArePendingChanges then
    case Sender.ShowConfirmationMessage(rsExitSalir, rsPendingChanges +
        #13#10 + rsExitQuestion) of
      mrYes:
      begin
        CanClose := True;
        Model.DiscardChanges;
        (Model.MasterDataModule as ISubject).Detach(Sender as IObserver);
      end;
      mrNo:
      begin
        CanClose := False;
      end;
    end
  else
    inherited CloseQuery(Sender, CanClose);
end;

procedure TABMController.Commit(Sender: IView);
begin
  Model.Commit;
  Model.Connect;
end;



{ TController }

procedure TController.Connect(Sender: IView);
begin
  Model.Connect;
end;

procedure TController.Disconnect(Sender: IView);
begin
  Model.Disconnect;
end;

function TController.IsDBConnected(Sender: IView): boolean;
begin
  Result := Model.GetDBStatus.Connected;
end;

procedure TController.SetModel(AValue: IModel);
begin
  if FModel = AValue then
    Exit;
  FModel := AValue;
end;

function TController.GetModel: IModel;
begin
  Result := FModel;
end;

procedure TController.ErrorHandler(E: Exception; Sender: IView);
begin
  if E is EDatabaseError then
    Sender.ShowErrorMessage(GetErrorMessage(E as EDatabaseError))
  else if E is EIBDatabaseError then
    Sender.ShowErrorMessage(GetErrorMessage(E as EIBDatabaseError))
  else
    Sender.ShowErrorMessage(GetErrorMessage(E));
end;

function TController.GetVersion(Sender: IView): string;
begin
  Result := rsProductName + #13#10 + rsProductVersion + #13#10 + rsProductCopyright;
end;

constructor TController.Create(AModel: IModel);
begin
  Model := AModel;
end;

destructor TController.Destroy;
var
  t: pointer;
begin
  t := Pointer(Model);
  Model := nil;
  TComponent(t).Free;
end;

procedure TController.Close(Sender: IView);
begin
  // aca tiene que ir codigo para cerrar la vista de text
end;

procedure TController.Close(Sender: IFormView);
begin
  (Sender as TForm).Close;
end;

procedure TController.CloseQuery(Sender: IView; var CanClose: boolean);
begin
  case Sender.ShowConfirmationMessage(rsExitSalir, rsExitQuestion) of
    mrYes:
    begin
      CanClose := True;
      (Model.MasterDataModule as ISubject).Detach(Sender as IObserver);
    end;
    mrNo:
    begin
      CanClose := False;
    end;
  end;
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
