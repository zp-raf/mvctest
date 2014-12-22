unit frmprocesorptcertificado;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, LazHelpHTML, ButtonPanel, DBGrids, frmprocesoreporte, rptcertificadoctrl;

type

  { TProcesoRptCertificado }

  TProcesoRptCertificado = class(TProcesoReporte)
    DBGrid1: TDBGrid;
    procedure OKButtonClick(Sender: TObject);
  protected
    function GetCustomController: TReporteCertificadoController;
  end;

var
  ProcesoRptCertificado: TProcesoRptCertificado;

implementation

{$R *.lfm}

{ TProcesoRptCertificado }

procedure TProcesoRptCertificado.OKButtonClick(Sender: TObject);
begin
  GetCustomController.ShowReport(Self);
end;

function TProcesoRptCertificado.GetCustomController: TReporteCertificadoController;
begin
  Result := GetController as TReporteCertificadoController;
end;

end.

