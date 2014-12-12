unit frmabmcuentas;

{$mode objfpc}{$H+}

interface

uses
  Forms, Controls, Menus, ExtCtrls, DBCtrls, StdCtrls, frmAbm,
  cuentactrl;

resourcestring
  rsControllerErr = 'El controlador no es del tipo adecuado';

type

  { TAbmCuentas }

  TAbmCuentas = class(TAbm)
  protected
    function GetCustomController: TCuentaController;
  published
    DBLookupComboBox1: TDBLookupComboBox;
    LabelCuentaPadre: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBRadioGroupTipo: TDBRadioGroup;
    Codigo: TLabel;
    Nombre: TLabel;
    procedure ABMInsert; override;
    procedure ObserverUpdate(const Subject: IInterface); override;
  end;

var
  AbmCuentas: TAbmCuentas;

implementation

{$R *.lfm}

{ TAbmCuentas }

procedure TAbmCuentas.ObserverUpdate(const Subject: IInterface);
begin
  inherited ObserverUpdate(Subject);
  if GetCustomController.EsCuentaHija then
    DBRadioGroupTipo.Enabled := False
  else
    DBRadioGroupTipo.Enabled := True;
end;

function TAbmCuentas.GetCustomController: TCuentaController;
begin
  Result := GetController as TCuentaController;
end;

procedure TAbmCuentas.ABMInsert;
begin
  inherited ABMInsert;
  DBRadioGroupTipo.Enabled := True;
end;

end.
