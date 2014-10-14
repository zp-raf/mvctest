unit frmpagodatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, DB, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmquerydatamodule, frmsgcddatamodule;

const
  CREDITO = '1';
  DEBITO = '2';
  FACTURA = '1';
  RECIBO = '2';
  NOTA_CREDITO = '3';
  EFECTIVO = '1';
  CHEQUE = '2';
  TARJETA_DEBITO = '3';
  TARJETA_CREDITO = '4';
  ITEM_SEPARATOR = ', ';

resourcestring
  rsGenPago = 'GENERATOR_PAGO';
  rsGenPagoDet = 'GENERATOR_PAGO_DETALLE';

type

  { TPagoDataModule }

  TPagoDataModule = class(TQueryDataModule)
    dsCheques: TDataSource;
    dsTarjetas: TDataSource;
    dsPago: TDataSource;
    dsPagoDet: TDataSource;
    Pago: TSQLQuery;
    PagoCHEQUES: TFloatField;
    PagoDESCRIPCION: TStringField;
    PagoDet: TSQLQuery;
    PagoDetCOMPROBANTE_TARJETA: TStringField;
    PagoDetEMISOR_CHEQUE: TStringField;
    PagoDetEMISOR_TARJETA: TStringField;
    PagoDetID: TLongintField;
    PagoDetMONTO: TFloatField;
    PagoDetNRO_CHEQUE: TStringField;
    PagoDetNRO_TARJETA: TStringField;
    PagoDetPAGOID: TLongintField;
    PagoDetTIPO_PAGO: TLongintField;
    PagoEFECTIVO: TFloatField;
    PagoESCOBRO: TSmallintField;
    PagoFACTURACOMPRAID: TLongintField;
    PagoFACTURAID: TLongintField;
    PagoFECHA: TDateField;
    PagoHORA: TTimeField;
    PagoID: TLongintField;
    PagoMONTO: TFloatField;
    PagoMOVIMIENTOID: TLongintField;
    PagoNOTA_CREDITOCOMPRAID: TLongintField;
    PagoNOTA_CREDITOID: TLongintField;
    PagoRECIBOCOMPRAID: TLongintField;
    PagoRECIBOID: TLongintField;
    PagoTARJETAS: TFloatField;
    PagoTIPO_MOVIMIENTO: TLongintField;
    PagoTOTALPAGADO: TFloatField;
    PagoVALIDO: TSmallintField;
    PagoVUELTO: TFloatField;
    PagoDetCheques: TSQLQuery;
    PagoDetTarjetas: TSQLQuery;
    procedure ActualizarTotales;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure NuevoPago(EsCobro: boolean);
    procedure PagoAfterScroll(DataSet: TDataSet);
    procedure PagoDetAfterInsert(DataSet: TDataSet);
    procedure PagoDetChequesAfterInsert(DataSet: TDataSet);
    procedure PagoDetTarjetasAfterInsert(DataSet: TDataSet);
    procedure PagoNewRecord(DataSet: TDataSet);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  PagoDataModule: TPagoDataModule;

implementation

{$R *.lfm}

{ TPagoDataModule }

procedure TPagoDataModule.ActualizarTotales;
begin
  //try
  //  //qryDetCh.Refresh;
  //  qryCabeceraCHEQUES.AsFloat := 0;
  //  qryDetCh.First;
  //  while not qryDetCh.EOF do
  //  begin
  //    qryCabeceraCHEQUES.AsFloat := qryCabeceraCHEQUES.AsFloat + qryDetChMONTO.AsFloat;
  //    qryDetCh.Next;
  //  end;
  //  //qryDetTa.Refresh;
  //  qryCabeceraTARJETAS.AsFloat := 0;
  //  qryDetTa.First;
  //  while not qryDetTa.EOF do
  //  begin
  //    qryCabeceraTARJETAS.AsFloat := qryCabeceraTARJETAS.AsFloat + qryDetTaMONTO.AsFloat;
  //    qryDetTa.Next;
  //  end;
  //  qryCabeceraTOTALPAGADO.AsFloat := 0;
  //  qryCabeceraTOTALPAGADO.AsFloat :=
  //    qryCabeceraEFECTIVO.AsFloat + qryCabeceraCHEQUES.AsFloat +
  //    qryCabeceraTARJETAS.AsFloat;
  //  if qryCabeceraTOTALPAGADO.AsFloat > qryCabeceraMONTO.AsFloat then
  //    qryCabeceraVUELTO.AsFloat :=
  //      qryCabeceraTOTALPAGADO.AsFloat - qryCabeceraMONTO.AsFloat
  //  else
  //    qryCabeceraVUELTO.AsFloat := 0;
  //except
  //  on e: EDatabaseError do
  //  begin
  //    ManejoErrores(e);
  //    AbrirCursor;
  //  end;
  //end;
end;

procedure TPagoDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  QryList.Add(TObject(Pago));
  QryList.Add(TObject(PagoDet));
  QryList.Add(TObject(PagoDetCheques));
  QryList.Add(TObject(PagoDetTarjetas));
  PagoDetCheques.ParamByName('TIPO_PAGO').AsString := CHEQUE;
  PagoDetCheques.ParamByName('TIPO_PAGO').Bound := True;
  PagoDetTarjetas.ParamByName('TIPO_PAGO1').AsString := TARJETA_DEBITO;
  PagoDetTarjetas.ParamByName('TIPO_PAGO1').Bound := True;
  PagoDetTarjetas.ParamByName('TIPO_PAGO2').AsString := TARJETA_CREDITO;
  PagoDetTarjetas.ParamByName('TIPO_PAGO2').Bound := True;
end;

procedure TPagoDataModule.NuevoPago(EsCobro: boolean);
begin

end;

procedure TPagoDataModule.PagoAfterScroll(DataSet: TDataSet);
begin
  PagoDet.Close;
  PagoDet.ParamByName('ID').Value := Pago.FieldByName('ID').Value;
  PagoDet.Open;
end;

procedure TPagoDataModule.PagoDetAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenPagoDet);
  DataSet.FieldByName('PAGOID').Value := Pago.FieldByName('ID').Value;
end;

procedure TPagoDataModule.PagoDetChequesAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenPagoDet);
  DataSet.FieldByName('PAGOID').Value := Pago.FieldByName('ID').Value;
end;

procedure TPagoDataModule.PagoDetTarjetasAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenPagoDet);
  DataSet.FieldByName('PAGOID').Value := Pago.FieldByName('ID').Value;
end;

procedure TPagoDataModule.PagoNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenPago);

  DataSet.FieldByName('FECHA').AsDateTime := Now;
  DataSet.FieldByName('HORA').AsDateTime := Now;

  DataSet.FieldByName('VALIDO').AsInteger := 1;

  DataSet.FieldByName('EFECTIVO').AsFloat := 0;
  DataSet.FieldByName('CHEQUES').AsFloat := 0;
  DataSet.FieldByName('TARJETAS').AsFloat := 0;
  DataSet.FieldByName('TOTALPAGADO').AsFloat := 0;
  DataSet.FieldByName('VUELTO').AsFloat := 0;

  DataSet.FieldByName('ESCOBRO').AsInteger := 1;
end;

end.
