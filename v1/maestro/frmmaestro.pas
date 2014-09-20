unit frmMaestro;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  Menus, ctrl, mvc, observerSubject;

resourcestring
  rsError = 'Error';
  rsInformation = 'Informacion';
  rsWarning = 'Advertencia';
  rsConfirmation = 'Confimación';

type

  { TMaestro }

  { Ahora este form maneja solamente lo que atañe a la presentaacion y nada mas.
    La logica del negocio se maneja en el controlador. }

  TMaestro = class(TForm, IObserver, IView, IFormView)
  private
    FController: IController;
    function GetController: IController;
    procedure SetController(AValue: IController);
  published
    AppProps: TApplicationProperties;
    MainMenu: TMainMenu;
    MenuArchivo: TMenuItem;
    MenuAyuda: TMenuItem;
    MenuItemSalir: TMenuItem;
    MenuItemAyuda: TMenuItem;
    MenuItemAbout: TMenuItem;
    procedure AppPropsException(Sender: TObject; E: Exception);
    procedure CloseView(Sender: IController);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure MenuItemAboutClick(Sender: TObject);
    procedure MenuItemAyudaClick(Sender: TObject); virtual;
    procedure MenuItemSalirClick(Sender: TObject);
    { la clase TComponent ya tiene un metodo update que hace otra cosa
      por eso le cambiamos el nombre del metodo Update de la interfaz
      por otro para que no haya conflictos ni cosas indeseadas }
    procedure IObserver.Update = ObserverUpdate;
    procedure ObserverUpdate(const Subject: IInterface); virtual; abstract;
    function ShowErrorMessage(AMsg: string): TModalResult;
    function ShowErrorMessage(ATitle: string; AMsg: string): TModalResult;
    function ShowInfoMessage(AMsg: string): TModalResult;
    function ShowInfoMessage(ATitle: string; AMsg: string): TModalResult;
    function ShowWarningMessage(AMsg: string): TModalResult;
    function ShowWarningMessage(ATitle: string; AMsg: string): TModalResult;
    function ShowConfirmationMessage(AMsg: string): TModalResult;
    function ShowConfirmationMessage(ATitle: string; AMsg: string): TModalResult;
    property Controller: IController read GetController write SetController;
  public
    constructor Create(AOwner: IFormView; AController: IController); overload;

  { TODO: Aca faltaria un metodo Update() que sea llamado por el sujeto al cual esta
    adherido este observador. Por ejemplo para mostrar el estado de conexion de la
    base de datos en un Text. }
  end;

var
  Maestro: TMaestro;

implementation

{$R *.lfm}

{ TMaestro }

procedure TMaestro.MenuItemAboutClick(Sender: TObject);
begin
  ShowInfoMessage(Controller.GetVersion(Self));
end;

procedure TMaestro.MenuItemAyudaClick(Sender: TObject);
begin
  Controller.ShowHelp(Self as IFormView);
end;

procedure TMaestro.AppPropsException(Sender: TObject; E: Exception);
begin
  Controller.ErrorHandler(E, Self);
end;

procedure TMaestro.CloseView(Sender: IController);
begin
  Close;
end;

procedure TMaestro.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  Controller.CloseQuery(Self, CanClose);
  if CanClose then
  begin
    Controller := nil; // liberamos la referencia al objeto asi se destruye
    if GetOwner <> nil then
    begin
      TForm(GetOwner).Enabled := True;
      TForm(GetOwner).SetFocus;
    end;
  end;
end;

procedure TMaestro.SetController(AValue: IController);
begin
  if FController = AValue then
    Exit;
  FController := AValue;
end;

function TMaestro.GetController: IController;
begin
  Result := FController;
end;

procedure TMaestro.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
  if GetOwner <> nil then
  begin
    TForm(GetOwner).Enabled := True;
    TForm(GetOwner).SetFocus;
  end;
end;

procedure TMaestro.FormShow(Sender: TObject);
begin
  if GetOwner <> nil then
    TForm(GetOwner).Enabled := False;
  //if Visible then
  //  ObserverUpdate(nil); // actualizamos la vista
end;

procedure TMaestro.MenuItemSalirClick(Sender: TObject);
begin
  Controller.Close(Self as IFormView);
end;

function TMaestro.ShowErrorMessage(AMsg: string): TModalResult;
begin
  Result := MessageDlg(rsError, AMsg, mtError, [mbOK], 0);
end;

function TMaestro.ShowErrorMessage(ATitle: string; AMsg: string): TModalResult;
begin
  Result := MessageDlg(ATitle, AMsg, mtError, [mbOK], 0);
end;

function TMaestro.ShowInfoMessage(AMsg: string): TModalResult;
begin
  Result := MessageDlg(rsInformation, AMsg, mtInformation, [mbOK], 0);
end;

function TMaestro.ShowInfoMessage(ATitle: string; AMsg: string): TModalResult;
begin
  Result := MessageDlg(ATitle, AMsg, mtInformation, [mbOK], 0);
end;

function TMaestro.ShowWarningMessage(AMsg: string): TModalResult;
begin
  Result := MessageDlg(rsWarning, AMsg, mtWarning, [mbOK], 0);
end;

function TMaestro.ShowWarningMessage(ATitle: string; AMsg: string): TModalResult;
begin
  Result := MessageDlg(ATitle, AMsg, mtWarning, [mbOK], 0);
end;

function TMaestro.ShowConfirmationMessage(AMsg: string): TModalResult;
begin
  Result := MessageDlg(rsConfirmation, AMsg, mtConfirmation, mbYesNo, 0);
end;

function TMaestro.ShowConfirmationMessage(ATitle: string; AMsg: string): TModalResult;
begin
  Result := MessageDlg(ATitle, AMsg, mtConfirmation, mbYesNo, 0);
end;

constructor TMaestro.Create(AOwner: IFormView; AController: IController);
begin
  inherited Create((AOwner as TComponent));
  Controller := AController;
end;

end.