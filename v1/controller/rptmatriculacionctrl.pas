unit rptmatriculacionctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, reportectrl, frmreportematriculaciondatamodule, mvc;

type

  { TReporteMatriculacionController }

  TReporteMatriculacionController = class(TReporteController)
  protected
    function GetCustomModel: TReporteMatriculacionDataModule;
  public
    procedure ShowReport(Sender: IView);
  end;

implementation

{ TReporteMatriculacionController }

function TReporteMatriculacionController.GetCustomModel: TReporteMatriculacionDataModule;
begin
  Result := GetModel as TReporteMatriculacionDataModule;
end;

procedure TReporteMatriculacionController.ShowReport(Sender: IView);
begin
  GetCustomModel.ShowReport(GetCustomModel.Personas.PersonasRoles.FieldByName(
    'ID').AsString);
end;

end.
