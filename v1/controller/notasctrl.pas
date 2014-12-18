unit notasctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctrl, frmnotasdatamodule, mvc, DBGrids;

type

  { TNotasController }

  TNotasController = class(TController)
  protected
    function GetCustomModel: TNotasDataModule;
  public
    procedure CalcularNotas(AList: Pointer; Sender: IView);
    procedure SetCriterios(ACri: TCriterios; Sender: IView);
  end;

implementation

{ TNotasController }

function TNotasController.GetCustomModel: TNotasDataModule;
begin
  Result := GetModel as TNotasDataModule;
end;

procedure TNotasController.CalcularNotas(AList: Pointer; Sender: IView);
var
  selectedRowsCount, i: integer;
begin
  GetModel.OpenDataSets;
  if TDBGrid(AList).SelectedRows.Count > 0 then
    selectedRowsCount := TDBGrid(AList).SelectedRows.Count
  else
    selectedRowsCount := 1;
  for i := 0 to Pred(selectedRowsCount) do
  begin
    if selectedRowsCount > 1 then
    begin
      TDBGrid(AList).DataSource.DataSet.GotoBookmark(
        Pointer(TDBGrid(AList).SelectedRows.Items[i]));
      GetCustomModel.CalcularNota(TDBGrid(AList).DataSource.DataSet.FieldByName(
        'ID').AsString);
    end
    else
      GetCustomModel.CalcularNota(TDBGrid(AList).DataSource.DataSet.FieldByName(
        'ID').AsString);
  end;
  Save(Sender);
  Commit(Sender);
end;

procedure TNotasController.SetCriterios(ACri: TCriterios; Sender: IView);
begin
  GetCustomModel.Criterios := ACri;
end;

end.
