unit frmmodulodatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, sgcdTypes,
  frmquerydatamodule, sqldb, DB;

resourcestring
  rsGenName = 'SEQ_MODULO';

type

  { TModuloDataModule }

  TModuloDataModule = class(TQueryDataModule)
    dsModulo: TDataSource;
    Modulo: TSQLQuery;
    ModuloDESCRIPCION: TStringField;
    ModuloDURACION_CANTIDAD: TLongintField;
    ModuloDURACION_UNIDAD: TSmallintField;
    ModuloFUNDAMENTACION: TStringField;
    ModuloHABILITADO: TSmallintField;
    ModuloID: TLongintField;
    ModuloMODULOGENERAL: TSmallintField;
    ModuloNOMBRE: TStringField;
    ModuloOBJETIVOS: TStringField;
    ModuloPERFILEGRESADO: TStringField;
    ModuloREQUISITOS: TStringField;
    ModulosHabilitadosView: TSQLQuery;
    ModulosHabilitadosViewDESCRIPCION: TStringField;
    ModulosHabilitadosViewFUNDAMENTACION: TStringField;
    ModulosHabilitadosViewHABILITADO: TSmallintField;
    ModulosHabilitadosViewID: TLongintField;
    ModulosHabilitadosViewNOMBRE: TStringField;
    ModulosHabilitadosViewOBJETIVOS: TStringField;
    ModulosHabilitadosViewPERFILEGRESADO: TStringField;
    ModulosHabilitadosViewREQUISITOS: TStringField;
    procedure DataModuleCreate(Sender: TObject); override;
    function ModuloGeneralDefinido: boolean;
    procedure ModuloNewRecord(DataSet: TDataSet);
  end;

var
  ModuloDataModule: TModuloDataModule;

implementation

{$R *.lfm}

{ TModuloDataModule }

procedure TModuloDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  QryList.Add(TObject(Modulo));
  AuxQryList.Add(TObject(ModulosHabilitadosView));
  SearchFieldList.Add('NOMBRE');
  SearchFieldList.Add('DESCRIPCION');
end;

function TModuloDataModule.ModuloGeneralDefinido: boolean;
begin
  if Modulo.State = dsInactive then
    raise Exception.Create('Datos no disponibles');
  if Modulo.Lookup('MODULOGENERAL', DB_TRUE, 'ID') = null then
    Result := False
  else
    Result := True;
end;

procedure TModuloDataModule.ModuloNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenName);
  DataSet.FieldByName('MODULOGENERAL').AsInteger := 0;
  DataSet.FieldByName('HABILITADO').AsInteger := 0;
end;

end.
