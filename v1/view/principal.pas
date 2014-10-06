unit Principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, frmMaestro,
  Menus, ExtCtrls, ComCtrls, StdCtrls, mvc, principalctrl;

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
    Pagos: TButton;
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
    StatusBar1: TStatusBar;
    trabajoPractico1: TMenuItem;
    procedure AsientosClick(Sender: TObject);
    procedure facturasClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure generarDeudaClick(Sender: TObject);
    procedure MenuItemABMCuentasClick(Sender: TObject);
    procedure PagosClick(Sender: TObject);
    procedure SalirClick(Sender: TObject);
    procedure setConnStatus(connected: boolean; host: string);
    procedure setLoggedUser(username: string);
    //procedure ayuda1Click(Sender: TObject);
    procedure ObserverUpdate(const Subject: IInterface); override;
    procedure academiasClick(Sender: TObject);
    procedure allpersonasClick(Sender: TObject);
    function GetCustomController: TPrincipalController;
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

procedure TPrincipal1.facturasClick(Sender: TObject);
begin
  GetCustomController.OpenFacturasForm(Self);
end;

procedure TPrincipal1.AsientosClick(Sender: TObject);
begin
  GetCustomController.OpenAsientosFrom(Self);
end;

procedure TPrincipal1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  inherited;
  Application.Terminate;
end;

procedure TPrincipal1.FormShow(Sender: TObject);
begin
  inherited;
  Controller.Connect(Self);
end;

procedure TPrincipal1.generarDeudaClick(Sender: TObject);
begin
  GetCustomController.OpenVentaForm(Self);
end;

procedure TPrincipal1.MenuItemABMCuentasClick(Sender: TObject);
begin
  GetCustomController.OpenABMCuentasForm(Self);
end;

procedure TPrincipal1.PagosClick(Sender: TObject);
begin
  GetCustomController.OpenPagosForm(Self);
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
  setConnStatus(Controller.IsDBConnected(Self),
    (Controller as TPrincipalController).GetHostName(Self));
  setLoggedUser((Controller as TPrincipalController).GetUserName(Self));
end;

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
  Result := (Controller as TPrincipalController);
end;

end.
