unit reporteextractoctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, reportectrl, frmreporteextractodatamodule, mvc, mensajes;

type

  { TRepExtractoController }

  TRepExtractoController = class(TReporteController)
  protected
    function GetCustomModel: TReporteExtractoDataModule;
  public
    procedure ShowReport(AFechaIni: TDateTime; AFechaFin: TDateTime; Sender: IView);
    procedure ShowReport(ACuentaID: string; AFechaIni: TDateTime;
      AFechaFin: TDateTime; Sender: IView);
  end;

implementation

{ TRepExtractoController }

function TRepExtractoController.GetCustomModel: TReporteExtractoDataModule;
begin
  Result := GetModel as TReporteExtractoDataModule;
end;

procedure TRepExtractoController.ShowReport(AFechaIni: TDateTime;
  AFechaFin: TDateTime; Sender: IView);
begin
  ShowReport(GetCustomModel.Cuentas.CuentasContablesID.AsString,
    AFechaIni, AFechaFin, Sender);
end;

procedure TRepExtractoController.ShowReport(ACuentaID: string;
  AFechaIni: TDateTime; AFechaFin: TDateTime; Sender: IView);
begin
  // chequear que las fechas esten bien
  if AFechaIni > AFechaFin then
  begin
    Sender.ShowErrorMessage(rsInvalidDateRange);
    Exit;
  end;
  if not IsValidDate(AFechaFin) //and not
  //  GetController.IsValidDate(DateEditInicio.Text)
  then
  begin
    Sender.ShowErrorMessage(rsInvalidDate);
    Exit;
  end;
  if not IsValidDate(AFechaIni) //and not
  //  GetController.IsValidDate(DateEditInicio.Text)
  then
  begin
    Sender.ShowErrorMessage(rsInvalidDate);
    Exit;
  end;
  GetCustomModel.ShowReport(ACuentaID, AFechaIni, AFechaFin);
end;

end.
