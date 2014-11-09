unit frmpago;

{$mode objfpc}{$H+}

interface

uses
  Forms, Controls, StdCtrls, DBGrids, DBCtrls, PairSplitter, ComCtrls, Menus,
  ButtonPanel, frmproceso, pagoctrl, mensajes;

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
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
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

procedure TProcesoPago.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
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
  try
    case ShowConfirmationMessage(rsPrintReceiptConfirmation, rsPrintReceiptQuestion) of
      mrYes:
      begin
        GetCustomController.ImprimirRecibo(Self);
      end;
      mrNo:
      begin
        Exit;
      end;
    end;
  finally
    GetCustomController.CerrarPago(Self);
  end;
end;

procedure TProcesoPago.ObserverUpdate(const Subject: IInterface);
begin
  if GetCustomController.PagoListo then
    ButtonPanel1.OKButton.Enabled := True
  else
    ButtonPanel1.OKButton.Enabled := False;
end;

end.
