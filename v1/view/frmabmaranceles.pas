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
    CheckBoxSetCuotas: TCheckBox;
    CheckBoxSetImpuestos: TCheckBox;
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
    procedure ABMEdit; override;
    procedure ABMInsert; override;
    procedure CheckBoxSetCuotasChange(Sender: TObject);
    procedure CheckBoxSetImpuestosChange(Sender: TObject);
  protected
    function GetCustomController: TArancelesController;
  end;

var
  AbmAranceles: TAbmAranceles;

implementation

{$R *.lfm}

{ TAbmAranceles }

procedure TAbmAranceles.ABMEdit;
begin
  inherited ABMEdit;
  try
    CheckBoxSetCuotas.OnChange := nil;
    CheckBoxSetImpuestos.OnChange := nil;
    CheckBoxSetCuotas.Checked := GetCustomController.HayCuotas;
    GroupBoxCuotas.Enabled := GetCustomController.HayCuotas;
    CheckBoxSetImpuestos.Checked := GetCustomController.HayImpuestos;
    GroupBoxImpuestos.Enabled := GetCustomController.HayImpuestos;
  finally
    CheckBoxSetCuotas.OnChange := @CheckBoxSetCuotasChange;
    CheckBoxSetImpuestos.OnChange := @CheckBoxSetImpuestosChange;
  end;
end;

procedure TAbmAranceles.ABMInsert;
begin
  inherited ABMInsert;
  CheckBoxSetImpuestos.Checked := False;
  GroupBoxImpuestos.Enabled := False;
  CheckBoxSetCuotas.Checked := False;
  GroupBoxCuotas.Enabled := False;
end;

procedure TAbmAranceles.CheckBoxSetCuotasChange(Sender: TObject);
begin
  GroupBoxCuotas.Enabled := TCheckBox(Sender).Checked;
  GetCustomController.SetCuotas(TCheckBox(Sender).Checked);
end;

procedure TAbmAranceles.CheckBoxSetImpuestosChange(Sender: TObject);
begin
  GroupBoxImpuestos.Enabled := TCheckBox(Sender).Checked;
  GetCustomController.SetImpuesos(TCheckBox(Sender).Checked);
end;

function TAbmAranceles.GetCustomController: TArancelesController;
begin
  Result := GetABMController as TArancelesController;
end;

end.

