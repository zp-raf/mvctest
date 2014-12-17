unit registroanecdoticoctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmregistroanecdoticodatamodule, mvc, sgcdTypes;

type

  { TRegistroAnecdoticoController }

  TRegistroAnecdoticoController = class(TController)
  protected
    function GetCustomModel: TRegistroAnecdoticoDataModule;
  public
    procedure FilterAlumnos(ASearchText: string; Sender: IView);
  end;

implementation

{ TRegistroAnecdoticoController }

function TRegistroAnecdoticoController.GetCustomModel: TRegistroAnecdoticoDataModule;
begin
  Result := GetModel as TRegistroAnecdoticoDataModule;
end;

procedure TRegistroAnecdoticoController.FilterAlumnos(ASearchText: string;
  Sender: IView);
begin
  GetCustomModel.Personas.FilterData(ASearchText, roAlumno);
end;

end.
