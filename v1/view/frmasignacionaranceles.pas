unit frmasignacionaranceles;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, ExtCtrls, DBGrids, PairSplitter, StdCtrls, Buttons,
  DBCtrls, frmproceso, sqldb, asignacionctrl;

type

  { TProcesoAsignacionAranceles }

  TProcesoAsignacionAranceles = class(TProceso)
  protected
    function GetCustomController: TAsignacionArancelesController;
  published
    DBGridModulos: TDBGrid;
    DBGridModulos1: TDBGrid;
    DBGridModulos2: TDBGrid;
    DBNavigator1: TDBNavigator;
    DBNavigator2: TDBNavigator;
    DBNavigator3: TDBNavigator;
    PageControlAranceles: TPageControl;
    TabSheetModulos: TTabSheet;
    TabSheetMaterias: TTabSheet;
    TabSheetDesarrollo: TTabSheet;
    procedure OKButtonClick(Sender: TObject);
  end;

var
  ProcesoAsignacionAranceles: TProcesoAsignacionAranceles;

implementation

{$R *.lfm}

{ TProcesoAsignacionAranceles }

function TProcesoAsignacionAranceles.GetCustomController: TAsignacionArancelesController;
begin
  Result := GetController as TAsignacionArancelesController;
end;

procedure TProcesoAsignacionAranceles.OKButtonClick(Sender: TObject);
begin
  GetController.Save(Self);
  GetController.Commit(Self);
end;

end.

