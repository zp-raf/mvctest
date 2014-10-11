unit frmprocesofacturacion;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ButtonPanel, StdCtrls, DbCtrls, EditBtn, PairSplitter, DBGrids, frmproceso, mvc,
  facturactrl2, frmfacturadatamodule2, frmMaestro;
type

  { TProcesoFacturacion }

  TProcesoFacturacion = class(TProceso)

  private
    FABMController : IABMController;
    FCustomController: TFacturaController;
    function GetController: IABMController;
    function GetCustomController: TFacturaController;
    procedure SetController(AValue: IABMController);
    procedure SetCustomController(AValue: TFacturaController);
    { private declarations }
  public
    { public declarations }
    constructor Create(AOwner: IFormView; AController: TFacturaController);
      overload;
  published
    btSeleccionar: TButton;
    ButtonLimpiar: TButton;
    Cabecera: TGroupBox;
    Condicion: TDBRadioGroup;
    DateEdit1: TDateEdit;
    DateEdit2: TDateEdit;
    DBEdit1: TDBEdit;
    DBEdit10: TDBEdit;
    DBEdit11: TDBEdit;
    DBEdit12: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    DBText1: TDBText;
    DBText2: TDBText;
    Detalles: TGroupBox;
    Grantotal: TLabel;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    PairSplitter1: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    Subtotal: TLabel;
    Subtotal1: TLabel;
    Subtotal2: TLabel;
    Totales: TGroupBox;

    procedure ObserverUpdate(const Subject: IInterface); override;

    property ABMController: IABMController read GetController write SetController;
    procedure Limpiar;
        procedure OKButtonClick(Sender: TObject);
        procedure CancelButtonClick(Sender: TObject);
    { Aca esta el controlador especifico del modulo }
    property CustomController: TFacturaController read GetCustomController write SetCustomController;

{

procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
procedure XMLPropStorage1RestoreProperties(Sender: TObject);
procedure XMLPropStorage1SaveProperties(Sender: TObject);
procedure AbrirCursor;
procedure ActualizarTotal;
procedure btSeleccionarClick(Sender: TObject);
procedure ButtonLimpiarClick(Sender: TObject);
procedure CancelButtonClick(Sender: TObject); override;
procedure CondicionChange(Sender: TObject);
procedure FormCreate(Sender: TObject); override;
procedure ManejoErrores(E: EDatabaseError); override;
procedure OKButtonClick(Sender: TObject); override;
procedure qryDetalleFilterRecord(DataSet: TDataSet; var Accept: boolean);
procedure qryDetalleNewRecord(DataSet: TDataSet);
procedure qryDeudaFilterRecord(DataSet: TDataSet; var Accept: boolean);
procedure talonarioClick(Sender: TObject);
property pTalonarioID: integer read FTalonarioID write SetTalonarioID;
property pFacturaID: integer read FFacturaID write SetFacturaID;

}

  end;

var
  ProcesoFacturacion: TProcesoFacturacion;

implementation

{$R *.lfm}

{ TProcesoFacturacion }

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
  if FCustomController=AValue then Exit;
  FCustomController:=AValue;
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
   //  raise Exception.Create(rsProvidedCont)
   else
   begin
     inherited Create(AOwner, Cont);
     ABMController := ABMCont;
     CustomController := AController;
   end;
end;

