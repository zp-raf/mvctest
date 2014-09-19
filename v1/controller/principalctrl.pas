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
  frmpersonasdatamodule,
  frmabmpersonas,
  personactrl,
  // Facturacion
  frmfacturadatamodule,
  //frmfacturacion,
  facturactrl,
  // Ventas(Deudas)
  frmventadatamodule,
  frmventa,
  ventactrl;

type

  { TPrincipalController }

  TPrincipalController = class(TController)
  private
    FDBModel: IDBModel;
  public
    constructor Create(AModel: IModel; ADBModel: IDBModel); overload;
    destructor Destroy; override;
    function GetUserName(Sender: IFormView): string;
    function GetHostName(Sender: IFormView): string;
    procedure ABMAcad(Sender: IFormView);
    procedure allpersonasClick(Sender: IFormView);
    procedure OpenFacturasForm(Sender: IFormView);
    procedure OpenVentaForm(Sender: IFormView);
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

destructor TPrincipalController.Destroy;
begin
  (Model as TComponent).Free;
  (FDBModel as TComponent).Free;
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
  AbmAcademias := TAbmAcademias.Create(Sender,
    TAcademiaController.Create(TAcademiaDataModule.Create(Application, FDBModel)));
  AbmAcademias.Show;
  (FDBModel as ISubject).Attach(AbmAcademias as IObserver);
end;

procedure TPrincipalController.allpersonasClick(Sender: IFormView);
begin
  AbmPersonas := TAbmPersonas.Create(Sender,
    TPersonaController.Create(TPersonasDataModule.Create(Application, FDBModel)));
  AbmPersonas.Show;
  (FDBModel as ISubject).Attach(AbmPersonas as IObserver);
end;

procedure TPrincipalController.OpenFacturasForm(Sender: IFormView);
begin
  FacturaDataModule := TFacturaDataModule.Create(Application, FDBModel);
  FacturaController := TFacturaController.Create(FacturaDataModule);
  //ProcesoFacturacion := TProcesoFacturacion.Create(nil, PersonaController);
  //ProcesoFacturacion.Show;
  //(SgcdDataModule as ISubject).Attach(ProcesoFacturacion as IObserver);
end;

procedure TPrincipalController.OpenVentaForm(Sender: IFormView);
begin
  ProcesoVenta := TProcesoVenta.Create(Sender,
    TVentaController.Create(TVentaDataModule.Create(Application, FDBModel)));
  ProcesoVenta.Show;
  (FDBModel as ISubject).Attach(ProcesoVenta as IObserver);
end;

end.
