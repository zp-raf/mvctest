unit frmabmjustificativos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, ExtCtrls, DBGrids, DBCtrls, StdCtrls, LazHelpHTML,
  EditBtn, frmAbm, justificativoctrl, mensajes;

type

  { TAbmJustificativos }

  TAbmJustificativos = class(TAbm)
    DateEditPres: TDateEdit;
    DateEditInasistencia: TDateEdit;
    DBLookupComboBox1: TDBLookupComboBox;
    DBMemo1: TDBMemo;
    DBMemo2: TDBMemo;
    Persona: TLabel;
    FechaPresentacion: TLabel;
    FechaInasistencia: TLabel;
    Motivo: TLabel;
    Detalles: TLabel;
    procedure ABMEdit; override;
    procedure ABMInsert; override;
    procedure DateEditInasistenciaAcceptDate(Sender: TObject;
      var ADate: TDateTime; var AcceptDate: boolean);
    procedure DateEditInasistenciaEditingDone(Sender: TObject);
    procedure DateEditPresAcceptDate(Sender: TObject; var ADate: TDateTime;
      var AcceptDate: boolean);
    procedure DateEditPresEditingDone(Sender: TObject);
  protected
    function GetCustomController: TJustificativoController;
  end;

var
  AbmJustificativos: TAbmJustificativos;

implementation

{$R *.lfm}

{ TAbmJustificativos }

procedure TAbmJustificativos.ABMEdit;
begin
  inherited ABMEdit;
  DateEditInasistencia.Date := GetController.GetFieldValue('FECHAINASISTENCIA', Self);
  DateEditPres.Date := GetController.GetFieldValue('FECHAPRESENTACION', Self);
end;

procedure TAbmJustificativos.ABMInsert;
begin
  inherited ABMInsert;
  DateEditInasistencia.Clear;
  DateEditPres.Clear;
end;

procedure TAbmJustificativos.DateEditInasistenciaAcceptDate(Sender: TObject;
  var ADate: TDateTime; var AcceptDate: boolean);
begin
  if GetController.IsValidDate(ADate) then
  begin
    AcceptDate := True;
    GetController.SetFieldValue('FECHAINASISTENCIA', DateEditInasistencia.Date, Self);
  end
  else
  begin
    AcceptDate := False;
    ShowErrorMessage(rsInvalidDate);
  end;
end;

procedure TAbmJustificativos.DateEditInasistenciaEditingDone(Sender: TObject);
begin
  if GetController.IsValidDate(DateEditInasistencia.Date) then
    GetController.SetFieldValue('FECHAINASISTENCIA', DateEditInasistencia.Date, Self)
  else
  begin
    DateEditInasistencia.Clear;
    ShowErrorMessage(rsInvalidDate);
  end;
end;

procedure TAbmJustificativos.DateEditPresAcceptDate(Sender: TObject;
  var ADate: TDateTime; var AcceptDate: boolean);
begin
  if GetController.IsValidDate(ADate) then
  begin
    AcceptDate := True;
    GetController.SetFieldValue('FECHAPRESENTACION', DateEditPres.Date, Self);
  end
  else
  begin
    AcceptDate := False;
    ShowErrorMessage(rsInvalidDate);
  end;
end;

procedure TAbmJustificativos.DateEditPresEditingDone(Sender: TObject);
begin
  if GetController.IsValidDate(DateEditPres.Date) then
    GetController.SetFieldValue('FECHAPRESENTACION', DateEditPres.Date, Self)
  else
  begin
    DateEditPres.Clear;
    ShowErrorMessage(rsInvalidDate);
  end;
end;

function TAbmJustificativos.GetCustomController: TJustificativoController;
begin
  Result := GetController as TJustificativoController;
end;

end.
