unit frmasientosdatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, DB, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmquerydatamodule, frmcuentadatamodule, sgcdTypes,
  observerSubject, mensajes;

resourcestring
  rsGenNameMov = 'GEN_MOVIMIENTO';
  rsGenNameMovDet = 'GEN_MOVIMIENTO_DET';

const
  DEBITO = 'D';
  CREDITO = 'C';
  DESCRIPCION_POR_DEFECTO = 'REVERSION DE ASIENTO - ';
  OPERACION_NULL = '';

type

  TTipoMovimiento = (mvCredito, mvDebito);

  TEstadoAsiento = (asInicial, asEditando, asGuardado);

  { TMovimientoRec }

  TMovimientoRec = record
    CuentaID: string;
    TipoMovimiento: TTipoMovimiento;
    Monto: double;
    Deuda: string;
    Pago: string;
  end;

  TMovimientoList = array of TMovimientoRec;

  { TAsientosDataModule }

  TAsientosDataModule = class(TQueryDataModule)

  private
    FComprobarAsiento: boolean;
    FCuenta: TCuentaDataModule;
    FEstado: TEstadoAsiento;
    procedure ResetearEstado;
    procedure SetComprobarAsiento(AValue: boolean);
  published
    dsMovimientoDetView: TDataSource;
    MovimientoDetViewCUENTAID: TLongintField;
    MovimientoDetViewDESCRIPCION: TStringField;
    MovimientoDetViewDET_DEUDAID: TLongintField;
    MovimientoDetViewDET_ID: TLongintField;
    MovimientoDetViewDET_NUMERO: TLongintField;
    MovimientoDetViewDET_PAGOID: TLongintField;
    MovimientoDetViewDEUDAID: TLongintField;
    MovimientoDetViewFECHA: TDateField;
    MovimientoDetViewID: TLongintField;
    MovimientoDetViewMONTO: TFloatField;
    MovimientoDetViewMOVIMIENTOID: TLongintField;
    MovimientoDetViewNUMERO: TLongintField;
    MovimientoDetViewPAGOID: TLongintField;
    MovimientoDetViewTIPO_MOVIMIENTO: TStringField;
    MovimientoDOCUMENTOID: TLongintField;
    MovimientoTIPO_DOCUMENTO: TLongintField;
    dsMovimiento: TDataSource;
    dsMovimientoDet: TDataSource;
    Movimiento: TSQLQuery;
    MovimientoDESCRIPCION: TStringField;
    MovimientoDet: TSQLQuery;
    MovimientoDetCUENTAID: TLongintField;
    MovimientoDetDEUDAID: TLongintField;
    MovimientoDetID: TLongintField;
    MovimientoDetMONTO: TFloatField;
    MovimientoDetMOVIMIENTOID: TLongintField;
    MovimientoDetPAGOID: TLongintField;
    MovimientoDetTIPO_MOVIMIENTO: TStringField;
    MovimientoDEUDAID: TLongintField;
    MovimientoFECHA: TDateField;
    MovimientoID: TLongintField;
    MovimientoNUMERO: TLongintField;
    MovimientoPAGOID: TLongintField;
    MovimientoDetView: TSQLQuery;
    dsCuenta: TDataSource;
    qryAsientosCUENTA_DEBE: TLongintField;
    qryAsientosCUENTA_HABER: TLongintField;
    qryAsientosNOMBRE_CUENTA_DEBE: TStringField;
    qryAsientosNOMBRE_CUENTA_HABER: TStringField;
    qryAsientosDESCRIPCION: TStringField;
    qryAsientosFECHA: TDateField;
    qryAsientosID: TLongintField;
    qryAsientosMONTO_DEBE: TFloatField;
    qryAsientosMONTO_HABER: TFloatField;
    qryAsientosMOVIMIENTOID: TLongintField;
    qryAsientosNUMERO: TLongintField;
    procedure CerrarAsiento;
    procedure CheckAsiento;
    procedure Connect; override;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure Disconnect; override;
    procedure DataModuleDestroy(Sender: TObject);
    procedure MovimientoAfterScroll(DataSet: TDataSet);
    procedure MovimientoDetAfterInsert(DataSet: TDataSet);
    procedure MovimientoNewRecord(DataSet: TDataSet);
    procedure NuevoAsiento(ADescripcion: string);
    procedure NuevoAsiento(ADescripcion: string; ATipoDoc: TTipoDocumento;
      ADocID: string);
    procedure NuevoAsiento(ADescripcion: string; ADeudaID: string; APagoID: string);
    procedure NuevoAsientoDetalle(ACuenta: string; ATipoMov: TTipoMovimiento;
      AMonto: double);
    procedure NuevoAsientoDetalle(ACuenta: string; ATipoMov: TTipoMovimiento;
      AMonto: double; ADeudaID: string; APagoID: string);
    procedure NuevoAsientoDetalle(ATipoMov: TTipoMovimiento; AMonto: double);
    procedure OnAsientoError(Sender: TObject; E: EDatabaseError);
    // This procedure posts data without applying
    procedure PostAsiento;
    procedure RefreshDataSets; override;
    procedure ReversarAsiento(ADescripcion: string);
    procedure ReversarAsiento(AAsientoID: string; ADescripcion: string);
    procedure SaveChanges; override;

    { esta clase esta compuesta por tres subobjetos mas; dos para las cuentas
      y otro para los movimientos }
    property Cuenta: TCuentaDataModule read FCuenta write FCuenta;
    property Estado: TEstadoAsiento read FEstado write FEstado;
    property ComprobarAsiento: boolean read FComprobarAsiento write SetComprobarAsiento;
  end;

