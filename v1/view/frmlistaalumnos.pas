unit frmListaALumnos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ButtonPanel, StdCtrls, DBGrids, DBCtrls, ExtCtrls, Buttons, ValEdit, ComCtrls,
  PopupNotifier, frmProceso, sqldb, DB, strutils;

type

  { TProcesoListaALumnos }

  TProcesoListaALumnos = class(TForm)
    qry2: TSQLQuery;
    qry2ALUMNO_CONFIRMADO: TSmallintField;
    qry2APELLIDO: TStringField;
    qry2CEDULA: TStringField;
    qry2FECHANAC: TDateField;
    qry2ID: TLongintField;
    qry2NOMBRE: TStringField;
    qry2SEXO: TStringField;
    Alumnos: TGroupBox;
    CheckBox1: TCheckBox;
    CheckGroup1: TCheckGroup;
    CheckGroup2: TCheckGroup;
    DBGrid1: TDBGrid;
    DBLookupComboBox1: TDBLookupComboBox;
    DBLookupComboBox2: TDBLookupComboBox;
    DBLookupComboBox3: TDBLookupComboBox;
    ds: TDatasource;
    dsDes: TDatasource;
    dsPer: TDatasource;
    dsPro: TDatasource;
    Seleccionar: TGroupBox;
    LabeledEdit1: TLabeledEdit;
    Materia: TLabel;
    Periodo: TLabel;
    Profesor: TLabel;
    qry: TSQLQuery;
    qryALUMNO_CONFIRMADO: TSmallintField;
    qryAPELLIDO: TStringField;
    qryCEDULA: TStringField;
    qryDERECHOEXAMEN: TSmallintField;
    qryDes: TSQLQuery;
    qryDESARROLLOMATERIAID: TLongintField;
    qryDesDESARROLLOMATERIAID: TLongintField;
    qryDesNOMBRE_MATERIA_DET: TStringField;
    qryEMPLEADOPERSONAID: TLongintField;
    qryFECHA: TDateField;
    qryFECHANAC: TDateField;
    qryGRUPOID: TLongintField;
    qryID: TLongintField;
    qryID_MATRICULA: TLongintField;
    qryMATERIAID: TLongintField;
    qryMATRICULA_CONFIRMADA: TSmallintField;
    qryMODULOID: TLongintField;
    qryNOMBRE: TStringField;
    qryNOMBRE_GRUPO: TStringField;
    qryNOMBRE_MATERIA: TStringField;
    qryNOMBRE_MATERIA_DET: TStringField;
    qryNOMBRE_MOD: TStringField;
    qryNOMBRE_PERIODO: TStringField;
    qryNOMBRE_PROFESOR: TStringField;
    qryNOMBRE_SECCION: TStringField;
    qryOBSERVACIONES: TStringField;
    qryPer: TSQLQuery;
    qryPERIODOLECTIVOID: TLongintField;
    qryPerNOMBRE_PERIODO: TStringField;
    qryPerPERIODOLECTIVOID: TLongintField;
    qryPro: TSQLQuery;
    qryProEMPLEADOPERSONAID: TLongintField;
    qryProNOMBRE_PROFESOR: TStringField;
    qrySECCIONID: TLongintField;
    qrySEXO: TStringField;
    SeleccionarNada: TButton;
    SeleccionarTodo: TButton;
    procedure AbrirCursor;
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckGroup1ItemClick(Sender: TObject; Index: integer);
    procedure DBLookupComboBoxChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure qryFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure qry2FilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure SeleccionarNadaClick(Sender: TObject);
    procedure SeleccionarTodoClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ProcesoListaALumnos: TProcesoListaALumnos;

implementation

{$R *.lfm}

{ TProcesoListaALumnos }

procedure TProcesoListaALumnos.qry2FilterRecord(DataSet: TDataSet; var Accept: boolean);
var
  //tengo aca las condiciones que se evaluan en variables separadas
  //para mejorar legibilidad del codigo
  c4, c5: boolean;
begin
  //condicion 4
  with LabeledEdit1 do
  begin
    if (Trim(Text) = '') then
      c4 := True
    else
      c4 := AnsiContainsText(DataSet.FieldByName('NOMBRE').AsString, Trim(Text)) or
        AnsiContainsText(DataSet.FieldByName('APELLIDO').AsString, Trim(Text)) or
        AnsiContainsText(DataSet.FieldByName('CEDULA').AsString, Trim(Text));
  end;
  //condicion 5
  with CheckGroup1 do
  begin
    if Checked[0] and Checked[1] then
      c5 := True
    else if Checked[0] and not Checked[1] then
      if DataSet.FieldByName('ALUMNO_CONFIRMADO').AsInteger = 1 then
        c5 := True
      else
        c5 := False
    else if Checked[1] and not Checked[0] then
      if DataSet.FieldByName('ALUMNO_CONFIRMADO').AsInteger = 0 then
        c5 := True
      else
        c5 := False
    else
      c5 := False;
  end;
  //hallamos el producto booleano de las condiciones para filtrar el dataset
  Accept := c4 and c5;
end;

