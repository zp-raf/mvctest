unit frmimpuestodadamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, sgcdTypes,
  frmquerydatamodule, sqldb, DB;

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
    procedure DoDeleteAction(ADataSet: TDataSet); override;
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

procedure TImpuestoDataModule.DoDeleteAction(ADataSet: TDataSet);
begin
  if not (ADataSet.State in [dsEdit]) then
    ADataSet.Edit;
  ADataSet.FieldByName('ACTIVO').AsString := DB_FALSE;
end;
end.
