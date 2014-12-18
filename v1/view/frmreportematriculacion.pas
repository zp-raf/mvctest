unit frmreportematriculacion;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, LazHelpHTML, ButtonPanel, DBGrids, frmprocesoreporte, rptmatriculacionctrl;

type

  { TProcesoReporteMatriculacion }

  TProcesoReporteMatriculacion = class(TProcesoReporte)
    DBGrid1: TDBGrid;
    procedure OKButtonClick(Sender: TObject);
  protected
    function GetCustomController: TReporteMatriculacionController;
  end;

var
  ProcesoReporteMatriculacion: TProcesoReporteMatriculacion;

implementation

{$R *.lfm}

{ TProcesoReporteMatriculacion }

procedure TProcesoReporteMatriculacion.OKButtonClick(Sender: TObject);
begin
  GetCustomController.ShowReport(Self);
end;

function TProcesoReporteMatriculacion.GetCustomController:
TReporteMatriculacionController;
begin
  Result := GetController as TReporteMatriculacionController;
end;

end.
