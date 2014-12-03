unit desarrolloctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmdesarrollodatamodule, personactrl;

type

  { TDesarrolloController }

  TDesarrolloController = class(TABMController)
  private
    FPersonasCtrl: TBuscarPersonaController;
    procedure SetPersonasCtrl(AValue: TBuscarPersonaController);
  protected
    function GetCustomModel: TDesarrolloMateriaDataModule;
  public
    constructor Create(AModel: Pointer); override;
    destructor Destroy; override;
    property PersonasCtrl: TBuscarPersonaController
      read FPersonasCtrl write SetPersonasCtrl;
  end;

implementation

{ TDesarrolloController }

procedure TDesarrolloController.SetPersonasCtrl(AValue: TBuscarPersonaController);
begin
  if FPersonasCtrl = AValue then
    Exit;
  FPersonasCtrl := AValue;
end;

function TDesarrolloController.GetCustomModel: TDesarrolloMateriaDataModule;
begin
  Result := GetModel as TDesarrolloMateriaDataModule;
end;

constructor TDesarrolloController.Create(AModel: Pointer);
begin
  inherited Create(AModel);
  FPersonasCtrl := TBuscarPersonaController.Create(GetCustomModel.Personas);
end;

destructor TDesarrolloController.Destroy;
begin
  inherited Destroy;
  if Assigned(FPersonasCtrl) then
  begin
    FreeAndNil(FPersonasCtrl);
  end;
end;

end.
