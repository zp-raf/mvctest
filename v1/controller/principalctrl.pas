unit principalctrl;

{$mode objfpc}{$H+}

interface

uses
  ctrl, mvc, observerSubject, Classes, Controls,
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
  notasctrl,
  // Entrega trabajos
  frmentregadatamodule,
  frmprocesoentrega,
  entregactrl,
  // factura compra
  frmprocesofacturacompra,
  // ABM aranceles
  frmaranceldatamodule,
  frmabmaranceles,
  arancelesctrl,
  // abm modulos
  frmmodulodatamodule,
  frmabmmodulos,
  moduloctrl,
  // recibo de compra
  frmrecibodatamodule,
  frmprocesorecibocompra,
  reciboctrl,
  // nota credito compra
  frmprocesonotacreditocompra,
  // ABM talonarios
  frmtalonariodatamodule,
  frmabmtalonarios,
  talonarioctrl,
  // multas
  frmmultasdatamodule,
  frmmultas,
  multactrl,
  // periodos lectivos
  frmperiodosdatamodule,
  frmabmperiodos,
  periodoctrl,
  // abm grupos
  frmgrupodatamodule,
  frmbabmgrupos,
  gruposctrl,
  // abm secciones
  frmsecciondatamodule,
  frmabmsecciones,
  seccionctrl,
  // abm materias
  frmmateriasdatamodule,
  frmabmmaterias,
  materiactrl,
  // abm desarrollo
  frmdesarrollodatamodule,
  frmabmdesarrollomat,
  desarrolloctrl,
  //abmclases
  frmclasesdatamodule,
  frmabmclases,
  clasesctrl,
  // registro anecdotico
  frmregistroanecdoticodatamodule,
  frmprocesoreganecdotico,
  registroanecdoticoctrl,
  // abm equipos
  frmequiposdatamodule,
  frmabmequipos,
  equipoctrl,
  // prestamo equipos
  frmprestamodatamodule,
  frmabmprestamos,
  prestamoctrl,
  // abm justificativos
  frmjustificativodatamodule,
  frmabmjustificativos,
  justificativoctrl,
  // aprobar justificativos
  frmaprobarjustdatamodule,
  frmprocesoaprobarjustificativo,
  // seleccionar talonario recibo
  frmseleccionartalonario,
  // reporte ingresos egresos
  frmrptingegrdatamodule,
  frmprocesorptingegr,
  reporteingegrctrl,
  // registro asistencia
  frmprocesoCargaHoraProf,
  asistenciactrl,
  frmasistenciadatamodule,
  uHelp,
  // reporte matriculacion
  frmreportematriculaciondatamodule,
  rptmatriculacionctrl,
  frmreportematriculacion,
  // otorgar derecho
  frmderechoexamendatamodule,
  derechoexamenctrl,
  frmprocesoderechoexamen,
  // devolucion de saldo
  frmdevoluciondatamodule,
  frmprocesodevolucion,
  devolucionctrl,
  // certificado de estudios
  frmrepcertificadodatamodule,
  frmprocesorptcertificado,
  rptcertificadoctrl;

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
    procedure OpenEntregaForm(Sender: IFormView);
    procedure OpenFacturaCompraForm(Sender: IFormView);
    procedure OpenABMAranceles(Sender: IFormView);
    procedure OpenABMModulos(Sender: IFormView);
    procedure OpenReciboCompraForm(Sender: IFormView);
    procedure OpenNotaCreditoCompraForm(Sender: IFormView);
    procedure OpenABMTalonariosForm(Sender: IFormView);
    procedure OpenMultasForm(Sender: IFormView);
    procedure OpenABMPeriodos(Sender: IFormView);
    procedure OpenABMGruposForm(Sender: IFormView);
    procedure OpenABMSeccionesForm(Sender: IFormView);
    procedure OpenABMMateriasForm(Sender: IFormView);
    procedure OpenABMDesarrolloForm(Sender: IFormView);
    procedure OpenABMClasesForm(Sender: IFormView);
    procedure OpenRegistroAnecdoticoForm(Sender: IFormView);
    procedure OpenABMEquiposForm(Sender: IFormView);
    procedure OpenReservaEquiposForm(Sender: IFormView);
    procedure OpenAsistenciaForm(Sender: IFormView);
    procedure OpenABMJustificativosForm(Sender: IFormView);
    procedure OpenAprobarJustForm(Sender: IFormView);
    procedure OpenSeleccionTalonarioRecForm(Sender: IFormView);
    procedure OpenIngEgresoReporteForm(Sender: IFormView);
    procedure OpenHelpForm(Sender: IFormView);
    procedure OpenReporteMatriculacionForm(Sender: IFormView);
    procedure OpenDerechoExamenForm(Sender: IFormView);
    procedure OpenDevolucionForm(Sender: IFormView);
    procedure OpenReporteCertificadoForm(Sender: IFormView);
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

