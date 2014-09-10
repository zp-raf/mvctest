unit mensajes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;
type
    { TDBInfo }

  // Este es un tipo para informar el estado de conexion de la DB
  TDBInfo = record
    Connected: boolean;
    User: string;
    Host: string;
  end;
implementation

end.

