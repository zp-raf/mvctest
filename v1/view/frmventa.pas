unit frmventa;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, frmproceso, Dialogs,
  Menus, ButtonPanel, StdCtrls, DBCtrls, EditBtn, PairSplitter, DBGrids,
  sqldb, DB, IBConnection, strutils, LCLType, Buttons, ShellApi,
  frmventadatamodule, ventactrl,
  // para los campos de persona
  frmpersonasdatamodule;

type
  { TProcesoVenta }

  TProcesoVenta = class(TProceso)
    ButtonBuscarNombre: TButton;
    ButtonBuscarCedula: TButton;
    DBNavigator1: TDBNavigator;
    DBEdit10: TDBEdit;
    DBEdit11: TDBEdit;
    DBEdit12: TDBEdit;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBGrid1: TDBGrid;
    Persona: TGroupBox;
    Detalles: TGroupBox;
    Grantotal: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Subtotal: TLabel;
    Subtotal1: TLabel;
    Subtotal2: TLabel;
    Totales: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    talonario: TMenuItem;
    opciones: TMenuItem;
    procedure btSeleccionarClick(Sender: TObject);
    procedure ButtonBuscarCedulaClick(Sender: TObject);
    procedure ButtonBuscarNombreClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure DBNavigator1Click(Sender: TObject; Button: TDBNavButtonType);
    procedure ObserverUpdate(const Subject: IInterface); override;
    procedure OKButtonClick(Sender: TObject);
    //procedure talonarioClick(Sender: TObject);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
  end;

var
  ProcesoVenta: TProcesoVenta;

implementation

{$R *.lfm}

{ TProcesoVenta }

{
*************************************
EVENTOS DE BOTONES Y MENUS
*************************************
}

procedure TProcesoVenta.btSeleccionarClick(Sender: TObject);
begin
  //try
  //  //creamos la ventana de seleccion
  //  try
  //    f := TPopupSeleccionAlumnos.Create(Self, FAlumno);
  //    if (f.ShowModal = mrOk) then
  //    begin
  //      if not qryPersona.Locate('ID', IntToStr(FAlumno.alumno.ID),
  //        [loCaseInsensitive]) then
  //        Exit;
  //    end
  //    else
  //    begin
  //      Exit;
  //    end;
  //  finally
  //    f.Free;
  //  end;
  //  //filtramos la Detalles para sacar solo la del alumno seleccionado
  //  qryDeuda.Close;
  //  qryDeuda.Open;

  //  //aplicamos los cambios a la Persona
  //  if DateEdit1.Text = '' then
  //  begin
  //    DateEdit1.Date := Now;
  //  end;
  //  qryCabeceraPERSONAID.AsInteger := qryPersonaID.AsInteger;
  //  qryCabeceraRUC.AsString := qryPersonaCEDULA.AsString;
  //  qryCabeceraNOMBRE.AsString := qryPersonaNOMBRECOMPLETO.AsString;
  //  ActualizarTotal;

  //  //recorremos el dataset y vamos cargando en la factura
  //  qryDeuda.First;
  //  while not qryDeuda.EOF do
  //  begin
  //    qryDetalle.Append;
  //    qryDetalleCANTIDAD.AsInteger := qryDeudaCANT.AsInteger;
  //    qryDetalleDETALLE.AsString := qryDeudaDETALLE.AsString;
  //    qryDetallePRECIO_UNITARIO.AsFloat := qryDeudaPRECIO_UNITARIO.AsFloat;
  //    qryDetalleEXENTA.AsFloat := qryDeudaEXENTA.AsFloat;
  //    qryDetalleIVA5.AsFloat := qryDeudaIVA5.AsFloat;
  //    qryDetalleIVA10.AsFloat := qryDeudaIVA10.AsFloat;
  //    qryDetalleDEUDAID.AsInteger := qryDeudaDEUDAID.AsInteger;
  //    qryDeuda.Next;
  //  end;
  //  DBGrid1.AutoSizeColumns;
  //  ActualizarTotal;
  //  DBGrid1.SetFocus;
  //except
  //  on e: EDatabaseError do
  //  begin
  //    ManejoErrores(e);
  //  end;
  //end;
end;

procedure TProcesoVenta.ButtonBuscarCedulaClick(Sender: TObject);
begin

end;

procedure TProcesoVenta.ButtonBuscarNombreClick(Sender: TObject);
begin

end;

procedure TProcesoVenta.CancelButtonClick(Sender: TObject);
begin

end;

procedure TProcesoVenta.DBNavigator1Click(Sender: TObject; Button: TDBNavButtonType);
begin
  if (Button in [nbInsert]) then
  begin
    //(Controller as TVentaController).Connect(Self);
  end;
end;

procedure TProcesoVenta.ObserverUpdate(const Subject: IInterface);
begin

end;

////para seleccionar el talonario a usar
//procedure TProcesoVenta.talonarioClick(Sender: TObject);
//begin
//  //creamos la ventana de seleccion
//  try
//    FTalonario.talonario.ID := pTalonarioID;
//    g := TPopupBuscarTalonario.Create(Self, FTalonario);
//    if (g.ShowModal = mrOk) then
//    begin
//      pTalonarioID := FTalonario.talonario.ID;
//      {por si se entro en condicion de error de talonario no existente
//      entonces volvemos a habilitar los campos}
//      Persona.Enabled := True;
//      Detalles.Enabled := True;
//      Totales.Enabled := True;
//      ButtonLimpiarClick(Self);
//      Exit;
//    end
//    else
//    begin
//      Exit;
//    end;
//  finally
//    g.Free;
//  end;
//end;

