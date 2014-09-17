unit frmfacturadatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, DB, FileUtil, frmsgcddatamodule, frmquerydatamodule,
  mvc;

resourcestring
  rsCabeceraGenName = 'SEQ_FACTURA';
  rsDetalleGenName = 'SEQ_FACTURA_DETALLE';

type

  { TFacturaDataModule }

  TFacturaDataModule = class(TQueryDataModule, IModel)
    NumeroFactura: TSQLQuery;
  private
    FFactura: integer;
    FIDTalonario: integer;
    procedure SetFactura(AValue: integer);
    procedure SetIDTalonario(AValue: integer);
  published
    CabeceraCONTADO: TSmallintField;
    CabeceraDIRECCION: TStringField;
    CabeceraFECHA_EMISION: TDateField;
    CabeceraID: TLongintField;
    CabeceraIVA10: TFloatField;
    CabeceraIVA5: TFloatField;
    CabeceraIVA_TOTAL: TFloatField;
    CabeceraNOMBRE: TStringField;
    CabeceraNOTA_REMISION: TStringField;
    CabeceraNUMERO: TLongintField;
    CabeceraPERSONAID: TLongintField;
    CabeceraRUC: TStringField;
    CabeceraSUBTOTAL_EXENTAS: TFloatField;
    CabeceraSUBTOTAL_IVA10: TFloatField;
    CabeceraSUBTOTAL_IVA5: TFloatField;
    CabeceraTALONARIOID: TLongintField;
    CabeceraTELEFONO: TStringField;
    CabeceraTOTAL: TFloatField;
    CabeceraVENCIMIENTO: TDateField;
    DetalleCANTIDAD: TLongintField;
    DetalleDETALLE: TStringField;
    DetalleDEUDAID: TLongintField;
    DetalleEXENTA: TFloatField;
    DetalleFACTURAID: TLongintField;
    DetalleID: TLongintField;
    DetalleIVA10: TFloatField;
    DetalleIVA5: TFloatField;
    DetallePRECIO_UNITARIO: TFloatField;
    DsTalonario: TDataSource;
    DsDetalle: TDataSource;
    DsCabecera: TDataSource;
    Cabecera: TSQLQuery;
    Detalle: TSQLQuery;
    StringField1: TStringField;
    TalonarioACTIVO: TSmallintField;
    TalonarioCAJA: TStringField;
    TalonarioCOPIAS: TLongintField;
    TalonarioDIRECCION: TStringField;
    TalonarioID: TLongintField;
    TalonarioNOMBRE: TStringField;
    TalonarioNUMERO_FIN: TLongintField;
    TalonarioNUMERO_INI: TLongintField;
    TalonarioRUBRO: TStringField;
    TalonarioRUC: TStringField;
    TalonarioSUCURSAL: TStringField;
    TalonarioTELEFONO: TStringField;
    TalonarioTIMBRADO: TStringField;
    TalonarioTIPO: TLongintField;
    TalonarioVALIDO_DESDE: TDateField;
    TalonarioVALIDO_HASTA: TDateField;
    TipoTalonario: TSQLQuery;
    Talonario: TSQLQuery;
    TipoTalonarioOBJETO: TStringField;
    TipoTalonarioSIGNIFICADO: TStringField;
    TipoTalonarioVALOR: TLongintField;
    procedure ActualizarTotal(Sender: IController);
    procedure Connect; override;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DetalleAfterInsert(DataSet: TDataSet);
    procedure DetalleNewRecord(DataSet: TDataSet);
    procedure Disconnect; override;
    property IDTalonario: integer read FIDTalonario write SetIDTalonario;
    property Factura: integer read FFactura write SetFactura;
  end;

var
  FacturaDataModule: TFacturaDataModule;

implementation

{$R *.lfm}

{ TFacturaDataModule }

procedure TFacturaDataModule.SetFactura(AValue: integer);
begin
  if FFactura = AValue then
    Exit;
  FFactura := AValue;
end;

procedure TFacturaDataModule.SetIDTalonario(AValue: integer);
begin
  if FIDTalonario = AValue then
    Exit;
  FIDTalonario := AValue;
end;

procedure TFacturaDataModule.ActualizarTotal(Sender: IController);
begin

end;


procedure TFacturaDataModule.Connect;
begin
  inherited Connect;
  TipoTalonario.Open;
  Talonario.Open;
end;

procedure TFacturaDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited DataModuleCreate(Sender);
  QryList.Add(Cabecera);
  QryList.Add(Detalle);
end;

procedure TFacturaDataModule.DetalleAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('FACTURAID').AsInteger := Cabecera.FieldByName('ID').AsInteger;
end;

procedure TFacturaDataModule.DetalleNewRecord(DataSet: TDataSet);
begin
  DetalleID.AsInteger := FMasterDataModule.NextValue(rsDetalleGenName);
  DetalleFACTURAID.AsInteger := Factura;
  DetalleDETALLE.AsString := '';
  DetalleCANTIDAD.AsInteger := 0;
  DetalleEXENTA.AsFloat := 0;
  DetalleIVA5.AsFloat := 0;
  DetalleIVA10.AsFloat := 0;
end;

procedure TFacturaDataModule.Disconnect;
begin
  Talonario.Close;
  TipoTalonario.Close;
  inherited Disconnect;
end;

end.
