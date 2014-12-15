unit personactrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmpersonasdatamodule, sgcdTypes, mvc, DB, Controls,
  frmseleccionararea, frmseleccionacademias;

type

  { TSeleccionarAcadController }

  TSeleccionarAcadController = class(TController)
  public
    destructor Destroy; override;
  end;

  { TSeleccionarAreaController }

  TSeleccionarAreaController = class(TController)
  public
    destructor Destroy; override;
  end;

  { TPersonaController }

  TPersonaController = class(TABMController)
  protected
    function GetCustomModel: TPersonasDataModule;
  public
    procedure SeleccionarAcademias(Sender: IFormView);
    procedure SeleccionarAreas(Sender: IFormView);
    procedure SetFechaNac(ADate: TDateTime; Sender: IView);
    procedure SetRol(ARol: TRolPersona; Option: boolean; Sender: IView);
    function GetFechaNac(Sender: IView): TDateTime;
    function GetRol(Sender: IView): TRoles;
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

{ TSeleccionarAcadController }

destructor TSeleccionarAcadController.Destroy;
begin
  ClearModelPtr;
  inherited Destroy;
end;

{ TSeleccionarAreaController }

destructor TSeleccionarAreaController.Destroy;
begin
  ClearModelPtr;
  inherited Destroy;
end;

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

procedure TPersonaController.SeleccionarAcademias(Sender: IFormView);
begin
  PopupSeleccionarAcademia := TPopupSeleccionarAcademia.Create(Sender,
    TSeleccionarAcadController.Create(GetCustomModel));
  try
    case PopupSeleccionarAcademia.ShowModal of
      mrOk:
      begin
        if (GetCustomModel.AcademiaAlumno.State in dsEditModes) then
          GetCustomModel.AcademiaAlumno.Post;
      end;
      mrCancel:
      begin
        GetCustomModel.AcademiaAlumno.CancelUpdates;
      end;

    end;
  finally
    PopupSeleccionarAcademia.Free;
  end;
end;

procedure TPersonaController.SeleccionarAreas(Sender: IFormView);
begin
  PopupSeleccionarArea := TPopupSeleccionarArea.Create(Sender,
    TSeleccionarAreaController.Create(GetCustomModel));
  try
    case PopupSeleccionarArea.ShowModal of
      mrOk:
      begin
        if (GetCustomModel.Cursa.State in dsEditModes) then
          GetCustomModel.Cursa.Post;
      end;
      mrCancel:
      begin
        GetCustomModel.Cursa.CancelUpdates;
      end;
    end;
  finally
    PopupSeleccionarArea.Free;
  end;
end;

procedure TPersonaController.SetFechaNac(ADate: TDateTime; Sender: IView);
begin
  if not (GetCustomModel.Persona.State in dsEditModes) then
    Exit;
  GetCustomModel.Persona.FieldByName('FECHANAC').AsDateTime := ADate;
end;

procedure TPersonaController.SetRol(ARol: TRolPersona; Option: boolean; Sender: IView);
begin
  if (GetCustomModel.Persona.State in [dsInactive]) then
    Exit;
  GetCustomModel.SetRol(ARol, Option);
end;

function TPersonaController.GetFechaNac(Sender: IView): TDateTime;
begin
  if (GetCustomModel.Persona.State in [dsBrowse, dsInactive]) then
    Exit;
  Result := GetCustomModel.Persona.FieldByName('FECHANAC').AsDateTime;
end;

function TPersonaController.GetRol(Sender: IView): TRoles;
begin
  try
    if (GetCustomModel.Persona.State in [dsBrowse, dsInactive]) then
      Result := nil
    else
      Result := GetCustomModel.GetRoles;
  except
    on E: Exception do
    begin
      Result := nil;
      raise;
    end;
  end;
end;

end.
