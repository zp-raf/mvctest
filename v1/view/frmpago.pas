unit frmpago;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, DB, FileUtil, Forms, Controls, Graphics, Dialogs,
  Menus, ButtonPanel, StdCtrls, DBGrids, DBCtrls, PairSplitter, frmMaestro,
  frmproceso, frmsgcddatamodule, frmpagodatamodule, pagoctrl, mvc;

const
  Credito = 1;
  Debito = 2;
  Factura = 1;
  Recibo = 2;
  NotaCredito = 3;
  Efectivo = 1;
  Cheque = 2;
  TarjetaDebito = 3;
  TarjetaCredito = 4;

//TipoMovimiento: array[Credito..Debito] of shortstring = (
//  'Credito',
//  'Debito');
//TipoComprobante: array[Factura..NotaCredito] of shortstring = (
//  'Factura',
//  'Recibo',
//  'NotaCredito');
//TipoPago: array[Efectivo..TarjetaCredito] of shortstring = (
//  'Efectivo',
//  'Cheque',
//  'TarjetaDebito',
//  'TarjetaCredito');

type

  { TProcesoPago }

  TProcesoPago = class(TProceso)
    DBEditEfectivo: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit2: TDBEdit;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBNavigator1: TDBNavigator;
    DBNavigator2: TDBNavigator;
    Detalles: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    PairSplitter1: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    Totales: TGroupBox;
  private
    FCustomController: TPagoController;
    procedure SetCustomController(AValue: TPagoController);
  public
    constructor Create(AOwner: IFormView; AController: TPagoController); overload;
  published
    procedure CancelButtonClick(Sender: TObject);
    procedure DBEditEfectivoEditingDone(Sender: TObject);
    procedure Limpiar;
    procedure OKButtonClick(Sender: TObject);
    procedure ObserverUpdate(const Subject: IInterface); override;
    property CustomController: TPagoController
      read FCustomController write SetCustomController;
  end;

var
  ProcesoPago: TProcesoPago;
//pid: integer;
//pdid: integer;

implementation

{$R *.lfm}

{ TProcesoPago }

procedure TProcesoPago.SetCustomController(AValue: TPagoController);
begin
  if FCustomController = AValue then
    Exit;
  FCustomController := AValue;
end;

procedure TProcesoPago.CancelButtonClick(Sender: TObject);
begin

end;

procedure TProcesoPago.DBEditEfectivoEditingDone(Sender: TObject);
begin

end;

procedure TProcesoPago.Limpiar;
begin

end;

procedure TProcesoPago.OKButtonClick(Sender: TObject);
begin

end;

procedure TProcesoPago.ObserverUpdate(const Subject: IInterface);
begin

end;

constructor TProcesoPago.Create(AOwner: IFormView; AController: TPagoController);
var
  Cont: IController;
begin
  { Aca se chequean el controlador y se asignan las propiedades
    correspondientes. Con queryinterface sacamos una referencia al objeto que
    implementa la interfaz. Hacemos asi por si acaso AController sea un objeto
    compuesto y que hayan subojetos que implementen las interfaces. Esto nos da
    mayor flexibilidad en la implementacion. }
  (AController as IInterface).QueryInterface(IController, Cont);
  if Cont = nil then
    raise Exception.Create(rsProvidedCont)
  else
  begin
    inherited Create(AOwner, Cont);
    CustomController := AController;
  end;
end;

end.
