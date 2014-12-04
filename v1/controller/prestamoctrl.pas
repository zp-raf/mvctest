unit prestamoctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmprestamodatamodule, mvc, sgcdTypes;

type

  { TPrestamoController }

  TPrestamoController = class(TABMController)
  protected
    function GetCustomModel: TPrestamoDataModule;
  public
    procedure FilterPersData(ASearchText: string; Sender: IView);
    procedure FilterEqData(ASearchText: string; Sender: IView);
  end;

implementation

{ TPrestamoController }

procedure TPrestamoController.FilterPersData(ASearchText: string; Sender: IView);
begin
  GetCustomModel.Personas.FilterData(ASearchText, roCualquiera);
end;

procedure TPrestamoController.FilterEqData(ASearchText: string; Sender: IView);
begin
  if Trim(ASearchText) = '' then
  begin
    GetCustomModel.Equipos.UnfilterData;
    GetCustomModel.Equipos.RefreshDataSets;
  end
  else
  begin
    GetCustomModel.Equipos.FilterData(ASearchText);
    GetCustomModel.Equipos.RefreshDataSets;
  end;
end;

function TPrestamoController.GetCustomModel: TPrestamoDataModule;
begin
  Result := GetModel as TPrestamoDataModule;
end;

end.
