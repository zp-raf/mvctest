unit frmrecibodatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, sqldb, FileUtil, LR_DBSet, LR_Class, Forms, Controls,
  Graphics, Dialogs, XMLPropStorage, IniPropStorage, frmcomprobantedatamodule,
  sgcdTypes, frmfacturadatamodule2, variants;

resourcestring
  rsReciboGenName = 'SEQ_RECIBO';
  rsReciboDetGenName = 'SEQ_RECIBO_DETALLE';

const
  TALONARIO_RE = '15';

type

  { TReciboDataModule }

  TReciboDataModule = class(TComprobanteDataModule)
    dsCabReport: TDataSource;
    dsDetReport: TDataSource;
    qryCabeceraReport: TSQLQuery;
    qryCabeceraReportCEDULA: TStringField;
    qryCabeceraReportDIRECCION: TStringField;
    qryCabeceraReportESCOMPRA: TLongintField;
    qryCabeceraReportFECHA_EMISION: TDateField;
    qryCabeceraReportID: TLongintField;
    qryCabeceraReportNOMBRE: TStringField;
    qryCabeceraReportNUMERO_RECIBO: TStringField;
    qryCabeceraReportPERS_DIRECCION: TStringField;
    qryCabeceraReportPERS_NOMBRECOMPLETO: TStringField;
    qryCabeceraReportPERS_RUCCEDULA: TStringField;
    qryCabeceraReportPERS_TELEFONO: TStringField;
    qryCabeceraReportTAL_DIRECCION: TStringField;
    qryCabeceraReportTAL_NOMBRE: TStringField;
    qryCabeceraReportTAL_RUBRO: TStringField;
    qryCabeceraReportTAL_RUC: TStringField;
    qryCabeceraReportTAL_TELEFONO: TStringField;
    qryCabeceraReportTELEFONO: TStringField;
    qryCabeceraReportTIMBRADO: TStringField;
    qryCabeceraReportTOTAL: TFloatField;
    qryCabeceraReportVALIDO_HASTA: TDateField;
    qryDetalleReport: TSQLQuery;
    qryDetalleReportCANTIDAD: TLongintField;
    qryDetalleReportDETALLE: TStringField;
    qryDetalleReportDEUDAID: TLongintField;
    qryDetalleReportID: TLongintField;
    qryDetalleReportPRECIO_UNITARIO: TFloatField;
    qryDetalleReportRECIBOID: TLongintField;
    qryDetalleReportTOTAL: TFloatField;
    RecibosView: TSQLQuery;
    RecibosViewCEDULA: TStringField;
    RecibosViewESCOMPRA: TLongintField;
    RecibosViewFECHA_EMISION: TDateField;
    RecibosViewID: TLongintField;
    RecibosViewNOMBRE: TStringField;
    RecibosViewNUMERO_RECIBO: TStringField;
    RecibosViewPERSONAID: TLongintField;
    RecibosViewTIMBRADO: TStringField;
    RecibosViewTOTAL: TFloatField;
    RecibosViewVALIDO: TSmallintField;
  private
    FCheckPrecioUnitario: boolean;
    FFacturas: TFacturasDataModule;
    procedure SetCheckPrecioUnitario(AValue: boolean);
    procedure SetFacturas(AValue: TFacturasDataModule);
  published
    DateField1: TDateField;
    DateField2: TDateField;
    IniPropStorage1: TIniPropStorage;
    qryCabeceraNUMERO_REC_COMPRA: TStringField;
    qryCabeceraVALIDO: TSmallintField;
    StringField2: TStringField;
    StringField3: TStringField;
    dsFacturas: TDataSource;
    qryCabeceraPAGOID: TLongintField;
    qryCabeceraCEDULA: TStringField;
    qryCabeceraDIRECCION: TStringField;
    qryCabeceraFACTURAID: TLongintField;
    qryCabeceraFECHA_EMISION: TDateField;
    qryCabeceraID: TLongintField;
    qryCabeceraNOMBRE: TStringField;
    qryCabeceraNUMERO: TLongintField;
    qryCabeceraPERSONAID: TLongintField;
    qryCabeceraTALONARIOID: TLongintField;
    qryCabeceraTELEFONO: TStringField;
    qryCabeceraTIMBRADO: TStringField;
    qryCabeceraTOTAL: TFloatField;
    qryDetalleCANTIDAD: TLongintField;
    qryDetalleDETALLE: TStringField;
    qryDetalleDEUDAID: TLongintField;
    qryDetalleID: TLongintField;
    qryDetallePRECIO_UNITARIO: TFloatField;
    qryDetalleRECIBOID: TLongintField;
    qryDetalleTOTAL: TFloatField;
    StringField1: TStringField;
    procedure AfterConstruction; override;
    procedure ActualizarTotales; override;
    procedure AnularRecibo(AReciboID: string);
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DeterminarImpuesto; override;
    procedure FetchCabeceraFactura(AFacturaID: string);
    procedure FetchCabeceraFactura;
    procedure FetchCabeceraPersona(APersonaID: string); override; overload;
    procedure FetchDetalleFactura;
    procedure FetchDetalleFactura(AFacturaID: string);
    procedure GetImpuestos; override;
    procedure IniPropStorage1RestoreProperties(Sender: TObject);
    procedure IniPropStorage1SaveProperties(Sender: TObject);
    procedure NuevoComprobante(APagoID: string); overload;
    procedure qryCabeceraAfterScroll(DataSet: TDataSet); override;
    procedure qryDetalleAfterInsert(DataSet: TDataSet); override;
    procedure qryDetallePRECIO_UNITARIOChange(Sender: TField);
    procedure SetNumero; override;
    property Facturas: TFacturasDataModule read FFacturas write SetFacturas;
    property CheckPrecioUnitario: boolean read FCheckPrecioUnitario
      write SetCheckPrecioUnitario;
  end;

