unit frmabmtalonarios;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, ExtCtrls, DBGrids, DBCtrls, StdCtrls, frmAbm, sgcdTypes,
  talonarioctrl;

type

  { TAbmTalonarios }

  TAbmTalonarios = class(TAbm)
    procedure DBLookupComboBoxTipoEditingDone(Sender: TObject);
  protected
    function GetCustomController: TTalonarioController;
  published
    DBCheckBoxActivo: TDBCheckBox;
    DBEditNombre: TDBEdit;
    DBEditDesde: TDBEdit;
    DBEditHasta: TDBEdit;
    DBEditDireccion: TDBEdit;
    DBEditCopias: TDBEdit;
    DBEditIni: TDBEdit;
    DBEditFin: TDBEdit;
    DBEditTimbrado: TDBEdit;
    DBEditRUC: TDBEdit;
    DBEditRubro: TDBEdit;
    DBEditTelefono: TDBEdit;
    DBEditCaja: TDBEdit;
    DBEditSucursal: TDBEdit;
    DBLookupComboBoxTipo: TDBLookupComboBox;
    LabelNombre: TLabel;
    LabelDesde: TLabel;
    LabelHasta: TLabel;
    LabelDireccion: TLabel;
    LabelCopias: TLabel;
    LabelTipoTalonario: TLabel;
    LabelIni: TLabel;
    LabelFin: TLabel;
    LabelTimbrado: TLabel;
    LabelRUC: TLabel;
    LabelRubro: TLabel;
    LabelTelefono: TLabel;
    LabelCaja: TLabel;
    LabelSucursal: TLabel;
    procedure ObserverUpdate(const Subject: IInterface); override;

  private
    { private declarations }
  public
    { public declarations }
  end;

var
  AbmTalonarios: TAbmTalonarios;

implementation

{$R *.lfm}

{ TAbmTalonarios }

procedure TAbmTalonarios.DBLookupComboBoxTipoEditingDone(Sender: TObject);
begin
  GetController.RequestUpdate(Self);
end;

function TAbmTalonarios.GetCustomController: TTalonarioController;
begin
  Result := GetABMController as TTalonarioController;
end;

procedure TAbmTalonarios.ObserverUpdate(const Subject: IInterface);
begin
  inherited ObserverUpdate(Subject);
  case GetCustomController.GetTipoTalonario of
    taRecibo:
    begin
      DBEditRUC.Enabled := False;
    end;
    else
      DBEditRUC.Enabled := True;
  end;
end;

end.
