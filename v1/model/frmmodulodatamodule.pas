unit frmmodulodatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
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
    ModuloNOMBRE: TStringField;
    ModuloOBJETIVOS: TStringField;
    ModuloPERFILEGRESADO: TStringField;
    ModuloREQUISITOS: TStringField;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure ModuloNewRecord(DataSet: TDataSet);
  private
    { private declarations }
  public
    { public declarations }
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
  SearchFieldList.Add('NOMBRE');
  SearchFieldList.Add('DESCRIPCION');
end;

procedure TModuloDataModule.ModuloNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenName);
end;

end.
