unit frmprocesorptextracto;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, DBCtrls, StdCtrls, EditBtn, frmprocesoreporte, mensajes,
  reporteextractoctrl;

type

  { TProcesoReporteExtracto }

  TProcesoReporteExtracto = class(TProcesoReporte)
  protected
    function GetCustomController: TRepExtractoController;
  published
    DateEditInicio: TDateEdit;
    DateEditFin: TDateEdit;
    DBLookupComboBoxPersona: TDBLookupComboBox;
    GroupBoxRangoFecha: TGroupBox;
    LabelInicio: TLabel;
    LabelFin: TLabel;
    LabelCuenta: TLabel;
    procedure AfterConstruction; override;
    procedure OKButtonClick(Sender: TObject);
  end;

var
  ProcesoReporteExtracto: TProcesoReporteExtracto;

implementation

{$R *.lfm}

{ TProcesoReporteExtracto }

function TProcesoReporteExtracto.GetCustomController: TRepExtractoController;
begin
  Result := GetController as TRepExtractoController;
end;

procedure TProcesoReporteExtracto.AfterConstruction;
begin
  inherited AfterConstruction;
  //OpenOnShow := False;
end;

procedure TProcesoReporteExtracto.OKButtonClick(Sender: TObject);
begin
  if DBLookupComboBoxPersona.Text = '' then
  begin
    ShowErrorMessage(rsPleaseSelectAccount);
    Exit;
  end;
  GetCustomController.ShowReport(DateEditInicio.Date, DateEditFin.Date, Self);
end;

end.

