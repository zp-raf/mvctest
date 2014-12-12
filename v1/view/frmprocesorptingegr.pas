unit frmprocesorptingegr;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, EditBtn, StdCtrls, frmprocesoreporte, reporteingegrctrl;

type

  { TProcesoReportIngEgr }

  TProcesoReportIngEgr = class(TProcesoReporte)
    DateEditFin: TDateEdit;
    DateEditInicio: TDateEdit;
    LabelFin: TLabel;
    LabelInicio: TLabel;
  protected
    function GetCustomController: TRepIngEgrController;
  published
    procedure OKButtonClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ProcesoReportIngEgr: TProcesoReportIngEgr;

implementation

{$R *.lfm}

{ TProcesoReportIngEgr }

function TProcesoReportIngEgr.GetCustomController: TRepIngEgrController;
begin
   Result := GetController as TRepIngEgrController;
end;

procedure TProcesoReportIngEgr.OKButtonClick(Sender: TObject);
begin
  GetCustomController.ShowReport(DateEditInicio.Date, DateEditFin.Date, Self);
end;

end.

