unit frmaprobarjustdatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmjustificativodatamodule, DB, sqldb;

type

  { TAprobarJustificativoDataModule }

  TAprobarJustificativoDataModule = class(TJustificativoDataModule)
    procedure FilterJustificativos;
  end;

var
  AprobarJustificativoDataModule: TAprobarJustificativoDataModule;

implementation

{$R *.lfm}

{ TAprobarJustificativoDataModule }

procedure TAprobarJustificativoDataModule.FilterJustificativos;
begin
  if JustificativoAsistencia.State <> dsInactive then
  begin
    JustificativoAsistencia.Close;
    JustificativoAsistencia.ServerFilter :=
      'PERSONAID = ' + Personas.PersonasRoles.FieldByName('ID').AsString;
    JustificativoAsistencia.ServerFiltered := True;
    JustificativoAsistencia.Open;
  end;
end;

end.



