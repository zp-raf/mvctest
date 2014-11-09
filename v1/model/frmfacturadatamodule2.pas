unit frmfacturadatamodule2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, sqldb, FileUtil, LR_Class, LR_DBSet, Forms, Controls,
  Graphics, Dialogs, frmsgcddatamodule, frmcomprobantedatamodule, sgcdTypes;

resourcestring
  rsGenFacturaID = 'SEQ_FACTURA';
  rsGenFacturaDetalleID = 'SEQ_FACTURA_DETALLE';

const
  //mientras tanto pongo aca el id del talonario
  TALONARIO = '1';

type

  TCodigos = TStringList;

  { TFacturasDataModule }

  TFacturasDataModule = class(TComprobanteDataModule)
  private
    FIVA10Codigo: string;
    FIVA5Codigo: string;
    procedure SetIVA10Codigo(AValue: string);
    procedure SetIVA5Codigo(AValue: string);
  published
    qryCabeceraCONTADO: TSmallintField;
    qryCabeceraDIRECCION: TStringField;
    qryCabeceraFECHA_EMISION: TDateField;
    qryCabeceraID: TLongintField;
    qryCabeceraIVA10: TFloatField;
    qryCabeceraIVA5: TFloatField;
    qryCabeceraIVA_TOTAL: TFloatField;
    qryCabeceraNOMBRE: TStringField;
    qryCabeceraNOTA_REMISION: TStringField;
    qryCabeceraNUMERO: TLongintField;
    qryCabeceraPERSONAID: TLongintField;
    qryCabeceraRUC: TStringField;
    qryCabeceraSUBTOTAL_EXENTAS: TFloatField;
    qryCabeceraSUBTOTAL_IVA10: TFloatField;
    qryCabeceraSUBTOTAL_IVA5: TFloatField;
    qryCabeceraTALONARIOID: TLongintField;
    qryCabeceraTELEFONO: TStringField;
    qryCabeceraTOTAL: TFloatField;
    qryCabeceraVALIDO: TSmallintField;
    qryCabeceraVENCIMIENTO: TDateField;
    qryDetalleCANTIDAD: TLongintField;
    qryDetalleDETALLE: TStringField;
    qryDetalleDEUDAID: TLongintField;
    qryDetalleEXENTA: TFloatField;
    qryDetalleFACTURAID: TLongintField;
    qryDetalleID: TLongintField;
    qryDetalleIVA10: TFloatField;
    qryDetalleIVA5: TFloatField;
    qryDetallePRECIO_UNITARIO: TFloatField;
    procedure ActualizarTotales; override;
    procedure AnularFactura(AID: string);
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DeterminarImpuesto; override;
    procedure FetchCabeceraPersona(APersonaID: string); override; overload;
    procedure GetImpuestos; override;
    procedure qryCabeceraAfterScroll(DataSet: TDataSet); override;
    procedure qryCabeceraNewRecord(DataSet: TDataSet); override;
    procedure qryDetalleAfterInsert(DataSet: TDataSet); override;
    procedure qryDetallePRECIO_UNITARIOChange(Sender: TField);
    procedure SetNumero; override;
    property IVA10Codigo: string read FIVA10Codigo write SetIVA10Codigo;
    property IVA5Codigo: string read FIVA5Codigo write SetIVA5Codigo;
  end;

var
  FacturasDataModule: TFacturasDataModule;
  i5fac, i10fac: double;

implementation

{$R *.lfm}

{ TFacturasDataModule }

procedure TFacturasDataModule.SetIVA10Codigo(AValue: string);
begin
  if FIVA10Codigo = AValue then
    Exit;
  FIVA10Codigo := AValue;
end;

procedure TFacturasDataModule.SetIVA5Codigo(AValue: string);
begin
  if FIVA5Codigo = AValue then
    Exit;
  FIVA5Codigo := AValue;
end;

