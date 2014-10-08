unit frmgeneradeudadatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, sqldb, FileUtil, Forms, Controls, Graphics, Dialogs,
    frmquerydatamodule;

type

  { TGeneraDeudaDataModule }

  TGeneraDeudaDataModule = class(TQueryDataModule)
    ds1: TDatasource;
    qry1: TSQLQuery;
    qry1ACTIVO: TSmallintField;
    qry1ID: TLongintField;
    qry1MONTO_DEUDA: TFloatField;
    qry1MONTO_PAGADO: TFloatField;
    qry1PERSONAID: TLongintField;
    qry1SALDO: TFloatField;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  GeneraDeudaDataModule: TGeneraDeudaDataModule;

implementation

{$R *.lfm}

end.

