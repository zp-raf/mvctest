unit manejoerrores;

{$mode objfpc}{$H+}

interface


uses
  Classes, SysUtils, DB, IBConnection, Dialogs, strutils;

resourcestring
  rsAppError = 'Error de aplicacion. Mensaje tecnico del error: ';
  rsErrorTitle = 'Error';
  rsGeneralDBError = 'Error de base de datos. Mensaje tecnico del error: ';
  rsCHK1_ESCALA_POS = 'Los limites deben tener valores positivos';
  rsINTEG_329 = 'Valor no admitido para columna VALIDO';
  rsReqFields = 'No se completaron los campos requeridos';
  rsSelectTalonario = 'Por favor seleccione un talonario en el menu "Opciones"';
  rsBlankSpace = ' ';
  rsPeriod = '. ';
  rsErrorMessage = 'Mensaje del error: ';

function TrimMessage(s: string; token: string): string;
function GetErrorMessage(E: EIBDatabaseError): string;
function GetErrorMessage(E: EDatabaseError): string;
function GetErrorMessage(E: Exception): string;

implementation

function TrimMessage(s: string; token: string): string;
var
  i: integer;
  est: integer;
begin
  if AnsiPos(token, s) = 0 then
  begin
    Result := s;
    Exit;
  end;
  est := 0;
  for i := 1 to Length(s) do
  begin
    if (est = 0) and (s[i] = token) then
      est := 1
    else if (est = 1) and not (s[i] = token) then
      Result := Result + s[i]
    else if (est = 1) and (s[i] = token) then
      break;
  end;
end;

function GetErrorMessage(E: EIBDatabaseError): string;
var
  tmp: string;
  m: string;
begin
  tmp := E.Message;
  if not SameText(tmp, TrimMessage(E.Message, '#')) then
    m := TrimMessage(E.Message, '#')
  else
    case E.GDSErrorCode of
      335544472: m := 'Usuario o contraseña incorrecto.';
      else
        m := E.Message;
    end;
  Result := rsErrorTitle + rsBlankSpace + IntToStr(E.GDSErrorCode) +
    rsPeriod + rsErrorMessage + #13#10 + m;
end;

function GetErrorMessage(E: EDatabaseError): string;
var
  tmp: string;
  m: string;
begin
  tmp := E.Message;
  if SameText(tmp, TrimMessage(E.Message, '#')) then
  begin
    if AnsiContainsText(tmp, 'cannot delete primary key') then
      m := rsGeneralDBError + tmp
    else if AnsiContainsText(tmp, 'violation of primary') then
      m := rsGeneralDBError + tmp
    else if AnsiContainsText(tmp, 'violation of foreign') then
      m := rsGeneralDBError + tmp
    else if AnsiContainsText(tmp, 'but not supplied') then
      m := rsReqFields
    else if AnsiContainsStr(E.Message, '65432') then //frmfacturacion
      m := rsSelectTalonario
    else if AnsiContainsText(tmp, 'CHK1_ESCALA_POS') then
      m := rsCHK1_ESCALA_POS
    else if AnsiContainsText(tmp, 'INTEG_329') then
      m := rsINTEG_329
    else
      m := rsGeneralDBError + #13#10 + tmp;
  end
  else
    m := TrimMessage(E.Message, '#');
  Result := rsErrorMessage + #13#10 + m;
end;

function GetErrorMessage(E: Exception): string;
begin
  Result := rsAppError + #13#10 + E.Message;
end;

end.