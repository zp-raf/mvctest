unit frmmovimientodatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, DB, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmquerydatamodule;

resourcestring
  rsGenNameMov = 'GEN_MOVIMIENTO';
  rsGenNameMovDet = 'GEN_MOVIMIENTO_DET';

type

  { TMovimientoDataModule }

  TMovimientoDataModule = class(TQueryDataModule)
    dsMovimientoDet: TDataSource;
    dsMovimiento: TDataSource;
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
    procedure DataModuleCreate(Sender: TObject); override;
    procedure MovimientoDetAfterInsert(DataSet: TDataSet);
    procedure MovimientoFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure MovimientoNewRecord(DataSet: TDataSet);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  MovimientoDataModule: TMovimientoDataModule;

implementation

{$R *.lfm}

{ TMovimientoDataModule }

procedure TMovimientoDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  QryList.Add(TObject(Movimiento));
  QryList.Add(TObject(MovimientoDet));
  SearchFieldList.Add('DESCRIPCION');
end;

procedure TMovimientoDataModule.MovimientoDetAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('MOVIMIENTOID').AsInteger :=
    Movimiento.FieldByName('ID').AsInteger;
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenNameMovDet);
end;

procedure TMovimientoDataModule.MovimientoFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  FilterRecord(DataSet, Accept);
end;

procedure TMovimientoDataModule.MovimientoNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenNameMov);
end;

end.
