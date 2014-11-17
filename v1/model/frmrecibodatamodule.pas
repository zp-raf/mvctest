unit frmrecibodatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, sqldb, FileUtil, LR_DBSet, LR_Class, Forms, Controls,
  Graphics, Dialogs, XMLPropStorage, frmcomprobantedatamodule, sgcdTypes,
  frmfacturadatamodule2;

resourcestring
  rsReciboGenName = 'SEQ_RECIBO';
  rsReciboDetGenName = 'SEQ_RECIBO_DETALLE';

const
  TALONARIO_RE = '15';

type

  { TReciboDataModule }

  TReciboDataModule = class(TComprobanteDataModule)
    DateField1: TDateField;
    DateField2: TDateField;
    qryCabeceraVALIDO: TSmallintField;
    StringField2: TStringField;
    StringField3: TStringField;
  private
    FFacturas: TFacturasDataModule;
    procedure SetFacturas(AValue: TFacturasDataModule);
  published
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
    procedure ActualizarTotales;
      override;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DeterminarImpuesto; override;
    procedure FetchCabeceraFactura(AFacturaID: string);
    procedure FetchCabeceraFactura;
    procedure FetchDetalleFactura;
    procedure FetchDetalleFactura(AFacturaID: string);
    procedure GetImpuestos; override;
    procedure NuevoComprobante(APagoID: string); overload;
    procedure qryCabeceraAfterScroll(DataSet: TDataSet); override;
    procedure qryDetalleAfterInsert(DataSet: TDataSet); override;
    procedure SetNumero; override;
    property Facturas: TFacturasDataModule read FFacturas write SetFacturas;
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
  dsFacturas.DataSet := FFacturas.qryCabecera;
  SetTipoComprobante(doRecibo);
  CabeceraGenName := rsReciboGenName;
  DetalleGenName := rsReciboDetGenName;
  TalonarioID := TALONARIO_RE;
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

procedure TReciboDataModule.DeterminarImpuesto;
begin
  // no hace falta, todavia...
end;

procedure TReciboDataModule.FetchCabeceraFactura(AFacturaID: string);
begin
  Facturas.LocateComprobante(AFacturaID);
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
  FetchCabeceraFactura(FFacturas.qryCabeceraID.AsString);
end;

procedure TReciboDataModule.FetchDetalleFactura;
begin
  FetchDetalleFactura(FFacturas.qryCabeceraID.AsString);
end;

procedure TReciboDataModule.FetchDetalleFactura(AFacturaID: string);
begin
  Facturas.qryDetalle.First;
  while not Facturas.qryDetalle.EOF do
  begin
    NuevoComprobanteDetalle;
    qryDetalleDEUDAID.Value := Facturas.qryDetalle.FieldByName('DEUDAID').Value;
    qryDetalleCANTIDAD.Value := Facturas.qryDetalle.FieldByName('CANTIDAD').Value;
    qryDetalleDETALLE.Value := Facturas.qryDetalle.FieldByName('DETALLE').Value;
    qryDetallePRECIO_UNITARIO.AsFloat :=
      Facturas.qryDetalle.FieldByName('PRECIO_UNITARIO').AsFloat;
    qryDetalleTOTAL.AsFloat :=
      qryDetalleCANTIDAD.AsFloat * qryDetallePRECIO_UNITARIO.AsFloat;
    Facturas.qryDetalle.Next;
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
  qryDetalle.ParamByName('RECIBOID').Value := DataSet.FieldByName('ID').Value;
  qryDetalle.Open;
end;

procedure TReciboDataModule.qryDetalleAfterInsert(DataSet: TDataSet);
begin
  inherited qryDetalleAfterInsert(DataSet);
  DataSet.FieldByName('RECIBOID').AsString := qryCabeceraID.AsString;
end;

end.
