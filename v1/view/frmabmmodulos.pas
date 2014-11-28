unit frmabmmodulos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, ExtCtrls, DBGrids, DbCtrls, StdCtrls, frmAbm;

type

  { TAbmModulos }

  TAbmModulos = class(TAbm)
    DBCheckBoxActivo: TDBCheckBox;
    DBCheckBoxModuloGen: TDBCheckBox;
    DBEditNombre: TDBEdit;
    LabelNombre: TLabel;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  AbmModulos: TAbmModulos;

implementation

{$R *.lfm}

end.