var
  AsientosDataModule: TAsientosDataModule;

implementation

{$R *.lfm}

{ TAsientosDataModule }

procedure TAsientosDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited DataModuleCreate(Sender);
  OnError := @OnAsientoError;
  QryList.Add(TObject(Movimiento));
  DetailList.Add(TObject(MovimientoDet));
  AuxQryList.Add(TObject(MovimientoDetView));
  //SearchFieldList.Add('DESCRIPCION');
  //SearchFieldList.Add('DEUDAID');
  //SearchFieldList.Add('PAGOID');
  Movimiento.OnFilterRecord := nil;
  Estado := asInicial;
  // modelo de cuentas
  FCuenta := TCuentaDataModule.Create(Self, MasterDataModule);
  // FCuenta.SetReadOnly(True);
  dsCuenta.DataSet := FCuenta.CuentasContables;
  ComprobarAsiento := True;
end;

procedure TAsientosDataModule.Disconnect;
begin
  FCuenta.Disconnect;
  inherited Disconnect;
end;

procedure TAsientosDataModule.NuevoAsiento(ADescripcion: string);
begin
  if not GetDBStatus.Connected then
    Connect;
  Movimiento.Open;
  MovimientoDet.Open;
  if (Estado in [asEditando]) then
    raise Exception.Create(rsNewEntryError);
  Movimiento.Append;
  MovimientoFECHA.AsDateTime := Now;
  MovimientoDESCRIPCION.AsString := ADescripcion;
  Estado := asEditando;
  (MasterDataModule as ISubject).Notify;
end;

procedure TAsientosDataModule.NuevoAsiento(ADescripcion: string;
  ATipoDoc: TTipoDocumento; ADocID: string);
begin
  NuevoAsiento(ADescripcion, '', '');
  case ATipoDoc of
    doFactura: Movimiento.FieldByName('TIPO_DOCUMENTO').AsString := FACTURA;
    doNotaCredito: Movimiento.FieldByName('TIPO_DOCUMENTO').AsString := NOTA_CREDITO;
    doRecibo: Movimiento.FieldByName('TIPO_DOCUMENTO').AsString := RECIBO;
  end;
  Movimiento.FieldByName('DOCUMENTOID').AsString := ADocID;
end;

procedure TAsientosDataModule.NuevoAsiento(ADescripcion: string;
  ADeudaID: string; APagoID: string);
