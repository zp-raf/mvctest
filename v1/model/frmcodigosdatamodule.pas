unit frmcodigosdatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, sqldb, FileUtil, frmquerydatamodule;

type

  { TCodigosDataModule }

  TCodigosDataModule = class(TQueryDataModule)
    CodigosOBJETO: TStringField;
    CodigosSIGNIFICADO: TStringField;
    CodigosVALOR: TLongintField;
    dsCodigos: TDataSource;
    Codigos: TSQLQuery;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure SetObject(AObj: string);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  CodigosDataModule: TCodigosDataModule;

implementation

{$R *.lfm}

{ TCodigosDataModule }

procedure TCodigosDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  QryList.Add(TObject(Codigos));
  SetReadOnly(True);
end;

procedure TCodigosDataModule.SetObject(AObj: string);
begin
  Codigos.Filter := 'OBJETO = ' + '''' + AObj + '''';
  Codigos.Filtered := True;
  RefreshDataSets;
end;

end.

