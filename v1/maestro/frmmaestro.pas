unit frmMaestro;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  Menus, ComCtrls, LazHelpHTML, ctrl, mvc, observerSubject, mensajes;

type

  { TMaestro }

  TMaestro = class(TForm, IObserver, IView, IFormView)
    HTMLBrowserHelpViewer1: THTMLBrowserHelpViewer;
    HTMLHelpDatabase1: THTMLHelpDatabase;
    procedure FormCreate(Sender: TObject);
  private
    FController: Pointer;
    FOpenOnShow: boolean;
    procedure SetConnStatus(connected: boolean; host: string; username: string);
    procedure SetOpenOnShow(AValue: boolean);
  protected
    { This procedure nils the controller pointer so it won't be destroyed once
      this view is }
    procedure ClearControllerPtr;
    function GetController: TController;
    procedure SetController(AValue: TController);
  public
    constructor Create(AOwner: IFormView; AController: Pointer); overload; virtual;
    destructor Destroy; override;
  published
    MainMenu: TMainMenu;
    MenuArchivo: TMenuItem;
    MenuAyuda: TMenuItem;
    MenuItemSalir: TMenuItem;
    MenuItemAyuda: TMenuItem;
    MenuItemAbout: TMenuItem;
    StatusBar1: TStatusBar;
    procedure CloseView(Sender: IController);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure MenuItemAboutClick(Sender: TObject);
    procedure MenuItemAyudaClick(Sender: TObject); virtual;
    procedure MenuItemSalirClick(Sender: TObject);
    { The TComponent class already has an Update method that does something
      else. For that reason we change the name of the Update method of the
      IObserver interface to another one to avoid conflicts }
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
    property OpenOnShow: boolean read FOpenOnShow write SetOpenOnShow;
  end;

var
  Maestro: TMaestro;

implementation

{$R *.lfm}


{ TMaestro }

procedure TMaestro.MenuItemAboutClick(Sender: TObject);
begin
  ShowInfoMessage(GetController.GetVersion(Self));
end;

procedure TMaestro.MenuItemAyudaClick(Sender: TObject);
//var
//  nombreform: string;
begin
  //  nombreform:= LowerCase('frm'+ Name) ;
  //  GetController.ShowHelp(Self as IFormView);
  //MostrarAyudaForm(Sender);
  ShowHelp;
end;

function TMaestro.GetController: TController;
begin
  Result := TController(FController);
end;

procedure TMaestro.SetController(AValue: TController);
begin
  if TController(FController) = TController(AValue) then
    Exit;
  FController := Pointer(AValue);
end;

procedure TMaestro.FormCreate(Sender: TObject);
var
  namehelpfile: string;
begin
  namehelpfile := LowerCase('html/' + UnitName + '.html');
  // si existe el archivo, lo asigno al formulario
  if FileExists(namehelpfile) then
    HelpKeyword := namehelpfile
  else
    HelpKeyword:= '';
end;

procedure TMaestro.SetConnStatus(connected: boolean; host: string; username: string);
begin
  if connected then
  begin
    StatusBar1.Panels.Items[1].Text := 'Server: ' + host;
    StatusBar1.Panels.Items[0].Text := username;
  end
  else
  begin
    StatusBar1.Panels.Items[1].Text := 'Desconectado';
    StatusBar1.Panels.Items[0].Text := '';
  end;
end;

procedure TMaestro.SetOpenOnShow(AValue: boolean);
begin
  if FOpenOnShow = AValue then
    Exit;
  FOpenOnShow := AValue;
end;

procedure TMaestro.ClearControllerPtr;
begin
  FController := nil;
end;

procedure TMaestro.CloseView(Sender: IController);
begin
  Close;
end;

procedure TMaestro.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  GetController.CloseQuery(Self, CanClose);
  //if CanClose then
  //begin
  //  if GetOwner <> nil then
  //  begin
  //    TForm(GetOwner).Enabled := True;
  //    TForm(GetOwner).SetFocus;
  //  end;
  //end;
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
  //  ObserverUpdate(nil);
  // actualizamos la vista
  if OpenOnShow then
  begin
    GetController.Connect(Self);
    GetController.RefreshData(Self);
  end;
end;

procedure TMaestro.MenuItemSalirClick(Sender: TObject);
begin
  GetController.Close(Self as IFormView);
end;

procedure TMaestro.ObserverUpdate(const Subject: IInterface);
begin
  if (Subject is IDBModel) then
    SetConnStatus((Subject as IDBModel).GetDBStatus.Connected,
      (Subject as IDBModel).GetDBStatus.Host, (Subject as IDBModel).GetDBStatus.User);
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

constructor TMaestro.Create(AOwner: IFormView; AController: Pointer);
begin
  { We also check the pointer here in order to stop creation of the instance if
    the controller pointer is not valid }
  if Assigned(AController) and (TObject(AController) is TController) then
    FController := AController
  else
    raise Exception.Create(rsCreateErrorInvalidCont);
  if AOwner is TComponent then
    inherited Create((AOwner as TComponent))
  else
    inherited Create(nil);
  OpenOnShow := True;
end;

destructor TMaestro.Destroy;
begin
  if Assigned(FController) then
    FreeAndNil(TController(FController));
  inherited Destroy;
end;

end.