begin
  NuevoAsiento(ADescripcion);
  if Trim(ADeudaID) = '' then
    MovimientoDEUDAID.Clear
  else
    MovimientoDEUDAID.AsString := ADeudaID;
  if Trim(APagoID) = '' then
    MovimientoPAGOID.Clear
  else
    MovimientoPAGOID.AsString := APagoID;
end;

procedure TAsientosDataModule.NuevoAsientoDetalle(ACuenta: string;
  ATipoMov: TTipoMovimiento; AMonto: double);
begin
  if (Estado in [asInicial, asGuardado]) then
    raise Exception.Create(rsNoEntryInProc);
  MovimientoDet.Append;
  MovimientoDetCUENTAID.AsString := ACuenta;
  MovimientoDetMONTO.AsFloat := AMonto;
  case ATipoMov of
    mvCredito: MovimientoDetTIPO_MOVIMIENTO.AsString := CREDITO;
    mvDebito: MovimientoDetTIPO_MOVIMIENTO.AsString := DEBITO;
  end;
  (MasterDataModule as ISubject).Notify;
end;

procedure TAsientosDataModule.NuevoAsientoDetalle(ACuenta: string;
  ATipoMov: TTipoMovimiento; AMonto: double; ADeudaID: string; APagoID: string);
begin
  NuevoAsientoDetalle(ACuenta, ATipoMov, AMonto);
  if Trim(ADeudaID) = '' then
    MovimientoDetDEUDAID.Clear
  else
    MovimientoDetDEUDAID.AsString := ADeudaID;
  if Trim(APagoID) = '' then
    MovimientoDetPAGOID.Clear
  else
    MovimientoDetPAGOID.AsString := APagoID;
end;

procedure TAsientosDataModule.NuevoAsientoDetalle(ATipoMov: TTipoMovimiento;
  AMonto: double);
begin
  NuevoAsientoDetalle(FCuenta.CuentaID.AsString, ATipoMov, AMonto);
end;

procedure TAsientosDataModule.OnAsientoError(Sender: TObject; E: EDatabaseError);
begin
  DiscardChanges;
  Rollback;
  ResetearEstado;
  (MasterDataModule as ISubject).Notify;
end;

procedure TAsientosDataModule.PostAsiento;
begin
  CheckAsiento;
  Movimiento.Post;
  MovimientoDet.Post;
  Estado := asGuardado;
end;

procedure TAsientosDataModule.MovimientoDetAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('MOVIMIENTOID').AsInteger :=
    Movimiento.FieldByName('ID').AsInteger;
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenNameMovDet);
end;

procedure TAsientosDataModule.DataModuleDestroy(Sender: TObject);
begin
  if Assigned(FCuenta) then
    FreeAndNil(FCuenta);
  inherited;
end;

procedure TAsientosDataModule.MovimientoAfterScroll(DataSet: TDataSet);
begin
  // chequeamos que no hay datos sin postear porque o si no el close nos borra todo
  if not MovimientoDet.Active then
    Exit;
  if MovimientoDet.UpdateStatus <> usUnmodified then
    Exit;
  try
    MovimientoDet.Close;
    MovimientoDet.ParamByName('ID').AsInteger := DataSet.FieldByName('ID').AsInteger;
  finally
    MovimientoDet.Open;
  end;
end;

procedure TAsientosDataModule.MovimientoNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenNameMov);
end;

procedure TAsientosDataModule.ResetearEstado;
begin
  Estado := asInicial;
  Connect;
  (MasterDataModule as ISubject).Notify;
end;

procedure TAsientosDataModule.SetComprobarAsiento(AValue: boolean);
begin
  if FComprobarAsiento = AValue then
    Exit;
  FComprobarAsiento := AValue;
end;

procedure TAsientosDataModule.CerrarAsiento;
begin
  CheckAsiento;
  Movimiento.ApplyUpdates;
  MovimientoDet.ApplyUpdates;
  Estado := asGuardado;
  (MasterDataModule as ISubject).Notify;
