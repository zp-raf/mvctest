unit frmasientosdatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, DB, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmquerydatamodule, mvc, frmcuentadatamodule, frmmovimientodatamodule;

resourcestring
  rsSeHaSeleccio = 'Se ha seleccionado la misma cuenta para debe y haber';
  rsAsientoNoEnc = 'Asiento no encontrado';
  rsErrorAlRever = 'Error al reversar movimiento. Asiento invalido';
  rsNuevoAsientoError = 'Creacion de asiento en proceso. Finalice el asiento ' +
    'e intente de nuevo.';
  rsNoHayNigunAs = 'No hay nigun asiento en proceso.';

const
  DEBITO = 'D';
  CREDITO = 'C';
  DESCRIPCION_POR_DEFECTO = 'REVERSION DE ASIENTO - ';
  OPERACION_NULL = '';

type

  TTipoMovimiento = (mvCredito, mvDebito);

  TEstadoAsiento = (asInicial, asEditando, asGuardado);

  { TAsientosDataModule }

  TAsientosDataModule = class(TQueryDataModule)
  private
    FCuentaDebe: TCuentaDataModule;
    FCuentaHaber: TCuentaDataModule;
    FEstado: TEstadoAsiento;
    FMovimiento: TMovimientoDataModule;
  published
    dsCuentaHaber: TDataSource;
    dsCuentaDebe: TDataSource;
    dsAsientos: TDataSource;
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
    qryAsientos: TSQLQuery;
    procedure CerrarAsiento;
    procedure Connect; override;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure Disconnect; override;
    procedure NuevoAsiento(ADescripcion: string);
    procedure NuevoAsientoDetalle(ACuenta: string; ATipoMov: TTipoMovimiento;
      AMonto: double);
    procedure RefreshDataSets; override;
    procedure ReversarAsiento(ADescripcion: string);
    procedure ReversarAsiento(AAsientoID: string; ADescripcion: string);
    procedure SaveChanges; override;

    { esta clase esta compuesta por tres subobjetos mas; dos para las cuentas
      y otro para los movimientos }
    property CuentaDebe: TCuentaDataModule read FCuentaDebe write FCuentaDebe;
    property CuentaHaber: TCuentaDataModule read FCuentaHaber write FCuentaHaber;
    property Movimiento: TMovimientoDataModule read FMovimiento write FMovimiento;
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
  Estado := asInicial;
  // modelo de cuentas para debe
  FCuentaDebe := TCuentaDataModule.Create(Self, MasterDataModule);
  FCuentaDebe.SetReadOnly(True);
  // modelo de cuentas para haber
  FCuentaHaber := TCuentaDataModule.Create(Self, MasterDataModule);
  FCuentaHaber.SetReadOnly(True);
  //modelo de los movimientos
  FMovimiento := TMovimientoDataModule.Create(Self, MasterDataModule);

  QryList.Add(TObject(qryAsientos));
  //QryList.Add(TObject(FMovimiento.Movimiento));
  //QryList.Add(TObject(FMovimiento.MovimientoDet));
  //AuxQryList.Add(TObject(FCuentaDebe.Cuenta));
  //AuxQryList.Add(TObject(FCuentaHaber.Cuenta));
  dsCuentaDebe.DataSet := FCuentaDebe.Cuenta;
  dsCuentaHaber.DataSet := FCuentaHaber.Cuenta;
end;

procedure TAsientosDataModule.Disconnect;
begin
  FCuentaDebe.Disconnect;
  FCuentaHaber.Disconnect;
  FMovimiento.Disconnect;
  inherited Disconnect;
end;

procedure TAsientosDataModule.NuevoAsiento(ADescripcion: string);
begin
  if (Estado in [asEditando]) then
    raise Exception.Create(rsNuevoAsientoError);
  try
    with FMovimiento do
    begin
      Movimiento.Insert;
      MovimientoFECHA.AsDateTime := Now;
      MovimientoDESCRIPCION.AsString := ADescripcion;
      Estado := asEditando;
    end;
  except
    on E: EDatabaseError do
    begin
      FMovimiento.DiscardChanges;
      FMovimiento.Rollback;
      Estado := asInicial;
      Connect;
    end;
  end;
end;

procedure TAsientosDataModule.NuevoAsientoDetalle(ACuenta: string;
  ATipoMov: TTipoMovimiento; AMonto: double);
