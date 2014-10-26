unit frmprocesocomprobante;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Graphics, Menus,
  StdCtrls, DBCtrls, EditBtn, PairSplitter, DBGrids,
  frmproceso, comprobantectrl, frmcomprobantedatamodule,
  frmbuscarpersonas, ctrl;

type

  { TProcesoComprobante }

  TProcesoComprobante = class(TProceso)
  protected
    function GetABMController: TABMController;
    function GetCustomController: TComprobanteController;
  published
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
    MenuItem1: TMenuItem;
    MenuItemTalonario: TMenuItem;
    MenuItemOpciones: TMenuItem;
    PairSplitterDetSubTot: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    Totales: TGroupBox;
    procedure ButtonSeleccionarPersClick(Sender: TObject);
    procedure ButtonLimpiarClick(Sender: TObject);
    procedure DBGridDetEditingDone(Sender: TObject);
    procedure DBNavigatorDetBeforeAction(Sender: TObject; Button: TDBNavButtonType);
    procedure DBNavigatorDetClick(Sender: TObject; Button: TDBNavButtonType);
    procedure FormShow(Sender: TObject);
    procedure Edit;
    procedure Insert;
    procedure Delete;
    procedure Refresh;
    procedure ObserverUpdate(const Subject: IInterface); override;
    procedure Limpiar;
    procedure OKButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
  end;

var
  ProcesoComprobante: TProcesoComprobante;
  PopUp: TPopupSeleccionPersonas;

implementation

{$R *.lfm}

{ TProcesoComprobante }

function TProcesoComprobante.GetABMController: TABMController;
begin
  Result := GetABMController as TABMController;
end;

function TProcesoComprobante.GetCustomController: TComprobanteController;
begin
  Result := GetController as TComprobanteController;
end;

procedure TProcesoComprobante.ButtonSeleccionarPersClick(Sender: TObject);
begin

end;

procedure TProcesoComprobante.ButtonLimpiarClick(Sender: TObject);
begin
  Limpiar;
  GetABMController.Cancel(Self);
end;

procedure TProcesoComprobante.DBGridDetEditingDone(Sender: TObject);
begin
  GetCustomController.ActualizarTotales(Self);
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
    nbDelete: GetCustomController.ActualizarTotales(Self);
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
  case GetCustomController.GetEstadoComprobante(Self) of
    asInicial:
    begin
      Cabecera.Enabled := False;
      Detalles.Enabled := False;
      Totales.Enabled := False;
      DBGridDet.Color := clInactiveCaption;
      ButtonSeleccionarPers.Enabled := True;
      ButtonLimpiar.Enabled := True;
      GetController.CloseDataSets(Self);
    end;
    asGuardado:
    begin
      Cabecera.Enabled := False;
      Detalles.Enabled := False;
      Totales.Enabled := False;
      DBGridDet.Color := clInactiveCaption;
      ButtonSeleccionarPers.Enabled := True;
      ButtonLimpiar.Enabled := True;
      GetController.CloseDataSets(Self);
    end;
    asEditando:
    begin
      Cabecera.Enabled := True;
      Detalles.Enabled := True;
      Totales.Enabled := True;
      DBGridDet.Color := clWindow;
      ButtonSeleccionarPers.Enabled := False;
      ButtonLimpiar.Enabled := False;
      DBGridDet.AutoSizeColumns;
    end;
    asLeyendo:
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
  if not (GetCustomController.GetEstadoComprobante(Self) in [asEditando]) then
  begin
    ShowInfoMessage('No se esta procesando ningun comprobante');
    Exit;
  end;
  GetCustomController.CerrarComprobante(Self);
  ShowInfoMessage('Comprobante ingresado correctamente');
  Limpiar;
end;

procedure TProcesoComprobante.CancelButtonClick(Sender: TObject);
begin
  GetABMController.Cancel(Self);
  GetABMController.Rollback(Self);
  ShowInfoMessage('Comprobante descartado');
  Limpiar;
end;

end.
