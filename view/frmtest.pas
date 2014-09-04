unit frmtest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, observerSubject;

type

  { TTest }

  TTest = class(TForm, ISubject)
  private
    FSubject: ISubject;
  published
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    property Subject: ISubject read FSubject implements ISubject;
  public
    constructor Create(TheOwner: TComponent); override;
  end;

var
  Test: TTest;

implementation

{$R *.lfm}

{ TTest }

constructor TTest.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FSubject := TSubject.Create(Self);
end;

procedure TTest.Button1Click(Sender: TObject);
begin
  Subject.Notify;
end;

end.
