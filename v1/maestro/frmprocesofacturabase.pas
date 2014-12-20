unit frmprocesofacturabase;

{$mode objfpc}{$H+}

interface

uses
  StdCtrls, DBCtrls, EditBtn, ComCtrls, Menus, ButtonPanel, PairSplitter,
  DBGrids, notacreditoctrl, ctrl, Forms, sgcdTypes, Graphics,
  frmprocesocomprobante, Classes;

type

  { TProcesoFacturaBase }

  TProcesoFacturaBase = class(TProcesoComprobante)
  published
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
    procedure Limpiar; override;
  end;

var
  ProcesoFacturaBase: TProcesoFacturaBase;

implementation

{$R *.lfm}

{ TProcesoFacturaBase }

procedure TProcesoFacturaBase.Limpiar;
begin
  inherited;
  DBEditDireccion.Clear;
  DBEditRuc.Clear;
  DBEditTelefono.Clear;
  DBEditNotaRem.Clear;
  DBEditSubTotal.Clear;
  DBEditGranTotal.Clear;
  DBEditIVA5.Clear;
  DBEditIVA10.Clear;
  DBEditIVATotal.Clear;
  DBEditSubTotal5.Clear;
  DBEditSubTotal10.Clear;
  DBEditNombre.Clear;
  DateEditFecha.Clear;
end;


end.
