unit frmprocesomatriculacion;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, StdCtrls, DBGrids, PairSplitter, Buttons, DBCtrls,
  ExtCtrls, LazHelpHTML, frmproceso, mensajes, matriculactrl, sgcdTypes;

type

  { TProcesoMatriculacion }

  TProcesoMatriculacion = class(TProceso)
    DBTextAlumno: TDBText;
    procedure MenuItemGenerarClick(Sender: TObject);
  protected
    function GetCustomController: TMatriculaController;
  published
    BitBtnAgregar: TBitBtn;
    BitBtnEliminar: TBitBtn;
    ButtonSeleccionarAlumno: TButton;
    DBGridMaterias: TDBGrid;
    DBGridSecciones: TDBGrid;
    DBGridMatricula: TDBGrid;
    GroupBoxMatricula: TGroupBox;
    LabelMatriculas: TLabel;
    LabelMaterias: TLabel;
    MenuItemOpciones: TMenuItem;
    MenuItemGenerar: TMenuItem;
    PairSplitter1: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    Panel1: TPanel;
    procedure BitBtnAgregarClick(Sender: TObject);
    procedure BitBtnEliminarClick(Sender: TObject);
    procedure ButtonSeleccionarAlumnoClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure ObserverUpdate(const Subject: IInterface); override;
    procedure OKButtonClick(Sender: TObject);
  end;

var
  ProcesoMatriculacion: TProcesoMatriculacion;

implementation

{$R *.lfm}

{ TProcesoMatriculacion }

procedure TProcesoMatriculacion.ObserverUpdate(const Subject: IInterface);
begin
  inherited ObserverUpdate(Subject);
  if GetCustomController.OpcionAutoGenerarDeudas then
    MenuItemGenerar.Checked := True
  else
    MenuItemGenerar.Checked := False;
  case GetCustomController.GetEstado of
    edInicial:
    begin
      GroupBoxMatricula.Enabled := False;
      DBGridMaterias.Enabled := False;
      DBGridMatricula.Enabled := False;
      DBGridSecciones.Enabled := False;
      ButtonPanel1.OKButton.Enabled := False;
      ButtonPanel1.CancelButton.Enabled := False;
      DBTextAlumno.Visible := False;
    end;
    edEditando:
    begin
      GroupBoxMatricula.Enabled := True;
      DBGridMaterias.Enabled := True;
      DBGridMatricula.Enabled := True;
      DBGridSecciones.Enabled := True;
      ButtonPanel1.OKButton.Enabled := True;
      ButtonPanel1.CancelButton.Enabled := True;
      DBTextAlumno.Visible := True;
    end;
    edGuardado:
    begin
      GroupBoxMatricula.Enabled := False;
      DBGridMaterias.Enabled := False;
      DBGridMatricula.Enabled := False;
      DBGridSecciones.Enabled := False;
      ButtonPanel1.OKButton.Enabled := False;
      ButtonPanel1.CancelButton.Enabled := False;
      DBTextAlumno.Visible := False;
    end;
  end;
end;

procedure TProcesoMatriculacion.OKButtonClick(Sender: TObject);
begin
  GetController.Save(Self); // dentro del save del custom controller ya comitea
end;

procedure TProcesoMatriculacion.MenuItemGenerarClick(Sender: TObject);
begin
  // si esta chequeado entonces se manda falso ya que es un boton 'toggle'
  if TMenuItem(Sender).Checked then
    GetCustomController.SetOpcionAutoGenerarDeudas(False)
  else
    GetCustomController.SetOpcionAutoGenerarDeudas(True);
end;

function TProcesoMatriculacion.GetCustomController: TMatriculaController;
begin
  Result := GetController as TMatriculaController;
end;

procedure TProcesoMatriculacion.BitBtnAgregarClick(Sender: TObject);
begin
  GetCustomController.AgregarMateria(Self);
  DBGridMatricula.AutoSizeColumns;
end;

procedure TProcesoMatriculacion.BitBtnEliminarClick(Sender: TObject);
begin
  GetCustomController.EliminarMatricula(Self);
  DBGridMatricula.AutoSizeColumns;
end;

procedure TProcesoMatriculacion.ButtonSeleccionarAlumnoClick(Sender: TObject);
begin
  GetCustomController.SeleccionarAlumno(Self);
end;

procedure TProcesoMatriculacion.CancelButtonClick(Sender: TObject);
begin
  GetController.Cancel(Self);
  GetController.Rollback(Self);
  GetController.CloseDataSets(Self);
end;

end.

