unit frmprocesofacturacion;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ButtonPanel, StdCtrls, DBCtrls, EditBtn, PairSplitter, DBGrids, frmproceso, mvc,
  facturactrl2, frmfacturadatamodule2, frmMaestro, frmbuscaralumnos, buscaralctrl;

type

  { TProcesoFacturacion }

  TProcesoFacturacion = class(TProceso)
    procedure btSeleccionarClick(Sender: TObject);
    procedure ButtonLimpiarClick(Sender: TObject);
    procedure DateEditVenEditingDone(Sender: TObject);
    procedure DBGridDetEditingDone(Sender: TObject);
    procedure DBNavigatorDetBeforeAction(Sender: TObject; Button: TDBNavButtonType);
    procedure FormShow(Sender: TObject);
    procedure RadioCondicionChange(Sender: TObject);
  private
    FABMController: IABMController;
    FCustomController: TFacturaController;
    function GetController: IABMController;
    function GetCustomController: TFacturaController;
    procedure SetController(AValue: IABMController);
    procedure SetCustomController(AValue: TFacturaController);
  public
    constructor Create(AOwner: IFormView; AController: TFacturaController);
      overload;
  published
    btSeleccionar: TButton;
    ButtonLimpiar: TButton;
    Cabecera: TGroupBox;
    RadioCondicion: TDBRadioGroup;
    DateEditFecha: TDateEdit;
    DateEditVen: TDateEdit;
    DBEditDireccion: TDBEdit;
    DBEditSubTotal5: TDBEdit;
    DBEditSubTotal10: TDBEdit;
    DBEditNombre: TDBEdit;
    DBEditRuc: TDBEdit;
    DBEditTelefono: TDBEdit;
    DBEditNotaRem: TDBEdit;
    DBEditSubTotal: TDBEdit;
    DBEditGranTotal: TDBEdit;
    DBEditIVA5: TDBEdit;
    DBEditIVA10: TDBEdit;
    DBEditIVATotal: TDBEdit;
    DBGridDet: TDBGrid;
    DBNavigatorDet: TDBNavigator;
    DBTextNro: TDBText;
    DBTextTimbrado: TDBText;
    Detalles: TGroupBox;
    LabelGranTotal: TLabel;
    LabelDireccion: TLabel;
    LabelVen: TLabel;
    LabelNro: TLabel;
    LabelTimbrado: TLabel;
    LabelRuc: TLabel;
    LabelTelefono: TLabel;
    LabelNotaRem: TLabel;
    LabelFecha: TLabel;
    LabelIVA5: TLabel;
    LabelIVA10: TLabel;
    LabelIVATotal: TLabel;
    LabelNombre: TLabel;
    PairSplitterDetSubTot: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    LabelSubtotal: TLabel;
    LabelSubtotal5: TLabel;
    LabelSubtotal10: TLabel;
    Totales: TGroupBox;
    procedure Edit;
    procedure Insert;
    procedure Delete;
    procedure Refresh;
    procedure ObserverUpdate(const Subject: IInterface); override;
    property ABMController: IABMController read GetController write SetController;
    procedure Limpiar;
    procedure OKButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    { Aca esta el controlador especifico del modulo }
    property CustomController: TFacturaController
      read GetCustomController write SetCustomController;
  end;

var
  ProcesoFacturacion: TProcesoFacturacion;

implementation

{$R *.lfm}

{ TProcesoFacturacion }

procedure TProcesoFacturacion.btSeleccionarClick(Sender: TObject);
var
  PopUp: TPopupSeleccionAlumnos;
begin
  Controller.OpenDataSets(Self);
  try
    PopUp := TPopupSeleccionAlumnos.Create(Self, TBuscarAlumnosController.Create(
      Controller.Model));
    case PopUp.ShowModal of
      mrOk:
      begin
        Controller.Connect(Self);
        // si ya se esta editando la factura simplemente la cancelamos y hacemos otra
        CustomController.NuevaFactura(Self);
      end
      else
      begin
        Exit;
      end;
    end;
  finally
    PopUp.Free;
  end;
end;

procedure TProcesoFacturacion.ButtonLimpiarClick(Sender: TObject);
begin
  Limpiar;
  ABMController.Cancel(Self);
end;

procedure TProcesoFacturacion.DateEditVenEditingDone(Sender: TObject);
begin
  if DateEditVen.Date < Now then
    ShowErrorMessage('Fecha no permitida')
  else
    CustomController.SetVencimiento(DateEditVen.Date);
end;

procedure TProcesoFacturacion.DBGridDetEditingDone(Sender: TObject);
begin
  CustomController.ActualizarTotales(Self);
end;

procedure TProcesoFacturacion.DBNavigatorDetBeforeAction(Sender: TObject;
  Button: TDBNavButtonType);
begin
  //if not (Sender is TDBNavigator) then
  //  Abort;
  //case Button of
  //  nbInsert:
  //  begin
  //    Insert;
  //    Abort;
  //  end;
  //  nbEdit:
  //  begin
  //    Edit;
  //    Abort;
  //  end;
  //  nbRefresh:
  //  begin
  //    Refresh;
  //    Abort;
  //  end;
  //  nbDelete:
  //  begin
  //    Delete;
  //    Abort;
  //  end;
  //end;
