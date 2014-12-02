unit multactrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmmultasdatamodule, mvc;

type

  { TMultaController }

  TMultaController = class(TABMController)
  protected
    function GetCustomModel: TMultasDataModule;
  public
    procedure SetMultas(Sender: IView);
    procedure SetMultas(AArancelID: string; Sender: IView);
  end;

implementation

{ TMultaController }

function TMultaController.GetCustomModel: TMultasDataModule;
begin
  Result := GetModel as TMultasDataModule;
end;

procedure TMultaController.SetMultas(AArancelID: string; Sender: IView);
begin
  try
    GetCustomModel.AplicarMultas(AArancelID);
    Sender.ShowInfoMessage('Multas aplicadas');
  except
    on E: Exception do
    begin
      Sender.ShowErrorMessage('Error al aplicar multas. Error: ' + e.Message);
    end;
  end;
end;

procedure TMultaController.SetMultas(Sender: IView);
begin
  SetMultas(GetCustomModel.qry.FieldByName('ID').AsString, Sender);
end;

end.
