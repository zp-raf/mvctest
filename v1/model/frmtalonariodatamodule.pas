unit frmtalonariodatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmquerydatamodule, sqldb, DB, frmcodigosdatamodule, sgcdTypes;

type

  { TTalonarioDataModule }

  TTalonarioDataModule = class(TQueryDataModule)
    procedure DataModuleDestroy(Sender: TObject);
  private
    FCodigos: TCodigosDataModule;
    procedure SetCodigos(AValue: TCodigosDataModule);
  published
    dsTalonarioView: TDataSource;
    dsTalonario: TDataSource;
    TalonarioView: TSQLQuery;
    Talonario: TSQLQuery;
    TalonarioACTIVO: TSmallintField;
    TalonarioCAJA: TStringField;
    TalonarioCOPIAS: TLongintField;
    TalonarioDIRECCION: TStringField;
    TalonarioID: TLongintField;
    TalonarioNOMBRE: TStringField;
    TalonarioNUMERO_FIN: TLongintField;
    TalonarioNUMERO_INI: TLongintField;
    TalonarioRUBRO: TStringField;
    TalonarioRUC: TStringField;
    TalonarioSUCURSAL: TStringField;
    TalonarioTELEFONO: TStringField;
    TalonarioTIMBRADO: TStringField;
    TalonarioTIPO: TLongintField;
    TalonarioVALIDO_DESDE: TDateField;
    TalonarioVALIDO_HASTA: TDateField;
    TalonarioViewCAJA: TStringField;
    TalonarioViewCOPIAS: TLongintField;
    TalonarioViewDIRECCION: TStringField;
    TalonarioViewID: TLongintField;
    TalonarioViewNOMBRE: TStringField;
    TalonarioViewNOMBRE_TIPO: TStringField;
    TalonarioViewNUMERO_FIN: TLongintField;
    TalonarioViewNUMERO_INI: TLongintField;
    TalonarioViewRUBRO: TStringField;
    TalonarioViewRUC: TStringField;
    TalonarioViewSUCURSAL: TStringField;
    TalonarioViewTELEFONO: TStringField;
    TalonarioViewTIMBRADO: TStringField;
    TalonarioViewTIPO: TLongintField;
    TalonarioViewVALIDO_DESDE: TDateField;
    TalonarioViewVALIDO_HASTA: TDateField;
    procedure DataModuleCreate(Sender: TObject); override;
    function GetTipoTalonario: TTipoTalonario;
    property Codigos: TCodigosDataModule read FCodigos write SetCodigos;
  end;

var
  TalonarioDataModule: TTalonarioDataModule;

implementation

{$R *.lfm}

{ TTalonarioDataModule }

procedure TTalonarioDataModule.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FCodigos) then
    FreeAndNil(FCodigos);
end;

procedure TTalonarioDataModule.SetCodigos(AValue: TCodigosDataModule);
begin
  if FCodigos = AValue then
    Exit;
  FCodigos := AValue;
end;

procedure TTalonarioDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  FCodigos := TCodigosDataModule.Create(Self, MasterDataModule);
  FCodigos.SetObject('TALONARIO.TIPO_TALONARIO');
  QryList.Add(TObject(Talonario));
  AuxQryList.Add(TObject(TalonarioView));
  AuxQryList.Add(TObject(FCodigos.Codigos));
end;

function TTalonarioDataModule.GetTipoTalonario: TTipoTalonario;
begin
  if Talonario.State = dsInactive then
    raise Exception.Create('Datos no disponibles');
  case Talonario.FieldByName('TIPO').AsString of
    FACTURA: Result := taFactura;
    RECIBO: Result := taRecibo;
    NOTA_CREDITO: Result := taNotaCredito;
    else
      raise Exception.Create('Tipo de talonario no definido');
  end;
end;

end.
