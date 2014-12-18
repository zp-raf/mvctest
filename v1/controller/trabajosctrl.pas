unit trabajosctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmtrabajosdatamodule, DB, mvc, mensajes;

type

  { TTrabajosController }

  TTrabajosController = class(TABMController)
  protected
    function GetCustomModel: TTrabajosDataModule;
  public
    procedure SetFechaIni(ADate: TDateTime; Sender: IView);
    procedure SetFechaFin(ADate: TDateTime; Sender: IView);
    procedure SetPuntajeMax(AValue: double; Sender: IView);
    procedure SetPeso(AValue: double; Sender: IView);
    function GetFechaIni(Sender: IView): TDateTime;
    function GetFechaFin(Sender: IView): TDateTime;
    function GetPuntajeMax(Sender: IView): double;
    function GetPeso(Sender: IView): double;
  end;

implementation

{ TTrabajosController }

function TTrabajosController.GetCustomModel: TTrabajosDataModule;
begin
  Result := GetModel as TTrabajosDataModule;
end;

procedure TTrabajosController.SetFechaIni(ADate: TDateTime; Sender: IView);
begin
  if (GetCustomModel.Trabajo.State in dsEditModes) then
    GetCustomModel.Trabajo.Edit;
  if not IsValidDate(ADate) then
  begin
    Sender.ShowErrorMessage(rsInvalidDate);
    Exit;
  end;
  if not GetCustomModel.Trabajo.FieldByName('FECHAFIN').IsNull and
    (GetCustomModel.Trabajo.FieldByName('FECHAFIN').AsDateTime < ADate) then
    Sender.ShowErrorMessage('La fecha de inicio no puede ser mayor a la de fin')
  else
    GetCustomModel.Trabajo.FieldByName('FECHAINICIO').AsDateTime := ADate;
end;

procedure TTrabajosController.SetFechaFin(ADate: TDateTime; Sender: IView);
begin
  if (GetCustomModel.Trabajo.State in dsEditModes) then
    GetCustomModel.Trabajo.Edit;
  if not IsValidDate(ADate) then
  begin
    Sender.ShowErrorMessage(rsInvalidDate);
    Exit;
  end;
  if not GetCustomModel.Trabajo.FieldByName('FECHAINICIO').IsNull and
    (GetCustomModel.Trabajo.FieldByName('FECHAINICIO').AsDateTime > ADate) then
    Sender.ShowErrorMessage('La fecha de fin no puede ser menor a la de inicio')
  else
    GetCustomModel.Trabajo.FieldByName('FECHAFIN').AsDateTime := ADate;
end;

procedure TTrabajosController.SetPuntajeMax(AValue: double; Sender: IView);
begin
  if (GetCustomModel.Trabajo.State in dsEditModes) then
    GetCustomModel.Trabajo.Edit;
  if AValue < 0 then
    Sender.ShowErrorMessage('Puntaje no debe ser negativo')
  else
    GetCustomModel.Trabajo.FieldByName('PUNTAJEMAX').AsFloat := AValue;
end;

procedure TTrabajosController.SetPeso(AValue: double; Sender: IView);
begin
  if (GetCustomModel.Trabajo.State in dsEditModes) then
    GetCustomModel.Trabajo.Edit;
  if (AValue < 0) or (AValue > 100) then
    Sender.ShowErrorMessage('Peso debe estar entre 0 y 100')
  else
    GetCustomModel.Trabajo.FieldByName('PESO').AsFloat := AValue;
end;

function TTrabajosController.GetFechaIni(Sender: IView): TDateTime;
begin
  Result := GetCustomModel.Trabajo.FieldByName('FECHAINICIO').AsDateTime;
end;

function TTrabajosController.GetFechaFin(Sender: IView): TDateTime;
begin
  Result := GetCustomModel.Trabajo.FieldByName('FECHAFIN').AsDateTime;
end;

function TTrabajosController.GetPuntajeMax(Sender: IView): double;
begin
  Result := GetCustomModel.Trabajo.FieldByName('PUNTAJEMAX').AsFloat;
end;

function TTrabajosController.GetPeso(Sender: IView): double;
begin
  Result := GetCustomModel.Trabajo.FieldByName('PESO').AsFloat;
end;

end.
