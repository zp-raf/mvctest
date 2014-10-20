unit frmpago;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, DB, FileUtil, Forms, Controls, Graphics, Dialogs,
  Menus, ButtonPanel, StdCtrls, DBGrids, DBCtrls, PairSplitter, frmMaestro,
  frmproceso, frmsgcddatamodule, frmpagodatamodule, pagoctrl, mvc, observerSubject;

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
    procedure FormCreate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FCustomController: TPagoController;
    procedure SetCustomController(AValue: TPagoController);
  public
    constructor Create(AOwner: IFormView; AController: TPagoController); overload;
  published
    procedure CancelButtonClick(Sender: TObject);
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
  //inherited;
  if GetOwner <> nil then
    TForm(GetOwner).Enabled := False;
  //CustomController.NuevoPago(True, '409', doFactura);
  if not (fsModal in FormState) then
    Controller.OpenDataSets(Self);
end;

procedure TProcesoPago.FormCreate(Sender: TObject);
begin
  ButtonPanel1.OKButton.ModalResult := mrOk;
  ButtonPanel1.CancelButton.ModalResult := mrCancel;
end;

procedure TProcesoPago.FormHide(Sender: TObject);
begin
  if GetOwner <> nil then
    TForm(GetOwner).Enabled := True;
end;

procedure TProcesoPago.SetCustomController(AValue: TPagoController);
begin
  if FCustomController = AValue then
    Exit;
  FCustomController := AValue;
end;

procedure TProcesoPago.CancelButtonClick(Sender: TObject);
begin
  CustomController.Cancel(Self);
end;

procedure TProcesoPago.Limpiar;
begin

end;

procedure TProcesoPago.OKButtonClick(Sender: TObject);
begin
  CustomController.CerrarPago(Self);
end;

procedure TProcesoPago.ObserverUpdate(const Subject: IInterface);
begin
  if CustomController.PagoListo then
    ButtonPanel1.OKButton.Enabled := True
  else
    ButtonPanel1.OKButton.Enabled := False;
end;

constructor TProcesoPago.Create(AOwner: IFormView; AController: TPagoController);
var
  x: IController;
begin
  (AController as IInterface).QueryInterface(IController, x);
  if x <> nil then
  begin
    inherited Create(AOwner, x);
    FCustomController := AController;
  end
  else
    raise Exception.Create(rsProvidedCont);
end;

end.
