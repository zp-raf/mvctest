unit frmprocesoasientos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ButtonPanel, StdCtrls, DbCtrls, ExtCtrls, DBGrids, PairSplitter, frmproceso,
  frmmovimientodatamodule, frmasientosdatamodule, frmcuentadatamodule;

type

  { TProcesoAsientos }

  TProcesoAsientos = class(TProceso)
    DBGrid1: TDBGrid;
    DBLookupComboBox1: TDBLookupComboBox;
    DBLookupComboBox2: TDBLookupComboBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Debe: TLabel;
    Haber: TLabel;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
    procedure ObserverUpdate(const Subject: IInterface); override;
    property
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ProcesoAsientos: TProcesoAsientos;

implementation

{$R *.lfm}

{ TProcesoAsientos }

procedure TProcesoAsientos.ObserverUpdate(const Subject: IInterface);
begin

end;

procedure TProcesoAsientos.FormCreate(Sender: TObject);
begin

end;

end.
