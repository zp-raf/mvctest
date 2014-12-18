unit frmreportematriculaciondatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LR_DBSet, LR_Class, Forms, Controls, Graphics,
  Dialogs, frmreportedatamodule, frmpersonasdatamodule, sgcdTypes, sqldb, DB;

type

  { TReporteMatriculacionDataModule }

  TReporteMatriculacionDataModule = class(TReporteDataModule)
    CabeceraAPELLIDO: TStringField;
    CabeceraCEDULA: TStringField;
    CabeceraFECHANAC: TDateField;
    CabeceraNOMBRE: TStringField;
    CabeceraPERSONAID: TLongintField;
    CabeceraSEXO: TStringField;
    DetalleDERECHOAEXAMEN: TStringField;
    DetalleFECHA: TDateField;
    DetalleMATERIA: TStringField;
    DetallePROFESOR: TStringField;
    DetalleSECCION: TStringField;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DataModuleDestroy(Sender: TObject);
  private
    FPersonas: TPersonasDataModule;
    procedure SetPersonas(AValue: TPersonasDataModule);
  published
    procedure ShowReport(AID: string);
    property Personas: TPersonasDataModule read FPersonas write SetPersonas;
  end;

var
  ReporteMatriculacionDataModule: TReporteMatriculacionDataModule;

implementation

{$R *.lfm}

{ TReporteMatriculacionDataModule }

procedure TReporteMatriculacionDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  FPersonas := TPersonasDataModule.Create(Self, MasterDataModule);
  FPersonas.SetReadOnly(True);
  AuxQryList.Add(FPersonas.PersonasRoles);
  FPersonas.FilterData('', roAlumno);
  ReportFile := 'reportes\reporte-matriculacion.lrf';
end;

procedure TReporteMatriculacionDataModule.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FPersonas) then
    FreeAndNil(FPersonas);
end;

procedure TReporteMatriculacionDataModule.SetPersonas(AValue: TPersonasDataModule);
begin
  if FPersonas = AValue then
    Exit;
  FPersonas := AValue;
end;

procedure TReporteMatriculacionDataModule.ShowReport(AID: string);
begin
  Cabecera.Close;
  Detalle.Close;
  Cabecera.ParamByName('ALUMNOID').AsString := AID;
  Detalle.ParamByName('ALUMNOID').AsString := AID;
  Cabecera.Open;
  Detalle.Open;
  frReport1.LoadFromFile(ReportFile);
  frReport1.ShowReport;
end;

end.

