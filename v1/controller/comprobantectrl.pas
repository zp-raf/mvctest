unit comprobantectrl;

{$mode objfpc}{$H+}

interface

uses
  mvc, ctrl, frmcomprobantedatamodule, sgcdTypes, personactrl, SysUtils,
  frmseleccionartalonario, talonarioctrl, Controls;

type

  { TComprobanteController }

  TComprobanteController = class(TABMController)
  private
    FBuscarPersonaController: TBuscarPersonaController;
    procedure SetBuscarPersonaController(AValue: TBuscarPersonaController);
  protected
    function GetComprobanteModel: TComprobanteDataModule;
  public
    constructor Create(AModel: Pointer); overload; override;
    destructor Destroy; override;
    procedure ActualizarTotales(Sender: IView); virtual;
    procedure CerrarComprobante(Sender: IView); virtual; abstract;
    procedure NuevoComprobante(Sender: IView); virtual; abstract;
    procedure NuevoComprobanteDetalle(Sender: IView); virtual;
    procedure SeleccionarTalonario(Sender: IFormView);
    procedure SetCompra(Option: boolean); virtual;
    procedure ShowReport(Sender: IView);
    function EsCompra: boolean;
    function GetEstadoComprobante(Sender: IView): TEstadoComprobante;
    property BuscarPersonaController: TBuscarPersonaController
      read FBuscarPersonaController write SetBuscarPersonaController;
  end;

implementation

{ TComprobanteController }

procedure TComprobanteController.SetBuscarPersonaController(
  AValue: TBuscarPersonaController);
begin
  if FBuscarPersonaController = AValue then
    Exit;
  FBuscarPersonaController := AValue;
end;

function TComprobanteController.GetComprobanteModel: TComprobanteDataModule;
begin
  Result := GetModel as TComprobanteDataModule;
end;

constructor TComprobanteController.Create(AModel: Pointer);
begin
  inherited Create(AModel);
  FBuscarPersonaController :=
    TBuscarPersonaController.Create(GetComprobanteModel.Personas);
end;

destructor TComprobanteController.Destroy;
begin
  if Assigned(FBuscarPersonaController) then
    FreeAndNil(FBuscarPersonaController);
  inherited Destroy;
end;

procedure TComprobanteController.ActualizarTotales(Sender: IView);
begin
  GetComprobanteModel.ActualizarTotales;
end;

procedure TComprobanteController.NuevoComprobanteDetalle(Sender: IView);
begin
  GetComprobanteModel.NewDetailRecord;
end;

procedure TComprobanteController.SeleccionarTalonario(Sender: IFormView);
begin
  SeleccionTalonario := TSeleccionarTalonario.Create(Sender,
    TSeleccionTalonariosController.Create(GetComprobanteModel.Talonarios));
  try
    GetComprobanteModel.LocateTalonario;
    case SeleccionTalonario.ShowModal of
      mrOk:
      begin
        GetComprobanteModel.TalonarioID :=
          GetComprobanteModel.Talonarios.TalonarioView.FieldByName('ID').AsString;
        with GetComprobanteModel do
        begin
          Propierties.Save;
          Propierties.Save;
        end;
      end;
      mrCancel:
      begin

      end;
    end;
  finally
    SeleccionTalonario.Free;
  end;
end;

procedure TComprobanteController.SetCompra(Option: boolean);
begin
  GetComprobanteModel.Compra := Option;
end;

procedure TComprobanteController.ShowReport(Sender: IView);
begin
  //GetComprobanteModel.ShowReport();
end;

function TComprobanteController.EsCompra: boolean;
begin
  Result := GetComprobanteModel.Compra;
end;

function TComprobanteController.GetEstadoComprobante(Sender: IView): TEstadoComprobante;
begin
  Result := GetComprobanteModel.Estado;
end;

end.
