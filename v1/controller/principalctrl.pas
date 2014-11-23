unit principalctrl;

{$mode objfpc}{$H+}

interface

uses
  ctrl, mvc, observerSubject, Classes,
  {%H-}frmsgcddatamodule, // The datamodule which holds the database connection
  {%H-}frmquerydatamodule, // The base class for all models
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
  // nota credito
  frmNotaCreditoDataModule,
  frmprocesonotacredito,
  notacreditoctrl,
  // Documentos
  frmdocumentosdatamodule,
  frmprocesodocumentos,
  documentosctrl,
  // Extracto de cuenta
  frmreporteextractodatamodule,
  frmprocesorptextracto,
  reporteextractoctrl,
  // Matriculacion
  frmmatriculadatamodule,
  frmprocesomatriculacion,
  matriculactrl,
  // Asignacion de aranceles
  frmasignacionarancelesdatamodule,
  frmasignacionaranceles,
  asignacionctrl,
  // ABMExamenes
  frmexamendatamodule,
  frmabmexamenes,
  examenctrl,
  // Calificar
  frmcalificaciondatamodule,
  frmprocesocalificacion,
  calificacionctrl,
  // Escala
  frmescaladatamodule,
  frmprocesoescala,
  escalactrl,
  // ABM trabajos
  frmtrabajosdatamodule,
  frmabmtrabajos,
  trabajosctrl,
  // lista alumnos (test)
  frmListaALumnos,
  // Calcular nota
  frmnotasdatamodule,
  frmprocesonotas,
  notasctrl;

type

  { TPrincipalController }

  TPrincipalController = class(TController)
  public
    procedure ABMAcad(Sender: IFormView);
    procedure allpersonasClick(Sender: IFormView);
    procedure OpenABMCuentasForm(Sender: IFormView);
    procedure OpenAsientosFrom(Sender: IFormView);
    procedure OpenDeudaForm(Sender: IFormView);
    procedure OpenDocumentosForm(Sender: IFormView);
    procedure OpenFacturasForm(Sender: IFormView);
    procedure OpenNotaCreditoForm(Sender: IFormView);
    procedure OpenPagosForm(Sender: IFormView);
    procedure OpenExtractoRepForm(Sender: IFormView);
    procedure OpenMatriculacionForm(Sender: IFormView);
    procedure OpenAsignacionFrom(Sender: IFormView);
    procedure OpenExamenesForm(Sender: IFormView);
    procedure OpenCalificarForm(Sender: IFormView);
    procedure OpenEscalaForm(Sender: IFormView);
    procedure OpenABMTrabajosForm(Sender: IFormView);
    procedure OpenListaAlumnos(Sender: IFormView);
    procedure OpenCalcularNotaForm(Sender: IFormView);
  end;

var
  PrincipalController: TPrincipalController;

implementation

{ TPrincipalController }

procedure TPrincipalController.ABMAcad(Sender: IFormView);
begin
  AbmAcademias := TAbmAcademias.Create(Sender,
    TAcademiaController.Create(TAcademiaDataModule.Create(
    (Sender as TComponent), GetModel.MasterDataModule)));
  AbmAcademias.Show;
  (GetModel.MasterDataModule as ISubject).Attach(AbmAcademias as IObserver);
end;

procedure TPrincipalController.allpersonasClick(Sender: IFormView);
begin
  AbmPersonas := TAbmPersonas.Create(Sender,
    TPersonaController.Create(TPersonasDataModule.Create(
    (Sender as TComponent), GetModel.MasterDataModule)));
  AbmPersonas.Show;
  (GetModel.MasterDataModule as ISubject).Attach(AbmPersonas as IObserver);
end;

procedure TPrincipalController.OpenFacturasForm(Sender: IFormView);
begin
  ProcesoFacturacion := TProcesoFacturacion.Create(Sender,
    TFacturaController.Create(TFacturasDataModule.Create(
    (Sender as TComponent), GetModel.MasterDataModule)));
  ProcesoFacturacion.Show;
  (GetModel.MasterDataModule as ISubject).Attach(ProcesoFacturacion as IObserver);
end;

procedure TPrincipalController.OpenDeudaForm(Sender: IFormView);
begin
  GenerarDeuda := TGenerarDeuda.Create(Sender, TGenDeudaController.Create(
    TGeneraDeudaDataModule.Create((Sender as TComponent), GetModel.MasterDataModule)));
  GenerarDeuda.Show;
  (GetModel.MasterDataModule as ISubject).Attach(GenerarDeuda as IObserver);
end;

procedure TPrincipalController.OpenABMCuentasForm(Sender: IFormView);
begin
  AbmCuentas := TAbmCuentas.Create(Sender, TCuentaController.Create(
    TCuentaDataModule.Create((Sender as TComponent), GetModel.MasterDataModule)));
  AbmCuentas.Show;
  (GetModel.MasterDataModule as ISubject).Attach(AbmCuentas as IObserver);
end;

procedure TPrincipalController.OpenAsientosFrom(Sender: IFormView);
begin
  ProcesoAsientos := TProcesoAsientos.Create(Sender,
    TAsientosController.Create(TAsientosDataModule.Create(
    (Sender as TComponent), GetModel.MasterDataModule)));
  ProcesoAsientos.Show;
  (GetModel.MasterDataModule as ISubject).Attach(ProcesoAsientos as IObserver);
