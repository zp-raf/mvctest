unit frmabmacademias;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ButtonPanel, ExtCtrls, DBGrids, DBCtrls, StdCtrls, frmAbm, DB, frmacademiadatamodule;

type

  { TAbmAcademias }

  TAbmAcademias = class(TAbm)
    DBEdit1: TDBEdit;
    Label1: TLabel;
    TBConnected: TToggleBox;
    procedure FormShow(Sender: TObject);
    procedure TBConnectedClick(Sender: TObject);
    procedure ObserverUpdate(const Subject: IInterface); override;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  AbmAcademias: TAbmAcademias;

implementation

{$R *.lfm}

{ TAbmAcademias }

procedure TAbmAcademias.FormShow(Sender: TObject);
var
  i: integer;
begin
  { esto es para ver los elementos que tiene el form dentro
    puede servir para recorrer los campos para ver si se completaron todos. }
  for i := 0 to ComponentCount - 1 do
  begin
    {
     if Components[i] is TDBGrid then //para comparacion de tipos
       ShowMessage(Components[i].Name + ' es del tipo ' + Components[i].ClassName);
    }
  end;
  if not Controller.IsDBConnected(Self) then
    Controller.Connect(Self);
  inherited FormShow(Sender);
end;

procedure TAbmAcademias.TBConnectedClick(Sender: TObject);
begin
  if (Sender as TToggleBox).Checked then
    Controller.Connect(Self)
  else
    Controller.Disconnect(Self);
end;

procedure TAbmAcademias.ObserverUpdate(const Subject: IInterface);
begin
    { aca se actualiza la vista. en este caso que es para prueba nomas
    cambiamos boton connected }
  if Controller.IsDBConnected(Self) then
    TBConnected.Checked := True
  else
    TBConnected.Checked := False;
end;

end.