var
  ReciboDataModule: TReciboDataModule;

implementation

{$R *.lfm}

{ TReciboDataModule }

procedure TReciboDataModule.SetNumero;
begin
  try
    qryNumero.Close;
    qryNumero.ParamByName('TALONARIOID').AsString := TalonarioID;
    qryNumero.Open;
    qryCabecera.FieldByName('TALONARIOID').AsString := TalonarioID; // por si acaso...
    qryCabecera.FieldByName('NUMERO').AsString := qryNumeroNUM.AsString;
  except
    on E: EDatabaseError do
      DoOnErrorEvent(Self, E);
  end;
end;

procedure TReciboDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  FFacturas := TFacturasDataModule.Create(Self, MasterDataModule);
  dsFacturas.DataSet := FFacturas.FacturasView;
  SetTipoComprobante(doRecibo);
  CabeceraGenName := rsReciboGenName;
  DetalleGenName := rsReciboDetGenName;
  FFacturas.FacturasView.Close;
  FFacturas.FacturasView.ServerFilter := 'CONTADO = 0';
  FFacturas.FacturasView.ServerFiltered := True;
  AuxQryList.Add(TObject(FFacturas.FacturasView));
  AuxQryList.Add(TObject(RecibosView));
  AuxQryList.Add(TObject(qryCabeceraReport));
  AuxQryList.Add(TObject(qryDetalleReport));
  //TalonarioID := TALONARIO_RE;
  CheckPrecioUnitario := True;
  ReportFile := 'reportes\reporte-recibo.lrf';
  ReportFileCompra := 'reportes\reporte-recibo-compra.lrf';
end;

procedure TReciboDataModule.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FFacturas) then
    FreeAndNil(FFacturas);
end;

procedure TReciboDataModule.SetFacturas(AValue: TFacturasDataModule);
begin
  if FFacturas = AValue then
    Exit;
  FFacturas := AValue;
end;

procedure TReciboDataModule.AfterConstruction;
begin
  inherited AfterConstruction;
  IniPropStorage1.Restore;
end;

procedure TReciboDataModule.qryDetallePRECIO_UNITARIOChange(Sender: TField);
begin
  //if CheckPrecioUnitario then
  //  try
  //    montoMaximo := DeudaView.Lookup('ID', qryDetalleDEUDAID.Value, 'MONTO_DEUDA') -
  //      DeudaView.Lookup('ID', qryDetalleDEUDAID.Value, 'MONTO_FACTURADO');
  //    if Sender.AsFloat > montoMaximo then
  //      Sender.AsFloat := montoMaximo;
  //  except
  //    on E: EDatabaseError do
  //    begin
  //      Abort;
  //    end;
  //  end;

  try
    qryDetalleTOTAL.AsFloat :=
      qryDetalleCANTIDAD.AsFloat * qryDetallePRECIO_UNITARIO.AsFloat;
  finally
    //qryDetalle.Post;
  end;
end;

procedure TReciboDataModule.IniPropStorage1RestoreProperties(Sender: TObject);
begin
  FTalonarioID := IniPropStorage1.StoredValues.Items[0].Value;
end;

procedure TReciboDataModule.IniPropStorage1SaveProperties(Sender: TObject);
begin
  IniPropStorage1.StoredValues.Items[0].Value := FTalonarioID;
end;

procedure TReciboDataModule.SetCheckPrecioUnitario(AValue: boolean);
begin
  if FCheckPrecioUnitario = AValue then
    Exit;
  FCheckPrecioUnitario := AValue;
end;

procedure TReciboDataModule.ActualizarTotales;
begin
  if not (qryCabecera.State in [dsEdit, dsInsert]) then
    qryCabecera.Edit;
  qryCabeceraTOTAL.AsFloat := 0;
  qryDetalle.First;
  while not qryDetalle.EOF do
  begin
    // gran total
    qryCabeceraTOTAL.AsFloat :=
      qryCabeceraTOTAL.AsFloat + (qryDetalleCANTIDAD.AsFloat *
      qryDetallePRECIO_UNITARIO.AsFloat);
    qryDetalle.Next;
  end;
end;

