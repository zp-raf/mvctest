unit frmprocesorecibocompra;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, StdCtrls, DBCtrls, EditBtn, PairSplitter, DBGrids,
  frmprocesorecibo, LCLType, sgcdTypes, frmbuscarpersonas;

type

  { TProcesoReciboCompra }

  TProcesoReciboCompra = class(TProcesoRecibo)
    DBEditNumero: TDBEdit;
    DBEditTimbrado: TDBEdit;
    LabelNumero: TLabel;
    LabelTimbradoCompra: TLabel;
    procedure ButtonSeleccionarPersClick(Sender: TObject);
    procedure DBGridDetKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure ButtonLimpiarClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure ObserverUpdate(const Subject: IInterface); override; overload;
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

procedure TProcesoReciboCompra.ObserverUpdate(const Subject: IInterface);
begin
  inherited ObserverUpdate(Subject);
  case GetCustomController.GetEstadoComprobante(Self) of
    asInicial: DateEditFecha.Enabled := False;
    asEditando: DateEditFecha.Enabled := True;
    asGuardado: DateEditFecha.Enabled := False;
  end;
  ButtonLimpiar.Enabled := True;
  ButtonSeleccionarPers.Enabled := True;
end;

procedure TProcesoReciboCompra.OnPopupOk;
begin
  if GetCustomController.GetEstadoComprobante(Self) = asEditando then
  begin
    GetCustomController.FetchCabeceraPersona(Self);
  end
  else
  begin
    GetController.Connect(Self);
    GetCustomController.NuevoComprobanteCompra(Self);
    GetCustomController.FetchCabeceraPersona(Self);
  end;
end;

end.


