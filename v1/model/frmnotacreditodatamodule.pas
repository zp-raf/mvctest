unit frmNotaCreditoDataModule;

{$mode objfpc}{$H+}

interface

uses
    frmcomprobantedatamodule, LR_DBSet, LR_Class, db, sqldb;

type

  { TNotaCreditoDataModule }

  TNotaCreditoDataModule = class(TComprobanteDataModule)
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
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  NotaCreditoDataModule: TNotaCreditoDataModule;

implementation

{$R *.lfm}

end.

