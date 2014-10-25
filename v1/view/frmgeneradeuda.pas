unit frmgeneradeuda;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ButtonPanel, ExtCtrls, DBGrids, DBCtrls, StdCtrls, Spin, EditBtn, frmAbm,
  frmgeneradeudadatamodule, generardeudactrl, mvc, frmMaestro, mensajes, variants;

resourcestring
  rsFormatoDeFec = 'Formato de fecha invalido';

type

  { TGenerarDeuda }

  TGenerarDeuda = class(TAbm)
    DBText1: TDBText;
    DBText2: TDBText;
    DBText3: TDBText;
    procedure DateEditVenEditingDone(Sender: TObject);
  private
    FCustomController: TGenDeudaController;
    procedure SetCustomController(AValue: TGenDeudaController);
  published
    DateEditVen: TDateEdit;
    SpinEditCant: TSpinEdit;
    SpinEditVenCant: TSpinEdit;
    DBLookupComboBoxVenUnidad: TDBLookupComboBox;
    LabelCantCuotas: TLabel;
    Fecha: TLabel;
    SinVencimiento: TCheckBox;
    FraccionamientoPorDefecto: TCheckBox;
    DBLookupComboBoxPers: TDBLookupComboBox;
    DBLookupComboBoxAran: TDBLookupComboBox;
    GroupBoxVencimiento: TGroupBox;
    LabelPersona: TLabel;
    LabelArancel: TLabel;
    Label4: TLabel;
    procedure DateEditVenEnter(Sender: TObject);
    procedure EditVenCantEnter(Sender: TObject);
    procedure SpinEditCantChange(Sender: TObject);
    procedure FraccionamientoPorDefectoChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OKButtonClick(Sender: TObject); override;
    procedure SinVencimientoChange(Sender: TObject);
    procedure ABMInsert; override;
    procedure ABMEdit; override;
    procedure ABMDelete; override;
    property CustomController: TGenDeudaController
      read FCustomController write SetCustomController;
  public
    constructor Create(AOwner: IFormView; AController: TGenDeudaController); overload;
  end;

var
  GenerarDeuda: TGenerarDeuda;

implementation

{$R *.lfm}

{ TGenerarDeuda }

procedure TGenerarDeuda.FormCreate(Sender: TObject);
begin

end;

procedure TGenerarDeuda.FraccionamientoPorDefectoChange(Sender: TObject);
begin
  if FraccionamientoPorDefecto.Checked then
  begin
    SpinEditCant.Enabled := False;
    SinVencimiento.Checked := False;
    SinVencimiento.Enabled := False;
    GroupBoxVencimiento.Enabled := False;
  end
  else
  begin
    SpinEditCant.Enabled := True;
    SinVencimiento.State := cbGrayed;
    SinVencimiento.Enabled := True;
    GroupBoxVencimiento.Enabled := True;
  end;
  // actualizamos el checkbox de vencimiento porque no se actualiza asi nomas
  //SinVencimientoChange(SinVencimiento);
end;

procedure TGenerarDeuda.EditVenCantEnter(Sender: TObject);
begin
  DateEditVen.Clear;
end;

procedure TGenerarDeuda.SpinEditCantChange(Sender: TObject);
begin
  if SpinEditCant.Value > 1 then
  begin
    DateEditVen.Enabled := False;
    DateEditVen.Clear;
  end
  else
  begin
    DateEditVen.Enabled := True;
    DateEditVen.Clear;
  end;
end;

procedure TGenerarDeuda.DateEditVenEditingDone(Sender: TObject);
begin
  if not Controller.IsValidDate(DateEditVen.Text) then
    ShowErrorMessage(rsFormatoDeFec);
end;

procedure TGenerarDeuda.SetCustomController(AValue: TGenDeudaController);
begin
  if FCustomController = AValue then
    Exit;
  FCustomController := AValue;
end;

procedure TGenerarDeuda.DateEditVenEnter(Sender: TObject);
begin
  SpinEditVenCant.Value := 0;
  DBLookupComboBoxVenUnidad.Clear;
end;

procedure TGenerarDeuda.OKButtonClick(Sender: TObject);
var
  msg: TDeudaMsg;
begin
  msg.Inserting := PanelDetail.Visible;
  msg.Updating := PanelList.Visible;
  msg.FraccionamientoPorDefecto := FraccionamientoPorDefecto.Checked;
  msg.SinVencimiento := SinVencimiento.Checked;
  msg.CantCuotas := SpinEditCant.Value;
  msg.FechaVen := DateEditVen.Date;
  msg.CantidadVen := SpinEditVenCant.Value;
  msg.UnidadVen := StrToInt(VarToStrDef(DBLookupComboBoxVenUnidad.KeyValue, '99'));
  if PanelDetail.Visible and ((FraccionamientoPorDefecto.State = cbGrayed) or
    (SinVencimiento.State = cbGrayed)) then
  begin
    ShowErrorMessage(rsPorFavorSele);
    Exit;
  end;
  if CustomController.CheckAndSave(Self, msg) then
    ABMController.Commit(Self)
  else
    ABMController.Rollback(Self);
  ShowPanel(PanelList);
end;

procedure TGenerarDeuda.SinVencimientoChange(Sender: TObject);
begin
  //if SinVencimiento.State = cbChecked then
  //  GroupBoxVencimiento.Enabled := False
  //else if SinVencimiento.State = cbUnchecked then;
  //  GroupBoxVencimiento.Enabled := True;
  if SinVencimiento.Checked then
    GroupBoxVencimiento.Enabled := False
  else
    GroupBoxVencimiento.Enabled := True;
end;

procedure TGenerarDeuda.ABMInsert;
begin
  inherited ABMInsert;
  FraccionamientoPorDefectoChange(FraccionamientoPorDefecto);
  SinVencimientoChange(SinVencimiento);
end;

procedure TGenerarDeuda.ABMEdit;
begin
  // NO PERMITIDO
  //inherited ABMEdit;
  //FraccionamientoPorDefectoChange(FraccionamientoPorDefecto);
  //SinVencimientoChange(SinVencimiento);
end;

procedure TGenerarDeuda.ABMDelete;
begin
  inherited ABMDelete;
end;

constructor TGenerarDeuda.Create(AOwner: IFormView; AController: TGenDeudaController);
var
  x: IABMController;
begin
  (AController as IInterface).QueryInterface(IABMController, x);
  if x <> nil then
  begin
    inherited Create(AOwner, x);
    FCustomController := AController;
  end
  else
    raise Exception.Create(rsProvidedCont);
end;

end.
