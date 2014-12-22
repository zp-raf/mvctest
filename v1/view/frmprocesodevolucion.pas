unit frmprocesodevolucion;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmprocesorecibocompra, devolucionctrl;

type

  { TProcesoDevolucion }

  TProcesoDevolucion = class(TProcesoReciboCompra)
    procedure OnPopupOk; override;
    procedure OKButtonClick(Sender: TObject); override;
  protected
    function GetDevolucionController: TDevolucionController;
  end;

var
  ProcesoDevolucion: TProcesoDevolucion;

implementation

{$R *.lfm}

{ TProcesoDevolucion }

procedure TProcesoDevolucion.OnPopupOk;
begin
  inherited OnPopupOk;
  GetDevolucionController.FetchDevolucionDetalle(Self);
  DateEditFecha.Date := Now;
  DateEditFechaEditingDone(DateEditFecha);
end;

procedure TProcesoDevolucion.OKButtonClick(Sender: TObject);
begin
  inherited OKButtonClick(Sender);
end;

function TProcesoDevolucion.GetDevolucionController: TDevolucionController;
begin
  Result := GetController as TDevolucionController;
end;

end.

