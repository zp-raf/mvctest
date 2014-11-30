unit frmseleccionartalonario;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, DBGrids, StdCtrls, frmMaestro, DB, talonarioctrl;

type

  { TSeleccionarTalonario }

  TSeleccionarTalonario = class(TMaestro)
  protected
    function GetCustomController: TTalonarioController;
  public
    //constructor Create(AOwner: IFormView; AController: Pointer;
    //  ADataSource: TDataSource); overload;
  published
    Cancelar: TButton;
    Aceptar: TButton;
    DBGrid1: TDBGrid;
  end;

var
  SeleccionTalonario: TSeleccionarTalonario;

implementation

{$R *.lfm}

{ TSeleccionarTalonario }

function TSeleccionarTalonario.GetCustomController: TTalonarioController;
begin
  Result := GetController as TTalonarioController;
end;

//constructor TSeleccionarTalonario.Create(AOwner: IFormView;
//  AController: Pointer; ADataSource: TDataSource);
//begin
//  inherited Create(AOwner, AController);
//  DBGrid1.DataSource := GetCustomController.GetTalonarioDataSource;
//end;

end.