procedure TPrincipalController.OpenEntregaForm(Sender: IFormView);
begin
  ProcesoEntrega := TProcesoEntrega.Create(Sender,
    TEntregaController.Create(TEntregaDataModule.Create(
    (Sender as TComponent), GetModel.MasterDataModule)));
  ProcesoEntrega.Show;
  (GetModel.MasterDataModule as ISubject).Attach(ProcesoEntrega as IObserver);
end;

procedure TPrincipalController.OpenFacturaCompraForm(Sender: IFormView);
begin
  ProcesoFacturaCompra := TProcesoFacturaCompra.Create(Sender,
    TFacturaController.Create(TFacturasDataModule.Create(
    (Sender as TComponent), GetModel.MasterDataModule)));
  ProcesoFacturaCompra.Show;
  (GetModel.MasterDataModule as ISubject).Attach(ProcesoFacturaCompra as IObserver);
end;

procedure TPrincipalController.OpenABMAranceles(Sender: IFormView);
begin
  AbmAranceles := TAbmAranceles.Create(Sender,
    TArancelesController.Create(TArancelesDataModule.Create(
    (Sender as TComponent), GetModel.MasterDataModule)));
  AbmAranceles.Show;
  (GetModel.MasterDataModule as ISubject).Attach(AbmAranceles as IObserver);
end;

procedure TPrincipalController.OpenABMModulos(Sender: IFormView);
begin
  AbmModulos := TAbmModulos.Create(Sender, TModuloController.Create(
    TModuloDataModule.Create((Sender as TComponent), GetModel.MasterDataModule)));
  AbmModulos.Show;
  (GetModel.MasterDataModule as ISubject).Attach(AbmModulos as IObserver);
end;

procedure TPrincipalController.OpenReciboCompraForm(Sender: IFormView);
begin
  ProcesoReciboCompra := TProcesoReciboCompra.Create(Sender,
    TReciboController.Create(TReciboDataModule.Create(
    (Sender as TComponent), GetModel.MasterDataModule)));
  ProcesoReciboCompra.Show;
  (GetModel.MasterDataModule as ISubject).Attach(ProcesoReciboCompra as IObserver);
end;

procedure TPrincipalController.OpenNotaCreditoCompraForm(Sender: IFormView);
begin
  ProcesoNotaCreditoCompra :=
    TProcesoNotaCreditoCompra.Create(Sender, TNotaCreditoController.Create(
    TNotaCreditoDataModule.Create((Sender as TComponent), GetModel.MasterDataModule)));
  ProcesoNotaCreditoCompra.Show;
  (GetModel.MasterDataModule as ISubject).Attach(ProcesoNotaCreditoCompra as IObserver);
end;

procedure TPrincipalController.OpenABMTalonariosForm(Sender: IFormView);
begin
  AbmTalonarios := TAbmTalonarios.Create(Sender, TTalonarioController.Create(
    TTalonarioDataModule.Create((Sender as TComponent), GetModel.MasterDataModule)));
  AbmTalonarios.Show;
  (GetModel.MasterDataModule as ISubject).Attach(AbmTalonarios as IObserver);
end;

procedure TPrincipalController.OpenMultasForm(Sender: IFormView);
begin
  ProcesoMultas := TProcesoMultas.Create(Sender,
    TMultaController.Create(TMultasDataModule.Create(
    (Sender as TComponent), GetModel.MasterDataModule)));
  ProcesoMultas.Show;
  (GetModel.MasterDataModule as ISubject).Attach(ProcesoMultas as IObserver);
end;

procedure TPrincipalController.OpenABMPeriodos(Sender: IFormView);
begin
  AbmPeriodos := TAbmPeriodos.Create(Sender,
    TPeriodoController.Create(TPeriodosDataModule.Create(
    (Sender as TComponent), GetModel.MasterDataModule)));
  AbmPeriodos.Show;
  (GetModel.MasterDataModule as ISubject).Attach(AbmPeriodos as IObserver);
