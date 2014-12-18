unit frmreportematriculacion;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, LazHelpHTML, ButtonPanel, DBGrids, ExtCtrls, frmprocesoreporte,
  rptmatriculacionctrl;

type

  { TProcesoReporteMatriculacion }

  TProcesoReporteMatriculacion = class(TProcesoReporte)
    DBGrid1: TDBGrid;
    LabeledEdit1: TLabeledEdit;
    procedure LabeledEdit1Change(Sender: TObject);
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

procedure TProcesoReporteMatriculacion.LabeledEdit1Change(Sender: TObject);
begin
  GetCustomController.Filtrar(LabeledEdit1.Text, Self);
end;

function TProcesoReporteMatriculacion.GetCustomController:
TReporteMatriculacionController;
begin
  Result := GetController as TReporteMatriculacionController;
end;

end.
