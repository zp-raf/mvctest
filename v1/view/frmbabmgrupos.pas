unit frmbabmgrupos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, ExtCtrls, DBGrids, DbCtrls, StdCtrls, frmAbm, gruposctrl;

type

  { TAbmGrupos }

  TAbmGrupos = class(TAbm)
    DBCheckBoxHabilitado: TDBCheckBox;
    DBEditNombre: TDBEdit;
    DBLookupComboBoxAnterior: TDBLookupComboBox;
    DBMemoDesc: TDBMemo;
    LabelNombre: TLabel;
    LabelDescripcion: TLabel;
    LabelGrupoAnterior: TLabel;
  protected
    function GetCustomController: TGrupoController;
  end;

var
  AbmGrupos: TAbmGrupos;

implementation

{$R *.lfm}

{ TAbmGrupos }


function TAbmGrupos.GetCustomController: TGrupoController;
begin
  Result := GetABMController as TGrupoController;
end;

end.

