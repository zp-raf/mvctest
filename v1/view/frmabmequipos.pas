unit frmabmequipos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, ExtCtrls, DBGrids, DBCtrls, StdCtrls, LazHelpHTML,
  EditBtn, frmAbm, equipoctrl, mensajes;

type

  { TAbmEquipos }

  TAbmEquipos = class(TAbm)
    DateEdit1: TDateEdit;
    DBCheckBoxActivo: TDBCheckBox;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBMemo1: TDBMemo;
    Descripcion: TLabel;
    FechaIngreso: TLabel;
    NroSerie: TLabel;
    Nombre: TLabel;
    procedure ABMEdit; override;
    procedure ABMInsert; override;
    procedure DateEdit1AcceptDate(Sender: TObject; var ADate: TDateTime;
      var AcceptDate: boolean);
    procedure DateEdit1EditingDone(Sender: TObject);
  protected
    function GetCustomController: TEquiposController;
  end;

var
  AbmEquipos: TAbmEquipos;

implementation

{$R *.lfm}

{ TAbmEquipos }

procedure TAbmEquipos.ABMEdit;
begin
  inherited ABMEdit;
  DateEdit1.Date := GetController.GetFieldValue('FECHAINGRESO', Self);
end;

procedure TAbmEquipos.ABMInsert;
begin
  inherited ABMInsert;
  DateEdit1.Clear;
end;

procedure TAbmEquipos.DateEdit1AcceptDate(Sender: TObject; var ADate: TDateTime;
  var AcceptDate: boolean);
begin
  if GetController.IsValidDate(ADate) then
  begin
    AcceptDate := True;
    GetController.SetFieldValue('FECHAINGRESO', DateEdit1.Date, Self);
  end
  else
  begin
    AcceptDate := False;
    ShowErrorMessage(rsInvalidDate);
  end;
end;

procedure TAbmEquipos.DateEdit1EditingDone(Sender: TObject);
begin
  if GetController.IsValidDate(DateEdit1.Date) then
    GetController.SetFieldValue('FECHAINGRESO', DateEdit1.Date, Self)
  else
  begin
    DateEdit1.Clear;
    ShowErrorMessage(rsInvalidDate);
  end;
end;

function TAbmEquipos.GetCustomController: TEquiposController;
begin
  Result := GetABMController as TEquiposController;
end;

end.

