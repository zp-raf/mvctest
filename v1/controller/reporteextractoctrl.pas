unit reporteextractoctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, reportectrl, frmreporteextractodatamodule;

type

  { TRepExtractoController }

  TRepExtractoController = class(TReporteController)
  protected
    function GetCustomModel: TReporteExtractoDataModule;
  public
    procedure ShowReport(AFechaIni: TDateTime; AFechaFin: TDateTime);
    procedure ShowReport(ACuentaID: string; AFechaIni: TDateTime; AFechaFin: TDateTime);
  end;

implementation

{ TRepExtractoController }

function TRepExtractoController.GetCustomModel: TReporteExtractoDataModule;
begin
  Result := GetModel as TReporteExtractoDataModule;
end;

procedure TRepExtractoController.ShowReport(AFechaIni: TDateTime; AFechaFin: TDateTime);
begin
  ShowReport(GetCustomModel.Cuentas.CuentasContablesID.AsString, AFechaIni, AFechaFin);
end;

procedure TRepExtractoController.ShowReport(ACuentaID: string;
  AFechaIni: TDateTime; AFechaFin: TDateTime);
begin
  GetCustomModel.ShowReport(ACuentaID, AFechaIni, AFechaFin);
end;

end.

