unit frmabmaranceles;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, ExtCtrls, DBGrids, DBCtrls, StdCtrls, Spin, frmAbm,
  arancelesctrl;

type

  { TAbmAranceles }

  TAbmAranceles = class(TAbm)
    DBCheckBoxActivo: TDBCheckBox;
    DBEditCantCuotas: TDBEdit;
    DBEditVencCant: TDBEdit;
    DBEditMonto: TDBEdit;
    DBEditNombre: TDBEdit;
    DBEditDesc: TDBEdit;
    DBGrid2: TDBGrid;
    DBLookupComboBoxVencUnidad: TDBLookupComboBox;
    DBNavigator1: TDBNavigator;
    GroupBoxCuotas: TGroupBox;
    GroupBoxImpuestos: TGroupBox;
    LabelCantCuotas: TLabel;
    LabelVencUnidad: TLabel;
    LabelVencCant: TLabel;
    LabelMonto: TLabel;
    LabelDescripcion: TLabel;
    LabelNombre: TLabel;
  private
    { private declarations }
  protected
    function GetCustomController: TArancelesController;
  public
    { public declarations }
  end;

var
  AbmAranceles: TAbmAranceles;

implementation

{$R *.lfm}

{ TAbmAranceles }

function TAbmAranceles.GetCustomController: TArancelesController;
begin
  Result := GetABMController as TArancelesController;
end;

end.

