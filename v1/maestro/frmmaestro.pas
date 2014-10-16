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
  rsProvidedCont = 'Provided controller does not implements basic controller ' +
    'funcionality';

type

  { TMaestro }

  { Ahora este form maneja solamente lo que atañe a la presentaacion y nada mas.
    La logica del negocio se maneja en el controlador. }

  TMaestro = class(TForm, IObserver, IView, IFormView)
    MIConnected: TMenuItem;
    procedure MIConnectedClick(Sender: TObject);
  private
    hola: Pointer;
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
    procedure AppPropsException(Sender: TObject; E: Exception); virtual;
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
    procedure ObserverUpdate(const Subject: IInterface); virtual;
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

procedure TMaestro.MIConnectedClick(Sender: TObject);
begin
  if (Sender as TMenuItem).Checked then
  begin
    (Sender as TMenuItem).Checked := False;
    Controller.Disconnect(Self);
  end
  else
  begin
    Controller.Connect(Self);
    (Sender as TMenuItem).Checked := True;
  end;
end;

function TMaestro.GetController: IController;
begin
  Result := FController;
end;

procedure TMaestro.SetController(AValue: IController);
begin
  if FController = AValue then
    Exit;
  FController := AValue;
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

procedure TMaestro.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  (IController(hola).GetModel.MasterDataModule as ISubject).Detach(Self as IObserver);
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
  Controller.Connect(Self);
end;

procedure TMaestro.MenuItemSalirClick(Sender: TObject);
begin
  Controller.Close(Self as IFormView);
end;

procedure TMaestro.ObserverUpdate(const Subject: IInterface);
begin
  { aca se actualiza la vista. en este caso que es para prueba nomas
    cambiamos boton connected }
  if Controller.IsDBConnected(Self) then
    MIConnected.Checked := True
  else
    MIConnected.Checked := False;
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
  if AOwner is TComponent then
    inherited Create((AOwner as TComponent))
  else
    inherited Create(nil);
  Controller := AController;
  hola := Pointer(AController);
end;

end.