end;

procedure TPrincipalController.OpenPagosForm(Sender: IFormView);
begin
  ProcesoPago := TProcesoPago.Create(Sender,
    TPagoController.Create(TPagoDataModule.Create(
    (Sender as TComponent), GetModel.MasterDataModule)));
  ProcesoPago.Show;
  (GetModel.MasterDataModule as ISubject).Attach(ProcesoPago as IObserver);
end;

procedure TPrincipalController.OpenExtractoRepForm(Sender: IFormView);
begin
  ProcesoReporteExtracto := TProcesoReporteExtracto.Create(Sender,
    TRepExtractoController.Create(TReporteExtractoDataModule.Create(
    (Sender as TComponent), GetModel.MasterDataModule)));
  ProcesoReporteExtracto.Show;
  (GetModel.MasterDataModule as ISubject).Attach(ProcesoReporteExtracto as IObserver);
end;

procedure TPrincipalController.OpenMatriculacionForm(Sender: IFormView);
begin
  ProcesoMatriculacion := TProcesoMatriculacion.Create(Sender,
    TMatriculaController.Create(TMatriculaDataModule.Create(
    (Sender as TComponent), GetModel.MasterDataModule)));
  ProcesoMatriculacion.Show;
  (GetModel.MasterDataModule as ISubject).Attach(ProcesoMatriculacion as IObserver);
end;

procedure TPrincipalController.OpenAsignacionFrom(Sender: IFormView);
begin
  ProcesoAsignacionAranceles :=
    TProcesoAsignacionAranceles.Create(Sender,
    TAsignacionArancelesController.Create(TAsignacionArancelesDataModule.Create(
    (Sender as TComponent), GetModel.MasterDataModule)));
  ProcesoAsignacionAranceles.Show;
  (GetModel.MasterDataModule as ISubject).Attach(ProcesoAsignacionAranceles as
    IObserver);
end;

procedure TPrincipalController.OpenExamenesForm(Sender: IFormView);
begin
  AbmExamenes :=
    TAbmExamenes.Create(Sender, TExamenesController.Create(
    TExamenesDataModule.Create((Sender as TComponent), GetModel.MasterDataModule)));
  AbmExamenes.Show;
  (GetModel.MasterDataModule as ISubject).Attach(AbmExamenes as IObserver);
end;

procedure TPrincipalController.OpenCalificarForm(Sender: IFormView);
begin
  ProcesoCalificacion :=
    TProcesoCalificacion.Create(Sender, TCalificacionController.Create(
    TCalificacionDataModule.Create((Sender as TComponent), GetModel.MasterDataModule)));
  ProcesoCalificacion.Show;
  (GetModel.MasterDataModule as ISubject).Attach(ProcesoCalificacion as IObserver);
end;

procedure TPrincipalController.OpenEscalaForm(Sender: IFormView);
begin
  ProcesoEscala :=
    TProcesoEscala.Create(Sender, TEscalaController.Create(
    TEscalaDataModule.Create((Sender as TComponent), GetModel.MasterDataModule)));
  ProcesoEscala.Show;
  (GetModel.MasterDataModule as ISubject).Attach(ProcesoEscala as IObserver);
end;

procedure TPrincipalController.OpenABMTrabajosForm(Sender: IFormView);
begin
  AbmTrabajos :=
    TAbmTrabajos.Create(Sender, TTrabajosController.Create(
    TTrabajosDataModule.Create((Sender as TComponent), GetModel.MasterDataModule)));
  AbmTrabajos.Show;
  (GetModel.MasterDataModule as ISubject).Attach(AbmTrabajos as IObserver);
end;

procedure TPrincipalController.OpenListaAlumnos(Sender: IFormView);
begin
  TProcesoListaALumnos.Create(nil).Show;
end;

procedure TPrincipalController.OpenCalcularNotaForm(Sender: IFormView);
begin
  ProcesoNotas := TProcesoNotas.Create(Sender,
    TNotasController.Create(TNotasDataModule.Create(
    (Sender as TComponent), GetModel.MasterDataModule)));
  ProcesoNotas.Show;
  (GetModel.MasterDataModule as ISubject).Attach(ProcesoNotas as IObserver);
end;

procedure TPrincipalController.OpenNotaCreditoForm(Sender: IFormView);
begin
  ProcesoNotaCredito := TProcesoNotaCredito.Create(Sender,
    TNotaCreditoController.Create(TNotaCreditoDataModule.Create(
    (Sender as TComponent), GetModel.MasterDataModule)));
  ProcesoNotaCredito.Show;
  (GetModel.MasterDataModule as ISubject).Attach(ProcesoNotaCredito as IObserver);
end;

procedure TPrincipalController.OpenDocumentosForm(Sender: IFormView);
begin
  ProcesoDocumentos := TProcesoDocumentos.Create(Sender,
    TDocumentosController.Create(TDocumentosDataModule.Create(
    (Sender as TComponent), GetModel.MasterDataModule)));
  ProcesoDocumentos.Show;
  (GetModel.MasterDataModule as ISubject).Attach(ProcesoDocumentos as IObserver);
end;

end.
