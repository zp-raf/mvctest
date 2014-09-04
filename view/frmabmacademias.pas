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

end.

