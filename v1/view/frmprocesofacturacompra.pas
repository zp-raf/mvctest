unit frmprocesofacturacompra;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, StdCtrls, DBCtrls, EditBtn, PairSplitter, DBGrids,
  frmprocesofacturacion, LCLType, sgcdTypes;

type

  { TProcesoFacturaCompra }

  TProcesoFacturaCompra = class(TProcesoFacturacion)
    DBEditNro: TDBEdit;
    DBEditTimbrado: TDBEdit;
    LabelNumeroComp: TLabel;
    LabelTimbradoCompra: TLabel;
    procedure ButtonLimpiarClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure DBGridDetKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure ObserverUpdate(const Subject: IInterface); override;
    procedure OnPopupOk; override;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ProcesoFacturaCompra: TProcesoFacturaCompra;

implementation

{$R *.lfm}

{ TProcesoFacturaCompra }

procedure TProcesoFacturaCompra.ObserverUpdate(const Subject: IInterface);
begin
  inherited ObserverUpdate(Subject);
  case GetCustomController.GetEstadoComprobante(Self) of
    asInicial:
      DateEditFecha.Enabled := False;
    asEditando: DateEditFecha.Enabled := True;
    asGuardado: DateEditFecha.Enabled := False;
  end;
  ButtonLimpiar.Enabled := True;
  ButtonSeleccionarPers.Enabled := True;
end;

procedure TProcesoFacturaCompra.OnPopupOk;
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

procedure TProcesoFacturaCompra.ButtonLimpiarClick(Sender: TObject);
begin
  inherited;
  GetController.OpenDataSets(Self);
  GetCustomController.NuevoComprobanteCompra(Self);
end;

procedure TProcesoFacturaCompra.CancelButtonClick(Sender: TObject);
begin
  inherited;
end;

procedure TProcesoFacturaCompra.DBGridDetKeyDown(Sender: TObject;
  var Key: word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) and ((DBGridDet.SelectedField.FieldName = 'EXENTA') or
    (DBGridDet.SelectedField.FieldName = 'IVA5') or
    (DBGridDet.SelectedField.FieldName = 'IVA10')) then
    GetCustomController.SetPrecioTotal(DBGridDet.SelectedField.FieldName, Self);
  DBGridDet.AutoSizeColumns;
end;

end.