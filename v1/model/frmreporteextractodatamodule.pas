unit frmreporteextractodatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LR_DBSet, LR_Class, Forms, Controls, Graphics,
  Dialogs, frmreportedatamodule, DB, sqldb, frmcuentadatamodule;

type

  { TReporteExtractoDataModule }

  TReporteExtractoDataModule = class(TReporteDataModule)
  private
    FCuentas: TCuentaDataModule;
    procedure SetCuentas(AValue: TCuentaDataModule);
  published
    procedure CabeceraAfterOpen(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DataModuleDestroy(Sender: TObject);
    procedure ShowReport(ACuentaID: string; AFechaIni: TDateTime; AFechaFin: TDateTime);
    property Cuentas: TCuentaDataModule read FCuentas write SetCuentas;
  end;

var
  ReporteExtractoDataModule: TReporteExtractoDataModule;

implementation

{$R *.lfm}

{ TReporteExtractoDataModule }

procedure TReporteExtractoDataModule.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FCuentas) then
    FreeAndNil(FCuentas);
end;

procedure TReporteExtractoDataModule.ShowReport(ACuentaID: string;
  AFechaIni: TDateTime; AFechaFin: TDateTime);
begin
  Cuentas.CuentasContables.Open;
  if not Cuentas.CuentasContables.Locate('ID', ACuentaID, []) then
    raise Exception.Create('Cuenta no encontrada');
  Cabecera.Close;
  Detalle.Close;
  Cabecera.ParamByName('cuentaid').AsString := ACuentaID;
  Cabecera.ParamByName('fechaini').AsDateTime := AFechaIni;
  Cabecera.ParamByName('fechafin').AsDateTime := AFechaFin;
  Detalle.ParamByName('cuentaid').AsString := ACuentaID;
  Detalle.ParamByName('fechaini').AsDateTime := AFechaIni;
  Detalle.ParamByName('fechafin').AsDateTime := AFechaFin;
  Cabecera.Open;
  Detalle.Open;
  frReport1.LoadFromFile(ReportFile);
  frReport1.ShowReport;
end;

procedure TReporteExtractoDataModule.SetCuentas(AValue: TCuentaDataModule);
begin
  if FCuentas = AValue then
    Exit;
  FCuentas := AValue;
end;

procedure TReporteExtractoDataModule.CabeceraAfterOpen(DataSet: TDataSet);
begin
  Detalle.ParamByName('SALDO_ANTERIOR').AsFloat :=
    DataSet.FieldByName('CAB_SALDO_ANTERIOR').AsFloat;
end;

procedure TReporteExtractoDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  FCuentas := TCuentaDataModule.Create(Self, FMasterDataModule);
  AuxQryList.Add(TObject(FCuentas.CuentasContables));
  ReportFile := 'reportes\historico_saldos_3.lrf';
end;

end.
