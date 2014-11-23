unit frmnotasdatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmquerydatamodule, sqldb, DB, sqlscript;

type
  TEstadoMatricula = (maConfirmadas, maNoConfirmadas, maTodas);
  TEstadoAlumnos = (alConfirmados, alNoConfirmados, alTodos);
  { TCriterios }

  TCriterios = record
    KeyWord: string;
    Alumnos: TEstadoAlumnos;
    Matriculas: TEstadoMatricula;
  end;

  { TNotasDataModule }

  TNotasDataModule = class(TQueryDataModule)
  private
    FCriterios: TCriterios;
    procedure SetCriterios(AValue: TCriterios);
  public
    property Criterios: TCriterios read FCriterios write SetCriterios;
  published
    dsNotasView: TDataSource;
    NotasView: TSQLQuery;
    CalcularNota: TSQLScript;
    NotasViewACTIVA: TSmallintField;
    NotasViewALUMNOPERSONAID: TLongintField;
    NotasViewAPELLIDO: TStringField;
    NotasViewCEDULA: TStringField;
    NotasViewCONFIRMADA: TSmallintField;
    NotasViewCONFIRMADO: TSmallintField;
    NotasViewDERECHOEXAMEN: TSmallintField;
    NotasViewDESARROLLOMATERIAID: TLongintField;
    NotasViewFECHA: TDateField;
    NotasViewFECHA_NOTA: TDateField;
    NotasViewID: TLongintField;
    NotasViewNOMBRE: TStringField;
    NotasViewNOTA: TLongintField;
    NotasViewOBSERVACIONES: TStringField;
    NotasViewOBS_NOTA: TStringField;
    NotasViewPUNTAJE: TFloatField;
    NotasViewSECCION: TStringField;
    //procedure CalcularNotas
    procedure CalcularNotaException(Sender: TObject; Statement: TStrings;
      TheException: Exception; var Continue: boolean);
    procedure FilterRecord; overload;
    procedure DataModuleCreate(Sender: TObject); override;
  end;

var
  NotasDataModule: TNotasDataModule;

implementation

{$R *.lfm}

{ TNotasDataModule }

procedure TNotasDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  QryList.Add(TObject(NotasView));
  SearchFieldList.Add('NOMBRE');
  SearchFieldList.Add('APELLIDO');
  SearchFieldList.Add('CEDULA');
  SetReadOnly(True);
end;

procedure TNotasDataModule.SetCriterios(AValue: TCriterios);
begin
  FCriterios := AValue;
  FilterRecord;
end;

procedure TNotasDataModule.CalcularNotaException(Sender: TObject;
  Statement: TStrings; TheException: Exception; var Continue: boolean);
begin
  Continue := False;
  MasterDataModule.Rollback;
end;

procedure TNotasDataModule.FilterRecord;
var
  AFilterStr: string;
  i: integer;
begin
  if (SearchFieldList.Count > 0) and (Trim(Criterios.KeyWord) <> '') then
  begin
    AFilterStr := '(UPPER(' + SearchFieldList[0] + ') LIKE ' +
      QuotedStr('%' + UpperCase(Criterios.KeyWord) + '%');
    for i := 1 to Pred(SearchFieldList.Count) do
    begin
      AFilterStr := AFilterStr + ' OR UPPER(' + SearchFieldList[i] +
        ') LIKE ' + QuotedStr('%' + UpperCase(Criterios.KeyWord) + '%');
    end;
    AFilterStr := AFilterStr + ')';
    if not ((Criterios.Alumnos in [alTodos]) and
      (Criterios.Matriculas in [maTodas])) then
      AFilterStr := AFilterStr + ' AND ';
  end;
  case Criterios.Alumnos of
    alConfirmados:
    begin
      AFilterStr := AFilterStr + '(CONFIRMADO = 1)';
    end;
    alNoConfirmados:
    begin
      AFilterStr := AFilterStr + '(CONFIRMADO = 0)';
    end;
  end;
  if (Criterios.Alumnos <> alTodos) and (Criterios.Matriculas <> maTodas) then
    AFilterStr := AFilterStr + ' AND ';
  case Criterios.Matriculas of
    maConfirmadas:
    begin
      AFilterStr := AFilterStr + '(CONFIRMADA = 1)';
    end;
    maNoConfirmadas:
    begin
      AFilterStr := AFilterStr + '(CONFIRMADA = 0)';
    end;
  end;
  NotasView.Close;
  if AFilterStr <> '' then
  begin
    NotasView.ServerFilter := AFilterStr;
    NotasView.ServerFiltered := True;
  end
  else
    NotasView.ServerFiltered := False;
  NotasView.Open;
end;

end.
