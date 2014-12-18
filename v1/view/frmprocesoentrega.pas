unit frmprocesoentrega;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, StdCtrls, DBGrids, DBCtrls, LazHelpHTML, frmproceso,
  entregactrl, sgcdTypes;

type

  { TProcesoEntrega }

  TProcesoEntrega = class(TProceso)
  protected
    function GetCustomController: TEntregaController;
  published
    ButtonSeleccionarExamen: TButton;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    DBText1: TDBText;
    DBText2: TDBText;
    DBText3: TDBText;
    DBText4: TDBText;
    DBText5: TDBText;
    DBText6: TDBText;
    GroupBoxCalifiaciones: TGroupBox;
    GroupBoxTrabajo: TGroupBox;
    LabelFecha: TLabel;
    LabelFechaFin: TLabel;
    LabelMateria: TLabel;
    LabelPuntajeMax: TLabel;
    LabelSeccion: TLabel;
    Nombre: TLabel;
    procedure ButtonSeleccionarExamenClick(Sender: TObject);
    procedure ObserverUpdate(const Subject: IInterface); override;
    procedure CancelButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  end;

var
  ProcesoEntrega: TProcesoEntrega;

implementation

{$R *.lfm}

{ TProcesoEntrega }

procedure TProcesoEntrega.ButtonSeleccionarExamenClick(Sender: TObject);
begin
  GetCustomController.SeleccionarTrabajo(Self);
end;

procedure TProcesoEntrega.ObserverUpdate(const Subject: IInterface);
begin
  inherited ObserverUpdate(Subject);
  case GetCustomController.GetEstado of
    edInicial:
    begin
      GetController.CloseDataSets(Self);
      GroupBoxTrabajo.Visible := False;
      GroupBoxCalifiaciones.Enabled := False;
      ButtonPanel1.OKButton.Enabled := False;
      ButtonPanel1.CancelButton.Enabled := False;
    end;
    edEditando:
    begin
      GroupBoxTrabajo.Visible := True;
      GroupBoxCalifiaciones.Enabled := True;
      ButtonPanel1.OKButton.Enabled := True;
      ButtonPanel1.CancelButton.Enabled := True;
    end;
    edGuardado:
    begin
      GetController.CloseDataSets(Self);
      GroupBoxTrabajo.Visible := False;
      GroupBoxCalifiaciones.Enabled := False;
      ButtonPanel1.OKButton.Enabled := False;
      ButtonPanel1.CancelButton.Enabled := False;
    end;
  end;
end;

procedure TProcesoEntrega.CancelButtonClick(Sender: TObject);
begin
  GetController.Cancel(Self);
  GetController.CloseDataSets(Self);
end;

procedure TProcesoEntrega.OKButtonClick(Sender: TObject);
begin
  GetController.Save(Self);
  GetController.Commit(Self);
  GetController.CloseDataSets(Self);
end;

function TProcesoEntrega.GetCustomController: TEntregaController;
begin
  Result := GetController as TEntregaController;
end;

end.

