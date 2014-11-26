unit selecciontrabajosctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmtrabajosdatamodule;

type

  { TSeleccionTrabajosController }

  TSeleccionTrabajosController = class(TController)
  protected
    function GetCustomModel: TTrabajosDataModule;
  public
    destructor Destroy; override;
  end;

implementation

{ TSeleccionTrabajosController }

function TSeleccionTrabajosController.GetCustomModel: TTrabajosDataModule;
begin
  Result := GetModel as TTrabajosDataModule;
end;

destructor TSeleccionTrabajosController.Destroy;
begin
  ClearModelPtr;
  inherited Destroy;
end;

end.
