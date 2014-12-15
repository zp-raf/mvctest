unit frmaranceldatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, DB, FileUtil, frmsgcddatamodule, frmquerydatamodule,
  frmimpuestodadamodule, sgcdTypes, frmcodigosdatamodule;

resourcestring
  rsGenName = 'SEQ_ARANCEL';

type

  { TArancelesDataModule }

  TArancelesDataModule = class(TQueryDataModule)
    procedure ArancelImpuestoBeforePost(DataSet: TDataSet);
    procedure CuotaXArancelBeforePost(DataSet: TDataSet);
  private
    FCodigos: TCodigosDataModule;
    FImpuesto: TImpuestoDataModule;
    procedure SetCodigos(AValue: TCodigosDataModule);
    procedure SetImpuesto(AValue: TImpuestoDataModule);
  published
    Arancel: TSQLQuery;
    ArancelACTIVO: TSmallintField;
    ArancelDESCRIPCION: TStringField;
    ArancelGRUPO_PRODUCTOSID: TLongintField;
    ArancelID: TLongintField;
    ArancelMONTO: TFloatField;
    ArancelNOMBRE: TStringField;
    ArancelImpuesto: TSQLQuery;
    ArancelImpuestoARANCELID: TLongintField;
    ArancelImpuestoIMPUESTOID: TLongintField;
    ArancelImpuestoINLCUIDO: TSmallintField;
    CuotaXArancelARANCELID: TLongintField;
    CuotaXArancelCANTIDADCUOTA: TLongintField;
    CuotaXArancelVENCIMIENTO_CANTIDAD: TLongintField;
    CuotaXArancelVENCIMIENTO_UNIDAD: TLongintField;
    dsAranceles: TDataSource;
    ArancelesDetView: TSQLQuery;
    CuotaXArancel: TSQLQuery;
    dsArancelImpuesto: TDataSource;
    dsCuotaXArancel: TDataSource;
    StringField1: TStringField;
    procedure ArancelAfterScroll(DataSet: TDataSet);
    procedure ArancelImpuestoAfterInsert(DataSet: TDataSet);
    procedure ArancelMONTOChange(Sender: TField);
    procedure ArancelNewRecord(DataSet: TDataSet);
    procedure CuotaNewRecord(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DoDeleteAction(ADataSet: TDataSet); override;
    procedure SaveChanges; override;
    function HayCuotas: boolean;
    function HayImpuestos: boolean;
    property Codigos: TCodigosDataModule read FCodigos write SetCodigos;
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
  FCodigos := TCodigosDataModule.Create(Self, MasterDataModule);
  FCodigos.SetObject('CUOTAXARANCEL.VENCIMIENTO_UNIDAD');
  FImpuesto := TImpuestoDataModule.Create(Self, MasterDataModule);
  QryList.Add(TObject(Arancel));
  //QryList.Add(TObject(CuotaXArancel));
  AuxQryList.Add(TObject(ArancelesDetView));
  AuxQryList.Add(TObject(FImpuesto.Impuesto));
  AuxQryList.Add(TObject(Codigos.Codigos));
  SearchFieldList.Add('NOMBRE');
end;

procedure TArancelesDataModule.DoDeleteAction(ADataSet: TDataSet);
begin
  if ADataSet = CuotaXArancel then
    Exit;
  if not (ADataSet.State in [dsEdit]) then
    ADataSet.Edit;
  ADataSet.FieldByName('ACTIVO').AsString := DB_FALSE;
end;

procedure TArancelesDataModule.SaveChanges;
begin
  inherited SaveChanges;
  ArancelImpuesto.ApplyUpdates;
  CuotaXArancel.ApplyUpdates;
end;

procedure TArancelesDataModule.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FCodigos) then
    FreeAndNil(FCodigos);
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
  CuotaXArancel.Close;
  ArancelImpuesto.ParamByName('ARANCELID').AsInteger :=
    DataSet.FieldByName('ID').AsInteger;
  CuotaXArancel.ParamByName('ARANCELID').AsInteger :=
    DataSet.FieldByName('ID').AsInteger;
  CuotaXArancel.Open;
  ArancelImpuesto.Open;
end;

procedure TArancelesDataModule.SetImpuesto(AValue: TImpuestoDataModule);
begin
  if FImpuesto = AValue then
    Exit;
  FImpuesto := AValue;
end;

procedure TArancelesDataModule.ArancelImpuestoBeforePost(DataSet: TDataSet);
begin
  CheckRequiredFields(DataSet);
end;

procedure TArancelesDataModule.CuotaXArancelBeforePost(DataSet: TDataSet);
begin
  CheckRequiredFields(DataSet);
end;

procedure TArancelesDataModule.SetCodigos(AValue: TCodigosDataModule);
begin
  if FCodigos = AValue then
    Exit;
  FCodigos := AValue;
end;

procedure TArancelesDataModule.CuotaNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ARANCELID').Value :=
    Arancel.FieldByName('ID').Value;
end;

function TArancelesDataModule.HayCuotas: boolean;
begin
  if CuotaXArancel.Lookup('ARANCELID', ArancelID.AsString, 'ARANCELID') = null then
    Result := False
  else
    Result := True;
end;

function TArancelesDataModule.HayImpuestos: boolean;
begin
  if ArancelImpuesto.Lookup('ARANCELID', ArancelID.AsString, 'ARANCELID') = null then
    Result := False
  else
    Result := True;
end;

end.