end;

procedure TPrincipalController.OpenABMGruposForm(Sender: IFormView);
begin
  AbmGrupos := TAbmGrupos.Create(Sender, TGrupoController.Create(
    TGrupoDataModule.Create((Sender as TComponent), GetModel.MasterDataModule)));
  AbmGrupos.Show;
  (GetModel.MasterDataModule as ISubject).Attach(AbmGrupos as IObserver);
end;

procedure TPrincipalController.OpenABMSeccionesForm(Sender: IFormView);
begin
  AbmSecciones := TAbmSecciones.Create(Sender,
    TSeccionController.Create(TSeccionDataModule.Create(
    (Sender as TComponent), GetModel.MasterDataModule)));
  AbmSecciones.Show;
  (GetModel.MasterDataModule as ISubject).Attach(AbmSecciones as IObserver);
end;

procedure TPrincipalController.OpenABMMateriasForm(Sender: IFormView);
begin
  AbmMaterias := TAbmMaterias.Create(Sender,
    TMateriaController.Create(TMateriasDataModule.Create(
    (Sender as TComponent), GetModel.MasterDataModule)));
  AbmMaterias.Show;
  (GetModel.MasterDataModule as ISubject).Attach(AbmMaterias as IObserver);
end;

procedure TPrincipalController.OpenABMDesarrolloForm(Sender: IFormView);
begin
  AbmDesarrolloMAt := TAbmDesarrolloMAt.Create(Sender,
    TDesarrolloController.Create(TDesarrolloMateriaDataModule.Create(
    (Sender as TComponent), GetModel.MasterDataModule)));
  AbmDesarrolloMAt.Show;
  (GetModel.MasterDataModule as ISubject).Attach(AbmDesarrolloMAt as IObserver);
end;

procedure TPrincipalController.OpenABMClasesForm(Sender: IFormView);
begin
  AbmClases := TAbmClases.Create(Sender, TClaseController.Create(
    TClasesDataModule.Create((Sender as TComponent), GetModel.MasterDataModule)));
  AbmClases.Show;
  (GetModel.MasterDataModule as ISubject).Attach(AbmClases as IObserver);
end;

procedure TPrincipalController.OpenRegistroAnecdoticoForm(Sender: IFormView);
begin
  ProcesoRegistroAnecdotico :=
    TProcesoRegistroAnecdotico.Create(Sender,
    TRegistroAnecdoticoController.Create(TRegistroAnecdoticoDataModule.Create(
    (Sender as TComponent), GetModel.MasterDataModule)));
  ProcesoRegistroAnecdotico.Show;
  (GetModel.MasterDataModule as ISubject).Attach(ProcesoRegistroAnecdotico as IObserver);
end;

procedure TPrincipalController.OpenABMEquiposForm(Sender: IFormView);
begin
  AbmEquipos := TAbmEquipos.Create(Sender, TEquiposController.Create(
    TEquiposDataModule.Create((Sender as TComponent), GetModel.MasterDataModule)));
  AbmEquipos.Show;
  (GetModel.MasterDataModule as ISubject).Attach(AbmEquipos as IObserver);
end;

procedure TPrincipalController.OpenReservaEquiposForm(Sender: IFormView);
begin
  AbmPrestamos := TAbmPrestamos.Create(Sender, TPrestamoController.Create(
    TPrestamoDataModule.Create((Sender as TComponent), GetModel.MasterDataModule)));
  AbmPrestamos.Show;
  (GetModel.MasterDataModule as ISubject).Attach(AbmPrestamos as IObserver);
end;

procedure TPrincipalController.OpenAsistenciaForm(Sender: IFormView);
begin
  procesoCargaHoraProf := TprocesoCargaHoraProf.Create(Sender,
    TAsistenciaController.Create(TAsistenciaDataModule.Create(
    (Sender as TComponent), GetModel.MasterDataModule)));
  procesoCargaHoraProf.Show;
  (GetModel.MasterDataModule as ISubject).Attach(procesoCargaHoraProf as IObserver);
end;

procedure TPrincipalController.OpenABMJustificativosForm(Sender: IFormView);
begin
  AbmJustificativos := TAbmJustificativos.Create(Sender,
    TJustificativoController.Create(TJustificativoDataModule.Create(
    (Sender as TComponent), GetModel.MasterDataModule)));
  AbmJustificativos.Show;
  (GetModel.MasterDataModule as ISubject).Attach(AbmJustificativos as IObserver);
