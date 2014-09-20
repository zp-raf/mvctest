unit procesoctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, mvc;

type

  { TProcesoController }

  TProcesoController = class(TInterfacedObject, IController)
  private
    FControladorBasico: IController;
  public
    constructor Create; overload;
  published
    property ControladorBasico: IController read FControladorBasico
      implements IController;
  end;

implementation

{ TProcesoController }


constructor TProcesoController.Create;
begin
  FControladorBasico := TController.Create(elmodelo);
end;

end.