procedure TProcesoListaALumnos.AbrirCursor;
begin
    qry.Close;
    qry2.Close;
    qryDes.Close;
    qryPer.Close;
    qryPro.Close;
    DBLookupComboBox1.ClearSelection;
    DBLookupComboBox2.ClearSelection;
    DBLookupComboBox3.ClearSelection;
    qry.Open;
    qry2.Open;
    qryDes.Open;
    qryPer.Open;
    qryPro.Open;
end;

procedure TProcesoListaALumnos.CheckBox1Change(Sender: TObject);
begin
  if TCheckBox(Sender).Checked then
  begin
    DBLookupComboBox1.Enabled := True;
    DBLookupComboBox2.Enabled := True;
    DBLookupComboBox3.Enabled := True;
    CheckGroup2.Enabled := True;
    ds.DataSet := qry;
    AbrirCursor;
  end
  else
  begin
    DBLookupComboBox1.Enabled := False;
    DBLookupComboBox2.Enabled := False;
    DBLookupComboBox3.Enabled := False;
    CheckGroup2.Enabled := False;
    ds.DataSet := qry2;
    AbrirCursor;
  end;
end;

procedure TProcesoListaALumnos.CheckGroup1ItemClick(Sender: TObject; Index: integer);
begin
  DBGrid1.DataSource.DataSet.Refresh;
end;

procedure TProcesoListaALumnos.DBLookupComboBoxChange(Sender: TObject);
begin
  qry.Refresh;
  DBGrid1.Refresh;
end;

procedure TProcesoListaALumnos.FormCreate(Sender: TObject);
begin
  AbrirCursor;
end;

procedure TProcesoListaALumnos.LabeledEdit1Change(Sender: TObject);
begin
  DBGrid1.DataSource.DataSet.Refresh;
end;

procedure TProcesoListaALumnos.qryFilterRecord(DataSet: TDataSet; var Accept: boolean);
var
  //tengo aca las condiciones que se evaluan en variables separadas
  //para mejorar legibilidad del codigo
  c1, c2, c3, c4, c5, c6: boolean;
begin
  //condicion 1
  if (Trim(DBLookupComboBox1.Text) = '') then
    c1 := True
  else
    c1 := DataSet.FieldByName('DESARROLLOMATERIAID').AsInteger =
      qryDesDESARROLLOMATERIAID.AsInteger;
  //condicion2
  if (Trim(DBLookupComboBox2.Text) = '') then
    c2 := True
  else
    c2 := DataSet.FieldByName('PERIODOLECTIVOID').AsInteger =
      qryPerPERIODOLECTIVOID.AsInteger;
  //condicion 3
  if (Trim(DBLookupComboBox3.Text) = '') then
    c3 := True
  else
    c3 := DataSet.FieldByName('EMPLEADOPERSONAID').AsInteger =
      qryProEMPLEADOPERSONAID.AsInteger;
  //condicion 4
  with LabeledEdit1 do
  begin
    if (Trim(Text) = '') then
      c4 := True
    else
      c4 := AnsiContainsText(DataSet.FieldByName('NOMBRE').AsString, Trim(Text)) or
        AnsiContainsText(DataSet.FieldByName('APELLIDO').AsString, Trim(Text)) or
        AnsiContainsText(DataSet.FieldByName('CEDULA').AsString, Trim(Text));
  end;
  //condicion 5
  with CheckGroup1 do
  begin
    if Checked[0] and Checked[1] then
      c5 := True
    else if Checked[0] and not Checked[1] then
      if DataSet.FieldByName('ALUMNO_CONFIRMADO').AsInteger = 1 then
        c5 := True
      else
        c5 := False
    else if Checked[1] and not Checked[0] then
      if DataSet.FieldByName('ALUMNO_CONFIRMADO').AsInteger = 0 then
        c5 := True
      else
        c5 := False
    else
      c5 := False;
  end;
  //condicion 6
  with CheckGroup2 do
  begin
    if Checked[0] and Checked[1] then
      c6 := True
    else if Checked[0] and not Checked[1] then
      if DataSet.FieldByName('MATRICULA_CONFIRMADA').AsInteger = 1 then
        c6 := True
      else
        c6 := False
    else if Checked[1] and not Checked[0] then
      if DataSet.FieldByName('MATRICULA_CONFIRMADA').AsInteger = 0 then
        c6 := True
      else
        c6 := False
    else
      c6 := False;
  end;
  //hallamos el producto booleano de las condiciones para filtrar el dataset
  Accept := c1 and c2 and c3 and c4 and c5 and c6;
end;

procedure TProcesoListaALumnos.SeleccionarNadaClick(Sender: TObject);
begin
  with DBGrid1 do
  begin
    SelectedRows.Clear;
    DataSource.DataSet.First;
  end;
end;

procedure TProcesoListaALumnos.SeleccionarTodoClick(Sender: TObject);
begin
  SeleccionarNadaClick(nil);
  with DBGrid1.DataSource.DataSet do
  begin
    DisableControls;
    First;
    try
      while not EOF do
      begin
        DBGrid1.SelectedRows.CurrentRowSelected := True;
        Next;
      end;
    finally
      EnableControls;
    end;
  end;
end;

end.

