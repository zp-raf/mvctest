unit frmabmequipos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, ExtCtrls, DBGrids, DbCtrls, StdCtrls, frmAbm, equipoctrl;

type

  { TAbmEquipos }

  TAbmEquipos = class(TAbm)
    DBCheckBoxActivo: TDBCheckBox;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBMemo1: TDBMemo;
    Descripcion: TLabel;
    FechaIngreso: TLabel;
    NroSerie: TLabel;
    Nombre: TLabel;
  protected
    function GetCustomController: TEquiposController;
  end;

var
  AbmEquipos: TAbmEquipos;

implementation

{$R *.lfm}

{ TAbmEquipos }

function TAbmEquipos.GetCustomController: TEquiposController;
begin
  Result := GetABMController as TEquiposController;
end;

end.