end;

procedure TPrincipalController.OpenAprobarJustForm(Sender: IFormView);
begin
  ProcesoAprobarJustificativo :=
    TProcesoAprobarJustificativo.Create(Sender,
    TAprobarJustificativoController.Create(TAprobarJustificativoDataModule.Create(
    (Sender as TComponent), GetModel.MasterDataModule)));
  ProcesoAprobarJustificativo.Show;
  (GetModel.MasterDataModule as ISubject).Attach(ProcesoAprobarJustificativo as
    IObserver);
end;

procedure TPrincipalController.OpenSeleccionTalonarioRecForm(Sender: IFormView);
var
  Contr: TSeleccionTalonariosController;
begin
  ReciboDataModule := TReciboDataModule.Create((Sender as TComponent),
    GetModel.MasterDataModule);
  Contr := TSeleccionTalonariosController.Create(ReciboDataModule.Talonarios);
  SeleccionTalonario := TSeleccionarTalonario.Create(Sender, Contr);
  try
    ReciboDataModule.LocateTalonario;
    case SeleccionTalonario.ShowModal of
      mrOk:
      begin
        ReciboDataModule.TalonarioID :=
          ReciboDataModule.Talonarios.TalonarioView.FieldByName('ID').AsString;
        with ReciboDataModule do
        begin
          IniPropStorage1.Save;
          IniPropStorage1.Save;
        end;
      end;
      mrCancel:
      begin

      end;
    end;
  finally
    SeleccionTalonario.Free;
    ReciboDataModule.Free;
  end;
end;

procedure TPrincipalController.OpenIngEgresoReporteForm(Sender: IFormView);
begin
  ProcesoReportIngEgr := TProcesoReportIngEgr.Create(Sender,
    TRepIngEgrController.Create(TReporteIngEgrDataModule.Create(
    (Sender as TComponent), GetModel.MasterDataModule)));
  ProcesoReportIngEgr.Show;
  (GetModel.MasterDataModule as ISubject).Attach(ProcesoReportIngEgr as IObserver);
end;

procedure TPrincipalController.OpenHelpForm(Sender: IFormView);
begin
  //    frmHelp := TfrmHelp.Create(Sender as TComponent);
  frmHelp := TfrmHelp.CreateNew(Sender as TComponent);
  frmHelp.Show;
  frmHelp.OpenHTMLFile('about.html');
end;

procedure TPrincipalController.OpenReporteMatriculacionForm(Sender: IFormView);
begin
  ProcesoReporteMatriculacion :=
    TProcesoReporteMatriculacion.Create(Sender,
    TReporteMatriculacionController.Create(TReporteMatriculacionDataModule.Create(
    (Sender as TComponent), GetModel.MasterDataModule)));
  ProcesoReporteMatriculacion.Show;
  (GetModel.MasterDataModule as ISubject).Attach(ProcesoReporteMatriculacion as
    IObserver);
end;

procedure TPrincipalController.OpenDerechoExamenForm(Sender: IFormView);
begin
  ProcesoDerechoExamen := TProcesoDerechoExamen.Create(Sender,
    TDerechoExamenController.Create(TDerechoExamenDataModule.Create(
    (Sender as TComponent), GetModel.MasterDataModule)));
  ProcesoDerechoExamen.Show;
  (GetModel.MasterDataModule as ISubject).Attach(ProcesoDerechoExamen as IObserver);
end;

procedure TPrincipalController.OpenDevolucionForm(Sender: IFormView);
begin
  ProcesoDevolucion := TProcesoDevolucion.Create(Sender,
    TDevolucionController.Create(TDevolucionDataModule.Create(
    (Sender as TComponent), GetModel.MasterDataModule)));
  ProcesoDevolucion.Show;
  (GetModel.MasterDataModule as ISubject).Attach(ProcesoDevolucion as IObserver);
end;

procedure TPrincipalController.OpenReporteCertificadoForm(Sender: IFormView);
begin
  ProcesoRptCertificado := TProcesoRptCertificado.Create(Sender,
    TReporteCertificadoController.Create(TReporteCertificadoDataModule.Create(
    (Sender as TComponent), GetModel.MasterDataModule)));
  ProcesoRptCertificado.Show;
  (GetModel.MasterDataModule as ISubject).Attach(ProcesoRptCertificado as IObserver);
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
