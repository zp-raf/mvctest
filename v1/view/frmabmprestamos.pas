unit frmabmprestamos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, ExtCtrls, DBGrids, DBCtrls, StdCtrls, PairSplitter,
  frmAbm, prestamoctrl;

type

  { TAbmPrestamos }

  TAbmPrestamos = class(TAbm)
    DBEditFechaIni: TDBEdit;
    DBEditFechaFin: TDBEdit;
    DBGridEquipos: TDBGrid;
    DBGridPersonas: TDBGrid;
    FechaFin: TLabel;
    FechaInicio: TLabel;
    GroupBoxDetalles: TGroupBox;
    LabeledEditPers: TLabeledEdit;
    LabeledEditEq: TLabeledEdit;
    procedure LabeledEditPersChange(Sender: TObject);
    procedure LabeledEditEqChange(Sender: TObject);
  protected
    function GetCustomController: TPrestamoController;
  end;

var
  AbmPrestamos: TAbmPrestamos;

implementation

{$R *.lfm}

{ TAbmPrestamos }

procedure TAbmPrestamos.LabeledEditPersChange(Sender: TObject);
begin
  GetCustomController.FilterPersData(LabeledEditPers.Text, Self);
end;

procedure TAbmPrestamos.LabeledEditEqChange(Sender: TObject);
begin
  GetCustomController.FilterEqData(LabeledEditEq.Text, Self);
end;

function TAbmPrestamos.GetCustomController: TPrestamoController;
begin
  Result := GetABMController as TPrestamoController;
end;

end.

