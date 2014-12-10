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
    procedure AfterConstruction; override;
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

procedure TProcesoReportIngEgr.AfterConstruction;
begin
  inherited AfterConstruction;
end;

procedure TProcesoReportIngEgr.OKButtonClick(Sender: TObject);
begin
    {
    if DBLookupComboBoxPersona.Text = '' then
  begin
    ShowErrorMessage(rsPleaseSelectAccount);
    Exit;
  end;
    }
  GetCustomController.ShowReport(DateEditInicio.Date, DateEditFin.Date, Self);
end;

end.

