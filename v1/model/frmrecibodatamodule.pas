unit frmrecibodatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, sqldb, FileUtil, LR_DBSet, LR_Class, Forms, Controls,
  Graphics, Dialogs, XMLPropStorage, frmcomprobantedatamodule;

type

  { TReciboDataModule }

  TReciboDataModule = class(TComprobanteDataModule)
  published
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
    procedure ActualizarTotales; override;
    procedure DeterminarImpuesto; override;
    procedure GetImpuestos; override;
    procedure qryCabeceraAfterScroll(DataSet: TDataSet); override;
    procedure SetNumero; override;
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

procedure TReciboDataModule.ActualizarTotales;
begin

end;

procedure TReciboDataModule.DeterminarImpuesto;
begin

end;

procedure TReciboDataModule.GetImpuestos;
begin

end;

procedure TReciboDataModule.qryCabeceraAfterScroll(DataSet: TDataSet);
begin

end;

end.

