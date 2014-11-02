unit frmprocesoasientos;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Graphics, StdCtrls, ExtCtrls, DBGrids, Buttons, maskedit, Forms,
  frmproceso, frmasientosdatamodule, asientosctrl, mvc, ctrl;

resourcestring
  rsReversionDeA = 'Reversion de asiento';

type

  { TProcesoAsientos }

  TProcesoAsientos = class(TProceso)
  protected
    function GetABMController: TABMController;
    function GetCustomController: TAsientosController;
  published
    BitBtnCerrarAsiento: TBitBtn;
    BitBtnNuevoDetalle: TBitBtn;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBGridCuenta: TDBGrid;
    RadioGroup1: TRadioGroup;
    BitBtnNuevo: TBitBtn;
    Monto: TLabel;
    MaskEditMonto: TMaskEdit;
    BitBtnReversar: TBitBtn;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Haber: TLabel;
    LabeledEditDesscripcion: TLabeledEdit;
    procedure BitBtnCerrarAsientoClick(Sender: TObject);
    procedure BitBtnNuevoDetalleClick(Sender: TObject);
    procedure BitBtnNuevoClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure BitBtnReversarClick(Sender: TObject);
    procedure Limpiar;
    procedure MaskEditMontoKeyPress(Sender: TObject; var Key: char);
    procedure ObserverUpdate(const Subject: IInterface); override;
    procedure OKButtonClick(Sender: TObject);
  end;

var
  ProcesoAsientos: TProcesoAsientos;

implementation

{$R *.lfm}

{ TProcesoAsientos }

procedure TProcesoAsientos.ObserverUpdate(const Subject: IInterface);
begin
  inherited;
  case GetCustomController.GetAsientoEstado(Self) of
    asInicial:
    begin
      DBGridCuenta.Enabled := False;
      DBGridCuenta.Color := clInactiveCaption;
      MaskEditMonto.Enabled := False;
      LabeledEditDesscripcion.Enabled := True;
      RadioGroup1.Enabled := False;
      BitBtnReversar.Enabled := True;
      BitBtnCerrarAsiento.Enabled := False;
      BitBtnNuevoDetalle.Enabled := False;
      BitBtnNuevo.Enabled := True;
    end;
    asGuardado:
    begin
      DBGridCuenta.Enabled := False;
      DBGridCuenta.Color := clInactiveCaption;
      MaskEditMonto.Enabled := False;
      LabeledEditDesscripcion.Enabled := True;
      RadioGroup1.Enabled := False;
      BitBtnReversar.Enabled := True;
      BitBtnCerrarAsiento.Enabled := False;
      BitBtnNuevoDetalle.Enabled := False;
      BitBtnNuevo.Enabled := True;
    end;
    asEditando:
    begin
      DBGridCuenta.Enabled := False;
      DBGridCuenta.Color := clWindow;
      MaskEditMonto.Enabled := True;
      LabeledEditDesscripcion.Enabled := False;
      RadioGroup1.Enabled := True;
      BitBtnReversar.Enabled := False;
      BitBtnCerrarAsiento.Enabled := True;
      BitBtnNuevoDetalle.Enabled := True;
      BitBtnNuevo.Enabled := False;
    end;
  end;
end;

procedure TProcesoAsientos.Limpiar;
begin
  MaskEditMonto.Clear;
  RadioGroup1.ItemIndex := -1;
end;

procedure TProcesoAsientos.BitBtnNuevoClick(Sender: TObject);
begin
  GetCustomController.NuevoAsiento(LabeledEditDesscripcion.Text, Self as IFormView);
  Limpiar;
  LabeledEditDesscripcion.Enabled := False;
end;

procedure TProcesoAsientos.MaskEditMontoKeyPress(Sender: TObject; var Key: char);
begin
  if (Key in ['0'..'9', {%H-}DecimalSeparator, #8, #9]) then
    Exit;
  key := #0;
end;

procedure TProcesoAsientos.OKButtonClick(Sender: TObject);
begin
  GetABMController.Commit(Self);
  GetABMController.Connect(Self);
  Limpiar;
  ShowInfoMessage('Los nuevos asientos fueron guardados');
end;

procedure TProcesoAsientos.BitBtnNuevoDetalleClick(Sender: TObject);
begin
  if (RadioGroup1.ItemIndex in [0, 1]) then
  begin
    case RadioGroup1.ItemIndex of
      0: GetCustomController.NuevoAsientoDetalle(mvDebito, MaskEditMonto.Text, Self);
      1: GetCustomController.NuevoAsientoDetalle(mvCredito, MaskEditMonto.Text, Self);
    end;
    Limpiar;
  end
  else
    ShowInfoMessage('Por favor seleccione un tipo de movimiento');
end;

procedure TProcesoAsientos.BitBtnCerrarAsientoClick(Sender: TObject);
begin
  GetCustomController.CerrarAsiento(Self);
end;

procedure TProcesoAsientos.BitBtnReversarClick(Sender: TObject);
begin
  GetCustomController.ReversarAsiento(rsReversionDeA, Self);
  Limpiar;
end;

procedure TProcesoAsientos.CancelButtonClick(Sender: TObject);
begin
  //GetABMController.Cancel(Self);
  GetABMController.Rollback(Self);
  //GetABMController.Connect(Self);
  Limpiar;
  ShowInfoMessage('Los asientos no guardados fueron descartados');
end;

function TProcesoAsientos.GetABMController: TABMController;
begin
  Result := GetController as TABMController;
end;

function TProcesoAsientos.GetCustomController: TAsientosController;
begin
  Result := GetController as TAsientosController;
end;

end.
