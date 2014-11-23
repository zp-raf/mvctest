unit Principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, frmMaestro,
  Menus, ExtCtrls, StdCtrls, ComCtrls, mvc, principalctrl;

type

  { TPrincipal1 }

  TPrincipal1 = class(TMaestro)
    Asientos: TButton;
    Academico: TMenuItem;
    Administrativo: TMenuItem;
    ayuda2: TMenuItem;
    asistenciaProfesores: TMenuItem;
    aboutUs1: TMenuItem;
    ayuda1: TMenuItem;
    Listaalumnos: TButton;
    Documentos: TButton;
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
    procedure AsientosClick(Sender: TObject);
    procedure calcularnotaClick(Sender: TObject);
    procedure calificarClick(Sender: TObject);
    procedure DocumentosClick(Sender: TObject);
    procedure escalaClick(Sender: TObject);
    procedure examenabmClick(Sender: TObject);
    procedure extractoClick(Sender: TObject);
    procedure facturasClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure ListaalumnosClick(Sender: TObject);
    procedure matricularClick(Sender: TObject);
    procedure MenuItemAsignacionClick(Sender: TObject);
    procedure MenuItemGenerarDeudaClick(Sender: TObject);
    procedure MenuItemABMCuentasClick(Sender: TObject);
    procedure notaCreditoClick(Sender: TObject);
    procedure PagosClick(Sender: TObject);
    procedure SalirClick(Sender: TObject);
    //procedure ayuda1Click(Sender: TObject);
    procedure academiasClick(Sender: TObject);
    procedure allpersonasClick(Sender: TObject);
    function GetCustomController: TPrincipalController;
    procedure trabajosClick(Sender: TObject);
  end;

var
  Principal1: TPrincipal1;

implementation

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

procedure TPrincipal1.calcularnotaClick(Sender: TObject);
begin
  GetCustomController.OpenCalcularNotaForm(Self);
end;

procedure TPrincipal1.calificarClick(Sender: TObject);
begin
  GetCustomController.OpenCalificarForm(Self);
end;

procedure TPrincipal1.DocumentosClick(Sender: TObject);
begin
  GetCustomController.OpenDocumentosForm(Self);
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

procedure TPrincipal1.ListaalumnosClick(Sender: TObject);
begin
  GetCustomController.OpenListaAlumnos(Self);
end;

procedure TPrincipal1.matricularClick(Sender: TObject);
begin
  GetCustomController.OpenMatriculacionForm(Self);
end;

procedure TPrincipal1.MenuItemAsignacionClick(Sender: TObject);
begin
  GetCustomController.OpenAsignacionFrom(Self);
end;

procedure TPrincipal1.MenuItemGenerarDeudaClick(Sender: TObject);
begin
  GetCustomController.OpenDeudaForm(Self);
end;

procedure TPrincipal1.MenuItemABMCuentasClick(Sender: TObject);
begin
  GetCustomController.OpenABMCuentasForm(Self);
end;

procedure TPrincipal1.notaCreditoClick(Sender: TObject);
begin
  GetCustomController.OpenNotaCreditoForm(Self);
end;

procedure TPrincipal1.PagosClick(Sender: TObject);
begin
  GetCustomController.OpenPagosForm(Self);
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

procedure TPrincipal1.trabajosClick(Sender: TObject);
begin
  GetCustomController.OpenABMTrabajosForm(Self);
end;

end.
