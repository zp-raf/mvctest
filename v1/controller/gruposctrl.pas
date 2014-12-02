unit gruposctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmgrupodatamodule;
type

  { TGrupoController }

  TGrupoController = class(TABMController)
    protected
      function GetCustomModel: TGrupoDataModule;
  end;

implementation

{ TGrupoController }

function TGrupoController.GetCustomModel: TGrupoDataModule;
begin
  Result := GetModel as TGrupoDataModule;
end;

end.

