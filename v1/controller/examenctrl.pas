unit examenctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmexamendatamodule, mvc, mensajes, observerSubject, DB;

type

  { TExamenesController }

  TExamenesController = class(TABMController)
  protected
    function GetCustomModel: TExamenesDataModule;
  public
    procedure EditCurrentRecord(Sender: IView); override;
    function GetFecha: TDateTime;
    function GetPeso: double;
    function GetPuntajeMax: double;
    procedure SetFecha(ADate: TDateTime; Sender: IView);
    procedure SetPeso(APeso: double; Sender: IView);
    procedure SetPuntajeMax(APuntaje: double; Sender: IView);
  end;

implementation

{ TExamenesController }

function TExamenesController.GetCustomModel: TExamenesDataModule;
begin
  Result := GetModel as TExamenesDataModule;
end;

procedure TExamenesController.EditCurrentRecord(Sender: IView);
begin
  inherited EditCurrentRecord(Sender);
  (GetModel.MasterDataModule as ISubject).Notify;
end;

function TExamenesController.GetFecha: TDateTime;
begin
  Result := GetCustomModel.Examen.FieldByName('FECHA').AsDateTime;
end;

function TExamenesController.GetPeso: double;
begin
  Result := GetCustomModel.Examen.FieldByName('PESO').AsFloat;
end;

function TExamenesController.GetPuntajeMax: double;
begin
  Result := GetCustomModel.Examen.FieldByName('PUNTAJEMAX').AsFloat;
end;

procedure TExamenesController.SetFecha(ADate: TDateTime; Sender: IView);
begin
  if (GetCustomModel.Examen.State in [dsBrowse, dsInactive]) then
    Exit;
  if IsValidDate(ADate) then
    GetCustomModel.Examen.FieldByName('FECHA').AsDateTime := ADate
  else
    Sender.ShowErrorMessage(rsInvalidDate);
end;

procedure TExamenesController.SetPeso(APeso: double; Sender: IView);
begin
  if (GetCustomModel.Examen.State in [dsBrowse, dsInactive]) then
    Exit;
  if (APeso < 0.0) or (APeso > 100.0) then
    Sender.ShowErrorMessage('Peso debe estar entre 0 y 100')
  else
    GetCustomModel.Examen.FieldByName('PESO').AsFloat := APeso;
end;

procedure TExamenesController.SetPuntajeMax(APuntaje: double; Sender: IView);
begin
  if (GetCustomModel.Examen.State in [dsBrowse, dsInactive]) then
    Exit;
  if APuntaje < 0.0 then
    Sender.ShowErrorMessage('Puntaje debe ser mayor a 0')
  else
    GetCustomModel.Examen.FieldByName('PUNTAJEMAX').AsFloat := APuntaje;
end;

end.
