unit asistenciactrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmasistenciadatamodule;

type

  { TAsistenciaController }

  TAsistenciaController = class(TController)
  protected
    function GetCustomModel: TAsistenciaDataModule;

  public
    destructor Destroy; override;
  end;

implementation

{ TAsistenciaController }

function TAsistenciaController.GetCustomModel: TAsistenciaDataModule;
begin
  Result := GetModel as TAsistenciaDataModule;
end;

destructor TAsistenciaController.Destroy;
begin
  ClearModelPtr;
  inherited Destroy;
end;

end.

