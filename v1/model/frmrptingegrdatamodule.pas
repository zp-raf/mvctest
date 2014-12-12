unit frmrptingegrdatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LR_DBSet, LR_Class, Forms, Controls, Graphics,
  Dialogs, IniPropStorage, frmreportedatamodule, DB, sqldb, IniFiles;

type

  { TReporteIngEgrDataModule }

  TReporteIngEgrDataModule = class(TReporteDataModule)
  protected
    FINIFile: TIniFile;
    FCuentaID: string;
  published
    procedure CabeceraAfterOpen(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject); override;
    procedure RestoreProperties;
    procedure ShowReport(AFechaIni: TDateTime; AFechaFin: TDateTime);
  end;

var
  ReporteIngEgrDataModule: TReporteIngEgrDataModule;

implementation

{$R *.lfm}

procedure TReporteIngEgrDataModule.RestoreProperties;
begin
  FCuentaID := FINIFile.ReadString('datos', 'cuentaCompras', '');
end;

procedure TReporteIngEgrDataModule.CabeceraAfterOpen(DataSet: TDataSet);
begin
  Detalle.ParamByName('SALDO_ANTERIOR').AsFloat :=
    DataSet.FieldByName('CAB_SALDO_ANTERIOR').AsFloat;
end;

procedure TReporteIngEgrDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited DataModuleCreate(Sender);
  ReportFile := 'reportes\ingresos-egresos.lrf';
  FINIFile := TIniFile.Create('curso.ini');
  RestoreProperties;
end;

procedure TReporteIngEgrDataModule.ShowReport(AFechaIni: TDateTime;
  AFechaFin: TDateTime);
begin
  Cabecera.Close;
  Detalle.Close;
  Cabecera.ParamByName('cuentaid').AsString := FCuentaID;
  Cabecera.ParamByName('fechaini').AsDateTime := AFechaIni;
  Cabecera.ParamByName('fechafin').AsDateTime := AFechaFin;
  Detalle.ParamByName('cuentaid').AsString := FCuentaID;
  Detalle.ParamByName('fechaini').AsDateTime := AFechaIni;
  Detalle.ParamByName('fechafin').AsDateTime := AFechaFin;
  Cabecera.Open;
  Detalle.Open;
  frReport1.LoadFromFile(ReportFile);
  frReport1.ShowReport;
end;

end.
