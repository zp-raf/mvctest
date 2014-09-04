unit frmAcademia;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynMemo, Forms, Controls, Graphics, Dialogs,
  Menus, ExtCtrls, StdCtrls, ButtonPanel, DBCtrls, DBGrids, frmAbm, DB, sqldb,
  frmsgcddatamodule, contnrs, Grids, PopupNotifier;

type
  THackDBGrid = class(TDBGrid);

type
  { TABMAcademia }
  TABMAcademia = class(TAbm)
    EditNuevoNombre: TEdit;
    LabelPopupText: TLabel;
    LabelNuevoNombre: TLabel;
    LabelNombre: TLabel;
    PanelPopup: TPanel;
    SQLQuery1ID: TLongintField;
    SQLQuery1NOMBRE: TStringField;
    procedure Actualizar; override;
    function DatosValidos: boolean; override;
    procedure DBGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer); override;
    procedure DBGrid2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer); override;
    procedure FormCreate(Sender: TObject); override;
    procedure Insertar; override;
    procedure LimpiarCampos; override;
    procedure MenuItemNuevoClick(Sender: TObject); override;
    procedure ModificarDatos; override;
    procedure OKButtonClick(Sender: TObject); override;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ABMAcademia: TABMAcademia;

implementation

{$R *.lfm}

{ TABMAcademia }

{
 ****************************************
 QUERYS DE LA VISTA A UTILIZAR
 ****************************************
 }

procedure TABMAcademia.FormCreate(Sender: TObject);
begin
 { Self.Query := 'SELECT * FROM ACADEMIA';
  Self.InsQuery := 'INSERT INTO ACADEMIA (ID, NOMBRE) ' +
    'VALUES ( (SELECT COALESCE(MAX(ID), 0)+1 AS ID FROM ACADEMIA), :NOMBRE)';}
 IniciaForm ('ACADEMIA', 'ID');
 inherited;
  Self.WhereQuery := ' WHERE NOMBRE CONTAINING UPPER('':PARAMETER'')';
end;

{
 **********************************************
 MANEJO DE OPERACIONES CON DATOS
 **********************************************
 }

procedure TABMAcademia.Insertar;
begin
  SQLQuery1.FieldByName('ID').Required := False;
  SQLQuery1.Append;
  SQLQuery1NOMBRE.AsString := Filtrar(EditNuevoNombre.Text);
end;

procedure TABMAcademia.Actualizar;
begin
  SQLQuery1.Edit;
  SQLQuery1NOMBRE.AsString := Filtrar(EditNuevoNombre.Text);
end;

{
 ***********************************************
 MANEJO DE LOS ELEMENTOS VISUALES DE LA VENTANA
 ***********************************************
}
procedure TABMAcademia.LimpiarCampos;
begin
  inherited;
  EditNuevoNombre.Clear;
end;

procedure TABMAcademia.ModificarDatos;
begin
  EditNuevoNombre.SetFocus;
  EditNuevoNombre.Text := SQLQuery1NOMBRE.AsString;
  Estado := Modificacion;
end;

{
 ************************************************
 MANEJO DE VALIDACIONES DE CAMPOS
 ************************************************
 }
function TABMAcademia.DatosValidos: boolean;
begin
  if (Trim(EditNuevoNombre.Text) = '') then
  begin
    MessageDlg('Informacion', 'Complete los campos requeridos',
      mtInformation, [mbOK], 0);
    Result := False;
  end
  else
  begin
    Result := True;
  end;
end;

procedure TABMAcademia.DBGrid1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if Button in [mbRight] then
    MessageDlg('Contenido del campo',
      '*Nombre: ' + SQLQuery1NOMBRE.AsString, mtCustom, [mbOK], 0);
end;

procedure TABMAcademia.DBGrid2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if Button in [mbRight] then
    MessageDlg('Contenido del campo',
      '-Nombre: ' + SQLQuery1NOMBRE.AsString, mtCustom, [mbOK], 0);
end;

{
 ********************************************************
 MANEJO DE LAS ACCIONES DE LOS MENUS
 ********************************************************
 }

procedure TABMAcademia.MenuItemNuevoClick(Sender: TObject);
begin
  inherited;
  EditNuevoNombre.SetFocus;
end;

{
 ********************************************************
 MANEJO DE LAS ACCIONES DE LOS BOTONES
 ********************************************************
 }

procedure TABMAcademia.OKButtonClick(Sender: TObject);
begin
  inherited;
  if Estado in [Alta] then
    EditNuevoNombre.SetFocus;
end;

end.
