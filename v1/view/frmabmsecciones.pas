unit frmabmsecciones;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, ExtCtrls, DBGrids, DBCtrls, StdCtrls, frmAbm, seccionctrl;

type

  { TAbmSecciones }

  TAbmSecciones = class(TAbm)
    DBEdit1: TDBEdit;
    DBMemo1: TDBMemo;
    LabelNombre: TLabel;
    LabelDescripcion: TLabel;
  protected
    function GetCustomController: TSeccionController;
  end;

var
  AbmSecciones: TAbmSecciones;

implementation

{$R *.lfm}

{ TAbmSecciones }

function TAbmSecciones.GetCustomController: TSeccionController;
begin
  Result := GetABMController as TSeccionController;
end;

end.

