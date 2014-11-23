unit frmpopupseleccionexamen;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, StdCtrls, DBGrids, frmMaestro;

type

  { TPopupSeleccionExamen }

  TPopupSeleccionExamen = class(TMaestro)
  private
    { private declarations }
  public
    destructor Destroy; override;
  published
    Aceptar: TButton;
    Cancelar: TButton;
    DBGrid1: TDBGrid;
    Filtro: TGroupBox;
  end;

var
  PopupSeleccionExamen: TPopupSeleccionExamen;

implementation

{$R *.lfm}

{ TPopupSeleccionExamen }

destructor TPopupSeleccionExamen.Destroy;
begin
  //ClearControllerPtr;
  inherited Destroy;
end;

end.

