unit frmabmclases;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, ExtCtrls, DBGrids, DBCtrls, StdCtrls, frmAbm, clasesctrl;

type

  { TAbmClases }

  TAbmClases = class(TAbm)
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBLookupComboBox1: TDBLookupComboBox;
    DBMemo1: TDBMemo;
    DBMemo2: TDBMemo;
    DBMemo3: TDBMemo;
    DBMemo4: TDBMemo;
    DBMemo5: TDBMemo;
    Fecha: TLabel;
    Tema: TLabel;
    ObjetivoGeneral: TLabel;
    ObjetivosEspecificos: TLabel;
    Actividades: TLabel;
    Materiales: TLabel;
    Evaluacion: TLabel;
    Seccion: TLabel;
  protected
    function GetCustomController: TClaseController;
  end;

var
  AbmClases: TAbmClases;

implementation

{$R *.lfm}

{ TAbmClases }

function TAbmClases.GetCustomController: TClaseController;
begin
  Result := GetController as TClaseController;
end;

end.

