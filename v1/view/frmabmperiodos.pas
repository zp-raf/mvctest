unit frmabmperiodos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, frmAbm,
  periodoctrl, ComCtrls, Menus, ButtonPanel, ExtCtrls, DBGrids, DBCtrls,
  StdCtrls;

type

  { TAbmPeriodos }

  TAbmPeriodos = class(TAbm)
    DBCheckBoxACtivo: TDBCheckBox;
    DBEditNombre: TDBEdit;
    DBEditFechaIni: TDBEdit;
    DBEditFechaFin: TDBEdit;
    DBMemoDescripcion: TDBMemo;
    LabelNombre: TLabel;
    LabelDescrpcion: TLabel;
    LabelIni: TLabel;
    LabelFin: TLabel;
    procedure ABMEdit; override;
    procedure ABMInsert; override;
  protected
    function GetCustomController: TPeriodoController;
  end;

var
  AbmPeriodos: TAbmPeriodos;

implementation

{$R *.lfm}

{ TAbmPeriodos }

procedure TAbmPeriodos.ABMEdit;
begin
  inherited ABMEdit;
  DBCheckBoxACtivo.Enabled := True;
end;

procedure TAbmPeriodos.ABMInsert;
begin
  ShowPanel(PanelDetail);
  if GetCustomController.HayPeriodoActivo then
    DBCheckBoxACtivo.Enabled := False
  else
    DBCheckBoxACtivo.Enabled := True;
  GetController.NewRecord(Self);
end;

function TAbmPeriodos.GetCustomController: TPeriodoController;
begin
  Result := GetABMController as TPeriodoController;
end;

end.

