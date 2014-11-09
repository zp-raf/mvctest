unit frmAbm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, DBGrids, ButtonPanel, EditBtn, StdCtrls, DBCtrls, frmMaestro,
  sqldb, LCLType, IBConnection, BufDataset, mvc, ctrl, mensajes;

type

  { TAbm }

  TAbm = class(TMaestro, IABMView)
    procedure EditFilterKeyUp(Sender: TObject; var Key: word; {%H-}Shift: TShiftState);
  protected
    function GetABMController: TABMController;
  public
    constructor Create(AOwner: IFormView; AController: Pointer); override;
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
    {%H-}Shift: TShiftState; {%H-}X, {%H-}Y: integer);
    procedure DBNavListBeforeAction(Sender: TObject; Button: TDBNavButtonType);
    procedure FormShow(Sender: TObject);
    procedure MenuItemGuardarClick(Sender: TObject);
    procedure OK(Sender: TObject); virtual;
    procedure OKButtonClick(Sender: TObject); virtual;
    procedure ShowPanel(APanel: TPanel);
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
  GetController.OK(Self);
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
    // look for the TPanel type childs
    if (Components[i] is TPanel) and (Components[i] = (APanel as TComponent)) then
      // make it visible and hide the rest of them
      TPanel(Components[i]).Visible := True
    else if Components[i] is TPanel then
      TPanel(Components[i]).Visible := False;
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
    nbDelete:
    begin
      ABMDelete;
    end;
  end;
end;

procedure TAbm.EditFilterKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if Sender <> EditFilter then
    Exit;
  if Key = VK_RETURN then
    GetABMController.FilterData(Trim(EditFilter.Text), Self);
end;

function TAbm.GetABMController: TABMController;
begin
  Result := GetController as TABMController;
end;

constructor TAbm.Create(AOwner: IFormView; AController: Pointer);
begin
  if Assigned(AController) and (TObject(AController) is TABMController) then
  begin
    inherited Create(AOwner, AController);
  end
  else
    raise Exception.Create(rsCreateErrorInvalidCont);
end;

procedure TAbm.ABMInsert;
begin
  ShowPanel(PanelDetail);
  GetController.NewRecord(Self);
end;

procedure TAbm.ABMEdit;
begin
  ShowPanel(PanelDetail);
  GetController.EditCurrentRecord(Self);
end;

procedure TAbm.ABMDelete;
begin

end;

procedure TAbm.ABMRefresh;
begin
  GetController.RefreshData(Self);
end;

procedure TAbm.ButtonFilterClick(Sender: TObject);
begin
  GetABMController.FilterData(Trim(EditFilter.Text), Self);
end;

procedure TAbm.Cancel;
begin
  ShowPanel(PanelList);
  GetController.Cancel(Self);
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
    ShowInfoMessage(GetABMController.GetCurrentRecordText(Self));
end;

procedure TAbm.FormShow(Sender: TObject);
begin
  if not GetController.IsDBConnected(Self) then
    GetController.Connect(Self);
  GetController.RefreshData(Self);
  ShowPanel(PanelList);
  inherited FormShow(Sender);
end;

end.
