unit frmprocesocalificacion;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ButtonPanel, StdCtrls, DBGrids, DBCtrls, frmproceso, sgcdTypes,
  calificacionctrl;

type

  { TProcesoCalificacion }

  TProcesoCalificacion = class(TProceso)
  protected
    function GetCustomController: TCalificacionController;
  published
    ButtonSeleccionarExamen: TButton;
    DBGrid1: TDBGrid;
    DBText1: TDBText;
    DBText2: TDBText;
    DBText3: TDBText;
    GroupBoxExamen: TGroupBox;
    GroupBoxCalifiaciones: TGroupBox;
    LabelPuntajeMax: TLabel;
    DBNavigator1: TDBNavigator;
    LabelFecha: TLabel;
    LabelSeccion: TLabel;
    procedure ButtonSeleccionarExamenClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure ObserverUpdate(const Subject: IInterface); override;
  end;

var
  ProcesoCalificacion: TProcesoCalificacion;

implementation

{$R *.lfm}

{ TProcesoCalificacion }

procedure TProcesoCalificacion.ButtonSeleccionarExamenClick(Sender: TObject);
begin
  GetCustomController.SeleccionarExamen(Self);
end;

procedure TProcesoCalificacion.CancelButtonClick(Sender: TObject);
begin
  GetController.Cancel(Self);
  GetController.CloseDataSets(Self);
end;

procedure TProcesoCalificacion.OKButtonClick(Sender: TObject);
begin
  GetController.Save(Self);
  GetController.Commit(Self);
  GetController.CloseDataSets(Self);
end;

function TProcesoCalificacion.GetCustomController: TCalificacionController;
begin
  Result := GetController as TCalificacionController;
end;

procedure TProcesoCalificacion.ObserverUpdate(const Subject: IInterface);
begin
  inherited ObserverUpdate(Subject);
  case GetCustomController.GetEstado of
    edInicial:
    begin
      GetController.CloseDataSets(Self);
      GroupBoxExamen.Visible := False;
      GroupBoxCalifiaciones.Enabled := False;
      ButtonPanel1.OKButton.Enabled := False;
      ButtonPanel1.CancelButton.Enabled := False;
    end;
    edEditando:
    begin
      GroupBoxExamen.Visible := True;
      GroupBoxCalifiaciones.Enabled := True;
      ButtonPanel1.OKButton.Enabled := True;
      ButtonPanel1.CancelButton.Enabled := True;
    end;
    edGuardado:
    begin
      GetController.CloseDataSets(Self);
      GroupBoxExamen.Visible := False;
      GroupBoxCalifiaciones.Enabled := False;
      ButtonPanel1.OKButton.Enabled := False;
      ButtonPanel1.CancelButton.Enabled := False;
    end;
  end;
end;

end.

