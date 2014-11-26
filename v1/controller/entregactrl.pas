unit entregactrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, mvc, frmentregadatamodule, sgcdTypes,
  frmpopupseleccionartrabajos, selecciontrabajosctrl, Controls;

type

  { TEntregaController }

  TEntregaController = class(TController)
  protected
    function GetCustomModel: TEntregaDataModule;
  public
    procedure SeleccionarTrabajo(Sender: IFormView);
    function GetEstado: TEdicionEstado;
  end;

implementation

{ TEntregaController }

function TEntregaController.GetCustomModel: TEntregaDataModule;
begin
  Result := GetModel as TEntregaDataModule;
end;

procedure TEntregaController.SeleccionarTrabajo(Sender: IFormView);
begin
  PopupSeleccionarTrabajos := TPopupSeleccionarTrabajos.Create(Sender,
    TSeleccionTrabajosController.Create(GetCustomModel.Trabajos));
  try
    OpenDataSets(Sender);
    case PopupSeleccionarTrabajos.ShowModal of
      mrOk:
      begin
        try
          GetCustomModel.PrepararPlanillaTrabajo(
            GetCustomModel.Trabajos.TrabajosDetView.FieldByName('ID').AsString);
        except
          on E: Exception do
          begin
            GetCustomModel.Estado := edInicial;
            GetCustomModel.CloseDataSets;
          end;
        end;
      end;
      mrCancel:
      begin
        // nada por ahora
      end;
    end;
  finally
    PopupSeleccionarTrabajos.Free;
  end;
end;

function TEntregaController.GetEstado: TEdicionEstado;
begin
  Result := GetCustomModel.Estado;
end;

end.
