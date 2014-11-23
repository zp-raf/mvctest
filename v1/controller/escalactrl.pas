unit escalactrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmescaladatamodule;

type

  { TEscalaController }

  TEscalaController = class(TController)
  protected
    function GetCustomModel: TEscalaDataModule;
  end;

implementation

{ TEscalaController }

function TEscalaController.GetCustomModel: TEscalaDataModule;
begin
  Result := GetModel as TEscalaDataModule;
end;

end.
