unit frmabmclases;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, ExtCtrls, DBGrids, DBCtrls, StdCtrls, LazHelpHTML,
  EditBtn, frmAbm, clasesctrl, mensajes;

type

  { TAbmClases }

  TAbmClases = class(TAbm)
    DateEdit1: TDateEdit;
    DBEdit2: TDBEdit;
    DBLookupComboBox1: TDBLookupComboBox;
    DBMemo1: TDBMemo;
    DBMemo2: TDBMemo;
    DBMemo3: TDBMemo;
    DBMemo4: TDBMemo;
    DBMemo5: TDBMemo;
    Fecha: TLabel;
    Tema: TLabel;
    ObjetivoGeneral: TLabel;
    ObjetivosEspecificos: TLabel;
    Actividades: TLabel;
    Materiales: TLabel;
    Evaluacion: TLabel;
    Seccion: TLabel;
    procedure DateEdit1AcceptDate(Sender: TObject; var ADate: TDateTime;
      var AcceptDate: boolean);
    procedure DateEdit1EditingDone(Sender: TObject);
  protected
    function GetCustomController: TClaseController;
  end;

var
  AbmClases: TAbmClases;

implementation

{$R *.lfm}

{ TAbmClases }

procedure TAbmClases.DateEdit1AcceptDate(Sender: TObject; var ADate: TDateTime;
  var AcceptDate: boolean);
begin
  if GetController.IsValidDate(ADate) then
  begin
    AcceptDate := True;
    GetController.SetFieldValue('FECHA', DateEdit1.Date, Self);
  end
  else
  begin
    AcceptDate := False;
    ShowErrorMessage(rsInvalidDate);
  end;
end;

procedure TAbmClases.DateEdit1EditingDone(Sender: TObject);
begin
  if GetController.IsValidDate(DateEdit1.Date) then
    GetController.SetFieldValue('FECHA', DateEdit1.Date, Self)
  else
  begin
    DateEdit1.Clear;
    ShowErrorMessage(rsInvalidDate);
  end;
end;

function TAbmClases.GetCustomController: TClaseController;
begin
  Result := GetController as TClaseController;
end;

end.

