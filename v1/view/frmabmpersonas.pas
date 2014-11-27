unit frmabmpersonas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, DBCtrls, ComCtrls, ButtonPanel, DBGrids, StdCtrls, EditBtn,
  personactrl, frmAbm, mensajes, sgcdTypes;

const
  ALUMNO = 0;
  COORDINADOR = 1;
  ADMINISTRATIVO = 2;
  PROFESOR = 3;
  ENCARGADO = 4;
  PROVEEDOR = 5;

type

  { TAbmPersonas }

  TAbmPersonas = class(TAbm)
    ButtonSeleccionarAcad: TButton;
    ButtonSeleccionarAreas: TButton;
    CheckGroupRoles: TCheckGroup;
    DBGridDireccion: TDBGrid;
    DBGridTelefono: TDBGrid;
    DBNavigator1: TDBNavigator;
    DBNavigator2: TDBNavigator;
    LabelDirecciones: TLabel;
    LabelTelefonos: TLabel;
    procedure ButtonSeleccionarAcadClick(Sender: TObject);
    procedure ButtonSeleccionarAreasClick(Sender: TObject);
    procedure CheckGroupRolesItemClick(Sender: TObject; Index: integer);
  protected
    function GetCustomController: TPersonaController;
  published
    DateEditFechaNac: TDateEdit;
    DBCheckBoxActivo: TDBCheckBox;
    DBEditNombres: TDBEdit;
    DBEditApellidos: TDBEdit;
    DBEditCedula: TDBEdit;
    DBEditRuc: TDBEdit;
    DBRadioGroupSexo: TDBRadioGroup;
    GroupBoxDatosBasicos: TGroupBox;
    GroupBoxDetalles: TGroupBox;
    LabelFechaNac: TLabel;
    LabelRuc: TLabel;
    LabelCedula: TLabel;
    LabelApellidos: TLabel;
    LabelNombres: TLabel;
    procedure DateEditFechaNacAcceptDate(Sender: TObject; var ADate: TDateTime;
      var AcceptDate: boolean);
    procedure DateEditFechaNacEditingDone(Sender: TObject);
    procedure ObserverUpdate(const Subject: IInterface); override;
  end;

var
  AbmPersonas: TAbmPersonas;

implementation

{$R *.lfm}

{ TAbmPersonas }

procedure TAbmPersonas.DateEditFechaNacAcceptDate(Sender: TObject;
  var ADate: TDateTime; var AcceptDate: boolean);
begin
  if not GetController.IsValidDate(ADate) then
  begin
    ShowErrorMessage(rsInvalidDate);
    AcceptDate := False;
  end
  else
  begin
    AcceptDate := True;
    GetCustomController.SetFechaNac(ADate, Self);
  end;
end;

procedure TAbmPersonas.DateEditFechaNacEditingDone(Sender: TObject);
begin
  if not GetController.IsValidDate(DateEditFechaNac.Date) then
  begin
    ShowErrorMessage(rsInvalidDate);
    DateEditFechaNac.Clear;
  end
  else
    GetCustomController.SetFechaNac(DateEditFechaNac.Date, Self);
end;

procedure TAbmPersonas.ObserverUpdate(const Subject: IInterface);
var
  i: integer;
  Arr: TRoles;
begin
  inherited ObserverUpdate(Subject);
  DateEditFechaNac.Date := GetCustomController.GetFechaNac(Self);
  Arr := GetCustomController.GetRol(Self);
  if Arr = nil then
    Exit;
  for i := 0 to Pred(CheckGroupRoles.Items.Count) do
  begin
    CheckGroupRoles.Checked[i] := False;
  end;
  ButtonSeleccionarAreas.Visible := False;
  ButtonSeleccionarAcad.Visible := False;
  for i := 0 to Pred(Length(Arr)) do
  begin
    case Arr[i] of
      roAlumno:
      begin
        CheckGroupRoles.Checked[ALUMNO] := True;
        ButtonSeleccionarAreas.Visible := True;
        ButtonSeleccionarAcad.Visible := True;
      end;
      roCoordinador: CheckGroupRoles.Checked[COORDINADOR] := True;
      roAdministrativo: CheckGroupRoles.Checked[ADMINISTRATIVO] := True;
      roProfesor: CheckGroupRoles.Checked[PROFESOR] := True;
      roEncargado: CheckGroupRoles.Checked[ENCARGADO] := True;
      roProveedor: CheckGroupRoles.Checked[PROVEEDOR] := True;
    end;
  end;
end;

procedure TAbmPersonas.CheckGroupRolesItemClick(Sender: TObject; Index: integer);
begin
  case Index of
    ALUMNO:
    begin
      if CheckGroupRoles.Checked[Index] then
        GetCustomController.SetRol(roAlumno, True, Self)
      else
        GetCustomController.SetRol(roAlumno, False, Self);
    end;
    COORDINADOR:
    begin
      if CheckGroupRoles.Checked[Index] then
        GetCustomController.SetRol(roCoordinador, True, Self)
      else
        GetCustomController.SetRol(roCoordinador, False, Self);
    end;
    ADMINISTRATIVO:
    begin
      if CheckGroupRoles.Checked[Index] then
        GetCustomController.SetRol(roAdministrativo, True, Self)
      else
        GetCustomController.SetRol(roAdministrativo, False, Self);
    end;
    PROFESOR:
    begin
      if CheckGroupRoles.Checked[Index] then
        GetCustomController.SetRol(roProfesor, True, Self)
      else
        GetCustomController.SetRol(roProfesor, False, Self);
    end;
    ENCARGADO:
    begin
      if CheckGroupRoles.Checked[Index] then
        GetCustomController.SetRol(roEncargado, True, Self)
      else
        GetCustomController.SetRol(roEncargado, False, Self);
    end;
    PROVEEDOR:
    begin
      if CheckGroupRoles.Checked[Index] then
        GetCustomController.SetRol(roProveedor, True, Self)
      else
        GetCustomController.SetRol(roProveedor, False, Self);
    end;
  end;
end;

procedure TAbmPersonas.ButtonSeleccionarAreasClick(Sender: TObject);
begin
  GetCustomController.SeleccionarAreas(Self);
end;

procedure TAbmPersonas.ButtonSeleccionarAcadClick(Sender: TObject);
begin
  GetCustomController.SeleccionarAcademias(Self);
end;

function TAbmPersonas.GetCustomController: TPersonaController;
begin
  Result := GetController as TPersonaController;
end;

end.
