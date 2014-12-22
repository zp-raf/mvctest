unit frmprocesorecibocompra;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, StdCtrls, DBCtrls, EditBtn, PairSplitter, DBGrids,
  frmprocesorecibo, LCLType, LazHelpHTML, sgcdTypes, frmbuscarpersonas,
  frmbuscarfacturas, mensajes;

type

  { TProcesoReciboCompra }

  TProcesoReciboCompra = class(TProcesoRecibo)
    DBEditNumero: TDBEdit;
    DBEditTimbrado: TDBEdit;
    LabelNumero: TLabel;
    LabelTimbradoCompra: TLabel;
    procedure ButtonSeleccionarFacClick(Sender: TObject);
    procedure ButtonSeleccionarPersClick(Sender: TObject);
    procedure DateEditFechaAcceptDate(Sender: TObject; var ADate: TDateTime;
      var AcceptDate: boolean);
    procedure DateEditFechaEditingDone(Sender: TObject);
    procedure DBEditNumeroExit(Sender: TObject);
    procedure DBGridDetKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure ButtonLimpiarClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ObserverUpdate(const Subject: IInterface); override; overload;
    procedure OKButtonClick(Sender: TObject); override;
    procedure OnPopupOk; override;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ProcesoReciboCompra: TProcesoReciboCompra;

implementation

{$R *.lfm}

{ TProcesoReciboCompra }

procedure TProcesoReciboCompra.DBGridDetKeyDown(Sender: TObject;
  var Key: word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    GetCustomController.SetPrecioTotal(Self);
  DBGridDet.AutoSizeColumns;
end;

procedure TProcesoReciboCompra.ButtonSeleccionarPersClick(Sender: TObject);
begin
  Popup := TPopupSeleccionPersonas.Create(Self,
    GetComprobanteController.BuscarPersonaController);
  Popup.SetDataSource(GetCustomController.GetPersonasDataSource);
  inherited;
end;

procedure TProcesoReciboCompra.DateEditFechaAcceptDate(Sender: TObject;
  var ADate: TDateTime; var AcceptDate: boolean);
begin
  if GetController.IsValidDate(ADate) then
  begin
    AcceptDate := True;
    GetController.SetFieldValue('FECHA_EMISION', ADate, Self);
  end
  else
  begin
    AcceptDate := False;
    ShowErrorMessage(rsInvalidDate);
  end;
end;

procedure TProcesoReciboCompra.DateEditFechaEditingDone(Sender: TObject);
begin
  if GetController.IsValidDate(DateEditFecha.Date) then
    GetController.SetFieldValue('FECHA_EMISION', DateEditFecha.Date, Self)
  else
  begin
    DateEditFecha.Clear;
    ShowErrorMessage(rsInvalidDate);
  end;
end;

procedure TProcesoReciboCompra.DBEditNumeroExit(Sender: TObject);
begin
  DBEditNumero.Text := copy(DBEditNumero.Field.NewValue, 1, 8) +
    cwLeftPad(Trim(Copy(DBEditNumero.Field.NewValue, 9, 7)), 7, '0');
end;

procedure TProcesoReciboCompra.ButtonSeleccionarFacClick(Sender: TObject);
var
  PopupFac: TPopupSeleccionarFactura;
begin
  PopupFac := TPopupSeleccionarFactura.Create(Self);
  PopupFac.SetFacturaDataSource(GetCustomController.GetFacturaDataSource);
  GetController.OpenDataSets(Self);
  try
    case PopupFac.ShowModal of
      mrOk:
      begin
        GetCustomController.NuevoComprobanteCompraFac(Self);
      end
      else
      begin
        OnPopupCancel;
      end;
    end;
  finally
    PopupFac.Free;
  end;
end;

procedure TProcesoReciboCompra.ButtonLimpiarClick(Sender: TObject);
begin
  inherited;
  GetController.OpenDataSets(Self);
  GetCustomController.NuevoComprobanteCompra(Self);
end;

procedure TProcesoReciboCompra.CancelButtonClick(Sender: TObject);
begin
  inherited;
end;

procedure TProcesoReciboCompra.FormCreate(Sender: TObject);
begin
  GetCustomController.SetCompra(True);
end;

procedure TProcesoReciboCompra.ObserverUpdate(const Subject: IInterface);
begin
  inherited ObserverUpdate(Subject);
  case GetCustomController.GetEstadoComprobante(Self) of
    csInicial: DateEditFecha.Enabled := False;
    csEditando: DateEditFecha.Enabled := True;
    csGuardado: DateEditFecha.Enabled := False;
  end;
  ButtonLimpiar.Enabled := True;
  ButtonSeleccionarPers.Enabled := True;
end;

procedure TProcesoReciboCompra.OKButtonClick(Sender: TObject);
begin
  if not GetController.IsValidDate(DateEditFecha.Date) and
    (DateEditFecha.Date > Now) then
  begin
    ShowErrorMessage('Fecha de emision invalida');
    Exit;
  end;
  inherited;
end;

procedure TProcesoReciboCompra.OnPopupOk;
begin
  GetController.Connect(Self);
  GetCustomController.NuevoComprobanteCompra(Self);
end;

end.


