unit frmabmprestamos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, ExtCtrls, DBGrids, DBCtrls, StdCtrls, PairSplitter,
  LazHelpHTML, EditBtn, frmAbm, prestamoctrl, mensajes;

type

  { TAbmPrestamos }

  TAbmPrestamos = class(TAbm)
    DateEditIni: TDateEdit;
    DateEditFin: TDateEdit;
    DBCheckBox1: TDBCheckBox;
    DBGridEquipos: TDBGrid;
    DBGridPersonas: TDBGrid;
    FechaFin: TLabel;
    FechaInicio: TLabel;
    GroupBoxDetalles: TGroupBox;
    LabeledEditPers: TLabeledEdit;
    LabeledEditEq: TLabeledEdit;
    procedure ABMEdit; override;
    procedure ABMInsert; override;
    procedure DateEditFinAcceptDate(Sender: TObject; var ADate: TDateTime;
      var AcceptDate: boolean);
    procedure DateEditFinEditingDone(Sender: TObject);
    procedure DateEditIniAcceptDate(Sender: TObject; var ADate: TDateTime;
      var AcceptDate: boolean);
    procedure DateEditIniEditingDone(Sender: TObject);
    procedure LabeledEditPersChange(Sender: TObject);
    procedure LabeledEditEqChange(Sender: TObject);
    procedure OK(Sender: TObject); override;
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

procedure TAbmPrestamos.DateEditIniEditingDone(Sender: TObject);
begin
  if GetController.IsValidDate(DateEditIni.Date) then
    GetController.SetFieldValue('FECHAINICIO', DateEditIni.Date, Self)
  else
  begin
    DateEditIni.Clear;
    ShowErrorMessage(rsInvalidDate);
  end;
end;

procedure TAbmPrestamos.ABMEdit;
begin
  inherited ABMEdit;
  DateEditIni.Date := GetController.GetFieldValue('FECHAINICIO', Self);
  DateEditFin.Date := GetController.GetFieldValue('FECHAFIN', Self);
end;

procedure TAbmPrestamos.ABMInsert;
begin
  inherited ABMInsert;
  DateEditFin.Clear;
  DateEditIni.Clear;
end;

procedure TAbmPrestamos.DateEditFinAcceptDate(Sender: TObject;
  var ADate: TDateTime; var AcceptDate: boolean);
begin
  if GetController.IsValidDate(ADate) then
  begin
    AcceptDate := True;
    GetController.SetFieldValue('FECHAFIN', DateEditFin.Date, Self);
  end
  else
  begin
    AcceptDate := False;
    ShowErrorMessage(rsInvalidDate);
  end;
end;

procedure TAbmPrestamos.DateEditFinEditingDone(Sender: TObject);
begin
  if GetController.IsValidDate(DateEditFin.Date) then
    GetController.SetFieldValue('FECHAFIN', DateEditFin.Date, Self)
  else
  begin
    DateEditFin.Clear;
    ShowErrorMessage(rsInvalidDate);
  end;
end;

procedure TAbmPrestamos.DateEditIniAcceptDate(Sender: TObject;
  var ADate: TDateTime; var AcceptDate: boolean);
begin
  if GetController.IsValidDate(ADate) then
  begin
    AcceptDate := True;
    GetController.SetFieldValue('FECHAINICIO', DateEditFin.Date, Self);
  end
  else
  begin
    AcceptDate := False;
    ShowErrorMessage(rsInvalidDate);
  end;
end;

procedure TAbmPrestamos.LabeledEditEqChange(Sender: TObject);
begin
  GetCustomController.FilterEqData(LabeledEditEq.Text, Self);
end;

procedure TAbmPrestamos.OK(Sender: TObject);
begin
  if DateEditIni.Date > DateEditFin.Date then
    ShowErrorMessage('Rango de fechas invalido')
  else
    inherited OK(Sender);
end;

function TAbmPrestamos.GetCustomController: TPrestamoController;
begin
  Result := GetABMController as TPrestamoController;
end;

end.
