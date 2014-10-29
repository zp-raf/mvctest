unit frmdocumentosdatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, DB, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmquerydatamodule, frmfacturadatamodule2, frmpagodatamodule;

type

  { TDocumentosDataModule }

  TDocumentosDataModule = class(TQueryDataModule)
  private
    //FCodigos: TCodigosDataModule;
    //procedure SetCodigos(AValue: TCodigosDataModule);
  published
    CobrosViewTIPO_COMP: TStringField;
    dsFacturasCobradas: TDataSource;
    FacturasCobradasViewCOMPROBANTEID: TLongintField;
    FacturasCobradasViewCOMPROBANTE_VALIDO: TSmallintField;
    FacturasCobradasViewCONTADO: TSmallintField;
    FacturasCobradasViewFECHA_EMISION: TDateField;
    FacturasCobradasViewID: TLongintField;
    FacturasCobradasViewNOMBRE: TStringField;
    FacturasCobradasViewNUMERO: TLongintField;
    FacturasCobradasViewPERSONAID: TLongintField;
    FacturasCobradasViewRUC: TStringField;
    FacturasCobradasViewTIMBRADO: TStringField;
    FacturasCobradasViewTIPO_COMP: TStringField;
    FacturasCobradasViewTIPO_COMPROBANTE: TLongintField;
    FacturasCobradasViewTOTAL: TFloatField;
    FacturasCobradasViewVALIDO: TSmallintField;
    FacturasViewTIPO_COMP: TStringField;
    FacturasCobradasView: TSQLQuery;
    CobrosViewCOMPROBANTEID: TLongintField;
    CobrosViewESCOBRO: TSmallintField;
    CobrosViewFECHA: TDateField;
    CobrosViewHORA: TTimeField;
    CobrosViewID: TLongintField;
    CobrosViewMONTO: TFloatField;
    CobrosViewTIPO_COMPROBANTE: TLongintField;
    CobrosViewVALIDO: TSmallintField;
    dsFacturas: TDataSource;
    dsCobros: TDataSource;
    FacturasView: TSQLQuery;
    CobrosView: TSQLQuery;
    FacturasViewCOMPROBANTEID: TLongintField;
    FacturasViewCOMPROBANTE_VALIDO: TSmallintField;
    FacturasViewCONTADO: TSmallintField;
    FacturasViewFECHA_EMISION: TDateField;
    FacturasViewID: TLongintField;
    FacturasViewNOMBRE: TStringField;
    FacturasViewNUMERO: TLongintField;
    FacturasViewPERSONAID: TLongintField;
    FacturasViewRUC: TStringField;
    FacturasViewTIMBRADO: TStringField;
    FacturasViewTIPO_COMPROBANTE: TLongintField;
    FacturasViewTOTAL: TFloatField;
    FacturasViewVALIDO: TSmallintField;
    procedure DataModuleCreate(Sender: TObject); override;
    //property Codigos: TCodigosDataModule read FCodigos write SetCodigos;
  end;


var
  DocumentosDataModule: TDocumentosDataModule;

implementation

{$R *.lfm}

{ TDocumentosDataModule }

procedure TDocumentosDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  //FCodigos := TCodigosDataModule.Create(Self, MasterDataModule);
  //FCodigos.SetObject('TIPO_COMPROBANTE');
  //AuxQryList.Add(TObject(FCodigos.Codigos));
  AuxQryList.Add(TObject(FacturasView));
  AuxQryList.Add(TObject(CobrosView));
  AuxQryList.Add(TObject(FacturasCobradasView));
end;

//procedure TDocumentosDataModule.SetCodigos(AValue: TCodigosDataModule);
//begin
//  if FCodigos = AValue then
//    Exit;
//  FCodigos := AValue;
//end;

end.
