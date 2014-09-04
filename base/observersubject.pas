unit observerSubject;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  IObserver = interface
    ['{7E2E6235-5C71-4A83-BF13-B81EEDBF8FAE}']
    procedure Update(const Subject: IInterface);
  end;

  ISubject = interface
    ['{D7987BF8-E4D6-44C4-91D6-F476BD761740}']
    procedure Attach(Observer: IObserver);
    procedure Detach(Observer: IObserver);
    procedure Notify;
  end;

  TSubject = class(TInterfacedObject, ISubject)
  private
    fController: Pointer;
    fObservers: IInterfaceList;
    procedure Attach(AObserver: IObserver);
    procedure Detach(AObserver: IObserver);
    procedure Notify;
  public
    constructor Create(const Controller: IInterface);
  end;

implementation

constructor TSubject.Create(const Controller: IInterface);
begin
  inherited Create;
  fController := Pointer(Controller);
end;

procedure TSubject.Attach(AObserver: IObserver);
begin
  if (fObservers = nil) then
    fObservers := TInterfaceList.Create;
  fObservers.Add(AObserver);
  Notify;
end;

procedure TSubject.Detach(AObserver: IObserver);
begin
  if (fObservers <> nil) then
  begin
    fObservers.Remove(AObserver);
    if fObservers.Count = 0 then
      fObservers := nil;
  end;
end;

procedure TSubject.Notify;
var
  i: integer;
begin
  if (fObservers <> nil) then
    for i := 0 to Pred(fObservers.Count) do
      (fObservers[i] as IObserver).Update(IInterface(fController));
end;

end.
