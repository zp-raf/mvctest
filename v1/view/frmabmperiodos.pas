unit frmabmperiodos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, frmAbm,
  periodoctrl, ComCtrls, Menus, ButtonPanel, ExtCtrls, DBGrids, DBCtrls,
  StdCtrls, LazHelpHTML, EditBtn, mensajes;

type

  { TAbmPeriodos }

  TAbmPeriodos = class(TAbm)
    DateEdit1: TDateEdit;
    DateEdit2: TDateEdit;
    DBCheckBoxACtivo: TDBCheckBox;
    DBEditNombre: TDBEdit;
    DBMemoDescripcion: TDBMemo;
    LabelNombre: TLabel;
    LabelDescrpcion: TLabel;
    LabelIni: TLabel;
    LabelFin: TLabel;
    procedure ABMEdit; override;
    procedure ABMInsert; override;
    procedure DateEdit1AcceptDate(Sender: TObject; var ADate: TDateTime;
      var AcceptDate: boolean);
    procedure DateEdit1EditingDone(Sender: TObject);
    procedure DateEdit2AcceptDate(Sender: TObject; var ADate: TDateTime;
      var AcceptDate: boolean);
    procedure DateEdit2EditingDone(Sender: TObject);
  protected
    function GetCustomController: TPeriodoController;
  end;

var
  AbmPeriodos: TAbmPeriodos;

implementation

{$R *.lfm}

{ TAbmPeriodos }

procedure TAbmPeriodos.ABMEdit;
begin
  inherited ABMEdit;
  DBCheckBoxACtivo.Enabled := True;
  DateEdit1.Date := GetController.GetFieldValue('FECHAINICIO', Self);
  DateEdit2.Date := GetController.GetFieldValue('FECHAFIN', Self);
end;

procedure TAbmPeriodos.ABMInsert;
begin
  ShowPanel(PanelDetail);
  if GetCustomController.HayPeriodoActivo then
    DBCheckBoxACtivo.Enabled := False
  else
    DBCheckBoxACtivo.Enabled := True;
  GetController.NewRecord(Self);
  DateEdit1.Clear;
  DateEdit2.Clear;
end;

procedure TAbmPeriodos.DateEdit1AcceptDate(Sender: TObject;
  var ADate: TDateTime; var AcceptDate: boolean);
begin
  if GetController.IsValidDate(ADate) then
  begin
    AcceptDate := True;
    GetController.SetFieldValue('FECHAINICIO', ADate, Self);
  end
  else
  begin
    AcceptDate := False;
    ShowErrorMessage(rsInvalidDate);
  end;
end;

procedure TAbmPeriodos.DateEdit1EditingDone(Sender: TObject);
begin
  if GetController.IsValidDate(DateEdit1.Date) then
    GetController.SetFieldValue('FECHAINICIO', DateEdit1.Date, Self)
  else
  begin
    DateEdit1.Clear;
    ShowErrorMessage(rsInvalidDate);
  end;
end;

procedure TAbmPeriodos.DateEdit2AcceptDate(Sender: TObject;
  var ADate: TDateTime; var AcceptDate: boolean);
begin
  if GetController.IsValidDate(ADate) then
  begin
    AcceptDate := True;
    GetController.SetFieldValue('FECHAFIN', ADate, Self);
  end
  else
  begin
    AcceptDate := False;
    ShowErrorMessage(rsInvalidDate);
  end;
end;

procedure TAbmPeriodos.DateEdit2EditingDone(Sender: TObject);
begin
  if GetController.IsValidDate(DateEdit1.Date) then
    GetController.SetFieldValue('FECHAFIN', DateEdit2.Date, Self)
  else
  begin
    DateEdit1.Clear;
    ShowErrorMessage(rsInvalidDate);
  end;
end;

function TAbmPeriodos.GetCustomController: TPeriodoController;
begin
  Result := GetABMController as TPeriodoController;
end;

end.