procedure TReciboDataModule.AnularRecibo(AReciboID: string);
begin
  try
    LocateComprobante(AReciboID);
    if qryCabeceraVALIDO.AsString = DB_FALSE then
      raise Exception.Create('El recibo ya esta anulado');
    qryCabecera.Edit;
    qryCabeceraVALIDO.AsString := DB_FALSE;
    qryCabecera.ApplyUpdates;
    if qryCabeceraTALONARIOID.IsNull then
    begin
      if not RecibosView.Locate('ID', AReciboID, []) then
        raise Exception.Create('No se pudo obtener el numero y timbrado del recibo');
      Asientos.ReversarAsientoComprobante(doRecibo, AReciboID,
        'Anulacion de recibo de compra nro ' + RecibosViewNUMERO_RECIBO.AsString +
        ' con timbrado ' + RecibosViewTIMBRADO.AsString);
    end
    else
      qryCabecera.ApplyUpdates;
    Estado := csGuardado;
  except
    on E: EDatabaseError do
    begin
      DoOnErrorEvent(Self, E);
    end;
  end;
end;

procedure TReciboDataModule.DeterminarImpuesto;
begin
  // no hace falta, todavia...
end;

procedure TReciboDataModule.FetchCabeceraFactura(AFacturaID: string);
begin
  Facturas.LocateComprobante(AFacturaID);
  if not (qryCabecera.State in dsEditModes) then
    qryCabecera.Edit;
  qryCabeceraFACTURAID.Value := Facturas.qryCabecera.FieldByName('ID').Value;
  qryCabeceraPERSONAID.Value := Facturas.qryCabecera.FieldByName('PERSONAID').Value;
  qryCabeceraNOMBRE.AsString := Facturas.qryCabecera.FieldByName('NOMBRE').AsString;
  qryCabeceraCEDULA.AsString := Facturas.qryCabecera.FieldByName('RUC').AsString;
  qryCabeceraTELEFONO.AsString := Facturas.qryCabecera.FieldByName('TELEFONO').AsString;
  qryCabeceraDIRECCION.AsString :=
    Facturas.qryCabecera.FieldByName('DIRECCION').AsString;
  qryCabeceraTOTAL.Value := Facturas.qryCabecera.FieldByName('TOTAL').Value;
end;

procedure TReciboDataModule.FetchCabeceraFactura;
begin
  FetchCabeceraFactura(FFacturas.FacturasViewID.AsString);
end;

procedure TReciboDataModule.FetchCabeceraPersona(APersonaID: string);
begin
  inherited FetchCabeceraPersona(APersonaID);
  if Personas.PersonaCEDULA.IsNull then
    qryCabecera.FieldByName('CEDULA').AsString := Personas.PersonaRUC.AsString
  else
    qryCabecera.FieldByName('CEDULA').AsString := Personas.PersonaCEDULA.AsString;
end;

procedure TReciboDataModule.FetchDetalleFactura;
begin
  FetchDetalleFactura(FFacturas.FacturasViewID.AsString);
end;

procedure TReciboDataModule.FetchDetalleFactura(AFacturaID: string);
begin
  try
    qryDetalle.AfterPost := nil;
    Facturas.qryDetalle.First;
    while not Facturas.qryDetalle.EOF do
    begin
      NuevoComprobanteDetalle;
      qryDetalleDEUDAID.AsString := Facturas.qryDetalle.FieldByName('DEUDAID').AsString;
      qryDetalleCANTIDAD.Value := Facturas.qryDetalle.FieldByName('CANTIDAD').Value;
      qryDetalleDETALLE.AsString := Facturas.qryDetalle.FieldByName('DETALLE').AsString;
      qryDetallePRECIO_UNITARIO.AsFloat :=
        Facturas.qryDetalle.FieldByName('PRECIO_UNITARIO').AsFloat;
      qryDetalleTOTAL.Value :=
        Facturas.qryDetalle.FieldByName('CANTIDAD').Value *
        Facturas.qryDetalle.FieldByName('PRECIO_UNITARIO').AsFloat;
      Facturas.qryDetalle.Next;
    end;
  finally
    qryDetalle.AfterPost := @qryDetalleAfterPost;
  end;
  ActualizarTotales;
end;

procedure TReciboDataModule.GetImpuestos;
begin
  // tampoco hace falta, todavia...
end;

procedure TReciboDataModule.NuevoComprobante(APagoID: string);
begin
  NuevoComprobante;
  qryCabeceraPAGOID.AsString := APagoID;
end;

procedure TReciboDataModule.qryCabeceraAfterScroll(DataSet: TDataSet);
begin
  qryDetalle.Close;
  qryCabeceraReport.Close;
  qryDetalleReport.Close;
  qryDetalle.ParamByName('RECIBOID').Value := DataSet.FieldByName('ID').Value;
  qryCabeceraReport.ParamByName('ID').Value := DataSet.FieldByName('ID').Value;
  qryDetalleReport.ParamByName('ID').Value := DataSet.FieldByName('ID').Value;
  qryCabeceraReport.Open;
  qryDetalleReport.Open;
  qryDetalle.Open;
end;

procedure TReciboDataModule.qryDetalleAfterInsert(DataSet: TDataSet);
begin
  inherited qryDetalleAfterInsert(DataSet);
  DataSet.FieldByName('RECIBOID').AsString := qryCabeceraID.AsString;
end;

end.
