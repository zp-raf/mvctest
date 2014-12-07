unit calificacionctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmcalificaciondatamodule, sgcdTypes, mvc,
  frmpopupseleccionexamen, seleccionexamenctrl, Controls;

type

  { TCalificacionController }

  TCalificacionController = class(TController)
  protected
    function GetCustomModel: TCalificacionDataModule;
  public
    function GetEstado: TEdicionEstado;
    procedure SeleccionarExamen(Sender: IFormView);
  end;

implementation

{ TCalificacionController }

function TCalificacionController.GetCustomModel: TCalificacionDataModule;
begin
  Result := GetModel as TCalificacionDataModule;
end;

function TCalificacionController.GetEstado: TEdicionEstado;
begin
  Result := GetCustomModel.Estado;
end;

procedure TCalificacionController.SeleccionarExamen(Sender: IFormView);
begin
  PopupSeleccionExamen := TPopupSeleccionExamen.Create(Sender,
    TSeleccionExamenController.Create(GetCustomModel.Examenes));
  try
    OpenDataSets(Sender);
    case PopupSeleccionExamen.ShowModal of
      mrOk:
      begin
        try
          GetCustomModel.PrepararPlanillaCalificaciones(
            GetCustomModel.Examenes.Examen.FieldByName('ID').AsString);
        except
          on E: Exception do
          begin
            GetCustomModel.Estado := edInicial;
            GetCustomModel.CloseDataSets;
            raise;
          end;
        end;
      end;
      mrCancel:
      begin
        // nada por ahora
      end;
    end;
  finally
    PopupSeleccionExamen.Free;
  end;
end;

end.
