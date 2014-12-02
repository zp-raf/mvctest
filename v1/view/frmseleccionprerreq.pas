unit frmseleccionprerreq;

{$mode objfpc}{$H+}

interface

uses
  DBGrids, DBCtrls, StdCtrls, frmMaestro, Forms;

type

  { TSeleccionarPrerrequisitos }

  TSeleccionarPrerrequisitos = class(TMaestro)
    Aceptar: TButton;
    Cancelar: TButton;
    DBGridPre: TDBGrid;
    DBNavigatorPre: TDBNavigator;
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
  public
    destructor Destroy; override;
  end;

var
  SeleccionarPrerrequisitos: TSeleccionarPrerrequisitos;

implementation

{$R *.lfm}

{ TSeleccionarPrerrequisitos }

procedure TSeleccionarPrerrequisitos.FormCreate(Sender: TObject);
begin
  OpenOnShow := False;
end;

procedure TSeleccionarPrerrequisitos.FormCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  CanClose := True;
end;

destructor TSeleccionarPrerrequisitos.Destroy;
begin
  ClearControllerPtr;
  inherited Destroy;
end;

end.

