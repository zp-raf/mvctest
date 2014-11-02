unit frmcuotaxarancel;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, DB, FileUtil, frmquerydatamodule, frmcodigosdatamodule;

resourcestring
  rsGenName = 'GEN_CUOTAXARANCEL';

type

  { TCuotaArancelDataModule }

  TCuotaArancelDataModule = class(TQueryDataModule)
    procedure DataModuleDestroy(Sender: TObject);
  private
    FCodigos: TCodigosDataModule;
    procedure SetCodigos(AValue: TCodigosDataModule);
  published
    CuotaXArancel: TSQLQuery;
    CuotaXArancelARANCELID: TLongintField;
    CuotaXArancelCANTIDADCUOTA: TLongintField;
    CuotaXArancelVENCIMIENTO_CANTIDAD: TLongintField;
    CuotaXArancelVENCIMIENTO_UNIDAD: TLongintField;
    dsCuotaXArancel: TDataSource;
    procedure Connect; override;
    procedure Disconnect; override;
    procedure DataModuleCreate(Sender: TObject); override;
    property Codigos: TCodigosDataModule read FCodigos write SetCodigos;
    function GetCantCuotas(ArancelID: string): integer;
    function GetVencimientoUnidad(ArancelID: string): integer;
    function GetVencimientoCantidad(ArancelID: string): integer;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  CuotaArancelDataModule: TCuotaArancelDataModule;

implementation

{$R *.lfm}

{ TCuotaArancelDataModule }

procedure TCuotaArancelDataModule.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FCodigos) then
    FreeAndNil(FCodigos);
end;

procedure TCuotaArancelDataModule.SetCodigos(AValue: TCodigosDataModule);
begin
  if FCodigos = AValue then
    Exit;
  FCodigos := AValue;
end;

procedure TCuotaArancelDataModule.Connect;
begin
  FCodigos.Connect;
  inherited Connect;
end;

procedure TCuotaArancelDataModule.Disconnect;
begin
  FCodigos.Disconnect;
  inherited Disconnect;
end;

procedure TCuotaArancelDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  QryList.Add(TObject(CuotaXArancel));
  FCodigos := TCodigosDataModule.Create(Self, FMasterDataModule);
  FCodigos.SetObject('CUOTAXARANCEL.VENCIMIENTO_UNIDAD');
end;

function TCuotaArancelDataModule.GetCantCuotas(ArancelID: string): integer;
begin
  if CuotaXArancel.Lookup('ARANCELID', ArancelID, 'CANTIDADCUOTA') = null then
    Result := -1
  else
    Result := CuotaXArancel.Lookup('ARANCELID', ArancelID, 'CANTIDADCUOTA');
end;

function TCuotaArancelDataModule.GetVencimientoUnidad(ArancelID: string): integer;
begin
  if CuotaXArancel.Lookup('ARANCELID', ArancelID, 'VENCIMIENTO_UNIDAD') = null then
    Result := -1
  else
    Result := CuotaXArancel.Lookup('ARANCELID', ArancelID, 'VENCIMIENTO_UNIDAD');
end;

function TCuotaArancelDataModule.GetVencimientoCantidad(ArancelID: string): integer;
begin
  if CuotaXArancel.Lookup('ARANCELID', ArancelID, 'VENCIMIENTO_CANTIDAD') = null then
    Result := -1
  else
    Result := CuotaXArancel.Lookup('ARANCELID', ArancelID, 'VENCIMIENTO_CANTIDAD');
end;

end.
