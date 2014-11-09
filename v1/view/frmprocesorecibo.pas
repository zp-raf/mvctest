unit frmprocesorecibo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmprocesocomprobante, reciboctrl;

type

  { TProcesoRecibo }

  TProcesoRecibo = class(TProcesoComprobante)
  protected
    function GetCustomController: TReciboController;
  published
    procedure OnPopupCancel; override;
    procedure OnPopupOk; override;
  end;

var
  ProcesoRecibo: TProcesoRecibo;

implementation

{$R *.lfm}

{ TProcesoRecibo }

function TProcesoRecibo.GetCustomController: TReciboController;
begin
  Result := GetController as TReciboController;
end;

procedure TProcesoRecibo.OnPopupCancel;
begin
  GetController.CloseDataSets(Self);
end;

procedure TProcesoRecibo.OnPopupOk;
begin
  GetController.Connect(Self);
  // si ya se esta editando la factura simplemente la cancelamos y hacemos otra
  GetCustomController.NuevoComprobante(Self);
end;

end.

