unit personactrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmpersonasdatamodule, sgcdTypes, mvc;

type

  { TPersonaController }

  TPersonaController = class(TABMController)
  public
    function GetCustomModel: TPersonasDataModule;
  end;

  { TBuscarPersonaController }

  TBuscarPersonaController = class(TPersonaController)
  public
    destructor Destroy; override;
    procedure FilterData(AKeyWord: string; ARol: TRolPersona; Sender: IView); overload;
  end;

var
  PersonaController: TPersonaController;

implementation

{ TBuscarPersonaController }

destructor TBuscarPersonaController.Destroy;
begin
  ClearModelPtr; // para que no se destruya el modelo :)
  inherited Destroy;
end;

procedure TBuscarPersonaController.FilterData(AKeyWord: string;
  ARol: TRolPersona; Sender: IView);
begin
  GetCustomModel.FilterData(AKeyWord, ARol);
end;

{ TPersonaController }

function TPersonaController.GetCustomModel: TPersonasDataModule;
begin
  Result := GetModel as TPersonasDataModule;
end;

end.
