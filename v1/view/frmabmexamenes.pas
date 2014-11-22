unit frmabmexamenes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, ExtCtrls, DBGrids, DBCtrls, StdCtrls, EditBtn, Spin,
  frmAbm, examenctrl;

type

  { TAbmExamenes }

  TAbmExamenes = class(TAbm)
  protected
    function GetCustomController: TExamenesController;
  published
    DateEditFecha: TDateEdit;
    DBCheckBoxActivo: TDBCheckBox;
    DBLookupComboBoxSeccion: TDBLookupComboBox;
    DBMemoObservaciones: TDBMemo;
    FloatSpinEditPuntajeMax: TFloatSpinEdit;
    FloatSpinEditPeso: TFloatSpinEdit;
    LabelSeccion: TLabel;
    LabelFecha: TLabel;
    LabelPuntajeMax: TLabel;
    LabelPeso: TLabel;
    LabelObservaciones: TLabel;
    DBGrid2: TDBGrid;
    DBNavigator1: TDBNavigator;
    procedure ABMInsert; override;
    procedure DateEditFechaAcceptDate(Sender: TObject; var ADate: TDateTime;
      var AcceptDate: boolean);
    procedure DateEditFechaEditingDone(Sender: TObject);
    procedure FloatSpinEditPesoChange(Sender: TObject);
    procedure FloatSpinEditPuntajeMaxChange(Sender: TObject);
    procedure ObserverUpdate(const Subject: IInterface); override;
  end;

var
  AbmExamenes: TAbmExamenes;

implementation

{$R *.lfm}

{ TAbmExamenes }

procedure TAbmExamenes.FloatSpinEditPesoChange(Sender: TObject);
begin
  GetCustomController.SetPeso(FloatSpinEditPeso.Value, Self);
end;

procedure TAbmExamenes.DateEditFechaAcceptDate(Sender: TObject;
  var ADate: TDateTime; var AcceptDate: boolean);
begin
  if GetController.IsValidDate(ADate) then
  begin
    AcceptDate := True;
    GetCustomController.SetFecha(ADate, Self);
  end;
end;

function TAbmExamenes.GetCustomController: TExamenesController;
begin
  Result := GetController as TExamenesController;
end;

procedure TAbmExamenes.ABMInsert;
begin
  inherited ABMInsert;
  DateEditFecha.Clear;
  FloatSpinEditPeso.Clear;
  FloatSpinEditPuntajeMax.Clear;
end;

procedure TAbmExamenes.DateEditFechaEditingDone(Sender: TObject);
begin
  GetCustomController.SetFecha(DateEditFecha.Date, Self);
end;

procedure TAbmExamenes.FloatSpinEditPuntajeMaxChange(Sender: TObject);
begin
  GetCustomController.SetPuntajeMax(FloatSpinEditPuntajeMax.Value, Self);
end;

procedure TAbmExamenes.ObserverUpdate(const Subject: IInterface);
begin
  inherited ObserverUpdate(Subject);
  DateEditFecha.Date := GetCustomController.GetFecha;
  FloatSpinEditPuntajeMax.Value := GetCustomController.GetPuntajeMax;
  FloatSpinEditPeso.Value := GetCustomController.GetPeso;
end;

end.

