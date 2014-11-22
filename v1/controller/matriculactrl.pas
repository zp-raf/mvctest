unit matriculactrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmmatriculadatamodule, mvc, frmpopupseleccionalumnos,
  Controls, mensajes, sgcdTypes, personactrl;

type

  { TMatriculaController }

  TMatriculaController = class(TController)
  private
    FBuscarPersonaController: TBuscarPersonaController;
    procedure SetBuscarPersonaController(AValue: TBuscarPersonaController);
  protected
    function GetCustomModel: TMatriculaDataModule;
  public
    constructor Create(AModel: Pointer); override;
    destructor Destroy; override;
    procedure AgregarMateria(Sender: IView);
    procedure AgregarMateria(Sender: IView; DesarrolloID: string); overload;
    procedure EliminarMatricula(Sender: IView);
    procedure EliminarMatricula(Sender: IView; AMatriculaID: string); overload;
    procedure Save(Sender: IView); override;
    procedure SeleccionarAlumno(Sender: IFormView);
    procedure SeleccionarAranceles(Sender: IFormView);
    procedure SetOpcionAutoGenerarDeudas(AOpcion: boolean);
    function GetEstado: TEdicionEstado;
    function OpcionAutoGenerarDeudas: boolean;
    property BuscarPersonaController: TBuscarPersonaController
      read FBuscarPersonaController write SetBuscarPersonaController;
  end;

implementation

{ TMatriculaController }

procedure TMatriculaController.SetBuscarPersonaController(
  AValue: TBuscarPersonaController);
begin
  if FBuscarPersonaController = AValue then
    Exit;
  FBuscarPersonaController := AValue;
end;

function TMatriculaController.GetCustomModel: TMatriculaDataModule;
begin
  Result := GetModel as TMatriculaDataModule;
end;

constructor TMatriculaController.Create(AModel: Pointer);
begin
  inherited Create(AModel);
  FBuscarPersonaController := TBuscarPersonaController.Create(GetCustomModel.Personas);
end;

destructor TMatriculaController.Destroy;
begin
  inherited Destroy;
  if Assigned(FBuscarPersonaController) then
    FreeAndNil(FBuscarPersonaController);
end;

procedure TMatriculaController.SeleccionarAlumno(Sender: IFormView);
var
  Al: TPopupSeleccionAlumnos;
begin
  Al := TPopupSeleccionAlumnos.Create(Sender, BuscarPersonaController);
  try
    GetCustomModel.OpenDataSets;
    case al.ShowModal of
      mrOk:
      begin
        GetCustomModel.SetAlumno(GetCustomModel.Personas.PersonasRoles.FieldByName(
          'ID').AsString);
        GetCustomModel.Estado := edEditando;
      end;
      mrCancel:
      begin
        GetCustomModel.CloseDataSets;
        GetCustomModel.Estado := edInicial;
      end;
    end;
  finally
    Al.Free;
  end;
end;

procedure TMatriculaController.SeleccionarAranceles(Sender: IFormView);
begin

end;

procedure TMatriculaController.SetOpcionAutoGenerarDeudas(AOpcion: boolean);
begin
  GetCustomModel.AutoGenerarDeudas := AOpcion;
end;

procedure TMatriculaController.AgregarMateria(Sender: IView);
begin
  AgregarMateria(Sender, GetCustomModel.DesarrolloMatActivoDetView.FieldByName(
    'ID').AsString);
end;

procedure TMatriculaController.AgregarMateria(Sender: IView; DesarrolloID: string);
begin
  if GetCustomModel.DesarrolloMatActivoDetView.IsEmpty then
    Exit;
  GetCustomModel.AgregarMatricula(DesarrolloID);
end;

procedure TMatriculaController.EliminarMatricula(Sender: IView);
begin
  EliminarMatricula(Sender, GetCustomModel.Matricula.FieldByName('ID').AsString);
end;

procedure TMatriculaController.EliminarMatricula(Sender: IView; AMatriculaID: string);
begin
  GetCustomModel.EliminarMatricula(AMatriculaID);
end;

procedure TMatriculaController.Save(Sender: IView);
var
  Matriculas: TStringList;
  i: integer;
begin
  if GetCustomModel.Matricula.IsEmpty then
    Exit;
  Matriculas := TStringList.Create;
  try
    GetCustomModel.Matricula.First;
    while not GetCustomModel.Matricula.EOF do
    begin
      if GetCustomModel.Matricula.FieldByName('ACTIVA').AsInteger = 1 then
        Matriculas.Add(GetCustomModel.Matricula.FieldByName('ID').AsString);
      GetCustomModel.Matricula.Next;
    end;
    GetCustomModel.Matricula.ApplyUpdates;
    GetCustomModel.Deudas.SaveChanges;
    for i := 0 to Pred(Matriculas.Count) do
    begin
      GetCustomModel.GenerarDeuda(Matriculas[i]);
    end;
    Commit(Sender);
    CloseDataSets(Sender);
  finally
    Matriculas.Free;
  end;
end;

function TMatriculaController.GetEstado: TEdicionEstado;
begin
  Result := GetCustomModel.Estado;
end;

function TMatriculaController.OpcionAutoGenerarDeudas: boolean;
begin
  Result := GetCustomModel.AutoGenerarDeudas;
end;

end.
