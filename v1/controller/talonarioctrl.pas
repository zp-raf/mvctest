unit talonarioctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, DB, frmtalonariodatamodule, sgcdTypes;

type

  { TTalonarioController }

  TTalonarioController = class(TABMController)
  protected
    function GetCustomModel: TTalonarioDataModule;
  public
    function GetTipoTalonario: TTipoTalonario;
    //function GetTalonarioDataSource: TDataSource;
  end;

  { TSeleccionTalonarios }

  TSeleccionTalonarios = class(TTalonarioController)
  public
    destructor Destroy; override;
  end;

implementation

{ TSeleccionTalonarios }

destructor TSeleccionTalonarios.Destroy;
begin
  ClearModelPtr;
  inherited Destroy;
end;

{ TTalonarioController }

function TTalonarioController.GetCustomModel: TTalonarioDataModule;
begin
  Result := GetModel as TTalonarioDataModule;
end;

function TTalonarioController.GetTipoTalonario: TTipoTalonario;
begin
  Result := GetCustomModel.GetTipoTalonario;
end;

//function TTalonarioController.GetTalonarioDataSource: TDataSource;
//begin
//  Result := GetCustomModel.dsTalonarioView;
//end;

end.
