unit frmabmcuentas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ButtonPanel, ExtCtrls, DBGrids, DbCtrls, StdCtrls, frmAbm;

type

  { TAbmCuentas }

  TAbmCuentas = class(TAbm)
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBRadioGroupTipo: TDBRadioGroup;
    Codigo: TLabel;
    LabeledEdit1: TLabeledEdit;
    Nombre: TLabel;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  AbmCuentas: TAbmCuentas;

implementation

{$R *.lfm}

{ TAbmCuentas }

end.

