unit frmderechoexamendatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmquerydatamodule, DB, sqldb;

type

  { TDerechoExamenDataModule }

  TDerechoExamenDataModule = class(TQueryDataModule)
    AlumnosMatriculas2ACTIVA: TSmallintField;
    AlumnosMatriculas2ALUMNOPERSONAID: TLongintField;
    AlumnosMatriculas2APELLIDO: TStringField;
    AlumnosMatriculas2CEDULA: TStringField;
    AlumnosMatriculas2CONFIRMADA: TSmallintField;
    AlumnosMatriculas2CONFIRMADO: TSmallintField;
    AlumnosMatriculas2DERECHOEXAMEN: TSmallintField;
    AlumnosMatriculas2DESARROLLOMATERIAID: TLongintField;
    AlumnosMatriculas2FECHA: TDateField;
    AlumnosMatriculas2ID: TLongintField;
    AlumnosMatriculas2NOMBRE: TStringField;
    AlumnosMatriculas2OBSERVACIONES: TStringField;
    AlumnosMatriculas2SECCION: TStringField;
    dsDesarrolloFilter: TDataSource;
    dsAlumnosMatriculas2: TDataSource;
    AlumnosMatriculas2: TSQLQuery;
    DesarrolloFilter: TSQLQuery;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DesarrolloFilterAfterScroll(DataSet: TDataSet);
  end;

var
  DerechoExamenDataModule: TDerechoExamenDataModule;

implementation

{$R *.lfm}

{ TDerechoExamenDataModule }

procedure TDerechoExamenDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  QryList.Add(TObject(AlumnosMatriculas2));
  AuxQryList.Add(TObject(DesarrolloFilter));
end;

procedure TDerechoExamenDataModule.DesarrolloFilterAfterScroll(DataSet: TDataSet);
begin
  AlumnosMatriculas2.Close;
  AlumnosMatriculas2.ParamByName('SECCION').AsString :=
    DataSet.FieldByName('SECCION').AsString;
  AlumnosMatriculas2.Open;
end;

end.

