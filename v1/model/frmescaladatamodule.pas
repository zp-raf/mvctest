unit frmescaladatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmquerydatamodule, sqldb, DB;

resourcestring
  rsGenName = 'GEN_ESCALA';

type

  { TEscalaDataModule }

  TEscalaDataModule = class(TQueryDataModule)
    dsEscala: TDataSource;
    Escala: TSQLQuery;
    EscalaAPRUEBA: TSmallintField;
    EscalaID: TLongintField;
    EscalaLIMITEINF: TFloatField;
    EscalaLIMITESUP: TFloatField;
    EscalaNOTA: TLongintField;
    EscalaVALIDO: TSmallintField;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure EscalaNewRecord(DataSet: TDataSet);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  EscalaDataModule: TEscalaDataModule;

implementation

{$R *.lfm}

{ TEscalaDataModule }

procedure TEscalaDataModule.EscalaNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').Value := MasterDataModule.NextValue(rsGenName);
  DataSet.FieldByName('VALIDO').Value := 1;//por defecto activo
end;

procedure TEscalaDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  QryList.Add(TObject(Escala));
end;

end.
