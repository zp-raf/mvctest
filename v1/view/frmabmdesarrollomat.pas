unit frmabmdesarrollomat;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, ExtCtrls, DBGrids, DbCtrls, StdCtrls, frmAbm,
  desarrolloctrl;

type

  { TAbmDesarrolloMAt }

  TAbmDesarrolloMAt = class(TAbm)
    DBCheckBox1: TDBCheckBox;
    DBLookupComboBoxSeccion: TDBLookupComboBox;
    DBLookupComboBoxMateria: TDBLookupComboBox;
    DBLookupComboBoxPeriodo: TDBLookupComboBox;
    DBLookupComboBoxProfesor: TDBLookupComboBox;
    LabelSeccion: TLabel;
    LabelMateria: TLabel;
    LabelPeriodo: TLabel;
    LabelProfesor: TLabel;
  protected
    function GetCustomController: TDesarrolloController;
  end;

var
  AbmDesarrolloMAt: TAbmDesarrolloMAt;

implementation

{$R *.lfm}

{ TAbmDesarrolloMAt }

function TAbmDesarrolloMAt.GetCustomController: TDesarrolloController;
begin
  Result := GetABMController as TDesarrolloController;
end;

end.

