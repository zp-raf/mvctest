unit frmabmjustificativos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, ExtCtrls, DBGrids, DbCtrls, StdCtrls, frmAbm,
  justificativoctrl;

type

  { TAbmJustificativos }

  TAbmJustificativos = class(TAbm)
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBLookupComboBox1: TDBLookupComboBox;
    DBMemo1: TDBMemo;
    DBMemo2: TDBMemo;
    Persona: TLabel;
    FechaPresentacion: TLabel;
    FechaInasistencia: TLabel;
    Motivo: TLabel;
    Detalles: TLabel;
  protected
    function GetCustomController: TJustificativoController;
  end;

var
  AbmJustificativos: TAbmJustificativos;

implementation

{$R *.lfm}

{ TAbmJustificativos }

function TAbmJustificativos.GetCustomController: TJustificativoController;
begin
  Result := GetController as TJustificativoController;
end;

end.
