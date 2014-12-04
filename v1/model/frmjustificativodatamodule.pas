unit frmjustificativodatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmquerydatamodule, sqldb, DB, frmpersonasdatamodule;

resourcestring
  rsGenName = 'GEN_JUSTIFICATIVOASISTENCIA';

type

  { TJustificativoDataModule }

  TJustificativoDataModule = class(TQueryDataModule)
  private
    FPersonas: TPersonasDataModule;
    procedure SetPersonas(AValue: TPersonasDataModule);
  published
    dsJustificativoAsistencia: TDataSource;
    JustificativoAsistencia: TSQLQuery;
    JustificativoAsistenciaAPROBADO: TSmallintField;
    JustificativoAsistenciaDETALLES: TStringField;
    JustificativoAsistenciaFECHAINASISTENCIA: TDateField;
    JustificativoAsistenciaFECHAPRESENTACION: TDateField;
    JustificativoAsistenciaID: TLongintField;
    JustificativoAsistenciaMOTIVO: TStringField;
    JustificativoAsistenciaPERSONAID: TLongintField;
    StringField1: TStringField;
    StringField2: TStringField;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DataModuleDestroy(Sender: TObject);
    procedure JustificativoAsistenciaNewRecord(DataSet: TDataSet);
    property Personas: TPersonasDataModule read FPersonas write SetPersonas;
  end;

var
  JustificativoDataModule: TJustificativoDataModule;

implementation

{$R *.lfm}

{ TJustificativoDataModule }

procedure TJustificativoDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  FPersonas := TPersonasDataModule.Create(Self, MasterDataModule);
  QryList.Add(TObject(JustificativoAsistencia));
  AuxQryList.Add(TObject(FPersonas.PersonasRoles));
end;

procedure TJustificativoDataModule.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FPersonas) then
    FreeAndNil(FPersonas);
end;

procedure TJustificativoDataModule.JustificativoAsistenciaNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenName);
  DataSet.FieldByName('APROBADO').AsInteger := 0;
end;

procedure TJustificativoDataModule.SetPersonas(AValue: TPersonasDataModule);
begin
  if FPersonas = AValue then
    Exit;
  FPersonas := AValue;
end;

end.
