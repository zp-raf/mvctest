unit frmprocesocomprobante;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ButtonPanel, StdCtrls, DBCtrls, EditBtn, PairSplitter, DBGrids, ComCtrls,
  frmproceso, mvc, comprobantectrl, frmcomprobantedatamodule, frmMaestro,
  frmbuscarpersonas, buscarpersctrl;

type

  { TProcesoComprobante }

  TProcesoComprobante = class(TProceso)
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
  private
    FABMController: IABMController;
    FCustomController: TComprobanteController;
    function GetController: IABMController;
    function GetCustomController: TComprobanteController;
    procedure SetController(AValue: IABMController);
    procedure SetCustomController(AValue: TComprobanteController);
  public
    constructor Create(AOwner: IFormView; AController: TComprobanteController);
      overload;
  published
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
    property ABMController: IABMController read GetController write SetController;
    procedure Limpiar;
    procedure OKButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    { Aca esta el controlador especifico del modulo }
    property CustomController: TComprobanteController
      read GetCustomController write SetCustomController;
  end;

var
  ProcesoComprobante: TProcesoComprobante;
  PopUp: TPopupSeleccionPersonas;

implementation

{$R *.lfm}

{ TProcesoComprobante }

procedure TProcesoComprobante.ButtonSeleccionarPersClick(Sender: TObject);
begin
  //Controller.OpenDataSets(Self);
  //try
  //  PopUp := TPopupSeleccionPersonas.Create(Self,
  //    TBuscarPersonasController.Create(Controller.Model));
  //  case PopUp.ShowModal of
  //    mrOk:
  //    begin
  //      Controller.Connect(Self);
  //      // si ya se esta editando simplemente se cancela y se hace otra
  //      CustomController.NuevoComprobante(Self);
  //    end
  //    else
  //    begin
  //      Exit;
  //    end;
  //  end;
  //finally
  //  PopUp.Free;
  //end;
end;

procedure TProcesoComprobante.ButtonLimpiarClick(Sender: TObject);
begin
  Limpiar;
  ABMController.Cancel(Self);
end;

procedure TProcesoComprobante.DBGridDetEditingDone(Sender: TObject);
begin
  CustomController.ActualizarTotales(Self);
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
    nbDelete: CustomController.ActualizarTotales(Self);
  end;
end;

procedure TProcesoComprobante.FormShow(Sender: TObject);
begin
  inherited;
  //ABMController.NewRecord(Self);
  Controller.CloseDataSets(Self);
end;

function TProcesoComprobante.GetController: IABMController;
begin
  Result := FABMController;
end;

function TProcesoComprobante.GetCustomController: TComprobanteController;
begin
  Result := FCustomController;
end;

procedure TProcesoComprobante.SetController(AValue: IABMController);
begin
  if FABMController = AValue then
    Exit;
  FABMController := AValue;
end;

procedure TProcesoComprobante.SetCustomController(AValue: TComprobanteController);
begin
  if FCustomController = AValue then
    Exit;
  FCustomController := AValue;
end;

constructor TProcesoComprobante.Create(AOwner: IFormView;
  AController: TComprobanteController);
var
  Cont: IController;
  ABMCont: IABMController;
begin
  (AController as IInterface).QueryInterface(IController, Cont);
  (AController as IInterface).QueryInterface(IABMController, ABMCont);
  if (Cont = nil) or (ABMCont = nil) then
    raise Exception.Create(rsProvidedCont)
  else
  begin
    inherited Create(AOwner, Cont);
    ABMController := ABMCont;
    CustomController := AController;
  end;
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
  case CustomController.GetEstadoComprobante(Self) of
    asInicial:
    begin
      Cabecera.Enabled := False;
      Detalles.Enabled := False;
      Totales.Enabled := False;
      DBGridDet.Color := clInactiveCaption;
      ButtonSeleccionarPers.Enabled := True;
      ButtonLimpiar.Enabled := True;
      Controller.CloseDataSets(Self);
    end;
    asGuardado:
    begin
      Cabecera.Enabled := False;
      Detalles.Enabled := False;
      Totales.Enabled := False;
      DBGridDet.Color := clInactiveCaption;
      ButtonSeleccionarPers.Enabled := True;
      ButtonLimpiar.Enabled := True;
      Controller.CloseDataSets(Self);
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
      Controller.OpenDataSets(Self);
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
  if not (CustomController.GetEstadoComprobante(Self) in [asEditando]) then
  begin
    ShowInfoMessage('No se esta procesando ningun comprobante');
    Exit;
  end;
  CustomController.CerrarComprobante(Self);
  ShowInfoMessage('Comprobante ingresado correctamente');
  Limpiar;
end;

procedure TProcesoComprobante.CancelButtonClick(Sender: TObject);
begin
  ABMController.Cancel(Self);
  ABMController.Rollback(Self);
  ShowInfoMessage('Comprobante descartado');
  Limpiar;
end;

end.
