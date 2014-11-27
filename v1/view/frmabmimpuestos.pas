unit frmabmimpuestos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, ExtCtrls, DBGrids, DbCtrls, StdCtrls, frmAbm,
  impuestoctrl;

type

  { TAbmImpuestos }

  TAbmImpuestos = class(TAbm)
    DBCheckBoxActivo: TDBCheckBox;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    LabelNombre: TLabel;
    LabelFactor: TLabel;
  protected
    function GetCustomController: TImpuestoController;
  end;

var
  AbmImpuestos: TAbmImpuestos;

implementation

{$R *.lfm}

{ TAbmImpuestos }

function TAbmImpuestos.GetCustomController: TImpuestoController;
begin
  Result := GetABMController as TImpuestoController;
end;

end.

