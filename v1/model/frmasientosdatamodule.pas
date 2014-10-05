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

const
  DEBITO = 'D';
  CREDITO = 'C';
  DESCRIPCION_POR_DEFECTO = 'REVERSION DE ASIENTO - ';
  OPERACION_NULL = '';

type

  { TAsientosDataModule }

  TAsientosDataModule = class(TQueryDataModule)
  private
    FCuentaDebe: TCuentaDataModule;
    FCuentaHaber: TCuentaDataModule;
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
    procedure DataModuleCreate(Sender: TObject); override;
    procedure Disconnect; override;
    procedure NuevoAsiento(ADescripcion: string);
    procedure Connect; override;
    procedure RefreshDataSets; override;
    procedure ReversarAsiento(AAsientoID: string; ADescripcion: string);
    procedure ReversarAsiento(ADescripcion: string);
    procedure SaveChanges; override;

    { esta clase esta compuesta por tres subobjetos mas; dos para las cuentas
      y otro para los movimientos }
    property CuentaDebe: TCuentaDataModule read FCuentaDebe write FCuentaDebe;
    property CuentaHaber: TCuentaDataModule read FCuentaHaber write FCuentaHaber;
    property Movimiento: TMovimientoDataModule read FMovimiento write FMovimiento;
  end;

var
  AsientosDataModule: TAsientosDataModule;

implementation

{$R *.lfm}

{ TAsientosDataModule }

procedure TAsientosDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited DataModuleCreate(Sender);
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
  try
    // cabecera
    FMovimiento.Movimiento.Insert;
    FMovimiento.MovimientoFECHA.AsDateTime := Now;
    FMovimiento.MovimientoDESCRIPCION.AsString := ADescripcion;
    // debe
    FMovimiento.MovimientoDet.Insert;
    FMovimiento.MovimientoDetCUENTAID.AsString := ACuentaDebeID;
    FMovimiento.MovimientoDetMONTO.AsFloat := AMonto;
    FMovimiento.MovimientoDetTIPO_MOVIMIENTO.AsString := DEBITO;
    // haber
    FMovimiento.MovimientoDet.Insert;
    FMovimiento.MovimientoDetCUENTAID.AsString := ACuentaHaberID;
    FMovimiento.MovimientoDetMONTO.AsFloat := AMonto;
    FMovimiento.MovimientoDetTIPO_MOVIMIENTO.AsString := CREDITO;
  except
    on E: EDatabaseError do
    begin
      FMovimiento.DiscardChanges;
      FMovimiento.Rollback;
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

procedure TAsientosDataModule.ReversarAsiento(AAsientoID: string; ADescripcion: string);
var
  cont: integer;
  d: double;
  dd: string;
  ok: boolean;
  PDebe, PHaber, PDescripcion: string;
begin
  // buscamos el asiento
  if not FMovimiento.Movimiento.Locate('ID', AAsientoID, [loCaseInsensitive]) then
    raise Exception.Create(rsAsientoNoEnc);
  // chequeamos que el asiento este correcto
  // tiene que haber 2 asientos y los montos deben ser iguales y uno tiene que
  // ser credito y el otro debito
  ok := False;
  try
    FMovimiento.MovimientoDet.Filter :=
      'MOVIMIENTOID = ' + FMovimiento.MovimientoID.AsString;
    FMovimiento.MovimientoDet.Filtered := True;
    FMovimiento.MovimientoDet.Close;
    FMovimiento.MovimientoDet.Open;

    //chequear dos asientos de detalle
    FMovimiento.MovimientoDet.First;
    cont := 0;
    while not FMovimiento.MovimientoDet.EOF do
    begin
      cont := cont + 1;
      FMovimiento.MovimientoDet.Next;
    end;
    if cont = 2 then
    begin
      //ahora chequear que los montos sean iguales en ambos asientos
      FMovimiento.MovimientoDet.First;
      d := FMovimiento.MovimientoDetMONTO.AsFloat;
      dd := FMovimiento.MovimientoDetTIPO_MOVIMIENTO.AsString;
      FMovimiento.MovimientoDet.Next;
      if (d = FMovimiento.MovimientoDetMONTO.AsFloat) and
        (UpperCase(dd) <> UpperCase(FMovimiento.MovimientoDetTIPO_MOVIMIENTO.AsString))
      then
        ok := True;
    end
    else
      ok := False;
  finally
    if not ok then
      raise Exception.Create(rsErrorAlRever);
  end;

  try
    // sacamos las cuentas que iran en el nuevo asiento
    // en el debe tiene que ir el haber del movimiento a reversar y lo mismo con
    // el haber
    FMovimiento.MovimientoDet.First;
    while not Movimiento.MovimientoDet.EOF do
    begin
      if FMovimiento.MovimientoDetTIPO_MOVIMIENTO.AsString = DEBITO then
        PHaber := Movimiento.MovimientoDetCUENTAID.AsString
      else if FMovimiento.MovimientoDetTIPO_MOVIMIENTO.AsString = CREDITO then
        PDebe := Movimiento.MovimientoDetCUENTAID.AsString;
      FMovimiento.MovimientoDet.Next;
    end;


    // si no se metio una descripcion se usa la que esta por defecto
    if (Trim(ADescripcion) = '') then
      PDescripcion := DESCRIPCION_POR_DEFECTO + FMovimiento.MovimientoNUMERO.AsString +
        ' - ' + FMovimiento.MovimientoFECHA.AsString
    else
      PDescripcion := ADescripcion;
  finally
    FMovimiento.MovimientoDet.Filtered := False;
    FMovimiento.MovimientoDet.Filter := '';
    FMovimiento.MovimientoDet.Close;
    FMovimiento.MovimientoDet.Open;
  end;
  // ACA RECIEN REVERSAMOS!!!! :D
  NuevoAsiento(PDebe, PHaber, d, PDescripcion);
end;

procedure TAsientosDataModule.ReversarAsiento(ADescripcion: string);
begin
  ReversarAsiento(qryAsientosID.AsString, ADescripcion);
end;

procedure TAsientosDataModule.SaveChanges;
begin
  FMovimiento.Movimiento.ApplyUpdates;
  FMovimiento.MovimientoDet.ApplyUpdates;
  inherited SaveChanges;
end;

end.
