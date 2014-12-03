unit frmprocesoreganecdotico;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, StdCtrls, DBCtrls, DBGrids, frmproceso,
  registroanecdoticoctrl;

type

  { TProcesoRegistroAnecdotico }

  TProcesoRegistroAnecdotico = class(TProceso)
    DBGrid1: TDBGrid;
    DBLookupComboBox1: TDBLookupComboBox;
    DBNavigator1: TDBNavigator;
    GroupBoxAlumno: TGroupBox;
    GroupBoxRegsitro: TGroupBox;
    procedure CancelButtonClick(Sender: TObject);
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

function TProcesoRegistroAnecdotico.GetCustomController: TRegistroAnecdoticoController;
begin
  Result := GetController as TRegistroAnecdoticoController;
end;

end.

