unit materiactrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmmateriasdatamodule, mvc, frmseleccionprerreq, DB,
  Controls;

type

  { TMateriaController }

  TMateriaController = class(TABMController)
  protected
    function GetCustomModel: TMateriasDataModule;
  public
    procedure SeleccionarPre(Sender: IFormView);
  end;

implementation

{ TMateriaController }

function TMateriaController.GetCustomModel: TMateriasDataModule;
begin
  Result := GetModel as TMateriasDataModule;
end;

procedure TMateriaController.SeleccionarPre(Sender: IFormView);
begin
  SeleccionarPrerrequisitos := TSeleccionarPrerrequisitos.Create(Sender, Self);
  try
    case SeleccionarPrerrequisitos.ShowModal of
      mrOk:
      begin
        if (GetCustomModel.Prerrequisitos.State in dsEditModes) then
          GetCustomModel.Prerrequisitos.Post;
      end;
      mrCancel:
      begin
        GetCustomModel.Prerrequisitos.CancelUpdates;
      end;
    end;
  finally
    SeleccionarPrerrequisitos.Free;
  end;
end;

end.
