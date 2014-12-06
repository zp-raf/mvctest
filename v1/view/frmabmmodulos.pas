unit frmabmmodulos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, ExtCtrls, DBGrids, DBCtrls, StdCtrls, frmAbm, moduloctrl;

type

  { TAbmModulos }

  TAbmModulos = class(TAbm)
    DBCheckBoxActivo: TDBCheckBox;
    DBCheckBoxModuloGen: TDBCheckBox;
    DBEditNombre: TDBEdit;
    DBMemoDesc: TDBMemo;
    DBMemoFund: TDBMemo;
    DBMemoObj: TDBMemo;
    DBMemoReq: TDBMemo;
    DBMemoPerf: TDBMemo;
    LabelDescripcion: TLabel;
    LabelFundamentacion: TLabel;
    LabelObjetivos: TLabel;
    LabelRequisitos: TLabel;
    LabelPerfilEgresado: TLabel;
    LabelNombre: TLabel;
    procedure ABMInsert; override;
    procedure ABMEdit; override;
  protected
    function GetCustomController: TModuloController;
  end;

var
  AbmModulos: TAbmModulos;

implementation

{$R *.lfm}

{ TAbmModulos }

procedure TAbmModulos.ABMInsert;
begin
  ShowPanel(PanelDetail);
  if GetCustomController.ModuloGeneralDefinido(Self) then
  begin
    DBCheckBoxModuloGen.Enabled := False;
    DBCheckBoxModuloGen.Checked := False;
  end;
  GetController.NewRecord(Self);
end;

procedure TAbmModulos.ABMEdit;
begin
  inherited ABMEdit;
  DBCheckBoxModuloGen.Enabled := True;
end;

function TAbmModulos.GetCustomController: TModuloController;
begin
  Result := GetABMController as TModuloController;
end;

end.

