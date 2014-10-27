unit frmrecibodatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, sqldb, FileUtil, LR_DBSet, LR_Class, Forms, Controls,
  Graphics, Dialogs, XMLPropStorage, frmcomprobantedatamodule;

type

  { TReciboDataModule }

  TReciboDataModule = class(TComprobanteDataModule)
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
    qryCabeceraTOTAL: TFloatField;
    qryDetalleCANTIDAD: TLongintField;
    qryDetalleDETALLE: TStringField;
    qryDetalleDEUDAID: TLongintField;
    qryDetalleID: TLongintField;
    qryDetallePRECIO_UNITARIO: TFloatField;
    qryDetalleRECIBOID: TLongintField;
    qryDetalleTOTAL: TFloatField;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ReciboDataModule: TReciboDataModule;

implementation

{$R *.lfm}

end.

