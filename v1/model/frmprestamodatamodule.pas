unit frmprestamodatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmquerydatamodule, sqldb, DB, frmequiposdatamodule, frmpersonasdatamodule;

resourcestring
  rsGenName = 'GEN_PRESTAMO';

type

  { TPrestamoDataModule }

  TPrestamoDataModule = class(TQueryDataModule)
    StringField2: TStringField;
    StringField3: TStringField;
  private
    FEquipos: TEquiposDataModule;
    FPersonas: TPersonasDataModule;
    procedure SetEquipos(AValue: TEquiposDataModule);
    procedure SetPersonas(AValue: TPersonasDataModule);
  published
    dsPrestamo: TDataSource;
    Prestamo: TSQLQuery;
    PrestamoEQUIPOID: TLongintField;
    PrestamoFECHAFIN: TDateField;
    PrestamoFECHAINICIO: TDateField;
    PrestamoID: TLongintField;
    PrestamoPERSONAID: TLongintField;
    StringField1: TStringField;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DataModuleDestroy(Sender: TObject);
    procedure EqAfterScroll(DataSet: TDataSet);
    procedure PersAfterScroll(DataSet: TDataSet);
    procedure PrestamoNewRecord(DataSet: TDataSet);
    property Equipos: TEquiposDataModule read FEquipos write SetEquipos;
    property Personas: TPersonasDataModule read FPersonas write SetPersonas;
  end;

var
  PrestamoDataModule: TPrestamoDataModule;

implementation

{$R *.lfm}

{ TPrestamoDataModule }

procedure TPrestamoDataModule.PrestamoNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenName);
end;

procedure TPrestamoDataModule.SetEquipos(AValue: TEquiposDataModule);
begin
  if FEquipos = AValue then
    Exit;
  FEquipos := AValue;
end;

procedure TPrestamoDataModule.SetPersonas(AValue: TPersonasDataModule);
begin
  if FPersonas = AValue then
    Exit;
  FPersonas := AValue;
end;

procedure TPrestamoDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  FEquipos := TEquiposDataModule.Create(Self, MasterDataModule);
  FPersonas := TPersonasDataModule.Create(Self, MasterDataModule);
  QryList.Add(TObject(Prestamo));
  AuxQryList.Add(TObject(FEquipos.Equipo));
  AuxQryList.Add(TObject(FPersonas.PersonasRoles));
  FEquipos.Equipo.AfterScroll := @EqAfterScroll;
  FPersonas.PersonasRoles.AfterScroll := @PersAfterScroll;
end;

procedure TPrestamoDataModule.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FEquipos) then
    FreeAndNil(FEquipos);
  if Assigned(FPersonas) then
    FreeAndNil(FPersonas);
end;

procedure TPrestamoDataModule.EqAfterScroll(DataSet: TDataSet);
begin
  if (Prestamo.State in dsEditModes) then
  begin
    Prestamo.FieldByName('EQUIPOID').Value := DataSet.FieldByName('ID').Value;
  end;
end;

procedure TPrestamoDataModule.PersAfterScroll(DataSet: TDataSet);
begin
  if (Prestamo.State in dsEditModes) then
  begin
    Prestamo.FieldByName('PERSONAID').Value := DataSet.FieldByName('ID').Value;
  end;
end;

end.