procedure TFacturasDataModule.ActualizarTotales;
begin
  if not (qryCabecera.State in [dsEdit, dsInsert]) then
    qryCabecera.Edit;
  qryCabeceraIVA5.AsFloat := 0;
  qryCabeceraIVA10.AsFloat := 0;
  qryCabeceraIVA_TOTAL.AsFloat := 0;
  qryCabeceraSUBTOTAL_EXENTAS.AsFloat := 0;
  qryCabeceraSUBTOTAL_IVA5.AsFloat := 0;
  qryCabeceraSUBTOTAL_IVA10.AsFloat := 0;
  qryCabeceraTOTAL.AsFloat := 0;
  qryDetalle.First;
  while not qryDetalle.EOF do
  begin
    // subtotales
    qryCabeceraSUBTOTAL_EXENTAS.AsFloat :=
      qryCabeceraSUBTOTAL_EXENTAS.AsFloat + qryDetalleEXENTA.AsFloat;
    qryCabeceraSUBTOTAL_IVA5.AsFloat :=
      qryCabeceraSUBTOTAL_IVA5.AsFloat + qryDetalleIVA5.AsFloat;
    qryCabeceraSUBTOTAL_IVA10.AsFloat :=
      qryCabeceraSUBTOTAL_IVA10.AsFloat + qryDetalleIVA10.AsFloat;
    qryDetalle.Next;
  end;
  // totales iva
  qryCabeceraIVA5.AsFloat := Round((qryCabeceraSUBTOTAL_IVA5.AsFloat * I5Fac) /
    (1 + I5Fac));
  qryCabeceraIVA10.AsFloat :=
    Round((qryCabeceraSUBTOTAL_IVA10.AsFloat * I10Fac) / (1 + I10Fac));
  // sumatoria de iva5 e iva10
  qryCabeceraIVA_TOTAL.AsFloat :=
    qryCabeceraIVA_TOTAL.AsFloat + qryCabeceraIVA10.AsFloat + qryCabeceraIVA5.AsFloat;
  // gran total
  qryCabeceraTOTAL.AsFloat :=
    qryCabeceraTOTAL.AsFloat + qryCabeceraSUBTOTAL_EXENTAS.AsFloat +
    qryCabeceraSUBTOTAL_IVA5.AsFloat + qryCabeceraSUBTOTAL_IVA10.AsFloat;
end;

procedure TFacturasDataModule.AnularFactura(AID: string);
begin
  try
    LocateComprobante(AID);
    if qryCabeceraVALIDO.AsString = DB_FALSE then
      raise Exception.Create('La factura ya esta anulada');
    qryCabecera.Edit;
    qryCabeceraVALIDO.AsString := DB_FALSE;
    SaveChanges;
    Estado := asGuardado;
  except
    on E: EDatabaseError do
    begin
      DoOnErrorEvent(Self, E);
    end;
  end;
end;

procedure TFacturasDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited DataModuleCreate(Sender);
  // dsPersonasRoles.DataSet := Personas.PersonasRoles;
  SetTipoComprobante(doFactura);
  CabeceraGenName := rsGenFacturaID;
  DetalleGenName := rsGenFacturaDetalleID;
  TalonarioID := TALONARIO;
  IVA10Codigo := IVA10;
  IVA5Codigo := IVA5;
end;

procedure TFacturasDataModule.DeterminarImpuesto;
begin
  case ImpuestoViewIMP_ID.AsString of
    IVA10:
    begin
      qryDetalleIVA10.AsFloat :=
        qryDetalleCANTIDAD.AsFloat * qryDetallePRECIO_UNITARIO.AsFloat;
    end;
    IVA5:
    begin
      qryDetalleIVA5.AsFloat :=
        qryDetalleCANTIDAD.AsFloat * qryDetallePRECIO_UNITARIO.AsFloat;
    end;
    else
    begin
      qryDetalleEXENTA.AsFloat :=
        qryDetalleCANTIDAD.AsFloat * qryDetallePRECIO_UNITARIO.AsFloat;
    end;
  end;
