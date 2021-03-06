unit frmprocesocomprobante;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Graphics, Menus, Controls, sgcdTypes,
  StdCtrls, DBCtrls, EditBtn, PairSplitter, DBGrids, ComCtrls, ButtonPanel,
  frmproceso, comprobantectrl, frmcomprobantedatamodule,
  frmbuscarpersonas, ctrl, Classes, frmMaestro, manejoerrores, IBConnection , db;

type

  { TProcesoComprobante }

  TProcesoComprobante = class(TProceso)

  private
    FPopup: TPopupSeleccionPersonas;
  protected
    function GetABMController: TABMController;
    function GetComprobanteController: TComprobanteController;
  published
    DBTextSucursal: TDBText;
    DBTextCaja: TDBText;
    LabelSeparator1: TLabel;
    LabelSeparator2: TLabel;

    ButtonSeleccionarFac: TButton;
    ButtonSeleccionarPers: TButton;
    ButtonLimpiar: TButton;
    Cabecera: TGroupBox;
    DateEditFecha: TDateEdit;
    DBEditDireccion: TDBEdit;
    DBEditNombre: TDBEdit;
    DBEditRuc: TDBEdit;
    DBEditTelefono: TDBEdit;
    DBEditGranTotal: TDBEdit;
    DBGridDet: TDBGrid;
    DBNavigatorDet: TDBNavigator;
    DBTextNro: TDBText;
    DBTextTimbrado: TDBText;
    Detalles: TGroupBox;
    LabelGranTotal: TLabel;
    LabelDireccion: TLabel;
    LabelNro: TLabel;
    LabelTimbrado: TLabel;
    LabelRuc: TLabel;
    LabelTelefono: TLabel;
    LabelFecha: TLabel;
    LabelNombre: TLabel;
    MenuItemTalonario: TMenuItem;
    MenuItemOpciones: TMenuItem;
    Totales: TGroupBox;
    procedure ButtonSeleccionarPersClick(Sender: TObject);
    procedure ButtonLimpiarClick(Sender: TObject);
    procedure DBNavigatorDetBeforeAction(Sender: TObject; Button: TDBNavButtonType);
    procedure DBNavigatorDetClick(Sender: TObject; Button: TDBNavButtonType);
    procedure FormShow(Sender: TObject); virtual;
    procedure Edit;
    procedure Insert;
    procedure Delete;
    procedure Refresh;
    procedure MenuItemTalonarioClick(Sender: TObject);
    procedure ObserverUpdate(const Subject: IInterface); override;
    procedure OnPopupCancel; virtual; abstract;
    procedure OnPopupOk; virtual; abstract;
    procedure Limpiar; virtual;
    procedure OKButtonClick(Sender: TObject); virtual;
    procedure CancelButtonClick(Sender: TObject);
    function cwLeftPad(const aString: AnsiString; aCharCount: Integer; aChar: AnsiChar): AnsiString;
    property Popup: TPopupSeleccionPersonas read FPopup write FPopup;
  end;

var
  ProcesoComprobante: TProcesoComprobante;

implementation

{$R *.lfm}

{ TProcesoComprobante }

procedure TProcesoComprobante.MenuItemTalonarioClick(Sender: TObject);
begin
  GetComprobanteController.SeleccionarTalonario(Self);
end;

function TProcesoComprobante.GetABMController: TABMController;
begin
  Result := GetController as TABMController;
end;

function TProcesoComprobante.GetComprobanteController: TComprobanteController;
begin
  Result := GetController as TComprobanteController;
end;

procedure TProcesoComprobante.ButtonSeleccionarPersClick(Sender: TObject);
begin
  if not Assigned(FPopup) then
    Popup := TPopupSeleccionPersonas.Create(Self,
      GetComprobanteController.BuscarPersonaController);
  try
    GetController.Connect(Self);
    case Popup.ShowModal of
      mrOk:
      begin
        OnPopupOk;
      end
      else
      begin
        OnPopupCancel;
      end;
    end;
  finally
    FreeAndNil(FPopup);
  end;
end;

procedure TProcesoComprobante.ButtonLimpiarClick(Sender: TObject);
begin
  Limpiar;
  GetABMController.Cancel(Self);
end;

procedure TProcesoComprobante.DBNavigatorDetBeforeAction(Sender: TObject;
  Button: TDBNavButtonType);
begin
  //if not (Sender is TDBNavigator) then
  //  Abort;
  //case Button of
  //  nbInsert:
  //  begin
  //    Insert;
  //    Abort;
  //  end;
  //  nbEdit:
  //  begin
  //    Edit;
  //    Abort;
  //  end;
  //  nbRefresh:
  //  begin
  //    Refresh;
  //    Abort;
  //  end;
  //  nbDelete:
  //  begin
  //    Delete;
  //    Abort;
  //  end;
  //end;
end;

