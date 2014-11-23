unit notasctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmnotasdatamodule, mvc;

type

  { TNotasController }

  TNotasController = class(TController)
  protected
    function GetCustomModel: TNotasDataModule;
  public
    procedure SetCriterios(ACri: TCriterios; Sender: IView);
  end;

implementation

{ TNotasController }

function TNotasController.GetCustomModel: TNotasDataModule;
begin
  Result := GetModel as TNotasDataModule;
end;

procedure TNotasController.SetCriterios(ACri: TCriterios; Sender: IView);
begin
  GetCustomModel.Criterios := ACri;
end;

end.
