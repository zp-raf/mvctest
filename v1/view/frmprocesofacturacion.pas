unit frmprocesofacturacion;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, FileUtil, Forms, Controls, Graphics, Menus, StdCtrls, DBCtrls,
  EditBtn, PairSplitter, DBGrids, ComCtrls, ButtonPanel, frmproceso,
  facturactrl2, frmcomprobantedatamodule, frmprocesofacturabase, sgcdTypes,
  frmbuscarpersonas, ctrl, mensajes, Classes;

type

  { TProcesoFacturacion }

  TProcesoFacturacion = class(TProcesoFacturaBase)
    DateEditVen: TDateEdit;
    LabelVen: TLabel;
    RadioCondicion: TDBRadioGroup;
  protected
    function GetCustomController: TFacturaController;
  published
    procedure DateEditVenEditingDone(Sender: TObject);
    procedure Limpiar; override;
    procedure ObserverUpdate(const Subject: IInterface); override;
    procedure OKButtonClick(Sender: TObject); override;
    procedure OnPopupCancel; override;
    procedure OnPopupOk; override;
    procedure RadioCondicionChange(Sender: TObject);
  end;

var
  ProcesoFacturacion: TProcesoFacturacion;

implementation

{$R *.lfm}

{ TProcesoFacturacion }

procedure TProcesoFacturacion.DateEditVenEditingDone(Sender: TObject);
begin
  if DateEditVen.Date < Now then
    ShowErrorMessage(rsDateNotAllow)
  else
    GetCustomController.SetVencimiento(DateEditVen.Date);
end;

procedure TProcesoFacturacion.RadioCondicionChange(Sender: TObject);
begin
  case RadioCondicion.ItemIndex of
    -1: DateEditVen.Enabled := False;
    0: DateEditVen.Enabled := True;
    1: DateEditVen.Enabled := False;
  end;
end;

procedure TProcesoFacturacion.OnPopupCancel;
begin
  GetController.CloseDataSets(Self);
end;

procedure TProcesoFacturacion.OnPopupOk;
begin
  GetController.Connect(Self);
  // si ya se esta editando la factura simplemente la cancelamos y hacemos otra
  GetCustomController.NuevoComprobante(Self);
end;

function TProcesoFacturacion.GetCustomController: TFacturaController;
begin
  Result := GetController as TFacturaController;
end;

procedure TProcesoFacturacion.ObserverUpdate(const Subject: IInterface);
begin
  inherited ObserverUpdate(Subject);
  case GetCustomController.GetEstadoComprobante(Self) of
    asEditando:
    begin
      DateEditVen.Date := now; // no me gusta esto pero bue...
    end;
  end;
end;

procedure TProcesoFacturacion.Limpiar;
begin
  inherited;
  DateEditVen.Clear;
  RadioCondicion.ItemIndex := -1;
end;

procedure TProcesoFacturacion.OKButtonClick(Sender: TObject);
begin
  if RadioCondicion.ItemIndex = -1 then
  begin
    ShowErrorMessage('Por favor seleccione una condicion de venta');
    Exit;
  end
  else if (RadioCondicion.ItemIndex = 0) and
    (not GetController.IsValidDate(DateEditVen.Text) or (DateEditVen.Date < Now)) then
  begin
    ShowErrorMessage('Fecha de vencimiento no valida');
    Exit;
  end;
  inherited;
end;

