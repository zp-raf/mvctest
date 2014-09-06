unit mvc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms;

// Aca defino los metodos basicos que tiene que tener cada parte
type

  { Este es un tipo para informar el estado de conexion de la DB }
  TDBStatus = (Connected, Disconnected);

  { Forward declarations }

  IController = interface;
  IModel = interface;
  IFormView = interface;
  IView = interface;

  { IViewBase }

  IView = interface
    ['{BF806B18-377B-4EF8-8139-75EE0C7984D5}']
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    function ShowErrorMessage(AMsg: string): TModalResult;
    function ShowErrorMessage(ATitle: string; AMsg: string): TModalResult;
    function ShowInfoMessage(AMsg: string): TModalResult;
    function ShowInfoMessage(ATitle: string; AMsg: string): TModalResult;
    function ShowWarningMessage(AMsg: string): TModalResult;
    function ShowWarningMessage(ATitle: string; AMsg: string): TModalResult;
    function ShowConfirmationMessage(AMsg: string): TModalResult;
    function ShowConfirmationMessage(ATitle: string; AMsg: string): TModalResult;
    function GetController: IController;
    procedure SetController(AValue: IController);
    { La relacion controlador-vista es de uno a muchos por eso aca esta una
      referencia al controlador.}
    { TODO : Esto se podria mejorar teniendo un puntero
      que apunte al controlador para evitar problemas de referenciado. }
    property Controller: IController read GetController write SetController;
  end;


  { IFormView }

  IFormView = interface(IView)

    { Esto es para las vistas que sean graficas. }
    ['{A1AB24E3-C419-44E2-B390-D4653F8C5E88}']
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
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
    procedure DiscardChanges(Sender: IController);
    procedure SaveChanges(Sender: IController);
    procedure Connect(Sender: IController);
    procedure Disconnect(Sender: IController);
    function NextValue(gen: string): integer;
    function ArePendingChanges(Sender: IController): boolean;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure EditCurrentRecord(Sender: IController);
    function GetCurrentRecordText(Sender: IController): string;
    function GetDBStatus(Sender: IController): TDBStatus;
    procedure NewRecord(Sender: IController);
    procedure RefreshDataSets(Sender: IController);
  end;

  //{ IABMModel }

  //IDBModel = interface(IModel)
  //  ['{DE169099-9D2F-4180-BE80-64A4C2C3D846}']
  //  procedure Connect(Sender: IController);
  //  procedure Disconnect(Sender: IController);
  //  function NextValue(gen: string): integer;
  //end;

  //{ IDBViewModel }

  //IDBViewModel = interface (IDBModel)
  //  ['{CDFE6770-E3CB-43DC-935E-226FE08933D8}']
  //  function ArePendingChanges(Sender: IController): boolean;
  //  procedure DataModuleCreate(Sender: TObject);
  //  procedure DataModuleDestroy(Sender: TObject);
  //  procedure EditCurrentRecord(Sender: IController);
  //  function GetCurrentRecordText(Sender: IController): string;
  //  function GetDBStatus(Sender: IController): TDBStatus;
  //  procedure NewRecord(Sender: IController);
  //  procedure RefreshDataSets(Sender: IController);
  //end;

  { IController }

  IController = interface
    ['{B1D8EBC6-C5B4-4F72-9CA3-6E4B74F51858}']

    { El modelo MVC dice que los eventos deben ser manejados por el controlador.
      El controlador debe ser capaz de manejar una vista grafica o de linea de
      comandos sin modificaciones }
    procedure Close(Sender: IView);
    procedure Close(Sender: IFormView);
    procedure CloseQuery(Sender: IView; var CanClose: boolean);
    procedure ErrorHandler(E: Exception; Sender: IView);
    function GetModel: IModel;
    function GetVersion(Sender: IView): string;
    procedure SetModel(AValue: IModel);
    procedure ShowHelp(Sender: IView);
    procedure ShowHelp(Sender: IFormView);
    procedure Cancel(Sender: IView);
    procedure Commit(Sender: IView);
    procedure Connect(Sender: IView);
    procedure Disconnect(Sender: IView);
    procedure EditCurrentRecord(Sender: IView);
    function GetCurrentRecordText(Sender: IView): string;
    function IsDBConnected(Sender: IView): boolean;
    procedure NewRecord(Sender: IView);
  end;

implementation

end.
