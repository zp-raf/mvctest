unit frmprocesoreganecdotico;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, StdCtrls, DBCtrls, DBGrids, LazHelpHTML, ExtCtrls,
  frmproceso, registroanecdoticoctrl;

type

  { TProcesoRegistroAnecdotico }

  TProcesoRegistroAnecdotico = class(TProceso)
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBNavigator1: TDBNavigator;
    GroupBoxAlumno: TGroupBox;
    GroupBoxRegsitro: TGroupBox;
    LabeledEdit1: TLabeledEdit;
    procedure CancelButtonClick(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  protected
    function GetCustomController: TRegistroAnecdoticoController;
  end;

var
  ProcesoRegistroAnecdotico: TProcesoRegistroAnecdotico;

implementation

{$R *.lfm}

{ TProcesoRegistroAnecdotico }

procedure TProcesoRegistroAnecdotico.OKButtonClick(Sender: TObject);
begin
  GetController.Save(Self);
  GetController.Commit(Self);
end;

procedure TProcesoRegistroAnecdotico.CancelButtonClick(Sender: TObject);
begin
  GetController.Cancel(Self);
  GetController.Rollback(Self);
end;

procedure TProcesoRegistroAnecdotico.LabeledEdit1Change(Sender: TObject);
begin
  GetCustomController.FilterAlumnos(LabeledEdit1.Text, Self);
end;

function TProcesoRegistroAnecdotico.GetCustomController: TRegistroAnecdoticoController;
begin
  Result := GetController as TRegistroAnecdoticoController;
end;

end.

