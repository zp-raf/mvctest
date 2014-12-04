unit frmprocesoaprobarjustificativo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, DBGrids, ExtCtrls, StdCtrls, frmproceso, justificativoctrl;

type

  { TProcesoAprobarJustificativo }

  TProcesoAprobarJustificativo = class(TProceso)
    DBGrid1: TDBGrid;
    DBGridPersonas: TDBGrid;
    LabeledEditPers: TLabeledEdit;
    procedure CancelButtonClick(Sender: TObject);
    procedure DBGridPersonasCellClick(Column: TColumn);
    procedure LabeledEditPersChange(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  protected
    function GetCustomController: TAprobarJustificativoController;
  end;

var
  ProcesoAprobarJustificativo: TProcesoAprobarJustificativo;

implementation

{$R *.lfm}

{ TProcesoAprobarJustificativo }

procedure TProcesoAprobarJustificativo.LabeledEditPersChange(Sender: TObject);
begin
  GetCustomController.FilterPers(LabeledEditPers.Text, Self);
end;

procedure TProcesoAprobarJustificativo.CancelButtonClick(Sender: TObject);
begin
  GetController.Cancel(Self);
  GetController.Rollback(Self);
end;

procedure TProcesoAprobarJustificativo.DBGridPersonasCellClick(Column: TColumn);
begin
  GetCustomController.FiltrarJustificativos(Self);
end;

procedure TProcesoAprobarJustificativo.OKButtonClick(Sender: TObject);
begin
  GetController.Save(Self);
  GetController.Commit(Self);
end;

function TProcesoAprobarJustificativo.GetCustomController: TAprobarJustificativoController;
begin
  Result := GetController as TAprobarJustificativoController;
end;

end.

