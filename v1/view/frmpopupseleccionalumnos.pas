unit frmpopupseleccionalumnos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmbuscarpersonas;

type

  { TPopupSeleccionAlumnos }

  TPopupSeleccionAlumnos = class(TPopupSeleccionPersonas)
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  PopupSeleccionAlumnos: TPopupSeleccionAlumnos;

implementation

{$R *.lfm}

{ TPopupSeleccionAlumnos }

procedure TPopupSeleccionAlumnos.FormCreate(Sender: TObject);
begin
  OpenOnShow := False;
  Personas.Enabled := False;
  Personas.ItemIndex := 2;
  PersonasClick(Personas); // para que cambie el control y se filtre
end;

end.

