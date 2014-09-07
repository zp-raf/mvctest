unit frmacademiaview2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  DBCtrls, DBGrids, Menus, Buttons, frmMaestro, DB, frmacademiadatamodule, academiactrl;

type

  { TAcademiaView2 }

  TAcademiaView2 = class(TMaestro)
    ButtonCommit: TButton;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    ds: TDatasource;
    ToggleBoxConnected: TToggleBox;
    procedure ButtonCommitClick(Sender: TObject);
    procedure ToggleBoxConnectedChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  AcademiaView2: TAcademiaView2;

implementation

{$R *.lfm}

{ TAcademiaView2 }

{ Los eventos llaman a los metodos del controlador que queremos usar, ya no
  escribimos nada que tenga que ver con la logica del negocio en el form }

procedure TAcademiaView2.ToggleBoxConnectedChange(Sender: TObject);
begin
  if (Sender as TToggleBox).Checked then
    Controller.Connect(Self)
  else
    Controller.Disconnect(Self);
end;

procedure TAcademiaView2.ButtonCommitClick(Sender: TObject);
begin
{ cuando no tenemos un metodo que esta en la interfaz y esta solo en la
  implementacion del controlador casteamos el controlador al tipo deseado
  y llamamos al metodo deseado }
  (Controller as TAcademiaController).Commit(Self);
end;

end.

