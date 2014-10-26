unit frmabmacademias;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, DBCtrls, StdCtrls,
  frmAbm;

type

  { TAbmAcademias }

  TAbmAcademias = class(TAbm)
    DBEdit1: TDBEdit;
    Label1: TLabel;
  end;

var
  AbmAcademias: TAbmAcademias;

implementation

{$R *.lfm}

{ TAbmAcademias }

end.
