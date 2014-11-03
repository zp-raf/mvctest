unit frmNotaCreditoDataModule;

{$mode objfpc}{$H+}

interface

uses
  frmcomprobantedatamodule, LR_DBSet, LR_Class, DB, sqldb,
  frmfacturadatamodule2, Classes, sgcdTypes;

resourcestring
  GEN_NOTA_CREDITO = 'SEQ_NOTA_CREDITO';
  GEN_NOTA_CREDITO_DETALLE = 'SEQ_NOTA_CREDITO_DETALLE';

const
  TALONARIO_NC = '16';

type

  { TNotaCreditoDataModule }

  TNotaCreditoDataModule = class(TComprobanteDataModule)
  private
    FIVA10Codigo: string;
    FIVA5Codigo: string;
    procedure SetIVA10Codigo(AValue: string);
    procedure SetIVA5Codigo(AValue: string);
  published
    qryCabeceraDIRECCION: TStringField;
    qryCabeceraFACTURAID: TLongintField;
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
    qryDetalleCANTIDAD: TLongintField;
    qryDetalleCONTRA_FACTURA: TLongintField;
    qryDetalleDETALLE: TStringField;
    qryDetalleDEUDAID: TLongintField;
    qryDetalleEXENTA: TFloatField;
    qryDetalleID: TLongintField;
    qryDetalleIVA10: TFloatField;
    qryDetalleIVA5: TFloatField;
    qryDetalleNOTACREDITOID: TLongintField;
    qryDetallePRECIO_UNITARIO: TFloatField;
    procedure ActualizarTotales; override;
    procedure DataModuleCreate(Sender: TObject);
    procedure DeterminarImpuesto; override;
    procedure GetImpuestos; override;
    procedure qryCabeceraAfterScroll(DataSet: TDataSet); override;
    property IVA10Codigo: string read FIVA10Codigo write SetIVA10Codigo;
    property IVA5Codigo: string read FIVA5Codigo write SetIVA5Codigo;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  NotaCreditoDataModule: TNotaCreditoDataModule;
  i5fac, i10fac: double;

implementation

{$R *.lfm}

{ TNotaCreditoDataModule }


procedure TNotaCreditoDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  CabeceraGenName := GEN_NOTA_CREDITO;
  DetalleGenName := GEN_NOTA_CREDITO_DETALLE;
  // ??? = sacar esta asingancion cuando se haga por otro metodo mas flexible
  TalonarioID := TALONARIO_NC;
  tal.ParamByName('tipocomprobante').AsString := NOTA_CREDITO;
  tal.ParamByName('talonarioid').AsString := TalonarioID;
  IVA10Codigo := IVA10;
  IVA5Codigo := IVA5;
end;

procedure TNotaCreditoDataModule.SetIVA10Codigo(AValue: string);
begin
  if FIVA10Codigo=AValue then Exit;
  FIVA10Codigo:=AValue;
end;

procedure TNotaCreditoDataModule.SetIVA5Codigo(AValue: string);
begin
  if FIVA5Codigo=AValue then Exit;
  FIVA5Codigo:=AValue;
end;

procedure TNotaCreditoDataModule.ActualizarTotales;
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

procedure TNotaCreditoDataModule.DeterminarImpuesto;
begin
  // no hace falta
end;

procedure TNotaCreditoDataModule.GetImpuestos;
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

procedure TNotaCreditoDataModule.qryCabeceraAfterScroll(DataSet: TDataSet);
begin

end;

end.

