unit arancelesctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmaranceldatamodule;

type

  { TArancelesController }

  TArancelesController = class(TABMController)
  protected
    function GetCustomModel: TArancelesDataModule;
  end;

implementation

{ TArancelesController }

function TArancelesController.GetCustomModel: TArancelesDataModule;
begin
  Result := GetModel as TArancelesDataModule;
end;

end.