procedure TProcesoVenta.DBGrid1KeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
//
//  if (Key = VK_RETURN) then
//  begin
//    if not (qryDetalle.State in [dsEdit, dsInsert]) then
//      qryDetalle.Edit;
//    case DBGrid1.SelectedField.FieldName of
//      'EXENTA':
//      begin
//        qryDetalleIVA5.AsFloat := 0;
//        qryDetalleIVA10.AsFloat := 0;
//        qryDetalleEXENTA.AsFloat :=
//          qryDetalleCANTIDAD.AsInteger * qryDetallePRECIO_UNITARIO.AsFloat;
//        qryDetalle.Post;
//        ActualizarTotal;
//        qryDetalle.Append;
//        DBGrid1.SelectedIndex := 1;
//      end;
//      'IVA5':
//      begin
//        qryDetalleEXENTA.AsFloat := 0;
//        qryDetalleIVA10.AsFloat := 0;
//        qryDetalleIVA5.AsFloat :=
//          qryDetalleCANTIDAD.AsInteger * qryDetallePRECIO_UNITARIO.AsFloat;
//        qryDetalle.Post;
//        ActualizarTotal;
//        qryDetalle.Append;
//        DBGrid1.SelectedIndex := 1;
//      end;
//      'IVA10':
//      begin
//        qryDetalleEXENTA.AsFloat := 0;
//        qryDetalleIVA5.AsFloat := 0;
//        qryDetalleIVA10.AsFloat :=
//          qryDetalleCANTIDAD.AsInteger * qryDetallePRECIO_UNITARIO.AsFloat;
//        qryDetalle.Post;
//        ActualizarTotal;
//        qryDetalle.Append;
//        DBGrid1.SelectedIndex := 1;
//      end;
//      else
//      begin
//        Exit;
//      end;
//    end;
//  end
//  else if (Key = VK_DELETE) and (not (DBGrid1.EditorMode)) and not
//    qryDetalle.IsEmpty then
//  begin
//    //borrar la fila actual
//    if (qryDetalle.State in [dsEdit, dsInsert]) then
//      qryDetalle.Cancel;
//    qryDetalle.Delete;
//    ActualizarTotal;
//  end
//  else if (key = VK_ESCAPE) and not qryDetalle.IsEmpty then
//  begin
//    if (qryDetalle.State in [dsEdit, dsInsert]) then
//      qryDetalle.Delete;
//    ActualizarTotal;
//  end;
end;

procedure TProcesoVenta.OKButtonClick(Sender: TObject);
begin
  //try
  //  qryCabeceraFECHA_EMISION.AsDateTime := DateEdit1.Date;
  //  if qryCabeceraCONTADO.AsInteger = 0 then
  //  begin
  //    qryCabeceraVENCIMIENTO.AsDateTime := DateEdit2.Date;
  //    if (qryCabeceraVENCIMIENTO.AsDateTime <= qryCabeceraFECHA_EMISION.AsDateTime) then
  //      raise EDatabaseError.Create(
  //        '#La fecha de vencimiento no puede ser anterior a la fecha de emision#');
  //  end;
  //  qryCabeceraNUMERO.AsInteger := qryNumeroNUM.AsInteger;
  //  //si la factura es contado ya abrimos la ventana para pagar
  //  if qryCabeceraCONTADO.AsInteger = 1 then
  //  begin
  //    //guardamos los datos para pasarle a la ventana de cobro
  //    FComprobante.comprobante.ID := pFacturaID;
  //    FComprobante.comprobante.Tipo := 1;
  //    FComprobante.comprobante.PersonaID := qryCabeceraPERSONAID.AsInteger;
  //    FComprobante.comprobante.Total := qryCabeceraTOTAL.AsFloat;
  //
  //    qryCabecera.ApplyUpdates;
  //    qryDetalle.ApplyUpdates;
  //    try
  //      hola := TProcesoCobro.Create(Self, FComprobante);
  //      case hola.ShowModal of
  //        mrOk:
  //        begin
  //          SGCDDataModule.sqlTran.Commit; //se comitea el pago
  //          //actualizamos el estado de las deudas
  //          SGCDDataModule.Ejecutar('execute procedure actualizar_estado_deuda');
  //          //y comiteamos el stored procedure
  //          SGCDDataModule.sqlTran.Commit;
  //        end;
  //        mrCancel:
  //          raise EDatabaseError.Create(
  //            '#Se cancelo el pago y no se guarda el recibo#');
  //        else
  //          Exit;
  //      end;
  //    finally
  //      //hola.Free;
  //    end;
  //  end
  //  else
  //  begin
  //    qryCabecera.ApplyUpdates;
  //    qryDetalle.ApplyUpdates;
  //    SGCDDataModule.sqlTran.Commit;
  //  end;
  //  //mostrar reporte
  //  qryCabecera1.Params.ParamByName('factura_id').AsInteger := pFacturaID;
  //  qryDetalle1.Params.ParamByName('facturaid').AsInteger := pFacturaID;
  //  frReport1.LoadFromFile('reportes\reporte-factura.lrf');
  //  frReport1.ShowReport;
  //
  //  ButtonLimpiarClick(Self);
  //except
  //  on e: EDatabaseError do
  //  begin
  //    ManejoErrores(e);
  //    SGCDDataModule.sqlTran.Rollback;
  //    ButtonLimpiarClick(Self);
  //  end;
  //end;
end;

end.
