unit frmseleccionararea;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, DBGrids, StdCtrls, DBCtrls, frmMaestro;

type

  { TPopupSeleccionarArea }

  TPopupSeleccionarArea = class(TMaestro)
    Aceptar: TButton;
    Cancelar: TButton;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
  end;

var
  PopupSeleccionarArea: TPopupSeleccionarArea;

implementation

{$R *.lfm}

{ TPopupSeleccionarArea }

procedure TPopupSeleccionarArea.FormCreate(Sender: TObject);
begin
  OpenOnShow := False;
end;

procedure TPopupSeleccionarArea.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose := True;
end;

end.


