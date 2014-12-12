unit uHelp;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Buttons,
  FileUtil, IpHtml, ExtCtrls;

type
  TSimpleIpHtml = class(TIpHtml)
  public
    property OnGetImageX;
  end;

  TfrmHelp = class(TForm)
    IpHtmlPanel1 : TIpHtmlPanel;
    procedure HTMLGetImageX(Sender: TIpHtmlNode; const URL: string;
                            var Picture: TPicture);

    //You can remove this proc and the onHotClick property
    //if you do not need to navigate
    procedure IpHtmlPanel1HotClick(Sender: TObject);
  public
    procedure OpenHTMLFile(const Filename: string);
  end;

var
  frmHelp: TfrmHelp;

implementation
{$R *.lfm}

procedure TfrmHelp.IpHtmlPanel1HotClick(Sender: TObject);
var
  NodeA : TIpHtmlNodeA;
  NewFilename : String;
begin
  if IpHtmlPanel1.HotNode is TIpHtmlNodeA then
    begin
      NodeA := TIpHtmlNodeA(IpHtmlPanel1.HotNode);
      NewFilename := NodeA.HRef;
      OpenHTMLFile(NewFilename);
    end;
end;

procedure TfrmHelp.HTMLGetImageX(Sender : TIpHtmlNode; const URL : string;
                                 var Picture: TPicture);
var
  PicCreated: boolean;
begin
  try
    if FileExistsUTF8(URL) then
      begin
        PicCreated := False;
        if Picture = nil then
          begin
            Picture := TPicture.Create;
            PicCreated := True;
          end;
        Picture.LoadFromFile(URL);
      end;
  except
    if PicCreated then
      Picture.Free;
    Picture := nil;
  end;
end;

procedure TfrmHelp.OpenHTMLFile(const Filename : string);
var
  fs : TFileStream;
  NewHTML : TSimpleIpHtml;
begin
  try
    fs := TFileStream.Create(UTF8ToSys(Filename), fmOpenRead);
    try
      NewHTML := TSimpleIpHtml.Create; // Beware: Will be freed automatically by IpHtmlPanel1
    //  NewHTML.OnGetImageX := @HTMLGetImageX;
      NewHTML.LoadFromStream(fs);
    finally
      fs.Free;
    end;
    IpHtmlPanel1.SetHtml(NewHTML);
  except
    on E: Exception do
      begin
        MessageDlg('Unable to open HTML file', 'HTML File: ' + Filename + #13 +
                 'Error: ' + E.Message,mtError, [mbCancel], 0);
      end;
  end;
end;

end.

