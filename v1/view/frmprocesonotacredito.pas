unit frmprocesonotacredito;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, StdCtrls, DBCtrls, EditBtn, PairSplitter, DBGrids,
  frmprocesofacturabase, notacreditoctrl, frmbuscarfacturas, sgcdTypes;

type

  { TProcesoNotaCredito }

  TProcesoNotaCredito = class(TProcesoFacturaBase)
  protected
    function GetCustomController: TNotaCreditoController;
  published
    DBEditFactura: TDBEdit;
    LabelFactNro: TLabel;
    procedure ButtonSeleccionarFacClick(Sender: TObject);
    procedure ObserverUpdate(const Subject: IInterface); override;
    procedure OnPopupCancel; override;
    procedure OnPopupOk; override;
  end;

var
  ProcesoNotaCredito: TProcesoNotaCredito;

implementation

{$R *.lfm}

{ TProcesoNotaCredito }

procedure TProcesoNotaCredito.OnPopupCancel;
begin
  GetController.CloseDataSets(Self);
end;

procedure TProcesoNotaCredito.OnPopupOk;
begin
  GetController.Connect(Self);
  // si ya se esta editando la factura simplemente la cancelamos y hacemos otra
  GetCustomController.NuevoComprobante(Self);
end;

function TProcesoNotaCredito.GetCustomController: TNotaCreditoController;
begin
  Result := GetController as TNotaCreditoController;
end;

procedure TProcesoNotaCredito.ButtonSeleccionarFacClick(Sender: TObject);
var
  Popup: TPopupSeleccionarFactura;
begin
  Popup := TPopupSeleccionarFactura.Create(Self);
  GetController.OpenDataSets(Self);
  try
    case Popup.ShowModal of
      mrOk:
      begin
        OnPopupOk;
      end
      else
      begin
        OnPopupCancel;
      end;
    end;
  finally
    Popup.Free;
  end;
end;

procedure TProcesoNotaCredito.ObserverUpdate(const Subject: IInterface);
begin
  inherited ObserverUpdate(Subject);
  case GetComprobanteController.GetEstadoComprobante(Self) of
    asInicial:
    begin
      DBEditFactura.Enabled := False;
    end;
    asGuardado:
    begin
      DBEditFactura.Enabled := False;
    end;
    asEditando:
    begin
      DBEditFactura.Enabled := False;
    end;
  end;
end;

end.