{
//para seleccionar el talonario a usar
procedure TProcesoFacturacion.talonarioClick(Sender: TObject);
begin
  //creamos la ventana de seleccion
  try
    FTalonario.talonario.ID := pTalonarioID;
    g := TPopupBuscarTalonario.Create(Self, FTalonario);
    if (g.ShowModal = mrOk) then
    begin
      pTalonarioID := FTalonario.talonario.ID;
      Cabecera.Enabled := True;
      Detalles.Enabled := True;
      Totales.Enabled := True;
      ButtonLimpiarClick(Self);
      Exit;
    end
    else
    begin
      Exit;
    end;
  finally
    g.Free;
  end;
end;

procedure TProcesoFacturacion.DBGrid1KeyDown(Sender: TObject;
  var Key: word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
  begin
    if not (qryDetalle.State in [dsEdit, dsInsert]) then
      qryDetalle.Edit;
    case DBGridDet.SelectedField.FieldName of
      'EXENTA':
      begin
        qryDetalleIVA5.AsFloat := 0;
        qryDetalleIVA10.AsFloat := 0;
        qryDetalleEXENTA.AsFloat :=
          qryDetalleCANTIDAD.AsInteger * qryDetallePRECIO_UNITARIO.AsFloat;
        qryDetalle.Post;
        ActualizarTotal;
        qryDetalle.Append;
        DBGridDet.SelectedIndex := 1;
      end;
      'IVA5':
      begin
        qryDetalleEXENTA.AsFloat := 0;
        qryDetalleIVA10.AsFloat := 0;
        qryDetalleIVA5.AsFloat :=
          qryDetalleCANTIDAD.AsInteger * qryDetallePRECIO_UNITARIO.AsFloat;
        qryDetalle.Post;
        ActualizarTotal;
        qryDetalle.Append;
        DBGridDet.SelectedIndex := 1;
      end;
      'IVA10':
      begin
        qryDetalleEXENTA.AsFloat := 0;
        qryDetalleIVA5.AsFloat := 0;
        qryDetalleIVA10.AsFloat :=
          qryDetalleCANTIDAD.AsInteger * qryDetallePRECIO_UNITARIO.AsFloat;
        qryDetalle.Post;
        ActualizarTotal;
        qryDetalle.Append;
        DBGridDet.SelectedIndex := 1;
      end;
      else
      begin
        Exit;
      end;
    end;
  end
  else if (Key = VK_DELETE) and (not (DBGridDet.EditorMode)) and not
    qryDetalle.IsEmpty then
  begin
    //borrar la fila actual
    if (qryDetalle.State in [dsEdit, dsInsert]) then
      qryDetalle.Cancel;
    qryDetalle.Delete;
    ActualizarTotal;
  end
  else if (key = VK_ESCAPE) and not qryDetalle.IsEmpty then
  begin
    if (qryDetalle.State in [dsEdit, dsInsert]) then
      qryDetalle.Delete;
    ActualizarTotal;
  end;
end;

procedure TProcesoFacturacion.OKButtonClick(Sender: TObject);
begin
  try
    qryCabeceraFECHA_EMISION.AsDateTime := DateEditFecha.Date;
    if qryCabeceraCONTADO.AsInteger = 0 then
    begin
      qryCabeceraVENCIMIENTO.AsDateTime := DateEditVen.Date;
      if (qryCabeceraVENCIMIENTO.AsDateTime <= qryCabeceraFECHA_EMISION.AsDateTime) then
        raise EDatabaseError.Create(
          '#La fecha de vencimiento no puede ser anterior a la fecha de emision#');
    end;
    qryCabeceraNUMERO.AsInteger := qryNumeroNUM.AsInteger;
    //si la factura es contado ya abrimos la ventana para pagar
    if qryCabeceraCONTADO.AsInteger = 1 then
    begin
      //guardamos los datos para pasarle a la ventana de cobro
      FComprobante.comprobante.ID := pFacturaID;
      FComprobante.comprobante.Tipo := 1;
      FComprobante.comprobante.PersonaID := qryCabeceraPERSONAID.AsInteger;
      FComprobante.comprobante.Total := qryCabeceraTOTAL.AsFloat;

      qryCabecera.ApplyUpdates;
      qryDetalle.ApplyUpdates;
      try
        hola := TProcesoCobro.Create(Self, FComprobante);
        case hola.ShowModal of
          mrOk:
          begin
            SGCDDataModule.sqlTran.Commit; //se comitea el pago
            //actualizamos el estado de las deudas
            SGCDDataModule.Ejecutar('execute procedure actualizar_estado_deuda');
            //y comiteamos el stored procedure
            SGCDDataModule.sqlTran.Commit;
          end;
          mrCancel:
            raise EDatabaseError.Create('#Se cancelo el pago y no se guarda el recibo#');
          else
            Exit;
        end;
      finally
        //hola.Free;
      end;
    end
    else
    begin
      qryCabecera.ApplyUpdates;
      qryDetalle.ApplyUpdates;
      SGCDDataModule.sqlTran.Commit;
    end;
    //mostrar reporte
    qryCabecera1.Params.ParamByName('factura_id').AsInteger := pFacturaID;
    qryDetalle1.Params.ParamByName('facturaid').AsInteger := pFacturaID;
    frReport1.LoadFromFile('reportes\reporte-factura.lrf');
    frReport1.ShowReport;

    ButtonLimpiarClick(Self);
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
      SGCDDataModule.sqlTran.Rollback;
      ButtonLimpiarClick(Self);
    end;
  end;
end;
}


end.
