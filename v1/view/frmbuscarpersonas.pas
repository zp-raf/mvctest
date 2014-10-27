unit frmbuscarpersonas;

{$mode objfpc}{$H+}

interface

uses
  Forms,
  DBGrids, ExtCtrls, StdCtrls;

type

  { TPopupSeleccionPersonas }

  TPopupSeleccionPersonas = class(TForm)
  private
    //FCustomController: TBuscarPersonasController;
    //procedure SetCustomController(AValue: TBuscarPersonasController);
  public
    //constructor Create(AOwner: IFormView; AController: TBuscarPersonasController);
    //  overload;
  published
    ButtonCancel: TButton;
    ButtonOK: TButton;
    DBGrid1: TDBGrid;
    LabeledEdit1: TLabeledEdit;
    Personas: TRadioGroup;
    //procedure SQLQuery1FilterRecord(DataSet: TDataSet; var Accept: boolean);
    //property CustomController: TBuscarPersonasController
    //  read FCustomController write SetCustomController;
  end;

//var
//  PopupSeleccionPersonas: TPopupSeleccionPersonas;

implementation

{$R *.lfm}

{ TPopupSeleccionPersonas }

//procedure TPopupSeleccionPersonas.SQLQuery1FilterRecord(DataSet: TDataSet;
//  var Accept: boolean);
//begin
//  if Trim(LabeledEdit1.Text) = '' then
//  begin
//    case Personas.ItemIndex of
//      0: Accept := True;
//      1: Accept := (DataSet.FieldByName('ESPROVEEDOR').AsInteger = 1) or
//          (DataSet.FieldByName('ESINTERVENTOR').AsInteger = 1) or
//          (DataSet.FieldByName('ESVEEDOR').AsInteger = 1);
//      2: Accept := DataSet.FieldByName('ESALUMNO').AsInteger = 1;
//      3: Accept := DataSet.FieldByName('ESPROVEEDOR').AsInteger = 1;
//    end;
//  end
//  else
//  begin
//    case Personas.ItemIndex of
//      0: Accept := AnsiContainsText(DataSet.FieldByName('NOMBRECOMPLETO').AsString,
//          LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('CEDULA').AsString,
//          LabeledEdit1.Text);
//      1: Accept := (AnsiContainsText(DataSet.FieldByName('NOMBRECOMPLETO').AsString,
//          LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('CEDULA').AsString,
//          LabeledEdit1.Text)) and ((DataSet.FieldByName('ESPROVEEDOR').AsInteger = 1) or
//          (DataSet.FieldByName('ESINTERVENTOR').AsInteger = 1) or
//          (DataSet.FieldByName('ESVEEDOR').AsInteger = 1));
//      2: Accept := (AnsiContainsText(DataSet.FieldByName('NOMBRECOMPLETO').AsString,
//          LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('CEDULA').AsString,
//          LabeledEdit1.Text)) and (DataSet.FieldByName('ESALUMNO').AsInteger = 1);
//      3: Accept := (AnsiContainsText(DataSet.FieldByName('NOMBRECOMPLETO').AsString,
//          LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('CEDULA').AsString,
//          LabeledEdit1.Text)) and (DataSet.FieldByName('ESPROVEEDOR').AsInteger = 1);
//    end;
//  end;
//end;

//constructor TPopupSeleccionPersonas.Create(AOwner: IFormView;
//  AController: TBuscarPersonasController);
//var
//  Cont: IController;
//begin
//  (AController as IInterface).QueryInterface(IController, Cont);
//  if (Cont = nil) then
//    raise Exception.Create(rsProvidedCont)
//  else
//  begin
//    inherited Create(AOwner, Cont);
//    CustomController := AController;
//  end;
//end;

//procedure TPopupSeleccionPersonas.SetCustomController(
//  AValue: TBuscarPersonasController);
//begin
//  if FCustomController = AValue then
//    Exit;
//  FCustomController := AValue;
//end;

end.
