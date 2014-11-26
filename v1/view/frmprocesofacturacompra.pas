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
    procedure CancelButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure DBGridDetKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormShow(Sender: TObject); override;
    procedure OKButtonClick(Sender: TObject); override;
    procedure ObserverUpdate(const Subject: IInterface); override;
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

procedure TProcesoFacturaCompra.OKButtonClick(Sender: TObject);
begin
  inherited;
  GetCustomController.NuevoComprobanteCompra(Self);
end;

procedure TProcesoFacturaCompra.ObserverUpdate(const Subject: IInterface);
begin
  inherited ObserverUpdate(Subject);
  case GetCustomController.GetEstadoComprobante(Self) of
    asInicial: DateEditFecha.Enabled := False;
    asEditando: DateEditFecha.Enabled := True;
    asGuardado: DateEditFecha.Enabled := False;
  end;
end;

procedure TProcesoFacturaCompra.CancelButtonClick(Sender: TObject);
begin
  GetABMController.Cancel(Self);
  GetABMController.Rollback(Self);
  ShowInfoMessage('Comprobante no guardado');
  Limpiar;
  GetCustomController.NuevoComprobanteCompra(Self);
end;

procedure TProcesoFacturaCompra.CloseButtonClick(Sender: TObject);
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
end;

procedure TProcesoFacturaCompra.FormShow(Sender: TObject);
begin
  inherited;
  GetController.OpenDataSets(Self);
  GetCustomController.NuevoComprobanteCompra(Self);
end;

end.
