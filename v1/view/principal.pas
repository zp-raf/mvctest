unit Principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, frmMaestro,
  Menus, ExtCtrls, StdCtrls, ComCtrls, mvc, principalctrl;

type

  { TPrincipal1 }

  TPrincipal1 = class(TMaestro)
    ApplicationProperties1: TApplicationProperties;
    Asientos: TButton;
    Academico: TMenuItem;
    Administrativo: TMenuItem;
    ayuda2: TMenuItem;
    asistenciaProfesores: TMenuItem;
    aboutUs1: TMenuItem;
    ayuda1: TMenuItem;
    Button1: TButton;
    Listaalumnos: TButton;
    Documentos: TButton;
    ingresoegreso: TMenuItem;
    MenuItemTalonarioRec: TMenuItem;
    MenuItemAprobarJusti: TMenuItem;
    MenuItemDocumentos: TMenuItem;
    MenuItemAsignacion: TMenuItem;
    Pagos: TButton;
    gestionCurso: TMenuItem;
    academias: TMenuItem;
    grupos: TMenuItem;
    matricular: TMenuItem;
    materias: TMenuItem;
    clases: TMenuItem;
    examenes: TMenuItem;
    equipos: TMenuItem;
    extracto: TMenuItem;
    cuentasCobrar: TMenuItem;
    cuentasPagar: TMenuItem;
    cargarRecibo: TMenuItem;
    cargarFactura: TMenuItem;
    cargarNotaCredito: TMenuItem;
    desarrolloMaterias: TMenuItem;
    aranceles: TMenuItem;
    cuotaxarancel: TMenuItem;
    examenabm: TMenuItem;
    calificar: TMenuItem;
    MenuItemGenerarDeuda: TMenuItem;
    certificadoEstudio: TMenuItem;
    MenuItemABMCuentas: TMenuItem;
    reportRegAsistencia: TMenuItem;
    reporte1: TMenuItem;
    calcularnota: TMenuItem;
    confirmar: TMenuItem;
    escala: TMenuItem;
    multas: TMenuItem;
    talonarios: TMenuItem;
    secciones: TMenuItem;
    periodos: TMenuItem;
    modulos: TMenuItem;
    Salir: TMenuItem;
    allpersonas: TMenuItem;
    facturas: TMenuItem;
    notaCredito: TMenuItem;
    recibo: TMenuItem;
    justificativos: TMenuItem;
    financiero: TMenuItem;
    trabajos: TMenuItem;
    entregas: TMenuItem;
    personasSub: TMenuItem;
    alumnos: TMenuItem;
    personal: TMenuItem;
    personasext: TMenuItem;
    reservaEquipo1: TMenuItem;
    registroAnecdotico1: TMenuItem;
    trabajoPractico1: TMenuItem;
    procedure ApplicationProperties1Exception(Sender: TObject; E: Exception);
    procedure arancelesClick(Sender: TObject);
    procedure AsientosClick(Sender: TObject);
    procedure asistenciaProfesoresClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure calcularnotaClick(Sender: TObject);
    procedure calificarClick(Sender: TObject);
    procedure cargarFacturaClick(Sender: TObject);
    procedure cargarNotaCreditoClick(Sender: TObject);
    procedure cargarReciboClick(Sender: TObject);
    procedure clasesClick(Sender: TObject);
    procedure desarrolloMateriasClick(Sender: TObject);
    procedure DocumentosClick(Sender: TObject);
    procedure entregasClick(Sender: TObject);
    procedure equiposClick(Sender: TObject);
    procedure escalaClick(Sender: TObject);
    procedure examenabmClick(Sender: TObject);
    procedure extractoClick(Sender: TObject);
    procedure facturasClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure gruposClick(Sender: TObject);
    procedure ingresoegresoClick(Sender: TObject);
    procedure justificativosClick(Sender: TObject);
    procedure ListaalumnosClick(Sender: TObject);
    procedure materiasClick(Sender: TObject);
    procedure matricularClick(Sender: TObject);
    procedure MenuItemAprobarJustiClick(Sender: TObject);
    procedure MenuItemAsignacionClick(Sender: TObject);
    procedure MenuItemDocumentosClick(Sender: TObject);
    procedure MenuItemGenerarDeudaClick(Sender: TObject);
    procedure MenuItemABMCuentasClick(Sender: TObject);
    procedure MenuItemTalonarioRecClick(Sender: TObject);
    procedure modulosClick(Sender: TObject);
    procedure multasClick(Sender: TObject);
    procedure notaCreditoClick(Sender: TObject);
    procedure PagosClick(Sender: TObject);
    procedure periodosClick(Sender: TObject);
    procedure registroAnecdotico1Click(Sender: TObject);
    procedure reservaEquipo1Click(Sender: TObject);
    procedure SalirClick(Sender: TObject);
    //procedure ayuda1Click(Sender: TObject);
    procedure academiasClick(Sender: TObject);
    procedure allpersonasClick(Sender: TObject);
    function GetCustomController: TPrincipalController;
    procedure seccionesClick(Sender: TObject);
    procedure talonariosClick(Sender: TObject);
    procedure trabajosClick(Sender: TObject);
  end;

