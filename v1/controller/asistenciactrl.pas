unit asistenciactrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl;

type

  { TAsistenciaController }

  TAsistenciaController = class(TController)
  public
    destructor Destroy; override;
  end;

implementation

{ TAsistenciaController }

destructor TAsistenciaController.Destroy;
begin
  ClearModelPtr;
  inherited Destroy;
end;

end.

