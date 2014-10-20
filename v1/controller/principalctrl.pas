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
  frmfacturadatamodule2,
  frmprocesofacturacion,
  facturactrl2,
  // Ventas(Deudas)
  frmventadatamodule,
  frmventa,
  ventactrl,
  // Cuentas
  frmcuentadatamodule,
  frmabmcuentas,
  cuentactrl,
  // Asientos(test)
  frmasientosdatamodule,
  frmprocesoasientos,
  asientosctrl,
  // Pagos
  frmpagodatamodule,
  frmpago,
  pagoctrl,
  // Deudas(test)
  frmgeneradeudadatamodule,
  frmgeneradeuda,
  generardeudactrl,
  frmNotaCreditoDataModule,
  frmProcNotaCredito,
  notacreditoctrl,
  // Documentos
  frmdocumentosdatamodule,
  frmprocesodocumentos,
  documentosctrl;

type

  { TPrincipalController }

  TPrincipalController = class(TController)
  public
    procedure ABMAcad(Sender: IFormView);
    procedure allpersonasClick(Sender: IFormView);
    procedure OpenFacturasForm(Sender: IFormView);
    procedure OpenDeudaForm(Sender: IFormView);
    procedure OpenABMCuentasForm(Sender: IFormView);
    procedure OpenAsientosFrom(Sender: IFormView);
    procedure OpenPagosForm(Sender: IFormView);
    procedure OpenDocumentosForm(Sender: IFormView);
    procedure OpenNotaCreditoForm(Sender: IFormView);
  end;

var
  PrincipalController: TPrincipalController;

implementation

{ TPrincipalController }

procedure TPrincipalController.ABMAcad(Sender: IFormView);
begin
  AbmAcademias := TAbmAcademias.Create(Sender,
    TAcademiaController.Create(TAcademiaDataModule.Create(
    (Sender as TComponent), Model.MasterDataModule)));
  AbmAcademias.Show;
  (Model.MasterDataModule as ISubject).Attach(AbmAcademias as IObserver);
end;

procedure TPrincipalController.allpersonasClick(Sender: IFormView);
begin
  AbmPersonas := TAbmPersonas.Create(Sender,
    TPersonaController.Create(TPersonasDataModule.Create(
    (Sender as TComponent), Model.MasterDataModule)));
  AbmPersonas.Show;
  (Model.MasterDataModule as ISubject).Attach(AbmPersonas as IObserver);
end;

procedure TPrincipalController.OpenFacturasForm(Sender: IFormView);
begin
  ProcesoFacturacion := TProcesoFacturacion.Create(Sender,
    TFacturaController.Create(TFacturasDataModule.Create(
    (Sender as TComponent), Model.MasterDataModule)));
  ProcesoFacturacion.Show;
  (Model.MasterDataModule as ISubject).Attach(ProcesoFacturacion as IObserver);
end;

procedure TPrincipalController.OpenDeudaForm(Sender: IFormView);
begin
  GenerarDeuda := TGenerarDeuda.Create(Sender, TGenDeudaController.Create(
    TGeneraDeudaDataModule.Create((Sender as TComponent), Model.MasterDataModule)));
  GenerarDeuda.Show;
  (Model.MasterDataModule as ISubject).Attach(GenerarDeuda as IObserver);
end;

procedure TPrincipalController.OpenABMCuentasForm(Sender: IFormView);
begin
  AbmCuentas := TAbmCuentas.Create(Sender, TCuentaController.Create(
    TCuentaDataModule.Create((Sender as TComponent), Model.MasterDataModule)));
  AbmCuentas.Show;
  (Model.MasterDataModule as ISubject).Attach(AbmCuentas as IObserver);
end;

procedure TPrincipalController.OpenAsientosFrom(Sender: IFormView);
begin
  ProcesoAsientos := TProcesoAsientos.Create(Sender,
    TAsientosController.Create(TAsientosDataModule.Create(
    (Sender as TComponent), Model.MasterDataModule)));
  ProcesoAsientos.Show;
  (Model.MasterDataModule as ISubject).Attach(ProcesoAsientos as IObserver);
end;

procedure TPrincipalController.OpenPagosForm(Sender: IFormView);
begin
  ProcesoPago := TProcesoPago.Create(Sender,
    TPagoController.Create(TPagoDataModule.Create(
    (Sender as TComponent), Model.MasterDataModule)));
  ProcesoPago.Show;
  (Model.MasterDataModule as ISubject).Attach(ProcesoPago as IObserver);
end;

procedure TPrincipalController.OpenNotaCreditoForm(Sender: IFormView);
begin
  ProcesoNotaCredito := TProcesoNotaCredito.Create(Sender,
    TNotaCreditoController.Create(TNotaCreditoDataModule.Create(
    (Sender as TComponent), Model.MasterDataModule)));
  ProcesoNotaCredito.Show;
  (Model.MasterDataModule as ISubject).Attach(ProcesoNotaCredito as IObserver);
end;

procedure TPrincipalController.OpenDocumentosForm(Sender: IFormView);
begin
  ProcesoDocumentos := TProcesoDocumentos.Create(Sender,
    TDocumentosController.Create(TDocumentosDataModule.Create(
    (Sender as TComponent), Model.MasterDataModule)));
  ProcesoDocumentos.Show;
  (Model.MasterDataModule as ISubject).Attach(ProcesoDocumentos as IObserver);
end;

end.
