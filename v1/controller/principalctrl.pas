unit principalctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, mvc, observerSubject, Forms, Dialogs,
  frmsgcddatamodule, // el modelo de conexion de base de datos
  frmquerydatamodule, // modelo base para los datamodules de cada vista
  // ABM Academias
  frmacademiadatamodule,
  frmabmacademias,
  academiactrl,
  // ABM Personas
  frmpersonadatamodule,
  frmabmpersonas,
  personactrl,
  // Facturacion
  frmfacturadatamodule,
  frmfacturacion,
  facturactrl;

type

  { TPrincipalController }

  TPrincipalController = class(TController)
  private
    FDBModel: IDBModel;
  public
    constructor Create(AModel: IModel; ADBModel: IDBModel); overload;
    function GetUserName(Sender: IFormView): string;
    function GetHostName(Sender: IFormView): string;
    procedure ABMAcad(Sender: IFormView);
    procedure allpersonasClick(Sender: IFormView);
    procedure OpenFacturasForm(Sender: IFormView);
  end;

var
  PrincipalController: TPrincipalController;

implementation

{ TPrincipalController }

constructor TPrincipalController.Create(AModel: IModel; ADBModel: IDBModel);
begin
  inherited Create(AModel);
  FDBModel := ADBModel;
end;

function TPrincipalController.GetUserName(Sender: IFormView): string;
begin
  Result := Model.GetDBStatus.User;
end;

function TPrincipalController.GetHostName(Sender: IFormView): string;
begin
  Result := Model.GetDBStatus.Host;
end;

procedure TPrincipalController.ABMAcad(Sender: IFormView);
begin
  AcademiaDataModule := TAcademiaDataModule.Create(Application, FDBModel);
  AcademiaController := TAcademiaController.Create(AcademiaDataModule);
  AbmAcademias := TAbmAcademias.Create(Sender, AcademiaController);
  AbmAcademias.Show;
  (FDBModel as ISubject).Attach(AbmAcademias as IObserver);
  //(FDBModel as ISubject).Attach(TAbmAcademias.Create(Sender,
  //  TAcademiaController.Create(TAcademiaDataModule.Create(Application, FDBModel))) as
  //  IObserver);
end;

procedure TPrincipalController.allpersonasClick(Sender: IFormView);
begin
  PersonasDataModule := TPersonasDataModule.Create(Application, FDBModel);
  PersonaController := TPersonaController.Create(PersonasDataModule);
  AbmPersonas := TAbmPersonas.Create(nil, PersonaController);
  AbmPersonas.Show;
  (SgcdDataModule as ISubject).Attach(AbmPersonas as IObserver);
end;

procedure TPrincipalController.OpenFacturasForm(Sender: IFormView);
begin
  FacturaDataModule := TFacturaDataModule.Create(Application, FDBModel);
  FacturaController := TFacturaController.Create(FacturaDataModule);
  ProcesoFacturacion := TProcesoFacturacion.Create(nil, PersonaController);
  ProcesoFacturacion.Show;
  (SgcdDataModule as ISubject).Attach(ProcesoFacturacion as IObserver);
end;

end.
