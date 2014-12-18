unit frmabmtrabajos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, ExtCtrls, DBGrids, DBCtrls, StdCtrls, EditBtn, Spin,
  frmAbm, trabajosctrl;

type

  { TAbmTrabajos }

  TAbmTrabajos = class(TAbm)
    procedure FloatSpinEditPesoEditingDone(Sender: TObject);
    procedure FloatSpinEditPuntajeMaxEditingDone(Sender: TObject);
  protected
    function GetCustomController: TTrabajosController;
  published
    DateEditFechaini: TDateEdit;
    DateEditFechaFin: TDateEdit;
    DBCheckBoxActivo: TDBCheckBox;
    DBEditNombre: TDBEdit;
    DBLookupComboBoxDesarrollo: TDBLookupComboBox;
    FloatSpinEditPuntajeMax: TFloatSpinEdit;
    FloatSpinEditPeso: TFloatSpinEdit;
    LabelDesarrollo: TLabel;
    LabelNombre: TLabel;
    LabelFechaini: TLabel;
    LabelFechaFin: TLabel;
    LabelPuntajeMax: TLabel;
    LabelPeso: TLabel;
    DBMemo1: TDBMemo;
    LabelDescripcion: TLabel;
    procedure ABMInsert; override;
    procedure DateEditFechaFinAcceptDate(Sender: TObject;
      var ADate: TDateTime; var AcceptDate: boolean);
    procedure DateEditFechaFinCustomDate(Sender: TObject; var ADate: string);
    procedure DateEditFechaFinEditingDone(Sender: TObject);
    procedure DateEditFechainiAcceptDate(Sender: TObject; var ADate: TDateTime;
      var AcceptDate: boolean);
    procedure DateEditFechainiCustomDate(Sender: TObject; var ADate: string);
    procedure DateEditFechainiEditingDone(Sender: TObject);
    procedure ObserverUpdate(const Subject: IInterface); override;
  end;

var
  AbmTrabajos: TAbmTrabajos;

implementation

{$R *.lfm}

{ TAbmTrabajos }

procedure TAbmTrabajos.DateEditFechaFinAcceptDate(Sender: TObject;
  var ADate: TDateTime; var AcceptDate: boolean);
begin
  if GetController.IsValidDate(ADate) then
  begin
    AcceptDate := True;
    GetCustomController.SetFechaFin(ADate, Self);
  end
  else
    AcceptDate := False;
end;

procedure TAbmTrabajos.DateEditFechaFinCustomDate(Sender: TObject; var ADate: string);
begin
  GetCustomController.SetFechaFin(StrToDate(ADate), Self);
end;

procedure TAbmTrabajos.DateEditFechaFinEditingDone(Sender: TObject);
begin
  GetCustomController.SetFechaFin(StrToDate(DateEditFechaFin.Text), Self);
end;

procedure TAbmTrabajos.DateEditFechainiAcceptDate(Sender: TObject;
  var ADate: TDateTime; var AcceptDate: boolean);
begin
  if GetController.IsValidDate(ADate) then
  begin
    AcceptDate := True;
    GetCustomController.SetFechaIni(ADate, Self);
  end
  else
    AcceptDate := False;
end;

procedure TAbmTrabajos.DateEditFechainiCustomDate(Sender: TObject; var ADate: string);
begin
  GetCustomController.SetFechaIni(StrToDate(ADate), Self);
end;

procedure TAbmTrabajos.DateEditFechainiEditingDone(Sender: TObject);
begin
  GetCustomController.SetFechaIni(StrToDate(DateEditFechaini.Text), Self);
end;

procedure TAbmTrabajos.FloatSpinEditPesoEditingDone(Sender: TObject);
begin
  GetCustomController.SetPeso(FloatSpinEditPeso.Value, Self);
end;

procedure TAbmTrabajos.FloatSpinEditPuntajeMaxEditingDone(Sender: TObject);
begin
  GetCustomController.SetPuntajeMax(FloatSpinEditPuntajeMax.Value, Self);
end;

function TAbmTrabajos.GetCustomController: TTrabajosController;
begin
  Result := GetController as TTrabajosController;
end;

procedure TAbmTrabajos.ABMInsert;
begin
  inherited ABMInsert;
  DateEditFechaini.Clear;
  DateEditFechaFin.Clear;
  FloatSpinEditPuntajeMax.Clear;
  FloatSpinEditPeso.Clear;
end;

procedure TAbmTrabajos.ObserverUpdate(const Subject: IInterface);
begin
  inherited ObserverUpdate(Subject);
  DateEditFechaini.Date := GetCustomController.GetFechaIni(Self);
  DateEditFechaFin.Date := GetCustomController.GetFechaFin(Self);
  FloatSpinEditPuntajeMax.Value := GetCustomController.GetPuntajeMax(Self);
  FloatSpinEditPeso.Value := GetCustomController.GetPeso(Self);
end;

end.



