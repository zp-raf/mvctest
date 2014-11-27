unit frmseleccionacademias;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, DBGrids, StdCtrls, DBCtrls, frmMaestro;

type

  { TPopupSeleccionarAcademia }

  TPopupSeleccionarAcademia = class(TMaestro)
    Aceptar: TButton;
    Cancelar: TButton;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  PopupSeleccionarAcademia: TPopupSeleccionarAcademia;

implementation

{$R *.lfm}

{ TPopupSeleccionarAcademia }

procedure TPopupSeleccionarAcademia.FormCreate(Sender: TObject);
begin
  OpenOnShow := False;
end;

end.

