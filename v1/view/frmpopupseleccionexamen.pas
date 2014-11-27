unit frmpopupseleccionexamen;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, StdCtrls, DBGrids, frmMaestro;

type

  { TPopupSeleccionExamen }

  TPopupSeleccionExamen = class(TMaestro)
    procedure FormCreate(Sender: TObject);
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

procedure TPopupSeleccionExamen.FormCreate(Sender: TObject);
begin
  OpenOnShow := False;
end;

destructor TPopupSeleccionExamen.Destroy;
begin
  //ClearControllerPtr;
  inherited Destroy;
end;

end.