procedure TProcesoComprobante.DBNavigatorDetClick(Sender: TObject;
  Button: TDBNavButtonType);
begin
  if not (Sender is TDBNavigator) then
    Abort;
  case Button of
    nbDelete: GetComprobanteController.ActualizarTotales(Self);
  end;
end;

procedure TProcesoComprobante.FormShow(Sender: TObject);
begin
  inherited;
  //GetABMController.NewRecord(Self);
  GetController.CloseDataSets(Self);
end;

procedure TProcesoComprobante.Edit;
begin

end;

procedure TProcesoComprobante.Insert;
begin

end;

procedure TProcesoComprobante.Delete;
begin

end;

procedure TProcesoComprobante.Refresh;
begin

end;

procedure TProcesoComprobante.ObserverUpdate(const Subject: IInterface);
begin
  inherited ObserverUpdate(Subject);
  case GetComprobanteController.GetEstadoComprobante(Self) of
    csInicial:
    begin
      Cabecera.Enabled := False;
      Detalles.Enabled := False;
      Totales.Enabled := False;
      DBGridDet.Color := clInactiveCaption;
      ButtonSeleccionarPers.Enabled := True;
      ButtonLimpiar.Enabled := True;
      GetController.CloseDataSets(Self);
      ButtonPanel1.CancelButton.Enabled := False;
      ButtonPanel1.OKButton.Enabled := False;
    end;
    csGuardado:
    begin
      Cabecera.Enabled := False;
      Detalles.Enabled := False;
      Totales.Enabled := False;
      DBGridDet.Color := clInactiveCaption;
      ButtonSeleccionarPers.Enabled := True;
      ButtonLimpiar.Enabled := True;
      GetController.CloseDataSets(Self);
      ButtonPanel1.CancelButton.Enabled := False;
      ButtonPanel1.OKButton.Enabled := False;
    end;
    csEditando:
    begin
      Cabecera.Enabled := True;
      Detalles.Enabled := True;
      Totales.Enabled := True;
      DBGridDet.Color := clWindow;
      ButtonSeleccionarPers.Enabled := False;
      ButtonLimpiar.Enabled := False;
      DBGridDet.AutoSizeColumns;
      ButtonPanel1.CancelButton.Enabled := True;
      ButtonPanel1.OKButton.Enabled := True;
    end;
    csLeyendo:
    begin
      GetController.OpenDataSets(Self);
    end;
  end;
end;

procedure TProcesoComprobante.Limpiar;
begin
  DBEditDireccion.Clear;
  DBEditRuc.Clear;
  DBEditTelefono.Clear;
  DBEditGranTotal.Clear;
  DBEditNombre.Clear;
  DateEditFecha.Clear;
end;

procedure TProcesoComprobante.OKButtonClick(Sender: TObject);
begin
  if not (GetComprobanteController.GetEstadoComprobante(Self) in [csEditando]) then
  begin
    ShowInfoMessage('No se esta procesando ningun comprobante');
    Exit;
  end;
  if (DBGridDet.DataSource.DataSet.IsEmpty) then
  begin
    ShowErrorMessage('Debe llenar los detalles del comprobante');
    Exit;
  end;
  try
    GetComprobanteController.CerrarComprobante(Self);
    ShowInfoMessage('Comprobante ingresado correctamente');
//    GetComprobanteController.;
    Limpiar;
    GetComprobanteController.ShowReport(Self);
    // esto resuelve el problema de que se muestra la excepcion de la BD
   // pero con partes del trigger
  except
    on e: EIBDatabaseError do
      ShowErrorMessage('Comprobante descartado. ' + GetErrorMessage (e));
   on e: EDatabaseError do
      ShowErrorMessage('Comprobante descartado. ' + GetErrorMessage (e));
   on e: Exception do
   //   ShowErrorMessage('Comprobante descartado. Error: ' + e.Message);
      ShowErrorMessage('Comprobante descartado. Error: ' + GetErrorMessage (e));
  end;
  GetController.CloseDataSets(Self);
end;

procedure TProcesoComprobante.CancelButtonClick(Sender: TObject);
begin
  GetABMController.Cancel(Self);
  GetABMController.Rollback(Self);
  ShowInfoMessage('Comprobante descartado');
  Limpiar;
  GetController.CloseDataSets(Self);
end;

function TProcesoComprobante.cwLeftPad(const aString: AnsiString;
  aCharCount: Integer; aChar: AnsiChar): AnsiString;
var
      PadCount: Integer;
    begin   // rellena de 0 a la izq, para nro de factura.
      PadCount := ACharCount - Length(AString);
      if PadCount > 0 then begin
        SetLength(Result, ACharCount);
        FillChar(Result[1], PadCount, AChar);
        Move(AString[1], Result[PadCount + 1], Length(AString));
      end else
        Result := AString;

end;

end.