var
  Principal1: TPrincipal1;

implementation
uses uHelp;

{$R *.lfm}

{ TPrincipal1 }

procedure TPrincipal1.SalirClick(Sender: TObject);
begin
  GetController.Close(Self as IFormView);
end;

procedure TPrincipal1.facturasClick(Sender: TObject);
begin
  GetCustomController.OpenFacturasForm(Self);
end;

procedure TPrincipal1.AsientosClick(Sender: TObject);
begin
  GetCustomController.OpenAsientosFrom(Self);
end;

procedure TPrincipal1.asistenciaProfesoresClick(Sender: TObject);
begin
  GetCustomController.OpenAsistenciaForm(Self);
end;

procedure TPrincipal1.Button1Click(Sender: TObject);
begin
  GetCustomController.OpenHelpForm(Self);
end;

procedure TPrincipal1.arancelesClick(Sender: TObject);
begin
  GetCustomController.OpenABMAranceles(Self);
end;

procedure TPrincipal1.ApplicationProperties1Exception(Sender: TObject; E: Exception);
begin
  GetController.ErrorHandler(E, Self);
end;

procedure TPrincipal1.calcularnotaClick(Sender: TObject);
begin
  GetCustomController.OpenCalcularNotaForm(Self);
end;

procedure TPrincipal1.calificarClick(Sender: TObject);
begin
  GetCustomController.OpenCalificarForm(Self);
end;

procedure TPrincipal1.cargarFacturaClick(Sender: TObject);
begin
  GetCustomController.OpenFacturaCompraForm(Self);
end;

procedure TPrincipal1.cargarNotaCreditoClick(Sender: TObject);
begin
  GetCustomController.OpenNotaCreditoCompraForm(Self);
end;

procedure TPrincipal1.cargarReciboClick(Sender: TObject);
begin
  GetCustomController.OpenReciboCompraForm(Self);
end;

procedure TPrincipal1.clasesClick(Sender: TObject);
begin
  GetCustomController.OpenABMClasesForm(Self);
end;

procedure TPrincipal1.desarrolloMateriasClick(Sender: TObject);
begin
  GetCustomController.OpenABMDesarrolloForm(Self);
end;

procedure TPrincipal1.DocumentosClick(Sender: TObject);
begin
  GetCustomController.OpenDocumentosForm(Self);
end;

procedure TPrincipal1.entregasClick(Sender: TObject);
begin
  GetCustomController.OpenEntregaForm(Self);
end;

procedure TPrincipal1.equiposClick(Sender: TObject);
begin
  GetCustomController.OpenABMEquiposForm(Self);
end;

procedure TPrincipal1.escalaClick(Sender: TObject);
begin
  GetCustomController.OpenEscalaForm(Self);
end;

procedure TPrincipal1.examenabmClick(Sender: TObject);
begin
  GetCustomController.OpenExamenesForm(Self);
end;

procedure TPrincipal1.extractoClick(Sender: TObject);
begin
  GetCustomController.OpenExtractoRepForm(Self);
end;

procedure TPrincipal1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  inherited;
  Application.Terminate;
end;

