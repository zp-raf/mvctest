unit frmrptingegrdatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, 
    frmreportedatamodule;

type

  { TReporteIngEgrDataModule }

  TReporteIngEgrDataModule = class(TReporteDataModule)
  private
    { private declarations }
  published
//     procedure CabeceraAfterOpen(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DataModuleDestroy(Sender: TObject);
    procedure ShowReport(AFechaIni: TDateTime; AFechaFin: TDateTime);

  public
    { public declarations }
  end;

var
  ReporteIngEgrDataModule: TReporteIngEgrDataModule;

implementation

{$R *.lfm}

{ TReporteIngEgrDataModule }

{

 procedure TReporteIngEgrDataModule.CabeceraAfterOpen(DataSet: TDataSet);
 begin
     inherited;
 end;
}

procedure TReporteIngEgrDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited DataModuleCreate(Sender);
  ReportFile := '';
end;

procedure TReporteIngEgrDataModule.DataModuleDestroy(Sender: TObject);
begin
   Inherited;
end;

procedure TReporteIngEgrDataModule.ShowReport(AFechaIni: TDateTime; AFechaFin: TDateTime);
begin
   Cabecera.Close;
  //Detalle.Close;
  //Cabecera.ParamByName('cuentaid').AsString := ACuentaID;
  Cabecera.ParamByName('fechaini').AsDateTime := AFechaIni;
  Cabecera.ParamByName('fechafin').AsDateTime := AFechaFin;
  {
  Detalle.ParamByName('cuentaid').AsString := ACuentaID;
  Detalle.ParamByName('fechaini').AsDateTime := AFechaIni;
  Detalle.ParamByName('fechafin').AsDateTime := AFechaFin;

  }
  Cabecera.Open;
  //Detalle.Open;
  frReport1.LoadFromFile(ReportFile);
  frReport1.ShowReport;
end;

end.

