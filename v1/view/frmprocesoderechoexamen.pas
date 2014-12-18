unit frmprocesoderechoexamen;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, LazHelpHTML, ButtonPanel, DBGrids, StdCtrls, frmproceso, derechoexamenctrl;

type

  { TProcesoDerechoExamen }

  TProcesoDerechoExamen = class(TProceso)
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    GroupBoxAlumnos: TGroupBox;
    GroupBoxSeccion: TGroupBox;
    procedure CancelButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  protected
    function GetCustomController: TDerechoExamenController;
  end;

var
  ProcesoDerechoExamen: TProcesoDerechoExamen;

implementation

{$R *.lfm}

{ TProcesoDerechoExamen }

procedure TProcesoDerechoExamen.OKButtonClick(Sender: TObject);
begin
  GetController.Save(Self);
  GetController.Commit(Self);
end;

procedure TProcesoDerechoExamen.CancelButtonClick(Sender: TObject);
begin
  GetController.Cancel(Self);
  GetController.Rollback(Self);
end;

function TProcesoDerechoExamen.GetCustomController: TDerechoExamenController;
begin
  Result := GetController as TDerechoExamenController;
end;

end.

