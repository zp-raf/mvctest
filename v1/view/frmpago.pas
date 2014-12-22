unit frmpago;

{$mode objfpc}{$H+}

interface

uses
  Forms, Controls, StdCtrls, DBGrids, DBCtrls, PairSplitter, ComCtrls, Menus,
  ButtonPanel, LazHelpHTML, frmproceso, pagoctrl, mensajes;

type

  { TProcesoPago }

  TProcesoPago = class(TProceso)
    DBGridDet: TDBGrid;
    Detalles: TGroupBox;
    EditTotalNC: TEdit;
    LabelTotalNC: TLabel;
  protected
    function GetCustomController: TPagoController;
  public
    destructor Destroy; override;
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
    procedure Limpiar;
    procedure OKButtonClick(Sender: TObject);
    procedure ObserverUpdate(const Subject: IInterface); override;
  end;

var
  ProcesoPago: TProcesoPago;

implementation

{$R *.lfm}

{ TProcesoPago }

procedure TProcesoPago.FormCreate(Sender: TObject);
begin
  ButtonPanel1.OKButton.ModalResult := mrOk;
  ButtonPanel1.CancelButton.ModalResult := mrCancel;
  DBGridDet.DataSource := GetCustomController.GetDetallesDataSource;
  OpenOnShow := False;
end;

function TProcesoPago.GetCustomController: TPagoController;
begin
  Result := GetController as TPagoController;
end;

destructor TProcesoPago.Destroy;
begin
  ClearControllerPtr;
  inherited Destroy;
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
  if GetCustomController.HayNotasCredito then
  begin
    Detalles.Visible := True;
    EditTotalNC.Text := GetCustomController.GetNCTotalText;
  end
  else
    Detalles.Visible := False;
end;

end.
