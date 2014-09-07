unit frmacademiaview;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, sqldb, FileUtil, Forms, Controls, Graphics, Dialogs,
  Menus, DBGrids, DBCtrls, StdCtrls, frmMaestro, observerSubject;

type

  { TAcademiaView }

  TAcademiaView = class(TMaestro, IObserver)
    DBNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    ds: TDatasource;
    ToggleBox1: TToggleBox;
    procedure IObserver.Update = ObserverUpdate;
    procedure ObserverUpdate(const Subject: IInterface);
    procedure ToggleBox1Change(Sender: TObject);
  end;

var
  AcademiaView: TAcademiaView;

implementation

{$R *.lfm}

{ TAcademiaView }

procedure TAcademiaView.ToggleBox1Change(Sender: TObject);
begin
  {if (Sender as TToggleBox).Checked then
    Controller.ActivateDataSet(Self)
  else
    Controller.DeactivateDataSet(Self);}
end;

procedure TAcademiaView.ObserverUpdate(const Subject: IInterface);
var
  Obj: TDataModule;
begin
  Subject.QueryInterface(ISubject, Obj);
  if Obj <> nil then
    Caption := Caption + IntToStr(Random(256));
end;

end.
