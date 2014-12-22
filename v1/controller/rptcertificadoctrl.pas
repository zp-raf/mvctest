unit rptcertificadoctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, reportectrl, frmrepcertificadodatamodule, mvc;

type

  { TReporteCertificadoController }

  TReporteCertificadoController = class(TReporteController)
  protected
    function GetCustomModel: TReporteCertificadoDataModule;
  public
    procedure ShowReport(Sender: IView);
  end;

implementation

{ TReporteCertificadoController }

function TReporteCertificadoController.GetCustomModel: TReporteCertificadoDataModule;
begin
  Result := GetModel as TReporteCertificadoDataModule;
end;

procedure TReporteCertificadoController.ShowReport(Sender: IView);
begin
  GetCustomModel.ShowReport;
end;

end.
