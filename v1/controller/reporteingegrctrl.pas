unit reporteingegrctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, reportectrl, frmrptingegrdatamodule, mvc, mensajes;

type

  { TRepIngEgrController }

  TRepIngEgrController = class(TReporteController)
  protected
    function GetCustomModel: TReporteIngEgrDataModule;
  public
    procedure ShowReport(AFechaIni: TDateTime; AFechaFin: TDateTime; Sender: IView);
  end;

implementation

{ TRepIngEgrController }

function TRepIngEgrController.GetCustomModel: TReporteIngEgrDataModule;
begin
  Result := GetModel as TReporteIngEgrDataModule;
end;

{
 procedure TRepIngEgrController.ShowReport(AFechaIni: TDateTime;
   AFechaFin: TDateTime; Sender: IView);
 begin
   ShowReport(GetCustomModel.Cuentas.CuentasContablesID.AsString,
     AFechaIni, AFechaFin, Sender);
 end;

}
procedure TRepIngEgrController.ShowReport(AFechaIni: TDateTime; AFechaFin: TDateTime; Sender: IView);
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
  GetCustomModel.ShowReport(AFechaIni, AFechaFin);
end;

end.
