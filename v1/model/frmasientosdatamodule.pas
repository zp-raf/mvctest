unit frmasientosdatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, DB, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmquerydatamodule, mvc, frmcuentadatamodule, frmmovimientodatamodule,
  observerSubject;

resourcestring
  rsSeHaSeleccio = 'Se ha seleccionado la misma cuenta para debe y haber';
  rsAsientoNoEnc = 'Asiento no encontrado';
  rsErrorAlRever = 'Error al reversar movimiento. Asiento invalido';
  rsNuevoAsientoError = 'Creacion de asiento en proceso. Finalice el asiento ' +
    'e intente de nuevo.';
  rsNoHayNigunAs = 'No hay nigun asiento en proceso.';
  rsLosMontosDeb = 'Los montos debe y haber no coinciden. Por favor revise los' +
    ' datos e intente de nuevo';
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
  end;

  TMovimientoList = array of TMovimientoRec;

  { TAsientosDataModule }

  TAsientosDataModule = class(TQueryDataModule)
    dsMovimiento: TDataSource;
    dsMovimientoDet: TDataSource;
    Movimiento: TSQLQuery;
    MovimientoDESCRIPCION: TStringField;
    MovimientoDet: TSQLQuery;
    MovimientoDetCUENTAID: TLongintField;
    MovimientoDetID: TLongintField;
    MovimientoDetMONTO: TFloatField;
    MovimientoDetMOVIMIENTOID: TLongintField;
    MovimientoDetTIPO_MOVIMIENTO: TStringField;
    MovimientoFECHA: TDateField;
    MovimientoID: TLongintField;
    MovimientoNUMERO: TLongintField;
    procedure DataModuleDestroy(Sender: TObject);
    procedure MovimientoAfterScroll(DataSet: TDataSet);
    procedure MovimientoDetAfterInsert(DataSet: TDataSet);
    procedure MovimientoFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure MovimientoNewRecord(DataSet: TDataSet);
  private
    FCuenta: TCuentaDataModule;
    FEstado: TEstadoAsiento;
    procedure ResetearEstado;
  published
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
    procedure Connect; override;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure Disconnect; override;
    procedure NuevoAsiento(ADescripcion: string);
    procedure NuevoAsientoDetalle(ACuenta: string; ATipoMov: TTipoMovimiento;
      AMonto: double);
    procedure NuevoAsientoDetalle(ATipoMov: TTipoMovimiento; AMonto: double);
    procedure RefreshDataSets; override;
    procedure ReversarAsiento(ADescripcion: string);
    procedure ReversarAsiento(AAsientoID: string; ADescripcion: string);
    procedure Rollback; override;
    procedure SaveChanges; override;

    { esta clase esta compuesta por tres subobjetos mas; dos para las cuentas
      y otro para los movimientos }
    property Cuenta: TCuentaDataModule read FCuenta write FCuenta;
    property Estado: TEstadoAsiento read FEstado write FEstado;
  end;

var
  AsientosDataModule: TAsientosDataModule;

implementation

{$R *.lfm}

{ TAsientosDataModule }

procedure TAsientosDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited DataModuleCreate(Sender);
  QryList.Add(TObject(Movimiento));
  QryList.Add(TObject(MovimientoDet));
  SearchFieldList.Add('DESCRIPCION');
  Estado := asInicial;
  // modelo de cuentas
  FCuenta := TCuentaDataModule.Create(Self, MasterDataModule);
  FCuenta.SetReadOnly(True);
  dsCuenta.DataSet := FCuenta.CuentasContables;
end;

procedure TAsientosDataModule.Disconnect;
begin
  FCuenta.Disconnect;
  inherited Disconnect;
end;

procedure TAsientosDataModule.NuevoAsiento(ADescripcion: string);
begin
  if (Estado in [asEditando]) then
    raise Exception.Create(rsNuevoAsientoError);
  try
    Movimiento.Insert;
    MovimientoFECHA.AsDateTime := Now;
    MovimientoDESCRIPCION.AsString := ADescripcion;
    Estado := asEditando;
    (MasterDataModule as ISubject).Notify;
  except
    on E: EDatabaseError do
      ResetearEstado;
  end;
end;

