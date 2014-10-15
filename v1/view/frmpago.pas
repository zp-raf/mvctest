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
    DBEditCheques: TDBEdit;
    DBEditTarjeta: TDBEdit;
    DBEditPagado: TDBEdit;
    DBEditVuelto: TDBEdit;
    DBEditTotal: TDBEdit;
    DBGridCheques: TDBGrid;
    DBGridTarjetas: TDBGrid;
    DBNavigatorCheques: TDBNavigator;
    DBNavigatorTarjetas: TDBNavigator;
    GroupBoxDetalles: TGroupBox;
    LabelDetCheques: TLabel;
    LabelDetTarjetas: TLabel;
    LabelEfectivo: TLabel;
    LabelTotal: TLabel;
    LabelCheques: TLabel;
    LabelTarjetas: TLabel;
    LabelTotalPagado: TLabel;
    LabelVuelto: TLabel;
    PairSplitter1: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    GroupBoxTotales: TGroupBox;
    procedure FormShow(Sender: TObject);
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

implementation

{$R *.lfm}

{ TProcesoPago }

procedure TProcesoPago.FormShow(Sender: TObject);
begin
  inherited;
  CustomController.NuevoPago(True, '383', doFactura);
end;

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
