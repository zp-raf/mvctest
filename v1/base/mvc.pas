unit mvc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, mensajes, contnrs, DB, sgcdTypes;

type

  { Forward declarations }

  IController = interface;
  IModel = interface;
  IDBModel = interface;
  IFormView = interface;
  IView = interface;
  IABMController = interface;
  IABMView = interface;

  { IView }

  IView = interface
    ['{BF806B18-377B-4EF8-8139-75EE0C7984D5}']
    procedure CloseView(Sender: IController);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    function ShowErrorMessage(AMsg: string): TModalResult;
    function ShowErrorMessage(ATitle: string; AMsg: string): TModalResult;
    function ShowInfoMessage(AMsg: string): TModalResult;
    function ShowInfoMessage(ATitle: string; AMsg: string): TModalResult;
    function ShowWarningMessage(AMsg: string): TModalResult;
    function ShowWarningMessage(ATitle: string; AMsg: string): TModalResult;
    function ShowConfirmationMessage(AMsg: string): TModalResult;
    function ShowConfirmationMessage(ATitle: string; AMsg: string): TModalResult;
    //function GetController: IController;
    //procedure SetController(AValue: IController);
    //property Controller: IController read GetController write SetController;
  end;


  { IFormView }

  IFormView = interface(IView)
    ['{A1AB24E3-C419-44E2-B390-D4653F8C5E88}']
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  end;

  { IABMView }

  IABMView = interface
    ['{C8D5D732-64B6-4F9A-B41E-2E6471C54D6E}']
    procedure Cancel;
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
    procedure Rollback;
  end;

  { IModel }

  IModel = interface
    ['{91D626B4-415B-4FB2-8B98-620B8F24A406}']
    procedure CloseDataSets;
    procedure Commit;
    procedure Connect;
    procedure DataModuleCreate(Sender: TObject);
    procedure DiscardChanges;
    procedure Disconnect;
    procedure EditCurrentRecord;
    procedure FilterData(ASearchText: string);
    procedure FilterRecord(DataSet: TDataSet; var Accept: boolean);
    function GetOnError: TErrorEvent;
    procedure NewRecord;
    procedure NewDetailRecord;
    procedure OpenDataSets;
    procedure RefreshDataSets;
    procedure Rollback;
    procedure SaveChanges;
    procedure SetAuxQryList(AValue: TQryList);
    procedure SetMasterDataModule(AValue: IDBModel);
    procedure SetOnError(AValue: TErrorEvent);
    procedure SetQryList(AValue: TQryList);
    procedure SetReadOnly(Option: boolean);
    procedure SetSearchText(AValue: string);
    procedure SetSearchFieldList(AValue: TSearchFieldList);
    procedure UnfilterData;
    function ArePendingChanges: boolean;
    function GetAuxQryList: TQryList;
    function GetCurrentRecordText: string;
    function GetDBStatus: TDBInfo;
    function GetMasterDataModule: IDBModel;
    function GetQryList: TQryList;
    function GetSearchFieldList: TSearchFieldList;
    function GetSearchText: string;
    property OnError: TErrorEvent read GetOnError write SetOnError;
    property QryList: TQryList read GetQryList write SetQryList;
    property SearchText: string read GetSearchText write SetSearchText;
    property SearchFieldList: TSearchFieldList
      read GetSearchFieldList write SetSearchFieldList;
    property AuxQryList: TQryList read GetAuxQryList write SetAuxQryList;
    property MasterDataModule: IDBModel read GetMasterDataModule
      write SetMasterDataModule;
  end;

  { IController }

  IController = interface
    ['{B1D8EBC6-C5B4-4F72-9CA3-6E4B74F51858}']
    procedure Cancel(Sender: IView);
    procedure Commit(Sender: IView);
    procedure Close(Sender: IView);
    procedure Close(Sender: IFormView);
    procedure CloseDataSets(Sender: IView);
    procedure CloseQuery(Sender: IView; var CanClose: boolean);
    procedure Connect(Sender: IView);
    procedure Disconnect(Sender: IView);
    procedure EditCurrentRecord(Sender: IView);
    procedure ErrorHandler(E: Exception; Sender: IView);
    procedure NewDetailRecord(Sender: IView);
    procedure NewRecord(Sender: IView);
    procedure OpenDataSets(Sender: IView);
    procedure RefreshData(Sender: IView);
    procedure Rollback(Sender: IView);
    procedure Save(Sender: IView);
    procedure ShowHelp(Sender: IView);
    procedure ShowHelp(Sender: IFormView);
    function GetVersion(Sender: IView): string;
    //function GetModel: IModel;
    function IsDBConnected(Sender: IView): boolean;
    function IsValidDate(ADateStr: string): boolean;
    //procedure SetModel(AValue: IModel);
    //property Model: IModel read GetModel write SetModel;
  end;

  { IABMController }

  IABMController = interface(IController)
    ['{DCFA8850-3248-48F4-BC94-72A140AA75F4}']
    procedure FilterData(AFilterText: string; Sender: IView);
    function GetCurrentRecordText(Sender: IView): string;
  end;

implementation

end.
