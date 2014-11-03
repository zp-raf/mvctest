unit frmProcNotaCredito;

{$mode objfpc}{$H+}

interface

uses
  frmprocesorecibo, StdCtrls, DBCtrls, EditBtn, ComCtrls, Menus, ButtonPanel,
  PairSplitter, DBGrids, notacreditoctrl, ctrl;

type

  { TProcesoNotaCredito }

  TProcesoNotaCredito = class(TProcesoRecibo)
    DBEdit1: TDBEdit;
    Label1: TLabel;
  protected
    function GetABMController: TABMController;
    function GetCustomController: TNotaCreditoController;
  published
    DateEditVen: TDateEdit;
    DBEditIVA10: TDBEdit;
    DBEditIVA5: TDBEdit;
    DBEditIVATotal: TDBEdit;
    DBEditNotaRem: TDBEdit;
    DBEditSubTotal: TDBEdit;
    DBEditSubTotal10: TDBEdit;
    DBEditSubTotal5: TDBEdit;
    LabelIVA10: TLabel;
    LabelIVA5: TLabel;
    LabelIVATotal: TLabel;
    LabelNotaRem: TLabel;
    LabelSubtotal: TLabel;
    LabelSubtotal10: TLabel;
    LabelSubtotal5: TLabel;
    LabelVen: TLabel;
    RadioCondicion: TDBRadioGroup;
  end;

var
  ProcesoNotaCredito: TProcesoNotaCredito;

implementation

{$R *.lfm}

{ TProcesoNotaCredito }

function TProcesoNotaCredito.GetABMController: TABMController;
begin
  Result := GetController as TABMController;
end;

function TProcesoNotaCredito.GetCustomController: TNotaCreditoController;
begin
  Result := GetController as TNotaCreditoController;
end;

end.
