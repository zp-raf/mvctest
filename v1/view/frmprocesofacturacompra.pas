unit frmprocesofacturacompra;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, StdCtrls, DBCtrls, EditBtn, PairSplitter, DBGrids,
  frmprocesofacturacion, LCLType, sgcdTypes, mensajes;

type

  { TProcesoFacturaCompra }

  TProcesoFacturaCompra = class(TProcesoFacturacion)
    DBEditNro: TDBEdit;
    DBEditTimbrado: TDBEdit;
    LabelNumeroComp: TLabel;
    LabelTimbradoCompra: TLabel;
    procedure ButtonLimpiarClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure DateEditFechaAcceptDate(Sender: TObject; var ADate: TDateTime;
      var AcceptDate: boolean);
    procedure DateEditFechaEditingDone(Sender: TObject);
    procedure DBEditNroExit(Sender: TObject);
    procedure DBGridDetKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure ObserverUpdate(const Subject: IInterface); override;
    procedure OKButtonClick(Sender: TObject); override;
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
    csInicial:
      DateEditFecha.Enabled := False;
    csEditando: DateEditFecha.Enabled := True;
    csGuardado: DateEditFecha.Enabled := False;
  end;
  ButtonLimpiar.Enabled := True;
  ButtonSeleccionarPers.Enabled := True;
end;

procedure TProcesoFacturaCompra.OKButtonClick(Sender: TObject);
begin
  //if (Trim(DBEditNro.Text) = '') or (Trim(DBEditTimbrado.Text) = '') then
  //begin
  //  ShowErrorMessage('Complete los campos de numero y timbrado');
  //  Exit;
  //end;
  if RadioCondicion.ItemIndex = -1 then
  begin
    ShowErrorMessage('Por favor seleccione una condicion de compra');
    Exit;
  end;
  if not GetController.IsValidDate(DateEditFecha.Date) or
    (DateEditFecha.Date > Now) then
  begin
    ShowErrorMessage('Fecha de emision invalida');
    Exit;
  end;
  // aca ya verifico que el nro y el timbrado esten cargados.
  // Porque al verificar en el metodo CerrarComprobanteCompra de facturactrl
  // hace el exit pero luego se muestra el mensaje de que el comprobante
  // se ingreso correctamente y se llama al metodo limpiar
  if ((DBEditNro.Text = '') or (DBEditNro.Text = '   -   -       ')) then
  begin
       ShowErrorMessage('Número inválido');
       Exit;
  end;
  if ((DBEditTimbrado.Text = '') or (strlen( PChar ( DBEditTimbrado.Text)) > 8)) then
  Begin
       ShowErrorMessage('Timbrado inválido');
       Exit;
  end;
  inherited;
end;

procedure TProcesoFacturaCompra.OnPopupOk;
begin
  //if GetCustomController.GetEstadoComprobante(Self) = csEditando then
  //begin
  //  GetCustomController.FetchCabeceraPersona(Self);
  //end
  //else
  //begin
  GetController.Connect(Self);
  GetCustomController.NuevoComprobanteCompra(Self);
  //GetCustomController.FetchCabeceraPersona(Self);
  //end;
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

procedure TProcesoFacturaCompra.DateEditFechaAcceptDate(Sender: TObject;
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

procedure TProcesoFacturaCompra.DateEditFechaEditingDone(Sender: TObject);
begin
  if GetController.IsValidDate(DateEditFecha.Date) then
    GetController.SetFieldValue('FECHA_EMISION', DateEditFecha.Date, Self)
  else
  begin
    DateEditFecha.Clear;
    ShowErrorMessage(rsInvalidDate);
  end;
end;

procedure TProcesoFacturaCompra.DBEditNroExit(Sender: TObject);
begin
 // qryPrincipalNUMERO_FACTURA.Value := copy(DBEdit3.Field.NewValue, 1, 8)
 //   + datos.cwLeftPad(Trim(copy(DBEdit3.Field.NewValue, 9, 7)), 7, '0');
 DBEditNro.Text:= copy (DBEditNro.Field.NewValue,1,8) +
  cwLeftPad(Trim(Copy(DBEditNro.Field.NewValue, 9,7)),7,'0') ;

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

procedure TProcesoFacturaCompra.FormCreate(Sender: TObject);
begin
  GetCustomController.SetCompra(True);
end;

end.
