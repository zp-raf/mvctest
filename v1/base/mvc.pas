unit mvc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, mensajes, contnrs;

// Aca defino los metodos basicos que tiene que tener cada parte
type

  { Forward declarations }

  TQryList = class;
  IController = interface;
  IModel = interface;
  IFormView = interface;
  IView = interface;

  { TQryList }

  TQryList = class(TFPObjectList)
  end;

  { IView }

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

    { La relacion controlador-vista es de uno a muchos por eso aca esta una
      referencia al controlador.}
    { TODO : Esto se podria mejorar teniendo un puntero
      que apunte al controlador para evitar problemas de referenciado. }
    function GetController: IController;
    procedure SetController(AValue: IController);
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
    procedure DiscardChanges;
    function GetQryList: TQryList;
    procedure SaveChanges;
    procedure Connect;
    procedure Disconnect;
    function ArePendingChanges: boolean;
    procedure DataModuleCreate(Sender: TObject);
    procedure EditCurrentRecord;
    function GetCurrentRecordText: string;
    function GetDBStatus: TDBInfo;
    procedure NewRecord;
    procedure RefreshDataSets;
    procedure SetQryList(AValue: TQryList);
    property QryList: TQryList read GetQryList write SetQryList;
  end;

  { IDBModel }

  IDBModel = interface
    ['{C5841B7F-3BB1-4296-A096-B20D4CB7C9C3}']
    procedure Commit;
    procedure Connect;
    procedure DataModuleCreate(Sender: TObject);
    function DevuelveValor(AQry: string; NombreCampoADevolver: string): string;
    procedure Disconnect;
    function GetDBStatus: TDBInfo;
    function NextValue(gen: string): integer;
  end;

  { IController }

  IController = interface
    ['{B1D8EBC6-C5B4-4F72-9CA3-6E4B74F51858}']
    procedure Close(Sender: IView);
    procedure Close(Sender: IFormView);
    procedure CloseQuery(Sender: IView; var CanClose: boolean);
    procedure ErrorHandler(E: Exception; Sender: IView);
    function GetVersion(Sender: IView): string;
    procedure ShowHelp(Sender: IView);
    procedure ShowHelp(Sender: IFormView);
    procedure Cancel(Sender: IView);
    procedure Connect(Sender: IView);
    procedure Disconnect(Sender: IView);
    procedure EditCurrentRecord(Sender: IView);
    function GetCurrentRecordText(Sender: IView): string;
    procedure NewRecord(Sender: IView);
    procedure RefreshData(Sender: IView);
    procedure Commit(Sender: IView);
    function IsDBConnected(Sender: IView): boolean;
    { El modelo MVC dice que los eventos deben ser manejados por el controlador.
      El controlador debe ser capaz de manejar una vista grafica o de linea de
      comandos sin modificaciones }
    function GetModel: IModel;
    procedure SetModel(AValue: IModel);
    property Model: IModel read GetModel write SetModel;
  end;

implementation

end.
