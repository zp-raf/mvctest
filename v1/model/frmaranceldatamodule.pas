unit frmaranceldatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, DB, FileUtil, frmsgcddatamodule, frmquerydatamodule,
  frmcuotaxarancel, frmimpuestodadamodule, sgcdTypes;

resourcestring
  rsGenName = 'SEQ_ARANCEL';

type

  { TArancelesDataModule }

  TArancelesDataModule = class(TQueryDataModule)
    ArancelImpuesto: TSQLQuery;
    ArancelImpuestoARANCELID: TLongintField;
    ArancelImpuestoIMPUESTOID: TLongintField;
    ArancelImpuestoINLCUIDO: TSmallintField;
    dsArancelImpuesto: TDataSource;
    StringField1: TStringField;
    procedure ArancelAfterScroll(DataSet: TDataSet);
    procedure ArancelImpuestoAfterInsert(DataSet: TDataSet);
    procedure ArancelMONTOChange(Sender: TField);
    procedure ArancelNewRecord(DataSet: TDataSet);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FCuotasXArancel: TCuotaArancelDataModule;
    FImpuesto: TImpuestoDataModule;
    procedure SetCuotasXArancel(AValue: TCuotaArancelDataModule);
    procedure SetImpuesto(AValue: TImpuestoDataModule);
  published
    Arancel: TSQLQuery;
    ArancelACTIVO: TSmallintField;
    ArancelDESCRIPCION: TStringField;
    ArancelGRUPO_PRODUCTOSID: TLongintField;
    ArancelID: TLongintField;
    ArancelMONTO: TFloatField;
    ArancelNOMBRE: TStringField;
    CuotaXArancelARANCELID: TLongintField;
    CuotaXArancelCANTIDADCUOTA: TLongintField;
    CuotaXArancelVENCIMIENTO_CANTIDAD: TLongintField;
    CuotaXArancelVENCIMIENTO_UNIDAD: TLongintField;
    dsAranceles: TDataSource;
    ArancelesDetView: TSQLQuery;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DoDeleteAction(ADataSet: TDataSet); override;
    procedure SaveChanges; override;
    procedure NewRecord; override;
    property CuotasXArancel: TCuotaArancelDataModule
      read FCuotasXArancel write SetCuotasXArancel;
    property Impuesto: TImpuestoDataModule read FImpuesto write SetImpuesto;
  end;

var
  ArancelesDataModule: TArancelesDataModule;

implementation

{$R *.lfm}

{ TArancelesDataModule }

procedure TArancelesDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  FCuotasXArancel := TCuotaArancelDataModule.Create(Self, MasterDataModule);
  FImpuesto := TImpuestoDataModule.Create(Self, MasterDataModule);
  QryList.Add(TObject(Arancel));
  QryList.Add(TObject(FCuotasXArancel.CuotaXArancel));
  AuxQryList.Add(TObject(ArancelesDetView));
  AuxQryList.Add(TObject(FImpuesto.Impuesto));
  AuxQryList.Add(TObject(FCuotasXArancel.Codigos.Codigos));
  SearchFieldList.Add('NOMBRE');
end;

procedure TArancelesDataModule.DoDeleteAction(ADataSet: TDataSet);
begin
  if ADataSet = CuotasXArancel.CuotaXArancel then
    Exit;
  if not (ADataSet.State in [dsEdit]) then
    ADataSet.Edit;
  ADataSet.FieldByName('ACTIVO').AsString := DB_FALSE;
end;

procedure TArancelesDataModule.SaveChanges;
begin
  inherited SaveChanges;
  ArancelImpuesto.ApplyUpdates;
end;

procedure TArancelesDataModule.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FCuotasXArancel) then
    FreeAndNil(FCuotasXArancel);
  if Assigned(FImpuesto) then
    FreeAndNil(FImpuesto);
end;

procedure TArancelesDataModule.ArancelNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenName);
end;

procedure TArancelesDataModule.ArancelImpuestoAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('ARANCELID').Value := Arancel.FieldByName('ID').Value;
end;

procedure TArancelesDataModule.ArancelMONTOChange(Sender: TField);
begin
  if Sender.AsFloat < 0 then
    Sender.Clear;
end;

procedure TArancelesDataModule.ArancelAfterScroll(DataSet: TDataSet);
begin
  ArancelImpuesto.Close;
  ArancelImpuesto.ParamByName('ARANCELID').AsInteger :=
    Arancel.FieldByName('ID').AsInteger;
  ArancelImpuesto.Open;
end;

procedure TArancelesDataModule.SetCuotasXArancel(AValue: TCuotaArancelDataModule);
begin
  if FCuotasXArancel = AValue then
    Exit;
  FCuotasXArancel := AValue;
end;

procedure TArancelesDataModule.SetImpuesto(AValue: TImpuestoDataModule);
begin
  if FImpuesto = AValue then
    Exit;
  FImpuesto := AValue;
end;

procedure TArancelesDataModule.NewRecord;
begin
  inherited;
  CuotasXArancel.CuotaXArancel.FieldByName('ARANCELID').Value :=
    Arancel.FieldByName('ID').Value;
end;

end.
