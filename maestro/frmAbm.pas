unit frmAbm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, DBGrids, ButtonPanel, EditBtn, StdCtrls, DBCtrls, frmMaestro,
  sqldb, LCLType, IBConnection, BufDataset, abmctrl;

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
    procedure ButtonFilterClick(Sender: TObject); virtual;
    procedure CancelButtonClick(Sender: TObject); virtual;
    procedure CloseButtonClick(Sender: TObject); virtual;
    procedure DBGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure DBNavListClick(Sender: TObject; Button: TDBNavButtonType);
    procedure HelpButtonClick(Sender: TObject); virtual;
    procedure MenuItemGuardarClick(Sender: TObject);
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
  OKButtonClick(Self);
end;

procedure TAbm.OKButtonClick(Sender: TObject);
begin
  Controller.Commit(Self);
  ShowPanel(PanelList);
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

procedure TAbm.ButtonFilterClick(Sender: TObject);
begin

end;

procedure TAbm.CancelButtonClick(Sender: TObject);
begin
  ShowPanel(PanelList);
  Controller.Cancel(Self);
end;

procedure TAbm.CloseButtonClick(Sender: TObject);
begin

end;

procedure TAbm.DBGrid1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if (Button in [mbRight]) then
    ShowInfoMessage((Controller as TABMController).GetCurrentRecordText(Self));
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
  end;
end;

procedure TAbm.HelpButtonClick(Sender: TObject);
begin

end;

end.
