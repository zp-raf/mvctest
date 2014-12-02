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
  protected
    function GetCustomController: TModuloController;
  end;

var
  AbmModulos: TAbmModulos;

implementation

{$R *.lfm}

{ TAbmModulos }

function TAbmModulos.GetCustomController: TModuloController;
begin
  Result := GetABMController as TModuloController;
end;

end.

