unit frmAbm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, DBGrids, ButtonPanel, EditBtn, StdCtrls, DBCtrls, frmMaestro,
  sqldb, LCLType, IBConnection, BufDataset, mvc;

type

  { TAbm }

  TAbm = class(TMaestro)
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
    TBConnected: TToggleBox;
    procedure ButtonFilterClick(Sender: TObject); virtual;
    procedure CancelButtonClick(Sender: TObject); virtual;
    procedure CloseButtonClick(Sender: TObject); virtual;
    procedure DBGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure DBNavListClick(Sender: TObject; Button: TDBNavButtonType);
    procedure FormShow(Sender: TObject);
    procedure MenuItemGuardarClick(Sender: TObject);
    procedure OK(Sender: TObject); virtual;
    procedure OKButtonClick(Sender: TObject); virtual;
    procedure ShowPanel(APanel: TPanel);
    procedure TBConnectedClick(Sender: TObject);
    procedure ObserverUpdate(const Subject: IInterface); override;
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
  Controller.Commit(Self);
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

procedure TAbm.TBConnectedClick(Sender: TObject);
begin
  if (Sender as TToggleBox).Checked then
    Controller.Connect(Self)
  else
    Controller.Disconnect(Self);
end;

procedure TAbm.ObserverUpdate(const Subject: IInterface);
begin
  { aca se actualiza la vista. en este caso que es para prueba nomas
    cambiamos boton connected }
  if Controller.IsDBConnected(Self) then
    TBConnected.Checked := True
  else
    TBConnected.Checked := False;
end;

procedure TAbm.ButtonFilterClick(Sender: TObject);
begin
  Controller.FilterData(EditFilter.Text, Self);
end;

procedure TAbm.CancelButtonClick(Sender: TObject);
begin
  ShowPanel(PanelList);
  Controller.Cancel(Self);
end;

procedure TAbm.CloseButtonClick(Sender: TObject);
begin
  MenuItemSalirClick(Sender);
end;

procedure TAbm.DBGrid1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if (Button in [mbRight]) then
    ShowInfoMessage(Controller.GetCurrentRecordText(Self));
end;

procedure TAbm.DBNavListClick(Sender: TObject; Button: TDBNavButtonType);
begin
  case Button of
    nbInsert:
    begin
      ShowPanel(PanelDetail);
      Controller.NewRecord(Self);
    end;
    nbEdit:
    begin
      ShowPanel(PanelDetail);
      Controller.EditCurrentRecord(Self);
    end;
    nbRefresh:
    begin
      Controller.RefreshData(Self);
    end;
  end;
end;

procedure TAbm.FormShow(Sender: TObject);
begin
  if not Controller.IsDBConnected(Self) then
    Controller.Connect(Self);
  inherited FormShow(Sender);
end;

end.
