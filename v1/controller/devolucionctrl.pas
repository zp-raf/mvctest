unit devolucionctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, reciboctrl, frmdevoluciondatamodule, mvc, sgcdTypes, observerSubject;

type

  { TDevolucionController }

  TDevolucionController = class(TReciboController)
  protected
    function GetDevolucionModel: TDevolucionDataModule;
  public
    procedure FetchDevolucionDetalle(Sender: IView);
    procedure CerrarComprobanteCompra(Sender: IView); override;
  end;

implementation

{ TDevolucionController }

function TDevolucionController.GetDevolucionModel: TDevolucionDataModule;
begin
  Result := GetModel as TDevolucionDataModule;
end;

procedure TDevolucionController.FetchDevolucionDetalle(Sender: IView);
begin
  GetDevolucionModel.FetchDevolucionDetalle(
    GetCustomModel.Personas.PersonasRolesID.AsString);
end;

procedure TDevolucionController.CerrarComprobanteCompra(Sender: IView);
var
  CompID, desc, descCtaPers, nom, ced: string;
begin
  try
    nom := GetModel.MasterDataModule.DevuelveValor(
      'select nombrecompleto from persona where id = ' +
      GetDevolucionModel.qryCabeceraPERSONAID.AsString, 'nombrecompleto');
    ced := GetModel.MasterDataModule.DevuelveValor(
      'select cedula from persona where id = ' +
      GetDevolucionModel.qryCabeceraPERSONAID.AsString, 'cedula');
    desc := 'Devolucion de saldo excedente a ' + nom + ' con cedula ' + ced;
    descCtaPers := desc;
    CompID := GetDevolucionModel.qryCabecera.FieldByName('ID').AsString;
    GetDevolucionModel.qryCabecera.ApplyUpdates;
    GetDevolucionModel.qryDetalle.ApplyUpdates;
    GetDevolucionModel.RegistrarMovimientoCompra(CompID, doRecibo, desc, descCtaPers);
    GetDevolucionModel.Asientos.SaveChanges;
    GetModel.Commit;
    with GetCustomModel do
    begin
      Estado := csGuardado;
      (MasterDataModule as ISubject).Notify;
    end;
  except
    on E: Exception do
    begin
      Rollback(Sender);
      raise;
    end;
  end;
end;

end.