end;

procedure TFacturasDataModule.FetchCabeceraPersona(APersonaID: string);
begin
  inherited FetchCabeceraPersona(APersonaID);
  if Personas.PersonaRUC.IsNull then
    qryCabeceraRUC.AsString := Personas.PersonaCEDULA.AsString
  else
    qryCabeceraRUC.AsString := Personas.PersonaRUC.AsString;
end;

procedure TFacturasDataModule.GetImpuestos;
begin
  if (Impuesto.Lookup('ID', IVA10, 'FACTOR') = null) or
    (Impuesto.Lookup('ID', IVA5, 'FACTOR') = null) then
    raise Exception.Create('Impuestos no encontrados')
  else
  begin
    I10Fac := Impuesto.Lookup('ID', IVA10, 'FACTOR');
    I5Fac := Impuesto.Lookup('ID', IVA5, 'FACTOR');
  end;
end;

procedure TFacturasDataModule.qryCabeceraAfterScroll(DataSet: TDataSet);
begin
  qryDetalle.Close;
  qryDetalle.ParamByName('FACTURAID').Value := DataSet.FieldByName('ID').Value;
  qryDetalle.Open;
end;

procedure TFacturasDataModule.qryCabeceraNewRecord(DataSet: TDataSet);
begin
  inherited qryCabeceraNewRecord(DataSet);
  DataSet.FieldByName('IVA5').AsFloat := 0;
  DataSet.FieldByName('IVA10').AsFloat := 0;
  DataSet.FieldByName('IVA_TOTAL').AsFloat := 0;
  DataSet.FieldByName('SUBTOTAL_EXENTAS').AsFloat := 0;
  DataSet.FieldByName('SUBTOTAL_IVA5').AsFloat := 0;
  DataSet.FieldByName('SUBTOTAL_IVA10').AsFloat := 0;
end;

procedure TFacturasDataModule.qryDetalleAfterInsert(DataSet: TDataSet);
begin
  inherited qryDetalleAfterInsert(DataSet);
  DataSet.FieldByName('FACTURAID').AsInteger := qryCabeceraID.AsInteger;
  DataSet.FieldByName('IVA5').AsFloat := 0;
  DataSet.FieldByName('IVA10').AsFloat := 0;
  DataSet.FieldByName('EXENTA').AsFloat := 0;
end;

procedure TFacturasDataModule.qryDetallePRECIO_UNITARIOChange(Sender: TField);
var
  montoMaximo: double;
begin
  try
    montoMaximo := DeudaView.Lookup('ID', qryDetalleDEUDAID.Value, 'MONTO_DEUDA') -
      DeudaView.Lookup('ID', qryDetalleDEUDAID.Value, 'MONTO_FACTURADO');
  except
    on E: EDatabaseError do
    begin
      Abort;
    end;
  end;

  if Sender.AsFloat > montoMaximo then
    Sender.AsFloat := montoMaximo;

  // iva 10
  if (qryDetalleIVA10.AsFloat = 0) or qryDetalleIVA10.IsNull then
    Exit
  else
    qryDetalleIVA10.AsFloat :=
      qryDetalleCANTIDAD.AsFloat * qryDetallePRECIO_UNITARIO.AsFloat;
  // iva 5
  if (qryDetalleIVA5.AsFloat = 0) or qryDetalleIVA5.IsNull then
    Exit
  else
    qryDetalleIVA5.AsFloat :=
      qryDetalleCANTIDAD.AsFloat * qryDetallePRECIO_UNITARIO.AsFloat;
  // exenta
  if (qryDetalleEXENTA.AsFloat = 0) or qryDetalleEXENTA.IsNull then
    Exit
  else
    qryDetalleEXENTA.AsFloat :=
      qryDetalleCANTIDAD.AsFloat * qryDetallePRECIO_UNITARIO.AsFloat;
end;

procedure TFacturasDataModule.SetNumero;
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

end.
