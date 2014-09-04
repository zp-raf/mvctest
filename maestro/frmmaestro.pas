unit frmMaestro;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  Menus, abmctrl, mvc, observerSubject;

type



  { TMaestro }

  { Ahora este form maneja solamente lo que atañe a la presentaacion y nada mas.
    La logica del negocio se maneja en el controlador. }

  TMaestro = class(TForm, IView, IFormView, IObserver)
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
    procedure ShowErrorMessage(AMsg: string);
    procedure ShowInfoMessage(AMsg: string);
    procedure ShowWarningMessage(AMsg: string);
    property Controller: IController read GetController write SetController;
  public
    constructor Create(AOwner: TComponent; AController: IController); overload;

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

procedure TMaestro.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  Controller.CloseQuery(Self, CanClose);
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
  end
  else
    Application.Terminate;
end;

procedure TMaestro.FormShow(Sender: TObject);
begin
  if GetOwner <> nil then
    TForm(GetOwner).Enabled := False;
  ObserverUpdate(nil); // actualizamos la vista
end;

procedure TMaestro.MenuItemSalirClick(Sender: TObject);
begin
  Close;
end;

procedure TMaestro.ShowErrorMessage(AMsg: string);
begin
  MessageDlg(rsError, AMsg, mtError, [mbOK], 0);
end;

procedure TMaestro.ShowInfoMessage(AMsg: string);
begin
  MessageDlg(rsInformation, AMsg, mtInformation, [mbOK], 0);
end;

procedure TMaestro.ShowWarningMessage(AMsg: string);
begin
  MessageDlg(rsWarning, AMsg, mtWarning, [mbOK], 0);
end;

constructor TMaestro.Create(AOwner: TComponent; AController: IController);
begin
  inherited Create(AOwner);
  Controller := AController;
end;

end.
