unit frmpopupseleccionartrabajos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, StdCtrls, DBGrids, frmMaestro;

type

  { TPopupSeleccionarTrabajos }

  TPopupSeleccionarTrabajos = class(TMaestro)
    Aceptar: TButton;
    Cancelar: TButton;
    DBGrid1: TDBGrid;
    Filtro: TGroupBox;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  PopupSeleccionarTrabajos: TPopupSeleccionarTrabajos;

implementation

{$R *.lfm}

{ TPopupSeleccionarTrabajos }

procedure TPopupSeleccionarTrabajos.FormCreate(Sender: TObject);
begin
  OpenOnShow := False;
end;

end.

