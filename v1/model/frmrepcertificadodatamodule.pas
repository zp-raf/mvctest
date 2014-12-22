unit frmrepcertificadodatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LR_DBSet, LR_Class, Forms, Controls, Graphics,
  Dialogs, frmreportedatamodule, DB, sqldb;

type

  { TReporteCertificadoDataModule }

  TReporteCertificadoDataModule = class(TReporteDataModule)
    alumnosAPELLIDO: TStringField;
    alumnosCEDULA: TStringField;
    alumnosCONFIRMADO: TSmallintField;
    alumnosFECHANAC: TDateField;
    alumnosID: TLongintField;
    alumnosNOMBRE: TStringField;
    alumnosNOMBRECOMPLETO: TStringField;
    alumnosSEXO: TStringField;
    CabeceraAPELLIDO: TStringField;
    CabeceraCEDULA: TStringField;
    CabeceraFECHANAC: TDateField;
    CabeceraID: TLongintField;
    CabeceraMODULO: TStringField;
    CabeceraMODULOID: TLongintField;
    CabeceraNOMBRE: TStringField;
    CabeceraSEXO: TStringField;
    dsalumnos: TDataSource;
    DetalleFECHA_NOTA: TDateField;
    DetalleGRUPO: TStringField;
    DetalleID: TLongintField;
    DetalleMATERIA: TStringField;
    DetalleMODULO: TStringField;
    DetalleMODULOID: TLongintField;
    DetalleNOTA: TLongintField;
    DetalleOBSERVACIONES: TStringField;
    DetallePERIODO: TStringField;
    alumnos: TSQLQuery;
    procedure CabeceraAfterScroll(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject); override;
    procedure ShowReport;
  end;

var
  ReporteCertificadoDataModule: TReporteCertificadoDataModule;

implementation

{$R *.lfm}

{ TReporteCertificadoDataModule }

procedure TReporteCertificadoDataModule.CabeceraAfterScroll(DataSet: TDataSet);
begin
  Detalle.Close;
  Detalle.ParamByName('PERSONAID').AsString := DataSet.FieldByName('ID').AsString;
  Detalle.ParamByName('MODULOID').AsString := DataSet.FieldByName('MODULOID').AsString;
  Detalle.Open;
end;

procedure TReporteCertificadoDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  AuxQryList.Add(TObject(alumnos));
  ReportFile:='reportes\certif_estudios.lrf';
end;

procedure TReporteCertificadoDataModule.ShowReport;
begin
  Cabecera.Close;
  Detalle.Close;
  Cabecera.ParamByName('PERSONAID').AsString := alumnos.FieldByName('ID').AsString;
  Cabecera.Open;
  Detalle.Open;
  frReport1.LoadFromFile(ReportFile);
  frReport1.ShowReport;
end;

end.

