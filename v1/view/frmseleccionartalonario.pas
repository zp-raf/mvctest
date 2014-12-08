unit frmseleccionartalonario;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, DBGrids, StdCtrls, frmMaestro, DB, talonarioctrl;

type

  { TSeleccionarTalonario }

  TSeleccionarTalonario = class(TMaestro)
    procedure FormCreate(Sender: TObject);
  protected
    function GetCustomController: TSeleccionTalonariosController;
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

procedure TSeleccionarTalonario.FormCreate(Sender: TObject);
begin
  OpenOnShow := False;
end;

function TSeleccionarTalonario.GetCustomController: TSeleccionTalonariosController;
begin
  Result := GetController as TSeleccionTalonariosController;
end;

//constructor TSeleccionarTalonario.Create(AOwner: IFormView;
//  AController: Pointer; ADataSource: TDataSource);
//begin
//  inherited Create(AOwner, AController);
//  DBGrid1.DataSource := GetCustomController.GetTalonarioDataSource;
//end;

end.