begin
  if (Estado in [asEditando]) then
    raise Exception.Create(rsNuevoAsientoError);
  try
    with FMovimiento do
    begin
      MovimientoDet.Insert;
      MovimientoDetCUENTAID.AsString := ACuenta;
      MovimientoDetMONTO.AsFloat := AMonto;
      case ATipoMov of
        mvCredito: MovimientoDetTIPO_MOVIMIENTO.AsString := CREDITO;
        mvDebito: MovimientoDetTIPO_MOVIMIENTO.AsString := DEBITO;
      end;
    end;
  except
    on E: EDatabaseError do
    begin
      FMovimiento.DiscardChanges;
      FMovimiento.Rollback;
      Estado := asInicial;
      Connect;
    end;
  end;
end;

procedure TAsientosDataModule.CerrarAsiento;
var
  sumaDebe, sumaHaber: double;
begin
  if not (Estado in [asEditando]) then
    raise Exception.Create(rsNoHayNigunAs);
  try
    sumaDebe:=0.0;
    sumaHaber:=0.0;
    // ponemos un filtro para el dataset
    FMovimiento.MovimientoDet.Filter :=
      'MOVIMIENTOID = ' + FMovimiento.MovimientoID.AsString;
    FMovimiento.MovimientoDet.Filtered := True;
    FMovimiento.MovimientoDet.Close;
    FMovimiento.MovimientoDet.Open;
    FMovimiento.MovimientoDet.First;
    while not Movimiento.MovimientoDet.EOF do
    begin
      case FMovimiento.MovimientoDetTIPO_MOVIMIENTO.AsString of
        DEBITO: ;
        CREDITO: ;
      end;
      FMovimiento.MovimientoDet.Next;
    end;
    Estado := asGuardado;
  except
    on E: EDatabaseError do
    begin
      FMovimiento.DiscardChanges;
      FMovimiento.Rollback;
      Estado := asInicial;
      Connect;
    end;
  end;
end;

procedure TAsientosDataModule.Connect;
begin
  FCuentaDebe.Connect;
  FCuentaHaber.Connect;
  FMovimiento.Connect;
  inherited Connect;
end;

procedure TAsientosDataModule.RefreshDataSets;
begin
  FCuentaDebe.RefreshDataSets;
  FCuentaHaber.RefreshDataSets;
  FMovimiento.RefreshDataSets;
  inherited RefreshDataSets;
end;

procedure TAsientosDataModule.ReversarAsiento(ADescripcion: string);
begin
  ReversarAsiento(qryAsientosID.AsString, ADescripcion);
end;

procedure TAsientosDataModule.ReversarAsiento(AAsientoID: string; ADescripcion: string);
var
  PDescripcion: string;
begin
  // buscamos el asiento
  if not FMovimiento.Movimiento.Locate('ID', AAsientoID, [loCaseInsensitive]) then
    raise Exception.Create(rsAsientoNoEnc);
  try
    // ponemos un filtro para el dataset
    FMovimiento.MovimientoDet.Filter :=
      'MOVIMIENTOID = ' + FMovimiento.MovimientoID.AsString;
    FMovimiento.MovimientoDet.Filtered := True;
    FMovimiento.MovimientoDet.Close;
    FMovimiento.MovimientoDet.Open;
    // si no se metio una descripcion se usa la que esta por defecto
    if (Trim(ADescripcion) = '') then
      PDescripcion := DESCRIPCION_POR_DEFECTO + FMovimiento.MovimientoNUMERO.AsString +
        ' - ' + FMovimiento.MovimientoFECHA.AsString
    else
      PDescripcion := ADescripcion;
    NuevoAsiento(PDescripcion);
    // sacamos las cuentas que iran en el nuevo asiento
    FMovimiento.MovimientoDet.First;
    while not Movimiento.MovimientoDet.EOF do
    begin
      // hay que insertar los movimientos contrarios
      case FMovimiento.MovimientoDetTIPO_MOVIMIENTO.AsString of
        DEBITO: NuevoAsientoDetalle(FMovimiento.MovimientoDetCUENTAID.AsString,
            mvCredito, FMovimiento.MovimientoDetMONTO.AsFloat);
        CREDITO: NuevoAsientoDetalle(FMovimiento.MovimientoDetCUENTAID.AsString,
            mvDebito, FMovimiento.MovimientoDetMONTO.AsFloat);
      end;
      FMovimiento.MovimientoDet.Next;
    end;
  finally
    FMovimiento.MovimientoDet.Filtered := False;
    FMovimiento.MovimientoDet.Filter := '';
  end;
end;

procedure TAsientosDataModule.SaveChanges;
begin
  if (Estado in [asEditando]) then
    CerrarAsiento;
  FMovimiento.Movimiento.ApplyUpdates;
  FMovimiento.MovimientoDet.ApplyUpdates;
  inherited SaveChanges;
end;

end.
