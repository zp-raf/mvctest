unit frmfacturadatamodule2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, sqldb, FileUtil, LR_DBSet, LR_Class, Forms, Controls,
  Graphics, Dialogs, XMLPropStorage, frmquerydatamodule;

type

  { TFacturasDataModule }

  TFacturasDataModule = class(TQueryDataModule)
    dsDetalle: TDatasource;
    dsFactura: TDatasource;
    dsNum: TDatasource;
    dsPersona: TDatasource;
    dstal: TDatasource;
    frDBReporteCab: TfrDBDataSet;
    frDBReporteDet: TfrDBDataSet;
    frReport1: TfrReport;
    qryDetalle: TSQLQuery;
    qryDetalleCANTIDAD: TLongintField;
    qryDetalleDETALLE: TStringField;
    qryDetalleDEUDAID: TLongintField;
    qryDetalleEXENTA: TFloatField;
    qryDetalleFACTURAID: TLongintField;
    qryDetalleID: TLongintField;
    qryDetalleIVA10: TFloatField;
    qryDetalleIVA5: TFloatField;
    qryDetallePRECIO_UNITARIO: TFloatField;
    qryFactura: TSQLQuery;
    qryNumero: TSQLQuery;
    qryNumeroNUM: TLongintField;
    qryPersona: TSQLQuery;
    qryPersonaCEDULA: TStringField;
    qryPersonaID: TLongintField;
    qryPersonaNOMBRECOMPLETO: TStringField;
    tal: TSQLQuery;
    talACTIVO: TSmallintField;
    talCAJA: TStringField;
    talCOPIAS: TLongintField;
    talDIRECCION: TStringField;
    talID: TLongintField;
    talNOMBRE: TStringField;
    talNUMERO_FIN: TLongintField;
    talNUMERO_INI: TLongintField;
    talRUBRO: TStringField;
    talRUC: TStringField;
    talSUCURSAL: TStringField;
    talTELEFONO: TStringField;
    talTIMBRADO: TStringField;
    talTIPO: TLongintField;
    talVALIDO_DESDE: TDateField;
    talVALIDO_HASTA: TDateField;
    XMLPropStorage1: TXMLPropStorage;
  private
    { private declarations }
  public
    { public declarations }

        procedure Connect; override;
        procedure DataModuleCreate(Sender: TObject); override;
        procedure Disconnect; override;
        procedure RefreshDataSets; override;
       procedure SaveChanges; override;
  end;

var
  FacturasDataModule: TFacturasDataModule;

implementation

{$R *.lfm}

{ TFacturasDataModule }

procedure TFacturasDataModule.Connect;
begin
  inherited Connect;
end;

procedure TFacturasDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited DataModuleCreate(Sender);
  QryList.Add(TObject(qryFactura));
end;

procedure TFacturasDataModule.Disconnect;
begin
  inherited Disconnect;
end;

procedure TFacturasDataModule.RefreshDataSets;
begin
  inherited RefreshDataSets;
end;

procedure TFacturasDataModule.SaveChanges;
begin
  inherited SaveChanges;
end;

end.

