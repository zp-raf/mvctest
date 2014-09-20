unit frmventadatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, frmquerydatamodule, sqldb, DB, frmsgcddatamodule, mvc;

resourcestring
  rsGenDeuda = 'GENERATOR_DEUDA';
  rsGenDeudaDetalle = 'GENERATOR_DEUDA_DETALLE';

type

  { TVentaDataModule }

  TVentaDataModule = class(TQueryDataModule, IModel)
    DeudaACTIVO: TSmallintField;
    DeudaDetalleARANCELID: TLongintField;
    DeudaDetalleCANTIDAD: TLongintField;
    DeudaDetalleCANT_CUOTAS: TLongintField;
    DeudaDetalleDEUDAID: TLongintField;
    DeudaDetalleFECHAINICIO: TDateField;
    DeudaDetalleFECHATOPE: TDateField;
    DeudaDetalleID: TLongintField;
    DeudaDetalleMONTODEUDA: TFloatField;
    DeudaDetalleMONTOPAGADO: TFloatField;
    DeudaDetalleNRO_CUOTA: TLongintField;
    DeudaDetalleOBSERVACION: TStringField;
    DeudaDetalleSALDO: TFloatField;
    DeudaID: TLongintField;
    DeudaMONTO_DEUDA: TFloatField;
    DeudaMONTO_PAGADO: TFloatField;
    DeudaPERSONAID: TLongintField;
    DeudaSALDO: TFloatField;
    dsDeudaDetalle: TDataSource;
    dsDeuda: TDataSource;
    Deuda: TSQLQuery;
    DeudaDetalle: TSQLQuery;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DeudaDetalleAfterInsert(DataSet: TDataSet);
    procedure DeudaNewRecord(DataSet: TDataSet);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  VentaDataModule: TVentaDataModule;

implementation

{$R *.lfm}

{ TVentaDataModule }

procedure TVentaDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  QryList.Add(Deuda);
  QryList.Add(DeudaDetalle);
end;

procedure TVentaDataModule.DeudaDetalleAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('DEUDAID').Value := Deuda.FieldByName('ID').Value;
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenDeudaDetalle);
end;

procedure TVentaDataModule.DeudaNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenDeuda);
end;

end.
