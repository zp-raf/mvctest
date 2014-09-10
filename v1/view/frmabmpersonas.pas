unit frmabmpersonas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ButtonPanel, ExtCtrls, DBGrids, DBCtrls, StdCtrls,
  frmAbm, personactrl;

type

  { TAbmPersonas }

  TAbmPersonas = class(TAbm)
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  AbmPersonas: TAbmPersonas;

implementation

{$R *.lfm}

{ TAbmPersonas }

end.