end;

procedure TAsientosDataModule.CheckAsiento;
var
  sumaDebe, sumaHaber: double;
begin
  if not (Estado in [asEditando]) then
    raise Exception.Create(rsNoEntryInProc);
  if ComprobarAsiento then
  begin
    sumaDebe := 0.0;
    sumaHaber := 0.0;
    // recorremos el dataset y vemos si se los montos cuadran
    MovimientoDet.First;
    while not MovimientoDet.EOF do
    begin
      case MovimientoDetTIPO_MOVIMIENTO.AsString of
        DEBITO: sumaDebe := sumaDebe + MovimientoDetMONTO.AsFloat;
        CREDITO: sumaHaber := sumaHaber + MovimientoDetMONTO.AsFloat;
      end;
      MovimientoDet.Next;
    end;

    if sumaDebe <> sumaHaber then
      raise Exception.Create(rsDebCredAmountSumError);
  end;
end;

procedure TAsientosDataModule.Connect;
begin
  FCuenta.Connect;
  inherited Connect;
end;

procedure TAsientosDataModule.RefreshDataSets;
begin
  FCuenta.RefreshDataSets;
  inherited RefreshDataSets;
end;

procedure TAsientosDataModule.ReversarAsiento(ADescripcion: string);
begin
  ReversarAsiento(MovimientoID.AsString, ADescripcion);
end;

procedure TAsientosDataModule.ReversarAsiento(AAsientoID: string; ADescripcion: string);
var
  PDescripcion: string;
  mov: TMovimientoList;
  x: integer;
begin
  // buscamos el asiento
  Movimiento.Open;
  MovimientoDet.Open;
  if not Movimiento.Locate('ID', AAsientoID, [loCaseInsensitive]) then
    raise Exception.Create(rsEntryNotFound);
  try
    // guardamos todos los movimientos en una lista para luego introducirlos
    // de nuevo pero en movimiento contrario
    // hay que ir hasta el ultimo registro para obtener el numero real de registros
    MovimientoDet.Last;
    SetLength(mov, MovimientoDet.RecordCount);
    MovimientoDet.First;
    x := 0;
    while not MovimientoDet.EOF do
    begin
      mov[x].CuentaID := MovimientoDet.FieldByName('CUENTAID').AsString;
      mov[x].Monto := MovimientoDet.FieldByName('MONTO').AsFloat;
      case MovimientoDet.FieldByName('TIPO_MOVIMIENTO').AsString of
        DEBITO:
          mov[x].TipoMovimiento := mvCredito; // movimiento contrario
        CREDITO:
          mov[x].TipoMovimiento := mvDebito; // movimiento contrario
      end;
      mov[x].Deuda := MovimientoDet.FieldByName('DEUDAID').AsString;
      mov[x].Pago := MovimientoDet.FieldByName('PAGOID').AsString;
      MovimientoDet.Next;
      Inc(x);
    end;
    // si no se metio una descripcion se usa la que esta por defecto
    if (Trim(ADescripcion) = '') then
      PDescripcion := DESCRIPCION_POR_DEFECTO +
        Movimiento.FieldByName('NUMERO').AsString + ' - ' +
        Movimiento.FieldByName('FECHA').AsString
    else
      PDescripcion := ADescripcion;
    // insertamos el asiento de reversion
    NuevoAsiento(PDescripcion, Movimiento.FieldByName('DEUDAID').AsString,
      Movimiento.FieldByName('PAGOID').AsString);
    for x := 0 to Length(mov) - 1 do
    begin
      NuevoAsientoDetalle(mov[x].CuentaID, mov[x].TipoMovimiento, mov[x].Monto,
        mov[x].Deuda, mov[x].Pago);
    end;
    //CerrarAsiento;
  finally
    (MasterDataModule as ISubject).Notify;
  end;
end;

procedure TAsientosDataModule.SaveChanges;
begin
  if (Estado in [asEditando]) then
    CerrarAsiento;
  inherited SaveChanges;
end;

end.
