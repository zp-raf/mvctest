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
  public
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
    TAcademiaController.Create(TAcademiaDataModule.Create(Application,
    Model.MasterDataModule)));
  AbmAcademias.Show;
  (Model.MasterDataModule as ISubject).Attach(AbmAcademias as IObserver);
end;

procedure TPrincipalController.allpersonasClick(Sender: IFormView);
begin
  AbmPersonas := TAbmPersonas.Create(Sender,
    TPersonaController.Create(TPersonasDataModule.Create(Application,
    Model.MasterDataModule)));
  AbmPersonas.Show;
  (Model.MasterDataModule as ISubject).Attach(AbmPersonas as IObserver);
end;

procedure TPrincipalController.OpenFacturasForm(Sender: IFormView);
begin
  //ProcesoFacturacion := TProcesoFacturacion.Create(nil,
  //  TFacturaController.Create(TFacturaDataModule.Create(Application,
  //  Model.MasterDataModule)));
  //ProcesoFacturacion.Show;
  //(Model.MasterDataModule as ISubject).Attach(ProcesoFacturacion as IObserver);
end;

procedure TPrincipalController.OpenVentaForm(Sender: IFormView);
begin
  //ProcesoVenta := TProcesoVenta.cre;
  //ProcesoVenta.Show;
  //(Model.MasterDataModule as ISubject).Attach(ProcesoVenta as IObserver);
end;

end.
