unit frmmultas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ButtonPanel, DBGrids, StdCtrls, XMLPropStorage, ExtCtrls, frmProceso, multactrl;

type

  { TProcesoMultas }

  TProcesoMultas = class(TProceso)
    procedure LabeledEdit1Change(Sender: TObject);
  protected
    function GetCustomController: TMultaController;
  published
    DBGrid1: TDBGrid;
    LabeledEdit1: TLabeledEdit;
    procedure OKButtonClick(Sender: TObject);
  end;

var
  ProcesoMultas: TProcesoMultas;

implementation

{$R *.lfm}

{ TProcesoMultas }


procedure TProcesoMultas.OKButtonClick(Sender: TObject);
begin
  GetCustomController.SetMultas(Self);
end;

procedure TProcesoMultas.LabeledEdit1Change(Sender: TObject);
begin
  GetCustomController.FilterData(LabeledEdit1.Text, Self);
end;

function TProcesoMultas.GetCustomController: TMultaController;
begin
  Result := GetController as TMultaController;
end;

end.
