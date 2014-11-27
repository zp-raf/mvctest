unit frmimpuestodadamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, 
    frmquerydatamodule, sqldb, db;
resourcestring
  rsGenName = 'GEN_IMPUESTO';

type

  { TImpuestoDataModule }

  TImpuestoDataModule = class(TQueryDataModule)
    dsImpuesto: TDataSource;
    Impuesto: TSQLQuery;
    ImpuestoACTIVO: TSmallintField;
    ImpuestoFACTOR: TFloatField;
    ImpuestoID: TLongintField;
    ImpuestoNOMBRE: TStringField;
    procedure DataModuleCreate(Sender: TObject); override;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ImpuestoDataModule: TImpuestoDataModule;

implementation

{$R *.lfm}

{ TImpuestoDataModule }

procedure TImpuestoDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  QryList.Add(TObject(Impuesto));
  SearchFieldList.Add('NOMBRE');
end;


end.

