unit frmpago;

{$mode objfpc}{$H+}

interface

uses
  Forms, Controls, StdCtrls, DBGrids, DBCtrls, PairSplitter, frmproceso,
  pagoctrl;

type

  { TProcesoPago }

  TProcesoPago = class(TProceso)
  protected
    function GetCustomController: TPagoController;
  published
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
    GroupBoxTotales: TGroupBox;
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
    procedure CancelButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Limpiar;
    procedure OKButtonClick(Sender: TObject);
    procedure ObserverUpdate(const Subject: IInterface); override;
  end;

var
  ProcesoPago: TProcesoPago;

implementation

{$R *.lfm}

{ TProcesoPago }

procedure TProcesoPago.FormShow(Sender: TObject);
begin
  if GetOwner <> nil then
    TForm(GetOwner).Enabled := False;
end;

procedure TProcesoPago.FormCreate(Sender: TObject);
begin
  ButtonPanel1.OKButton.ModalResult := mrOk;
  ButtonPanel1.CancelButton.ModalResult := mrCancel;
end;

function TProcesoPago.GetCustomController: TPagoController;
begin
  Result := GetController as TPagoController;
end;

procedure TProcesoPago.CancelButtonClick(Sender: TObject);
begin
  GetCustomController.Cancel(Self);
end;

procedure TProcesoPago.Limpiar;
begin

end;

procedure TProcesoPago.OKButtonClick(Sender: TObject);
begin
  GetCustomController.CerrarPago(Self);
end;

procedure TProcesoPago.ObserverUpdate(const Subject: IInterface);
begin
  if GetCustomController.PagoListo then
    ButtonPanel1.OKButton.Enabled := True
  else
    ButtonPanel1.OKButton.Enabled := False;
end;

end.