procedure TPrincipal1.FormShow(Sender: TObject);
begin
  inherited;
  GetController.Connect(Self);
end;

procedure TPrincipal1.gruposClick(Sender: TObject);
begin
  GetCustomController.OpenABMGruposForm(Self);
end;

procedure TPrincipal1.ingresoegresoClick(Sender: TObject);
begin
  GetCustomController.OpenIngEgresoReporteForm(Self);
end;

procedure TPrincipal1.justificativosClick(Sender: TObject);
begin
  GetCustomController.OpenABMJustificativosForm(Self);
end;

procedure TPrincipal1.ListaalumnosClick(Sender: TObject);
begin
  GetCustomController.OpenListaAlumnos(Self);
end;

procedure TPrincipal1.materiasClick(Sender: TObject);
begin
  GetCustomController.OpenABMMateriasForm(Self);
end;

procedure TPrincipal1.matricularClick(Sender: TObject);
begin
  GetCustomController.OpenMatriculacionForm(Self);
end;

procedure TPrincipal1.MenuItemAprobarJustiClick(Sender: TObject);
begin
  GetCustomController.OpenAprobarJustForm(Self);
end;

procedure TPrincipal1.MenuItemAsignacionClick(Sender: TObject);
begin
  GetCustomController.OpenAsignacionFrom(Self);
end;

procedure TPrincipal1.MenuItemDocumentosClick(Sender: TObject);
begin
  GetCustomController.OpenDocumentosForm(Self);
end;

procedure TPrincipal1.MenuItemGenerarDeudaClick(Sender: TObject);
begin
  GetCustomController.OpenDeudaForm(Self);
end;

procedure TPrincipal1.MenuItemABMCuentasClick(Sender: TObject);
begin
  GetCustomController.OpenABMCuentasForm(Self);
end;

procedure TPrincipal1.MenuItemTalonarioRecClick(Sender: TObject);
begin
  GetCustomController.OpenSeleccionTalonarioRecForm(Self);
end;

procedure TPrincipal1.modulosClick(Sender: TObject);
begin
  GetCustomController.OpenABMModulos(Self);
end;

procedure TPrincipal1.multasClick(Sender: TObject);
begin
  GetCustomController.OpenMultasForm(Self);
end;

procedure TPrincipal1.notaCreditoClick(Sender: TObject);
begin
  GetCustomController.OpenNotaCreditoForm(Self);
end;

procedure TPrincipal1.PagosClick(Sender: TObject);
begin
  GetCustomController.OpenPagosForm(Self);
end;

procedure TPrincipal1.periodosClick(Sender: TObject);
begin
  GetCustomController.OpenABMPeriodos(Self);
end;

procedure TPrincipal1.registroAnecdotico1Click(Sender: TObject);
begin
  GetCustomController.OpenRegistroAnecdoticoForm(Self);
end;

procedure TPrincipal1.reservaEquipo1Click(Sender: TObject);
begin
  GetCustomController.OpenReservaEquiposForm(Self);
end;

//procedure TPrincipal1.ayuda1Click(Sender: TObject);
//begin
//  //hacer algo
//  //  ShellExecute(Handle, 'open', 'help\sgcd-help_v1.chm', nil, nil, 1);
//  //ShellExecute(Handle, 'open', 'help\ABMs\index.html', nil, nil, 1);
//end;

procedure TPrincipal1.academiasClick(Sender: TObject);
begin
  GetCustomController.ABMAcad(Self);
end;

procedure TPrincipal1.allpersonasClick(Sender: TObject);
begin
  GetCustomController.allpersonasClick(Self);
end;

function TPrincipal1.GetCustomController: TPrincipalController;
begin
  Result := (GetController as TPrincipalController);
end;

procedure TPrincipal1.seccionesClick(Sender: TObject);
begin
  GetCustomController.OpenABMSeccionesForm(Self);
end;

procedure TPrincipal1.talonariosClick(Sender: TObject);
begin
  GetCustomController.OpenABMTalonariosForm(Self);
end;

procedure TPrincipal1.trabajosClick(Sender: TObject);
begin
  GetCustomController.OpenABMTrabajosForm(Self);
end;

end.
