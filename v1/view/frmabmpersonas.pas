unit frmabmpersonas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, DBCtrls, personactrl, frmAbm;

type

  { TAbmPersonas }

  TAbmPersonas = class(TAbm)
  private
    { private declarations }
  protected
    function GetCustomController: TPersonaController;
  public
    { public declarations }
  end;

var
  AbmPersonas: TAbmPersonas;

implementation

{$R *.lfm}

{ TAbmPersonas }

function TAbmPersonas.GetCustomController: TPersonaController;
begin
   Result := GetController as TPersonaController;
end;

end.
