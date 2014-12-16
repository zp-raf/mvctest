unit frmmultasdatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, sgcdTypes,
  XMLPropStorage, frmquerydatamodule, sqldb, DB, frmgeneradeudadatamodule;

const
  ARANCEL_NULL = '0';

type

  { TMultasDataModule }

  TMultasDataModule = class(TQueryDataModule)
    spGetDeudasEnMora: TSQLQuery;
    spGetDeudasEnMoraARANCELID: TLongintField;
    spGetDeudasEnMoraCANTIDAD_CUOTAS: TLongintField;
    spGetDeudasEnMoraCUENTAID: TLongintField;
    spGetDeudasEnMoraCUOTA_NRO: TLongintField;
    spGetDeudasEnMoraDESCRIPCION: TStringField;
    spGetDeudasEnMoraID: TLongintField;
    spGetDeudasEnMoraMATRICULAID: TLongintField;
    spGetDeudasEnMoraPERSONAID: TLongintField;
  private
    FArancelID: string;
    FDeudas: TGeneraDeudaDataModule;
    procedure SetDeudas(AValue: TGeneraDeudaDataModule);
  published
    ds: TDataSource;
    qry: TSQLQuery;
    qryDESCRIPCION: TStringField;
    qryID: TLongintField;
    qryMONTO: TFloatField;
    qryNOMBRE: TStringField;
    spMulta: TSQLQuery;
    XMLPropStorage1: TXMLPropStorage;
    procedure AplicarMultas(AID: string);
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    procedure Connect; override;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DataModuleDestroy(Sender: TObject);
    procedure Disconnect; override;
    procedure XMLPropStorage1RestoreProperties(Sender: TObject);
    procedure XMLPropStorage1SaveProperties(Sender: TObject);
    property ArancelID: string read FArancelID write FArancelID;
    property Deudas: TGeneraDeudaDataModule read FDeudas write SetDeudas;
  end;

var
  MultasDataModule: TMultasDataModule;

implementation

{$R *.lfm}

{ TMultasDataModule }

procedure TMultasDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  FDeudas := TGeneraDeudaDataModule.Create(Self, MasterDataModule);
  QryList.Add(TObject(qry));
  SearchFieldList.Add('NOMBRE');
  qry.OnFilterRecord := @FilterRecord;
end;

procedure TMultasDataModule.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FDeudas) then
    FreeAndNil(FDeudas);
end;

procedure TMultasDataModule.Connect;
begin
  FDeudas.Connect;
  inherited Connect;
  if not qry.Locate('ID', FArancelID, [loCaseInsensitive]) then
    qry.First;
end;

procedure TMultasDataModule.Disconnect;
begin
  inherited Disconnect;
  FDeudas.Disconnect;
end;

procedure TMultasDataModule.SetDeudas(AValue: TGeneraDeudaDataModule);
begin
  if FDeudas = AValue then
    Exit;
  FDeudas := AValue;
end;

procedure TMultasDataModule.AplicarMultas(AID: string);
begin
  //FArancelID := AID;
  try
    //  spGetDeudasEnMora.Close;
    //  spGetDeudasEnMora.ParamByName('arancelMultaID').AsString := AID;
    //  spGetDeudasEnMora.Open;
    //  if spGetDeudasEnMora.IsEmpty then
    //    Exit;
    //  Deudas.SetArancel(AID);
    //  spGetDeudasEnMora.First;
    //  while not spGetDeudasEnMora.EOF do
    //  begin
    //    Deudas.NewRecord;
    //    Deudas.SetPersona(spGetDeudasEnMora.FieldByName('PERSONAID').AsString);
    //    Deudas.Deuda.FieldByName('ARANCELID').AsString := AID;
    //    if not spGetDeudasEnMora.FieldByName('MATRICULAID').IsNull then
    //      Deudas.Deuda.FieldByName('MATRICULAID').AsString :=
    //        spGetDeudasEnMora.FieldByName('MATRICULAID').AsString;
    //    Deudas.GenerarCuotas;
    //    spGetDeudasEnMora.Next;
    //  end;
    //  Deudas.SaveChanges;
    //  Commit;
    spMulta.Params.Items[0].AsString := AID;
    spMulta.Prepare;
    spMulta.ExecSQL;
    Commit;
  except
    on E:
      EDatabaseError do
    begin
      Rollback;
      raise;
    end;
  end;
end;

procedure TMultasDataModule.AfterConstruction;
begin
  inherited AfterConstruction;
  XMLPropStorage1.Restore;
end;

procedure TMultasDataModule.BeforeDestruction;
begin
  XMLPropStorage1.Save;
  XMLPropStorage1.Save;
  inherited BeforeDestruction;
end;

procedure TMultasDataModule.XMLPropStorage1RestoreProperties(Sender: TObject);
begin
  if XMLPropStorage1.StoredValue['arancelid'] = '' then
    FArancelID := ARANCEL_NULL
  else
    FArancelID := XMLPropStorage1.StoredValue['arancelid'];
end;

procedure TMultasDataModule.XMLPropStorage1SaveProperties(Sender: TObject);
begin
  XMLPropStorage1.StoredValue['arancelid'] := FArancelID;
end;

end.