procedure TProcesoFacturacion.ObserverUpdate(const Subject: IInterface);
begin
  inherited ObserverUpdate(Subject);
  //case GetCustomController.GetAsientoEstado(Self) of
  case GetCustomController.GetFacturaEstado(Self) of
    asInicial:
    begin
      {DBGridCuenta.Enabled := False;
      DBGridCuenta.Color := clInactiveCaption;
      MaskEditMonto.Enabled := False;
      LabeledEditDesscripcion.Enabled := True;
      RadioGroup1.Enabled := False;
      BitBtnReversar.Enabled := True;
      BitBtnCerrarAsiento.Enabled := False;
      BitBtnNuevoDetalle.Enabled := False;
      BitBtnNuevo.Enabled := True;}
      DBGrid1.Enabled:= False;
      DBGrid1.Color:= clInactiveCaption;
      btSeleccionar.Visible:= False;
      ButtonLimpiar.Enabled:= False;
      DBEdit1.Enabled:= True;
      DBEdit2.Enabled:= True;
      DBEdit3.Enabled:= True;
      DBEdit4.Enabled:= True;
      DBEdit5.Enabled:= True;
      DBEdit6.Enabled:= True;
      DBEdit7.Enabled:= True;
      DBEdit8.Enabled:= True;
      DBEdit9.Enabled:= True;
      DBEdit10.Enabled:= True;
      DBEdit11.Enabled:= True;
      DBEdit12.Enabled:= True;
      DateEdit1.Enabled:=True;
      DateEdit2.Enabled:= True;
      Condicion.Enabled:= False;
    end;
    asGuardado:
    begin
      {
       DBGridCuenta.Enabled := False;
       DBGridCuenta.Color := clInactiveCaption;
       MaskEditMonto.Enabled := False;
       LabeledEditDesscripcion.Enabled := True;
       RadioGroup1.Enabled := False;
       BitBtnReversar.Enabled := True;
       BitBtnCerrarAsiento.Enabled := False;
       BitBtnNuevoDetalle.Enabled := False;
       BitBtnNuevo.Enabled := True;
      }
      DBGrid1.Enabled:= False;
      DBGrid1.Color:= clInactiveCaption;
      btSeleccionar.Visible:= False;
      ButtonLimpiar.Enabled:= False;
      DBEdit1.Enabled:= True;
      DBEdit2.Enabled:= True;
      DBEdit3.Enabled:= True;
      DBEdit4.Enabled:= True;
      DBEdit5.Enabled:= True;
      DBEdit6.Enabled:= True;
      DBEdit7.Enabled:= True;
      DBEdit8.Enabled:= True;
      DBEdit9.Enabled:= True;
      DBEdit10.Enabled:= True;
      DBEdit11.Enabled:= True;
      DBEdit12.Enabled:= True;
      DateEdit1.Enabled:=True;
      DateEdit2.Enabled:= True;
      Condicion.Enabled:= True;

    end;
    asEditando:
    begin
      {
       DBGridCuenta.Enabled := False;
       DBGridCuenta.Color := clWindow;
       MaskEditMonto.Enabled := True;
       LabeledEditDesscripcion.Enabled := False;
       RadioGroup1.Enabled := True;
       BitBtnReversar.Enabled := False;
       BitBtnCerrarAsiento.Enabled := True;
       BitBtnNuevoDetalle.Enabled := True;
       BitBtnNuevo.Enabled := False;
      }
      DBGrid1.Enabled:= False;
      DBGrid1.Color:= clWindow;
      btSeleccionar.Visible:= False;
      ButtonLimpiar.Enabled:= False;
      DBEdit1.Enabled:= False;
      DBEdit2.Enabled:= False;
      DBEdit3.Enabled:= False;
      DBEdit4.Enabled:= False;
      DBEdit5.Enabled:= False;
      DBEdit6.Enabled:= False;
      DBEdit7.Enabled:= False;
      DBEdit8.Enabled:= False;
      DBEdit9.Enabled:= False;
      DBEdit10.Enabled:= False;
      DBEdit11.Enabled:= False;
      DBEdit12.Enabled:= False;
      DateEdit1.Enabled:=False;
      DateEdit2.Enabled:= False;
      Condicion.Enabled:= False;

    end;
  end;

end;

procedure TProcesoFacturacion.Limpiar;
begin
    DBEdit1.Clear;
    DBEdit2.Clear;
    DBEdit3.Clear;
    DBEdit4.Clear;
    DBEdit5.Clear;
    DBEdit6.Clear;
    DBEdit7.Clear;
    DBEdit8.Clear;
    DBEdit9.Clear;
    DBEdit10.Clear;
    DBEdit11.Clear;
    DBEdit12.Clear;
    DateEdit1.Clear;
    DateEdit2.Clear;
    Condicion.ItemIndex:=-1;

end;

procedure TProcesoFacturacion.OKButtonClick(Sender: TObject);
begin
  ABMController.Commit(Self);
  ABMController.Connect(Self);
  Limpiar;
  ShowInfoMessage('Factura ingresada correctamente');
end;

procedure TProcesoFacturacion.CancelButtonClick(Sender: TObject);
begin
  ABMController.Rollback(Self);
  Limpiar;
  ShowInfoMessage('Factura descartada');
end;


