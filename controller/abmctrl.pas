unit abmctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, manejoerrores, mvc, frmsgcddatamodule,
  frmacademiadatamodule, IBConnection, DB;

// para modificar mas facilmente los textos de mensajes
resourcestring
  rsError = 'Error';
  rsInformation = 'Informacion';
  rsProductCopyright = '© 2014 Rafael Aquino - Federico Pérez';
  rsProductInitials = 'SGCD';
  rsProductName = 'Sistema de Gestión de Cursos de Danza ';
  rsProductVersion = 'Versión 0.0.0.1';
  rsWarning = 'Advertencia';

type

  { TABMController }

  TABMController = class(TInterfacedObject, IController)
  private
    FModel: IModel;
    procedure SetModel(AValue: IModel);
    function GetModel: IModel;

    // el controlador referencia al modelo que usa la vista
    property Model: IModel read GetModel write SetModel;
  public
    constructor Create(AModel: IModel);

    { todos estos metodos son de logica de negocio. Todo lo que esta en la
      vista es solo presentacion. }
    procedure CloseQuery(Sender: IView; var CanClose: boolean);
    procedure Cancel(Sender: IView);
    procedure Connect(Sender: IView);
    procedure Disconnect(Sender: IView);
    procedure EditCurrentRecord(Sender: IFormView);
    procedure ErrorHandler(E: Exception; Sender: IView);
    function GetVersion(Sender: IView): string;
    function GetCurrentRecordText(Sender: IView): string;
    procedure NewRecord(Sender: IFormView);
    procedure ShowHelp(Sender: IView);
    procedure ShowHelp(Sender: IFormView);
    procedure Commit(Sender: IView);
    function IsDBConnected(Sender: IView): boolean;
  end;

var
  ABMController: TABMController;

implementation


{ TABMController }

procedure TABMController.SetModel(AValue: IModel);
begin
  if FModel = AValue then
    Exit;
  FModel := AValue;
end;

function TABMController.GetModel: IModel;
begin
  Result := FModel;
end;

procedure TABMController.ErrorHandler(E: Exception; Sender: IView);
begin
  if E is EIBDatabaseError then
    Sender.ShowErrorMessage(GetErrorMessage(E as EIBDatabaseError))
  else if E is EDatabaseError then
    Sender.ShowErrorMessage(GetErrorMessage(E as EDatabaseError))
  else
    Sender.ShowErrorMessage(GetErrorMessage(E));
end;

function TABMController.GetVersion(Sender: IView): string;
begin
  Result := rsProductName + #13#10 + rsProductVersion + #13#10 + rsProductCopyright;
end;

function TABMController.GetCurrentRecordText(Sender: IView): string;
begin
  Result := (Model as TSgcdDataModule).GetCurrentRecordText(Self);
end;

constructor TABMController.Create(AModel: IModel);
begin
  inherited Create;
  Model := AModel;
end;

procedure TABMController.NewRecord(Sender: IFormView);
begin
  Model.NewRecord(Self);
end;

procedure TABMController.EditCurrentRecord(Sender: IFormView);
begin
  Model.EditCurrentRecord(Self);
end;

procedure TABMController.CloseQuery(Sender: IView; var CanClose: boolean);
begin
  //CanClose := True;

end;

procedure TABMController.Cancel(Sender: IView);
begin
  Model.DiscardChanges(Self);
  Model.RefreshDataSets(Self);
end;

procedure TABMController.Connect(Sender: IView);
begin
  Model.Connect(Self);
end;

procedure TABMController.Disconnect(Sender: IView);
begin
  Model.Disconnect(Self);
end;

procedure TABMController.ShowHelp(Sender: IView);
begin
  { TODO : Mostrar la ayuda para linea de comandos }
end;

procedure TABMController.ShowHelp(Sender: IFormView);
begin
  { TODO : Mostrar la ayuda }
end;

procedure TABMController.Commit(Sender: IView);
begin
  Model.SaveChanges(Self);
  Model.Connect(Self);
end;

function TABMController.IsDBConnected(Sender: IView): boolean;
begin
  with (Model as TAcademiaDataModule) do
  begin
    Result := DB.Connected;
  end;
end;

end.
