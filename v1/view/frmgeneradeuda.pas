unit frmgeneradeuda;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ButtonPanel, ExtCtrls, DBGrids, DbCtrls, StdCtrls, frmAbm;

type

  { TGenerarDeuda }

  TGenerarDeuda = class(TAbm)
    DBLookupComboBox1: TDBLookupComboBox;
    DBLookupComboBox2: TDBLookupComboBox;
    DBLookupComboBox3: TDBLookupComboBox;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Label2Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  GenerarDeuda: TGenerarDeuda;

implementation

{$R *.lfm}

{ TGenerarDeuda }

procedure TGenerarDeuda.FormCreate(Sender: TObject);
begin

end;

procedure TGenerarDeuda.Label2Click(Sender: TObject);
begin

end;

end.

