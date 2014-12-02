unit frmabmperiodos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, frmAbm,
  periodoctrl, ComCtrls, Menus, ButtonPanel, ExtCtrls, DBGrids, DbCtrls,
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
  protected
    function GetCustomController: TPeriodoController;
  end;

var
  AbmPeriodos: TAbmPeriodos;

implementation

{$R *.lfm}

{ TAbmPeriodos }

function TAbmPeriodos.GetCustomController: TPeriodoController;
begin
  Result := GetABMController as TPeriodoController;
end;

end.

