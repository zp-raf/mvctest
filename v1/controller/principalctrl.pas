unit principalctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, mvc, observerSubject, frmMaestro, Forms, Dialogs;

type

  { TPrincipalController }

  TPrincipalController = class(TController)
  public
    constructor Create(ASubject: ISubject); overload;
    procedure CreateModel(InstanceClass: TClass; AOwner: TComponent; out Reference);
    procedure CreateModel(InstanceClass: TClass; AOwner: TComponent;
      ASubOject: IInterface; out Reference);
    procedure CreateController(InstanceClass: TClass; AModel: IModel; out Reference);
    procedure CreateForm(InstanceClass: TClass; AOwner: TComponent;
      AController: IController; out Reference);
    function GetUserName(Sender: IFormView): string;
    function GetHostName(Sender: IFormView): string;
  end;

var
  PrincipalController: TPrincipalController;

implementation

{ TPrincipalController }

constructor TPrincipalController.Create(ASubject: ISubject);
begin

end;

procedure TPrincipalController.CreateModel(InstanceClass: TClass;
  AOwner: TComponent; out Reference);
var
  Instance: TClass;
  ok: boolean;
begin
  ShowMessage(InstanceClass.ClassName);
  //// Allocate the instance, without calling the constructor
  //Instance := TClass(InstanceClass).NewInstance;
  //// set the Reference before the constructor is called, so that
  //// events and constructors can refer to it
  //TClass(Reference) := Instance;
  //ok := False;
  //try
  //  Instance.Create(Self);
  //  ok := True;
  //finally
  //  if not ok then
  //  begin
  //    Reference := nil;
  //  end;
  //end;
end;

procedure TPrincipalController.CreateModel(InstanceClass: TClass;
  AOwner: TComponent; ASubOject: IInterface; out Reference);
var
  Instance: TClass;
  ok: boolean;
begin
  //// Allocate the instance, without calling the constructor
  //Instance := InstanceClass.NewInstance;
  //// set the Reference before the constructor is called, so that
  //// events and constructors can refer to it
  //TClass(Reference) := Instance;
  //ok := False;
  //try
  //  Instance.Create(Self);
  //  ok := True;
  //finally
  //  if not ok then
  //  begin
  //    Reference := nil;
  //  end;
  //end;
end;

procedure TPrincipalController.CreateController(InstanceClass: TClass;
  AModel: IModel; out Reference);
var
  Instance: TClass;
  ok: boolean;
begin
  //// Allocate the instance, without calling the constructor
  //Instance := InstanceClass.NewInstance;
  //// set the Reference before the constructor is called, so that
  //// events and constructors can refer to it
  //TClass(Reference) := Instance;
  //ok := False;
  //try
  //  Instance.Create(Self);
  //  ok := True;
  //finally
  //  if not ok then
  //  begin
  //    Reference := nil;
  //  end;
  //end;
end;

procedure TPrincipalController.CreateForm(InstanceClass: TClass;
  AOwner: TComponent; AController: IController; out Reference);
var
  Instance: TClass;
  ok: boolean;
begin
  //// Allocate the instance, without calling the constructor
  //Instance := InstanceClass.NewInstance;
  //// set the Reference before the constructor is called, so that
  //// events and constructors can refer to it
  //TClass(Reference) := Instance;
  //ok := False;
  //try
  //  Instance.Create(Self);
  //  ok := True;
  //finally
  //  if not ok then
  //  begin
  //    Reference := nil;
  //  end;
  //end;
end;

function TPrincipalController.GetUserName(Sender: IFormView): string;
begin
  Result := Model.GetDBStatus.User;
end;

function TPrincipalController.GetHostName(Sender: IFormView): string;
begin
  Result := model.GetDBStatus.Host;
end;

end.
