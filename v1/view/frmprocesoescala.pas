unit frmprocesoescala;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, DBGrids, DBCtrls, frmproceso, escalactrl;

type

  { TProcesoEscala }

  TProcesoEscala = class(TProceso)
  protected
    function GetCustomController: TEscalaController;
  published
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    procedure CancelButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  end;

var
  ProcesoEscala: TProcesoEscala;

implementation

{$R *.lfm}

{ TProcesoEscala }

procedure TProcesoEscala.OKButtonClick(Sender: TObject);
begin
  GetController.Save(Self);
  GetController.Commit(Self);
end;

function TProcesoEscala.GetCustomController: TEscalaController;
begin
  Result := GetController as TEscalaController;
end;

procedure TProcesoEscala.CancelButtonClick(Sender: TObject);
begin
  GetController.Cancel(Self);
  GetController.Rollback(Self);
end;

end.

