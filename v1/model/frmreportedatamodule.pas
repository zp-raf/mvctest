unit frmreportedatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LR_DBSet, LR_Class, Forms, Controls, Graphics,
  Dialogs, frmquerydatamodule, sqldb, DB;

type

  { TReporteDataModule }

  TReporteDataModule = class(TQueryDataModule)
  private
    FReportFile: string;
    procedure SetReportFile(AValue: string);
  published
    Cabecera: TSQLQuery;
    dsDetalle: TDataSource;
    dsCabecera: TDataSource;
    Detalle: TSQLQuery;
    frDBDataSetDetalle: TfrDBDataSet;
    frDBDataSetCabecera: TfrDBDataSet;
    frReport1: TfrReport;
    procedure DataModuleCreate(Sender: TObject); override;
    property ReportFile: string read FReportFile write SetReportFile;
  end;

var
  ReporteDataModule: TReporteDataModule;

implementation

{$R *.lfm}

{ TReporteDataModule }

procedure TReporteDataModule.SetReportFile(AValue: string);
begin
  if FReportFile = AValue then
    Exit;
  FReportFile := AValue;
end;

procedure TReporteDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  //QryList.Add(TObject(Cabecera));
  //DetailList.Add(TObject(Detalle));
end;

end.