{
procedure TProcesoFacturacion.SetFacturaID(AValue: integer);
begin
  if FFacturaID = AValue then
    Exit;
  FFacturaID := AValue;
end;

procedure TProcesoFacturacion.SetTalonarioID(AValue: integer);
begin
  if FTalonarioID = AValue then
    Exit;
  FTalonarioID := AValue;
end;

{
*************************************
FILTROS Y EVENTOS DEL DATASET
*************************************
}

procedure TProcesoFacturacion.AbrirCursor;
begin
  try
    qryPersona.Close;
    qryCabecera.Close;
    qryDetalle.Close;
    //qryNumero.Close;
    qryDeuda.Close;
    tal.Close;
    qryPersona.Open;
    qryCabecera.Open;
    qryDetalle.Open;
    //qryNumero.Open;
    qryDeuda.Open;
    tal.Open;
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
    end;
  end;
end;


procedure TProcesoFacturacion.qryDetalleFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  Accept := DataSet.FieldByName('FACTURAID').AsInteger = pFacturaID;
end;

{
 aca manejamos el autoincremento del dataset
}
procedure TProcesoFacturacion.qryDetalleNewRecord(DataSet: TDataSet);
begin
  qryDetalleID.AsInteger := SGCDDataModule.SiguienteValor('seq_factura_detalle');
  qryDetalleFACTURAID.AsInteger := pFacturaID;
  qryDetalleDETALLE.AsString := '';
  qryDetalleCANTIDAD.AsInteger := 0;
  qryDetalleEXENTA.AsFloat := 0;
  qryDetalleIVA5.AsFloat := 0;
  qryDetalleIVA10.AsFloat := 0;
end;

procedure TProcesoFacturacion.qryDeudaFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  Accept := DataSet.FieldByName('PERSONAID').AsInteger = qryPersonaID.AsInteger;
end;

{
*************************************
EVENTOS DE BOTONES Y MENUS
*************************************
}

procedure TProcesoFacturacion.ActualizarTotal;
begin
  if not (qryCabecera.State in [dsEdit, dsInsert]) then
    qryCabecera.Edit;
  qryCabeceraSUBTOTAL_EXENTAS.AsFloat := 0.0;
  qryCabeceraSUBTOTAL_IVA5.AsFloat := 0.0;
  qryCabeceraSUBTOTAL_IVA10.AsFloat := 0.0;
  if not qryDetalle.IsEmpty then
  begin
    qryDetalle.First;
    while not qryDetalle.EOF do
    begin
      qryCabeceraSUBTOTAL_EXENTAS.AsFloat :=
        qryCabeceraSUBTOTAL_EXENTAS.AsFloat + qryDetalleEXENTA.AsFloat;
      qryCabeceraSUBTOTAL_IVA5.AsFloat :=
        qryCabeceraSUBTOTAL_IVA5.AsFloat + qryDetalleIVA5.AsFloat;
      qryCabeceraSUBTOTAL_IVA10.AsFloat :=
        qryCabeceraSUBTOTAL_IVA10.AsFloat + qryDetalleIVA10.AsFloat;
      qryDetalle.Next;
    end;
    qryCabeceraTOTAL.AsFloat :=
      round(qryCabeceraSUBTOTAL_EXENTAS.AsFloat + qryCabeceraSUBTOTAL_IVA5.AsFloat +
      qryCabeceraSUBTOTAL_IVA10.AsFloat);
    qryCabeceraIVA5.AsFloat := round(qryCabeceraSUBTOTAL_IVA5.AsFloat / 23.0);
    qryCabeceraIVA10.AsFloat := round(qryCabeceraSUBTOTAL_IVA10.AsFloat / 11.0);
    qryCabeceraIVA_TOTAL.AsFloat :=
      round(qryCabeceraIVA5.AsFloat + qryCabeceraIVA10.AsFloat);
  end;
end;

procedure TProcesoFacturacion.btSeleccionarClick(Sender: TObject);
begin
  try
    //creamos la ventana de seleccion
    try
      f := TPopupSeleccionAlumnos.Create(Self, FAlumno);
      if (f.ShowModal = mrOk) then
      begin
        if not qryPersona.Locate('ID', IntToStr(FAlumno.alumno.ID),
          [loCaseInsensitive]) then
          Exit;
      end
      else
      begin
        Exit;
      end;
    finally
      f.Free;
    end;
    //filtramos la deuda para sacar solo la del alumno seleccionado
    qryDeuda.Close;
    qryDeuda.Open;

    //aplicamos los cambios a la cabecera
    if DateEdit1.Text = '' then
    begin
      DateEdit1.Date := Now;
    end;
    qryCabeceraPERSONAID.AsInteger := qryPersonaID.AsInteger;
    qryCabeceraRUC.AsString := qryPersonaCEDULA.AsString;
    qryCabeceraNOMBRE.AsString := qryPersonaNOMBRECOMPLETO.AsString;
    ActualizarTotal;

    //recorremos el dataset y vamos cargando en la factura
    qryDeuda.First;
    while not qryDeuda.EOF do
    begin
      qryDetalle.Append;
      qryDetalleCANTIDAD.AsInteger := qryDeudaCANT.AsInteger;
      qryDetalleDETALLE.AsString := qryDeudaDETALLE.AsString;
      qryDetallePRECIO_UNITARIO.AsFloat := qryDeudaPRECIO_UNITARIO.AsFloat;
      qryDetalleEXENTA.AsFloat := qryDeudaEXENTA.AsFloat;
      qryDetalleIVA5.AsFloat := qryDeudaIVA5.AsFloat;
      qryDetalleIVA10.AsFloat := qryDeudaIVA10.AsFloat;
      qryDetalleDEUDAID.AsInteger := qryDeudaDEUDAID.AsInteger;
      qryDeuda.Next;
    end;
    DBGrid1.AutoSizeColumns;
    ActualizarTotal;
    DBGrid1.SetFocus;
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
    end;
  end;
end;

procedure TProcesoFacturacion.ButtonLimpiarClick(Sender: TObject);
begin
  try

    //traemos el siguiente numero de factura disponible del talonario
    qryNumero.Params[0].AsInteger := pTalonarioID;
    qryNumero.Close;
    qryNumero.Open;
    {si se devuelve negativo quiere decir que el talonario no existe y se pide
    seleccionar uno}

    //sacamos un nuevo id de factura
    pFacturaID := SGCDDataModule.SiguienteValor('seq_factura');
    DateEdit1.Clear;
    DateEdit2.Clear;
    AbrirCursor;
    tal.Refresh;
    //creamos nueva factura
    qryCabecera.Append;
    qryCabeceraID.AsInteger := pFacturaID;
    qryCabeceraTALONARIOID.AsInteger := pTalonarioID;
    qryCabeceraCONTADO.AsInteger := 1;//por defecto contado
    DateEdit2.Enabled := False;
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
    end;
  end;
end;

procedure TProcesoFacturacion.CancelButtonClick(Sender: TObject);
begin
  SGCDDataModule.sqlTran.Rollback;
  ButtonLimpiarClick(Self);
end;

procedure TProcesoFacturacion.CondicionChange(Sender: TObject);
begin
  if Condicion.Value = '0' then
    DateEdit2.Enabled := True
  else
    DateEdit2.Enabled := False;
end;

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
      {por si se entro en condicion de error de talonario no existente
      entonces volvemos a habilitar los campos}
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
    case DBGrid1.SelectedField.FieldName of
      'EXENTA':
      begin
        qryDetalleIVA5.AsFloat := 0;
        qryDetalleIVA10.AsFloat := 0;
        qryDetalleEXENTA.AsFloat :=
          qryDetalleCANTIDAD.AsInteger * qryDetallePRECIO_UNITARIO.AsFloat;
        qryDetalle.Post;
        ActualizarTotal;
        qryDetalle.Append;
        DBGrid1.SelectedIndex := 1;
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
        DBGrid1.SelectedIndex := 1;
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
        DBGrid1.SelectedIndex := 1;
      end;
      else
      begin
        Exit;
      end;
    end;
  end
  else if (Key = VK_DELETE) and (not (DBGrid1.EditorMode)) and not
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

procedure TProcesoFacturacion.MenuItemAyudaClick(Sender: TObject);
begin
  //inherited;
   ShellExecute(Handle, 'open', 'help\ABMs\factura-venta.html', nil, nil, 1);
end;

procedure TProcesoFacturacion.talFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin
  Accept := DataSet.FieldByName('ID').AsInteger = pTalonarioID;
end;

procedure TProcesoFacturacion.OKButtonClick(Sender: TObject);
begin
  try
    qryCabeceraFECHA_EMISION.AsDateTime := DateEdit1.Date;
    if qryCabeceraCONTADO.AsInteger = 0 then
    begin
      qryCabeceraVENCIMIENTO.AsDateTime := DateEdit2.Date;
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

{
*************************************
MANEJO DE VENTANA
*************************************
}
procedure TProcesoFacturacion.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  XMLPropStorage1.Save;
  inherited;
end;

procedure TProcesoFacturacion.FormCreate(Sender: TObject);
begin
  XMLPropStorage1.Restore;
  //creamos los objetos que sirven de mensajeros entre los forms de busqueda y principal
  FAlumno := TMensajeAlumno.Create();
  FTalonario := TMensajeTalonario.Create();
  FComprobante := TMensajeComprobante.Create();
  ButtonLimpiarClick(Self);
end;

{
*************************************
MANEJO DE ERRORES
*************************************
}
procedure TProcesoFacturacion.ManejoErrores(E: EDatabaseError);
begin
  inherited ManejoErrores(E);
  Cabecera.Enabled := False;
  Detalles.Enabled := False;
  Totales.Enabled := False;
end;

{
*************************************
GUARDADO DE PROPIEDADES
*************************************
}

procedure TProcesoFacturacion.XMLPropStorage1RestoreProperties(Sender: TObject);
begin
  if Trim(XMLPropStorage1.StoredValues.Items[0].Value) = '' then
    pTalonarioID := 0
  else
    pTalonarioID := StrToInt(XMLPropStorage1.StoredValues.Items[0].Value);
end;

procedure TProcesoFacturacion.XMLPropStorage1SaveProperties(Sender: TObject);
begin
  XMLPropStorage1.StoredValues.Items[0].Value := IntToStr(pTalonarioID);
end;


}


end.

