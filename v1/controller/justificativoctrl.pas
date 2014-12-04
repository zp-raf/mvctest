unit justificativoctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmjustificativodatamodule, mvc, sgcdTypes,
  frmaprobarjustdatamodule;

type

  { TJustificativoController }

  TJustificativoController = class(TABMController)
  protected
    function GetCustomModel: TJustificativoDataModule;
  public
    procedure FilterPers(ASearchText: string; Sender: IView);
  end;

  { TAprobarJustificativoController }

  TAprobarJustificativoController = class(TJustificativoController)
  protected
    function GetAprobarModel: TAprobarJustificativoDataModule;
  public
    procedure FiltrarJustificativos(Sender: IView);
  end;

implementation

{ TAprobarJustificativoController }

function TAprobarJustificativoController.GetAprobarModel:
TAprobarJustificativoDataModule;
begin
  Result := GetModel as TAprobarJustificativoDataModule;
end;

procedure TAprobarJustificativoController.FiltrarJustificativos(Sender: IView);
begin
  GetAprobarModel.FilterJustificativos;
end;

{ TJustificativoController }

function TJustificativoController.GetCustomModel: TJustificativoDataModule;
begin
  Result := GetModel as TJustificativoDataModule;
end;

procedure TJustificativoController.FilterPers(ASearchText: string; Sender: IView);
begin
  GetCustomModel.Personas.FilterData(ASearchText, roCualquiera);
end;

end.
