unit mvc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms;

// Aca defino los metodos basicos que tiene que tener cada parte
type


  { Forward declarations }

  IController = interface;
  IView = interface;
  IModel = interface;
  IFormView = interface;

  { IView }

  IView = interface
    ['{BF806B18-377B-4EF8-8139-75EE0C7984D5}']
    function GetController: IController;
    procedure SetController(AValue: IController);
    procedure ShowErrorMessage(AMsg: string);
    procedure ShowInfoMessage(AMsg: string);
    procedure ShowWarningMessage(AMsg: string);
    { La relacion controlador-vista es de uno a muchos por eso aca esta una
      referencia al controlador.}
    { TODO : Esto se podria mejorar teniendo un puntero
      que apunte al controlador para evitar problemas de referenciado }
    property Controller: IController read GetController write SetController;
  end;

  { IModel }

  IModel = interface

      { TODO : Por ahora solo tiene esto pero deberia tener algun metodo que notifique a
        las vistas que deben actualizarse. Por ejemplo para mostrar algun texto que
        indique el estado de conexion a la base de datos.
        Los datasources de las vistas no necesitan ser actualizados ya que tienen
        su propio controlador y metodo de notificacion.
        La logica de datos se debe manejar aca (generators,
        llamadas a procedimientos, etc) }
    ['{91D626B4-415B-4FB2-8B98-620B8F24A406}']
    procedure Connect(Sender: IController);
    procedure DiscardChanges(Sender: IController);
    procedure Disconnect(Sender: IController);
    procedure EditCurrentRecord(Sender: IController);
    procedure NewRecord(Sender: IController);
    procedure RefreshDataSets(Sender: IController);
    procedure SaveChanges(Sender: IController);
  end;

  { IABMModel }

  IDBModel = interface(IModel)
    ['{DE169099-9D2F-4180-BE80-64A4C2C3D846}']
    function NextValue(gen: string): integer;
  end;

  { IDBViewModel }

  IDBViewModel = interface
    ['{CDFE6770-E3CB-43DC-935E-226FE08933D8}']
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  end;

  { IController }

  IController = interface
    ['{B1D8EBC6-C5B4-4F72-9CA3-6E4B74F51858}']

    { El modelo MVC dice que los eventos deben ser manejados por el controlador.
      El controlador debe ser capaz de manejar una vista grafica o de linea de
      comandos sin modificaciones }
    procedure Cancel(Sender: IView);
    procedure CloseQuery(Sender: IView; var CanClose: boolean);
    procedure Commit(Sender: IView);
    procedure Connect(Sender: IView);
    procedure Disconnect(Sender: IView);
    procedure EditCurrentRecord(Sender: IFormView);
    procedure ErrorHandler(E: Exception; Sender: IView);
    function GetModel: IModel;
    function GetVersion(Sender: IView): string;
    function IsDBConnected(Sender: IView): boolean;
    procedure NewRecord(Sender: IFormView);
    procedure SetModel(AValue: IModel);
    procedure ShowHelp(Sender: IView);
    procedure ShowHelp(Sender: IFormView);
  end;


  { IFormView }

  IFormView = interface(IView)

    { Esto es para las vistas que sean graficas. }
    ['{A1AB24E3-C419-44E2-B390-D4653F8C5E88}']
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  end;

implementation

end.
