unit frmregistroanecdoticodatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, sgcdTypes,
  frmquerydatamodule, sqldb, DB, frmpersonasdatamodule;

resourcestring
  rsGenName = 'GEN_REG_ANECDOTICO';

type

  { TRegistroAnecdoticoDataModule }

  TRegistroAnecdoticoDataModule = class(TQueryDataModule)
    RegistroAnecdoticoALUMNOPERSONAID: TLongintField;
    RegistroAnecdoticoCONTEXTO: TStringField;
    RegistroAnecdoticoEVENTO: TStringField;
    RegistroAnecdoticoFECHA: TDateField;
    RegistroAnecdoticoID: TLongintField;
    procedure RegistroAnecdoticoNewRecord(DataSet: TDataSet);
  private
    FPersonas: TPersonasDataModule;
    procedure SetPersonas(AValue: TPersonasDataModule);
  published
    dsRegistroAnecdotico: TDataSource;
    RegistroAnecdotico: TSQLQuery;
    procedure PersonasRolesAfterScroll(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DataModuleDestroy(Sender: TObject);
    property Personas: TPersonasDataModule read FPersonas write SetPersonas;
  end;

var
  RegistroAnecdoticoDataModule: TRegistroAnecdoticoDataModule;

implementation

{$R *.lfm}

{ TRegistroAnecdoticoDataModule }

procedure TRegistroAnecdoticoDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  FPersonas := TPersonasDataModule.Create(Self, MasterDataModule);
  QryList.Add(TObject(RegistroAnecdotico));
  AuxQryList.Add(TObject(FPersonas.PersonasRoles));
  FPersonas.PersonasRoles.AfterScroll := @PersonasRolesAfterScroll;
  FPersonas.FilterData('', roAlumno);
end;

procedure TRegistroAnecdoticoDataModule.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  if not Assigned(FPersonas) then
    FreeAndNil(FPersonas);
end;

procedure TRegistroAnecdoticoDataModule.RegistroAnecdoticoNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenName);
  DataSet.FieldByName('ALUMNOPERSONAID').Value :=
    FPersonas.PersonasRoles.FieldByName('ID').Value;
end;

procedure TRegistroAnecdoticoDataModule.SetPersonas(AValue: TPersonasDataModule);
begin
  if FPersonas = AValue then
    Exit;
  FPersonas := AValue;
end;

procedure TRegistroAnecdoticoDataModule.PersonasRolesAfterScroll(DataSet: TDataSet);
begin
  RegistroAnecdotico.Close;
  RegistroAnecdotico.ParamByName('ALUMNOPERSONAID').Value :=
    DataSet.FieldByName('ID').Value;
  RegistroAnecdotico.Open;
end;

end.