procedure TAsientosDataModule.NuevoAsientoDetalle(ACuenta: string;
  ATipoMov: TTipoMovimiento; AMonto: double);
begin
  if (Estado in [asInicial, asGuardado]) then
    raise Exception.Create(rsNoHayNigunAs);
  try
    MovimientoDet.Insert;
    MovimientoDetCUENTAID.AsString := ACuenta;
    MovimientoDetMONTO.AsFloat := AMonto;
    case ATipoMov of
      mvCredito: MovimientoDetTIPO_MOVIMIENTO.AsString := CREDITO;
      mvDebito: MovimientoDetTIPO_MOVIMIENTO.AsString := DEBITO;
    end;
    (MasterDataModule as ISubject).Notify;
  except
    on E: EDatabaseError do
      ResetearEstado;
  end;
end;

procedure TAsientosDataModule.NuevoAsientoDetalle(ATipoMov: TTipoMovimiento;
  AMonto: double);
begin
  NuevoAsientoDetalle(FCuenta.CuentaID.AsString, ATipoMov, AMonto);
end;

procedure TAsientosDataModule.MovimientoDetAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('MOVIMIENTOID').AsInteger :=
    Movimiento.FieldByName('ID').AsInteger;
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenNameMovDet);
end;

procedure TAsientosDataModule.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  FCuenta.Free;
end;

procedure TAsientosDataModule.MovimientoAfterScroll(DataSet: TDataSet);
begin
  try
    MovimientoDet.Close;
    MovimientoDet.ParamByName('ID').AsInteger := DataSet.FieldByName('ID').AsInteger;
  finally
    MovimientoDet.Open;
  end;
end;

procedure TAsientosDataModule.MovimientoFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  FilterRecord(DataSet, Accept);
end;

procedure TAsientosDataModule.MovimientoNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenNameMov);
end;

procedure TAsientosDataModule.ResetearEstado;
begin
  DiscardChanges;
  MasterDataModule.Rollback;
  Estado := asInicial;
  Connect;
  (MasterDataModule as ISubject).Notify;
end;

procedure TAsientosDataModule.CerrarAsiento;
var
  sumaDebe, sumaHaber: double;
begin
  if not (Estado in [asEditando]) then
    raise Exception.Create(rsNoHayNigunAs);
  try
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
      raise Exception.Create(rsLosMontosDeb);
    Movimiento.ApplyUpdates;
    MovimientoDet.ApplyUpdates;
    Estado := asGuardado;
    (MasterDataModule as ISubject).Notify;
  except
    on E: EDatabaseError do
      ResetearEstado;
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
  if not Movimiento.Locate('ID', AAsientoID, [loCaseInsensitive]) then
    raise Exception.Create(rsAsientoNoEnc);
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
      mov[x].CuentaID := MovimientoDetCUENTAID.AsString;
      mov[x].Monto := MovimientoDetMONTO.AsFloat;
      case MovimientoDetTIPO_MOVIMIENTO.AsString of
        DEBITO:
          mov[x].TipoMovimiento := mvCredito; // movimiento contrario
        CREDITO:
          mov[x].TipoMovimiento := mvDebito; // movimiento contrario
      end;
      MovimientoDet.Next;
      x := x + 1;
    end;
    // si no se metio una descripcion se usa la que esta por defecto
    if (Trim(ADescripcion) = '') then
      PDescripcion := DESCRIPCION_POR_DEFECTO + MovimientoNUMERO.AsString +
        ' - ' + MovimientoFECHA.AsString
    else
      PDescripcion := ADescripcion;
    // insertamos el asiento de reversion
    NuevoAsiento(PDescripcion);
    for x := 0 to Length(mov) - 1 do
    begin
      NuevoAsientoDetalle(mov[x].CuentaID, mov[x].TipoMovimiento, mov[x].Monto);
    end;
    CerrarAsiento;
  finally
    (MasterDataModule as ISubject).Notify;
  end;
end;

procedure TAsientosDataModule.Rollback;
begin
  ResetearEstado;
end;

procedure TAsientosDataModule.SaveChanges;
begin
  if (Estado in [asEditando]) then
    CerrarAsiento;
  inherited SaveChanges;
end;

end.
