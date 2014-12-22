unit frmprocesonotas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, DBGrids, ExtCtrls, StdCtrls, LazHelpHTML, frmproceso,
  notasctrl, frmnotasdatamodule;

type

  { TProcesoNotas }

  TProcesoNotas = class(TProceso)
    CheckBoxTodos: TCheckBox;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    procedure CheckBoxTodosChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
  protected
    function GetCustomController: TNotasController;
  published
    DBGrid1: TDBGrid;
    LabeledEdit1: TLabeledEdit;
    Seleccionar: TGroupBox;
    SeleccionarNada: TButton;
    SeleccionarTodo: TButton;
    procedure LabeledEdit1Change(Sender: TObject);
    procedure CambiarCriterios;
    procedure SeleccionarNadaClick(Sender: TObject);
    procedure SeleccionarTodoClick(Sender: TObject);
  end;

var
  ProcesoNotas: TProcesoNotas;

implementation

{$R *.lfm}

{ TProcesoNotas }

procedure TProcesoNotas.SeleccionarTodoClick(Sender: TObject);
begin
  SeleccionarNadaClick(DBGrid1);
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

procedure TProcesoNotas.SeleccionarNadaClick(Sender: TObject);
begin
  with DBGrid1 do
  begin
    SelectedRows.Clear;
    DataSource.DataSet.First;
  end;
end;

procedure TProcesoNotas.LabeledEdit1Change(Sender: TObject);
begin
  CambiarCriterios;
end;

procedure TProcesoNotas.RadioGroup1Click(Sender: TObject);
begin
  CambiarCriterios;
end;

procedure TProcesoNotas.OKButtonClick(Sender: TObject);
begin
  GetCustomController.CalcularNotas(Pointer(DBGrid1), Self);
end;

procedure TProcesoNotas.CheckBoxTodosChange(Sender: TObject);
begin
  GetCustomController.MostrarTodos(CheckBoxTodos.Checked, Self);
end;

procedure TProcesoNotas.FormShow(Sender: TObject);
begin
  inherited;
  CheckBoxTodos.Checked := False;
  CheckBoxTodosChange(CheckBoxTodos);
end;

procedure TProcesoNotas.RadioGroup2Click(Sender: TObject);
begin
  CambiarCriterios;
end;

function TProcesoNotas.GetCustomController: TNotasController;
begin
  Result := GetController as TNotasController;
end;

procedure TProcesoNotas.CambiarCriterios;
var
  Cri: TCriterios;
begin
  with cri do
  begin
    KeyWord := Trim(LabeledEdit1.Text);
    case RadioGroup1.ItemIndex of
      0: Alumnos := alTodos;
      1: Alumnos := alConfirmados;
      2: Alumnos := alNoConfirmados;
    end;
    case RadioGroup2.ItemIndex of
      0: Matriculas := maTodas;
      1: Matriculas := maConfirmadas;
      2: Matriculas := maNoConfirmadas;
    end;
  end;
  GetCustomController.SetCriterios(Cri, Self);
end;

end.
