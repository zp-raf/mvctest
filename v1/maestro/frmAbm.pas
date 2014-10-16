unit frmAbm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, DBGrids, ButtonPanel, EditBtn, StdCtrls, DBCtrls, frmMaestro,
  sqldb, LCLType, IBConnection, BufDataset, mvc, observerSubject;

type

  { TAbm }

  TAbm = class(TMaestro, IABMView)
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private
    FABMController: IABMController;
    function GetController: IABMController;
    procedure SetController(AValue: IABMController);
  public
    constructor Create(AOwner: IFormView; AController: IABMController); overload;
  published
    ButtonFilter: TButton;
    DBGrid1: TDBGrid;
    DBNavList: TDBNavigator;
    PanelList: TPanel;
    EditFilter: TEdit;
    MenuItemGuardar: TMenuItem;
    ButtonPanel: TButtonPanel;
    LabelFilter: TLabel;
    PanelDetail: TPanel;
    procedure ABMInsert; virtual;
    procedure ABMEdit; virtual;
    procedure ABMDelete; virtual;
    procedure ABMRefresh; virtual;
    procedure ButtonFilterClick(Sender: TObject); virtual;
    procedure Cancel;
    procedure CancelButtonClick(Sender: TObject); virtual;
    procedure CloseButtonClick(Sender: TObject); virtual;
    procedure DBGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure DBNavListBeforeAction(Sender: TObject; Button: TDBNavButtonType);
    procedure FormShow(Sender: TObject);
    procedure MenuItemGuardarClick(Sender: TObject);
    procedure OK(Sender: TObject); virtual;
    procedure OKButtonClick(Sender: TObject); virtual;
    procedure ShowPanel(APanel: TPanel);
    property ABMController: IABMController read GetController write SetController;
  end;

var
  Abm: TAbm;

implementation

{$R *.lfm}

{ TAbm }

procedure TAbm.MenuItemGuardarClick(Sender: TObject);
begin
  OK(Self);
end;

procedure TAbm.OK(Sender: TObject);
begin
  ABMController.Save(Self);
  ABMController.Commit(Self);
  ShowPanel(PanelList);
end;

procedure TAbm.OKButtonClick(Sender: TObject);
begin
  OK(Self);
end;

procedure TAbm.ShowPanel(APanel: TPanel);
var
  i: integer;
begin
  for i := 0 to Self.ComponentCount - 1 do
  begin

    //para comparacion de tipos
    if (Components[i] is TPanel) and (Components[i] = (APanel as TComponent)) then

      //hacemos visible el panel pasado como argumento
      TPanel(Components[i]).Visible := True
    else if Components[i] is TPanel then
      TPanel(Components[i]).Visible := False; //ocultamos los demas
  end;
end;

procedure TAbm.DBNavListBeforeAction(Sender: TObject; Button: TDBNavButtonType);
begin
  if not (Sender is TDBNavigator) then
    Abort;
  case Button of
    nbInsert:
    begin
      ABMInsert;
      Abort;
    end;
    nbEdit:
    begin
      ABMEdit;
      Abort;
    end;
    nbRefresh:
    begin
      ABMRefresh;
      Abort;
    end;
  end;
end;

procedure TAbm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if ABMController <> nil then
    (ABMController.GetModel.MasterDataModule as ISubject).Detach(Self as IObserver);
  inherited;
end;

function TAbm.GetController: IABMController;
begin
  Result := FABMController;
end;

procedure TAbm.SetController(AValue: IABMController);
begin
  if FABMController = AValue then
    Exit;
  FABMController := AValue;
end;

constructor TAbm.Create(AOwner: IFormView; AController: IABMController);
var
  temp: IController;
begin
  AController.QueryInterface(IController, temp);
  if temp <> nil then
  begin
    inherited Create(AOwner, AController);
    FABMController := AController;
  end
  else
    raise Exception.Create(rsProvidedCont);
end;

procedure TAbm.ABMInsert;
begin
  ShowPanel(PanelDetail);
  ABMController.NewRecord(Self);
end;

procedure TAbm.ABMEdit;
begin
  ShowPanel(PanelDetail);
  ABMController.EditCurrentRecord(Self);
end;

procedure TAbm.ABMDelete;
begin

end;

procedure TAbm.ABMRefresh;
begin
  ABMController.RefreshData(Self);
end;

procedure TAbm.ButtonFilterClick(Sender: TObject);
begin
  ABMController.FilterData(EditFilter.Text, Self);
end;

procedure TAbm.Cancel;
begin
  ShowPanel(PanelList);
  ABMController.Cancel(Self);
end;

procedure TAbm.CancelButtonClick(Sender: TObject);
begin
  Cancel;
end;

procedure TAbm.CloseButtonClick(Sender: TObject);
begin
  MenuItemSalirClick(Sender);
end;

procedure TAbm.DBGrid1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if (Button in [mbRight]) then
    ShowInfoMessage(ABMController.GetCurrentRecordText(Self));
end;

procedure TAbm.FormShow(Sender: TObject);
begin
  if not ABMController.IsDBConnected(Self) then
    ABMController.Connect(Self);
  ShowPanel(PanelList);
  inherited FormShow(Sender);
end;

end.
