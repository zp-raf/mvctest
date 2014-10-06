unit facturactrl2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmfacturadatamodule2;

type

  { TAsientosController }

  { TFacturaController }

  TFacturaController = class(TABMController)
  private
    { Aca saca el objeto model pero casteado al tipo que necesitamos para poder
      usar los metodos y funciones especificos del modelo y que no estan
      especificados en la interfaz }
    function GetCustomModel: TFacturasDataModule;
 //   function GetCuentaDebeDataSource: TDataSource;
 //   function GetCuentaHaberDataSource: TDataSource;
  public
    //constructor Create(AModel: IModel); overload;
  //  procedure NuevoAsiento(ADescripcion: string; Sender: IView);
   // procedure ErrorHandler(E: Exception; Sender: IView); override;
   // procedure ReversarAsiento(AAsientoID: string; ADescripcion: string; Sender: IView);
   // procedure ReversarAsiento(ADescripcion: string; Sender: IView);
  end;

var
  FacturaController: TFacturaController;

implementation

{ TFacturaController }

function TFacturaController.GetCustomModel: TFacturasDataModule;
begin
  Result := (Model as TFacturasDataModule);
end;

end.

