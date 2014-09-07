unit ctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, manejoerrores, mvc, frmsgcddatamodule,
  IBConnection, DB, Controls, Forms;

// para modificar mas facilmente los textos de mensajes
resourcestring
  rsExitQuestion = '¿Está seguro que desea salir?';
  rsExitSalir = 'Salir';
  rsProductCopyright = '© 2014 Rafael Aquino - Federico Pérez';
  rsProductInitials = 'SGCD';
  rsProductName = 'Sistema de Gestión de Cursos de Danza ';
  rsProductVersion = 'Versión 0.0.0.1';

type

  { TController }

  TController = class(TInterfacedObject, IController)
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
    procedure Close(Sender: IView);
    procedure Close(Sender: IFormView);
    procedure CloseQuery(Sender: IView; var CanClose: boolean);
    procedure ErrorHandler(E: Exception; Sender: IView);
    function GetVersion(Sender: IView): string;
    procedure ShowHelp(Sender: IView);
    procedure ShowHelp(Sender: IFormView);
    procedure Cancel(Sender: IView);
    procedure Connect(Sender: IView);
    procedure Disconnect(Sender: IView);
    procedure EditCurrentRecord(Sender: IView);
    function GetCurrentRecordText(Sender: IView): string;
    procedure NewRecord(Sender: IView);
    procedure Commit(Sender: IView);
    function IsDBConnected(Sender: IView): boolean;
  end;

var
  Controller: TController;

implementation

{ TController }

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
  if E is EIBDatabaseError then
    Sender.ShowErrorMessage(GetErrorMessage(E as EIBDatabaseError))
  else if E is EDatabaseError then
    Sender.ShowErrorMessage(GetErrorMessage(E as EDatabaseError))
  else
    Sender.ShowErrorMessage(GetErrorMessage(E));
end;

function TController.GetVersion(Sender: IView): string;
begin
  Result := rsProductName + #13#10 + rsProductVersion + #13#10 + rsProductCopyright;
end;

constructor TController.Create(AModel: IModel);
begin
  inherited Create;
  Model := AModel;
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
      Application.Terminate;
    end;
    mrNo: Abort;
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

function TController.GetCurrentRecordText(Sender: IView): string;
begin
  Result := Model.GetCurrentRecordText(Self);
end;

procedure TController.NewRecord(Sender: IView);
begin
  Model.NewRecord(Self);
end;

procedure TController.EditCurrentRecord(Sender: IView);
begin
  Model.EditCurrentRecord(Self);
end;

procedure TController.Cancel(Sender: IView);
begin
  Model.DiscardChanges(Self);
  Model.RefreshDataSets(Self);
end;

procedure TController.Connect(Sender: IView);
begin
  Model.Connect(Self);
end;

procedure TController.Disconnect(Sender: IView);
begin
  Model.Disconnect(Self);
end;

procedure TController.Commit(Sender: IView);
begin
  Model.SaveChanges(Self);
  Model.Connect(Self);
end;

function TController.IsDBConnected(Sender: IView): boolean;
begin
  Result := Model.GetDBStatus(Self).Connected;
end;

end.

