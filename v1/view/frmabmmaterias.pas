unit frmabmmaterias;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls, DB,
  Menus, ButtonPanel, ExtCtrls, DBGrids, DBCtrls, StdCtrls, frmAbm, materiactrl;

type

  { TAbmMaterias }

  TAbmMaterias = class(TAbm)
    ButtonPrerreq: TButton;
    DBCheckBox1: TDBCheckBox;
    DBEdit1: TDBEdit;
    DBLookupComboBox1: TDBLookupComboBox;
    DBLookupComboBox2: TDBLookupComboBox;
    DBMemo1: TDBMemo;
    DBMemo2: TDBMemo;
    DBMemo3: TDBMemo;
    DBMemo4: TDBMemo;
    DBMemo5: TDBMemo;
    DBMemo6: TDBMemo;
    DBMemo7: TDBMemo;
    DBMemo8: TDBMemo;
    DBMemo9: TDBMemo;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure ABMInsert; override;
    procedure ABMEdit; override;
    procedure ButtonPrerreqClick(Sender: TObject);
  protected
    function GetCustomController: TMateriaController;
  end;

var
  AbmMaterias: TAbmMaterias;

implementation

{$R *.lfm}

{ TAbmMaterias }

procedure TAbmMaterias.ABMInsert;
var
  x1, x2: TDataSource;
begin
  try
    x1 := DBLookupComboBox1.DataSource;
    x2 := DBLookupComboBox2.DataSource;
    DBLookupComboBox1.DataSource := nil;
    DBLookupComboBox2.DataSource := nil;
    inherited ABMInsert;
  finally
    DBLookupComboBox1.DataSource := x1;
    DBLookupComboBox2.DataSource := x2;
  end;
end;

procedure TAbmMaterias.ABMEdit;
var
  x1, x2: TDataSource;
begin
  try
    x1 := DBLookupComboBox1.DataSource;
    x2 := DBLookupComboBox2.DataSource;
    DBLookupComboBox1.DataSource := nil;
    DBLookupComboBox2.DataSource := nil;
    inherited ABMEdit;
  finally
    DBLookupComboBox1.DataSource := x1;
    DBLookupComboBox2.DataSource := x2;
  end;
end;

procedure TAbmMaterias.ButtonPrerreqClick(Sender: TObject);
begin
  GetCustomController.SeleccionarPre(Self);
end;

function TAbmMaterias.GetCustomController: TMateriaController;
begin
  Result := GetABMController as TMateriaController;
end;

end.

