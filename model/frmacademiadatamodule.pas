unit frmacademiadatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, DB, FileUtil, frmsgcddatamodule, mvc, IBConnection;

resourcestring
  rsGenName = 'GEN_ACADEMIA';

type

  { TAcademiaDataModule }

  { para que pueda mandar actualizaciones a las vistas añadidas tiene que
    implementar la interfaz ISubject que tiene todos los metodos pertinentes }
  TAcademiaDataModule = class(TSgcdDataModule, IDBViewModel)
    Datasource1: TDatasource;
    qry: TSQLQuery;
    qryID: TLongintField;
    qryNOMBRE: TStringField;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure qryNewRecord(DataSet: TDataSet);
  end;


var
  AcademiaDataModule: TAcademiaDataModule;

implementation

{$R *.lfm}

{ TAcademiaDataModule }

procedure TAcademiaDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited DataModuleCreate(Sender);
  QryList.Add(TObject(qry));
end;


procedure TAcademiaDataModule.qryNewRecord(DataSet: TDataSet);
begin
  qryID.Value := NextValue(rsGenName);
end;

end.
