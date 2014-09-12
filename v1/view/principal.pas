unit Principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, frmMaestro,
  Menus, ExtCtrls, ComCtrls, StdCtrls, mvc, principalctrl;

type

  { TPrincipal1 }

  TPrincipal1 = class(TMaestro)
    Button1: TButton;
    MainMenu1: TMainMenu;
    Academico: TMenuItem;
    Administrativo: TMenuItem;
    ayuda2: TMenuItem;
    asistenciaProfesores: TMenuItem;
    aboutUs1: TMenuItem;
    ayuda1: TMenuItem;
    gestionCurso: TMenuItem;
    academias: TMenuItem;
    grupos: TMenuItem;
    matricular: TMenuItem;
    materias: TMenuItem;
    clases: TMenuItem;
    examenes: TMenuItem;
    equipos: TMenuItem;
    historico: TMenuItem;
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
    generarDeuda: TMenuItem;
    certificadoEstudio: TMenuItem;
    historicoMovimiento: TMenuItem;
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
    StatusBar1: TStatusBar;
    trabajoPractico1: TMenuItem;
    procedure SalirClick(Sender: TObject);
    procedure setConnStatus(connected: boolean; host: string);
    procedure setLoggedUser(username: string);
    //procedure ayuda1Click(Sender: TObject);
    procedure ObserverUpdate(const Subject: IInterface); override;
    procedure academiasClick(Sender: TObject);
    procedure allpersonasClick(Sender: TObject);
    //procedure alumnosClick(Sender: TObject);
    //procedure arancelesClick(Sender: TObject);
    //procedure asistenciaProfesoresClick(Sender: TObject);
    //procedure calcularnotaClick(Sender: TObject);
    //procedure calificarClick(Sender: TObject);
    //procedure cargarFacturaClick(Sender: TObject);
    //procedure cargarNotaCreditoClick(Sender: TObject);
    //procedure cargarReciboClick(Sender: TObject);
    //procedure certificadoEstudioClick(Sender: TObject);
    //procedure clasesClick(Sender: TObject);
    //procedure cuentasCobrarClick(Sender: TObject);
    //procedure cuentasPagarClick(Sender: TObject);
    //procedure cuotaxarancelClick(Sender: TObject);
    //procedure desarrolloMateriasClick(Sender: TObject);
    //procedure entregasClick(Sender: TObject);
    //procedure equiposClick(Sender: TObject);
    //procedure escalaClick(Sender: TObject);
    //procedure examenesClick(Sender: TObject);
    //procedure facturasClick(Sender: TObject);
    //procedure generarDeudaClick(Sender: TObject);
    //procedure gruposClick(Sender: TObject);
    //procedure historicoClick(Sender: TObject);
    //procedure historicoMovimientoClick(Sender: TObject);
    //procedure justificativosClick(Sender: TObject);
    //procedure materiasClick(Sender: TObject);
    //procedure matricularClick(Sender: TObject);
    //procedure confirmarClick(Sender: TObject);
    //procedure modulosClick(Sender: TObject);
    //procedure multasClick(Sender: TObject);
    //procedure notaCreditoClick(Sender: TObject);
    //procedure periodosClick(Sender: TObject);
    //procedure personalClick(Sender: TObject);
    //procedure personasextClick(Sender: TObject);
    //procedure reciboClick(Sender: TObject);
    //procedure registroAnecdotico1Click(Sender: TObject);
    //procedure reportRegAsistenciaClick(Sender: TObject);
    //procedure reservaEquipo1Click(Sender: TObject);
    //procedure seccionesClick(Sender: TObject);
    //procedure talonariosClick(Sender: TObject);
    //procedure trabajosClick(Sender: TObject);
  end;

var
  Principal1: TPrincipal1;

implementation

{$R *.lfm}

{ TPrincipal1 }

procedure TPrincipal1.setConnStatus(connected: boolean; host: string);
begin
  if connected then
    StatusBar1.Panels.Items[1].Text := 'Server: ' + host
  else
    StatusBar1.Panels.Items[1].Text := 'Desconectado';
end;

procedure TPrincipal1.SalirClick(Sender: TObject);
begin
  Controller.Close(Self as IFormView);
end;

procedure TPrincipal1.setLoggedUser(username: string);
begin
  StatusBar1.Panels.Items[0].Text := username;
end;

//procedure TPrincipal1.ayuda1Click(Sender: TObject);
//begin
//  //hacer algo
//  //  ShellExecute(Handle, 'open', 'help\sgcd-help_v1.chm', nil, nil, 1);
//  //ShellExecute(Handle, 'open', 'help\ABMs\index.html', nil, nil, 1);
//end;

procedure TPrincipal1.ObserverUpdate(const Subject: IInterface);
begin
  //setConnStatus(Controller.IsDBConnected(Self),
  //  (Controller as TPrincipalController).GetHostName(Self));
  //setLoggedUser((Controller as TPrincipalController).GetUserName(Self));
end;

procedure TPrincipal1.academiasClick(Sender: TObject);
begin
  (Controller as TPrincipalController).ABMAcad(Self);
end;

procedure TPrincipal1.allpersonasClick(Sender: TObject);
begin
  (Controller as TPrincipalController).allpersonasClick(Self);
end;

end.
