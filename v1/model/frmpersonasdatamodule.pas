unit frmpersonasdatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, frmsgcddatamodule,
  frmquerydatamodule, sqldb, DB, sgcdTypes;

resourcestring
  rsGenName = 'GEN_ACADEMIA';
  rsGenNameDir = 'GEN_DIRECCION';
  rsGenNameTel = 'GEN_TEL';
  rsDocTypeNotSelected = 'No se selecciono el tipo de comprobante';

type

  { TPersonasDataModule }

  TPersonasDataModule = class(TQueryDataModule)
  published
    dsPersonasRoles: TDataSource;
    DireccionBARRIO: TStringField;
    DireccionCIUDAD: TStringField;
    DireccionDEPARTAMENTO: TStringField;
    DireccionDESCRIPCION: TStringField;
    DireccionDIRECCION: TStringField;
    DireccionID: TLongintField;
    DireccionIDPERSONA: TLongintField;
    dsTelefono: TDataSource;
    dsDireccion: TDataSource;
    dsPersona: TDataSource;
    Persona: TSQLQuery;
    Direccion: TSQLQuery;
    PersonaACTIVO: TSmallintField;
    PersonaAPELLIDO: TStringField;
    PersonaCEDULA: TStringField;
    PersonaFECHANAC: TDateField;
    PersonaID: TLongintField;
    PersonaNOMBRE: TStringField;
    PersonaNOMBRECOMPLETO: TStringField;
    PersonaRUC: TStringField;
    PersonaSEXO: TStringField;
    PersonasRoles: TSQLQuery;
    PersonasRolesACTIVO: TSmallintField;
    PersonasRolesAPELLIDO: TStringField;
    PersonasRolesCEDULA: TStringField;
    PersonasRolesESADMINISTRATIVO: TLongintField;
    PersonasRolesESALUMNO: TLongintField;
    PersonasRolesESCOORDINADOR: TLongintField;
    PersonasRolesESENCARGADO: TLongintField;
    PersonasRolesESINTERVENTOR: TLongintField;
    PersonasRolesESPROFESOR: TLongintField;
    PersonasRolesESPROVEEDOR: TLongintField;
    PersonasRolesESVEEDOR: TLongintField;
    PersonasRolesFECHANAC: TDateField;
    PersonasRolesID: TLongintField;
    PersonasRolesNOMBRE: TStringField;
    PersonasRolesNOMBRECOMPLETO: TStringField;
    PersonasRolesSEXO: TStringField;
    Telefono: TSQLQuery;
    TelefonoDESCRIPCION: TStringField;
    TelefonoID: TLongintField;
    TelefonoIDPERSONA: TLongintField;
    TelefonoNUMERO: TStringField;
    TelefonoPREFIJO: TStringField;
    procedure DataModuleCreate(Sender: TObject); override;
    procedure DireccionAfterInsert(DataSet: TDataSet);
    procedure FilterData(ASearchText: string; ARol: TRolPersona); overload;
    procedure PersonaAfterScroll(DataSet: TDataSet);
    procedure PersonaNewRecord(DataSet: TDataSet);
    procedure TelefonoAfterInsert(DataSet: TDataSet);
  end;

var
  PersonasDataModule: TPersonasDataModule;

implementation

{$R *.lfm}

{ TPersonasDataModule }

procedure TPersonasDataModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  QryList.Add(TObject(Persona));
  QryList.Add(TObject(Direccion));
  QryList.Add(TObject(Telefono));
  AuxQryList.Add(TObject(PersonasRoles));
  SearchFieldList.Add('NOMBRE');
  SearchFieldList.Add('APELLIDO');
  SearchFieldList.Add('CEDULA');
  Persona.OnFilterRecord := @FilterRecord;
end;

procedure TPersonasDataModule.DireccionAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('IDPERSONA').Value := Persona.FieldByName('ID').Value;
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenNameDir);
end;

procedure TPersonasDataModule.FilterData(ASearchText: string; ARol: TRolPersona);
var
  AFilterStr: string;
  i: integer;
begin
  if (SearchFieldList.Count > 0) and (Trim(ASearchText) <> '') then
  begin
    AFilterStr := '(UPPER(' + SearchFieldList[0] + ') LIKE ' +
      QuotedStr('%' + UpperCase(ASearchText) + '%');
    for i := 1 to Pred(SearchFieldList.Count) do
    begin
      AFilterStr := AFilterStr + ' OR UPPER(' + SearchFieldList[i] + ') LIKE ' +
        QuotedStr('%' + UpperCase(ASearchText) + '%');
    end;
    AFilterStr := AFilterStr + ')';
    // ???: sacar esto cuando se halle mejor solucion a este problema
    if not (ARol in [roCualquiera]) then
      AFilterStr := AFilterStr + ' AND ';
  end;
  case ARol of
    roCualquiera:
    begin
      // nada
    end;
    roExterno:
    begin
      AFilterStr := AFilterStr +
        '(ESVEEDOR = 1 OR ESINTERVENTOR = 1 OR ESENCARGADO = 1 OR ESPROVEEDOR = 1)';
    end;
    roAlumno:
    begin
      AFilterStr := AFilterStr + '(ESALUMNO = 1)';
    end;
    roProveedor:
    begin
      AFilterStr := AFilterStr + '(ESPROVEEDOR = 1)';
    end;
  end;
  //ShowMessage(AFilterStr);
  PersonasRoles.Close;
  PersonasRoles.ServerFilter := AFilterStr;
  if not (Trim(AFilterStr) = '') then
    PersonasRoles.ServerFiltered := True
  else
    PersonasRoles.ServerFiltered := False;
  PersonasRoles.Open;
end;

procedure TPersonasDataModule.PersonaAfterScroll(DataSet: TDataSet);
begin
  Telefono.Close;
  Direccion.Close;
  Telefono.ParamByName('ID').Value := DataSet.FieldByName('ID').Value;
  Direccion.ParamByName('ID').Value := DataSet.FieldByName('ID').Value;
  Telefono.Open;
  Direccion.Open;
end;

procedure TPersonasDataModule.PersonaNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenName);
end;

procedure TPersonasDataModule.TelefonoAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('IDPERSONA').Value := Persona.FieldByName('ID').Value;
  DataSet.FieldByName('ID').AsInteger := MasterDataModule.NextValue(rsGenNameTel);
end;

end.
