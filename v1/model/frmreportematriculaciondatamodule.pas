unit frmreportematriculaciondatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmreportedatamodule, frmpersonasdatamodule, sgcdTypes;

type

  { TReporteMatriculacionDataModule }

  TReporteMatriculacionDataModule = class(TReporteDataModule)
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

end;

end.

