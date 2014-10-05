unit frmabmcuentas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ButtonPanel, ExtCtrls, DBGrids, DBCtrls, StdCtrls, frmAbm,
  frmcuentadatamodule, cuentactrl;

resourcestring
  rsControllerErr = 'El controlador no es del tipo adecuado';

type

  { TAbmCuentas }

  TAbmCuentas = class(TAbm)
  private
    FCustomController: TCuentaController;
    procedure SetCustomController(AValue: TCuentaController);
  published
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBRadioGroupTipo: TDBRadioGroup;
    Codigo: TLabel;
    Nombre: TLabel;
    procedure FormCreate(Sender: TObject);
    property CustomController: TCuentaController
      read FCustomController write SetCustomController;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  AbmCuentas: TAbmCuentas;

implementation

{$R *.lfm}

{ TAbmCuentas }

procedure TAbmCuentas.SetCustomController(AValue: TCuentaController);
begin
  if FCustomController = AValue then
    Exit;
  FCustomController := AValue;
end;

procedure TAbmCuentas.FormCreate(Sender: TObject);
begin
  if (Controller is TCuentaController) then
    CustomController := (Controller as TCuentaController)
  else
    raise Exception.Create(rsControllerErr);
end;

end.