end;

procedure TProcesoFacturacion.FormShow(Sender: TObject);
begin
  inherited;
  //ABMController.NewRecord(Self);
  Controller.CloseDataSets(Self);
end;

procedure TProcesoFacturacion.RadioCondicionChange(Sender: TObject);
begin
  case RadioCondicion.ItemIndex of
    -1: DateEditVen.Enabled := False;
    0: DateEditVen.Enabled := True;
    1: DateEditVen.Enabled := False;
  end;
end;

function TProcesoFacturacion.GetController: IABMController;
begin
  Result := FABMController;
end;

function TProcesoFacturacion.GetCustomController: TFacturaController;
begin
  Result := FCustomController;
end;

procedure TProcesoFacturacion.SetController(AValue: IABMController);
begin
  if FABMController = AValue then
    Exit;
  FABMController := AValue;
end;

procedure TProcesoFacturacion.SetCustomController(AValue: TFacturaController);
begin
  if FCustomController = AValue then
    Exit;
  FCustomController := AValue;
end;

constructor TProcesoFacturacion.Create(AOwner: IFormView;
  AController: TFacturaController);
var
  Cont: IController;
  ABMCont: IABMController;
begin
  { Aca se chequean el controlador y se asignan las propiedades
     correspondientes. Con queryinterface sacamos una referencia al objeto que
     implementa la interfaz. Hacemos asi por si acaso AController sea un objeto
     compuesto y que hayan subojetos que implementen las interfaces. Esto nos da
     mayor flexibilidad en la implementacion. }
  (AController as IInterface).QueryInterface(IController, Cont);
  (AController as IInterface).QueryInterface(IABMController, ABMCont);
  if (Cont = nil) or (ABMCont = nil) then
    raise Exception.Create(rsProvidedCont)
  else
  begin
    inherited Create(AOwner, Cont);
    ABMController := ABMCont;
    CustomController := AController;
  end;
end;

procedure TProcesoFacturacion.Edit;
begin

end;

procedure TProcesoFacturacion.Insert;
begin

end;

procedure TProcesoFacturacion.Delete;
begin

end;

procedure TProcesoFacturacion.Refresh;
begin

end;

procedure TProcesoFacturacion.ObserverUpdate(const Subject: IInterface);
begin
  inherited ObserverUpdate(Subject);
  case GetCustomController.GetFacturaEstado(Self) of
    asInicial:
    begin
      Cabecera.Enabled := False;
      Detalles.Enabled := False;
      Totales.Enabled := False;
      DBGridDet.Color := clInactiveCaption;
      btSeleccionar.Enabled := True;
      ButtonLimpiar.Enabled := True;
      Controller.CloseDataSets(Self);
    end;
    asGuardado:
    begin
      Cabecera.Enabled := False;
      Detalles.Enabled := False;
      Totales.Enabled := False;
      DBGridDet.Color := clInactiveCaption;
      btSeleccionar.Enabled := True;
      ButtonLimpiar.Enabled := True;
      Controller.CloseDataSets(Self);
    end;
    asEditando:
    begin
      Cabecera.Enabled := True;
      Detalles.Enabled := True;
      Totales.Enabled := True;
      DBGridDet.Color := clWindow;
      btSeleccionar.Enabled := False;
      ButtonLimpiar.Enabled := False;
      DBGridDet.AutoSizeColumns;
      DateEditVen.Date := now; // no me gusta esto pero bue...
    end;
    asLeyendo:
    begin
      Controller.OpenDataSets(Self);
    end;
  end;
end;

procedure TProcesoFacturacion.Limpiar;
begin
  DBEditDireccion.Clear;
  DBEditRuc.Clear;
  DBEditTelefono.Clear;
  DBEditNotaRem.Clear;
  DBEditSubTotal.Clear;
  DBEditGranTotal.Clear;
  DBEditIVA5.Clear;
  DBEditIVA10.Clear;
  DBEditIVATotal.Clear;
  DBEditSubTotal5.Clear;
  DBEditSubTotal10.Clear;
  DBEditNombre.Clear;
  DateEditFecha.Clear;
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
    (not Controller.IsValidDate(DateEditVen.Text) or (DateEditVen.Date < Now)) then
  begin
    ShowErrorMessage('Fecha de vencimiento no valida');
    Exit;
  end;
  if not (CustomController.GetFacturaEstado(Self) in [asEditando]) then
  begin
    ShowInfoMessage('No se esta procesando ninguna factura');
    Exit;
  end;
  CustomController.CerrarFactura(Self);
  ShowInfoMessage('Factura ingresada correctamente');
  Limpiar;
end;

procedure TProcesoFacturacion.CancelButtonClick(Sender: TObject);
begin
  ABMController.Cancel(Self);
  ABMController.Rollback(Self);
  ShowInfoMessage('Factura descartada');
  Limpiar;
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
