unit login_handler;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, httpdefs, fpHTTP, fpWeb, fpjson;

type

  { TLoginHandler }

  TLoginHandler = class(TFPWebModule)
    procedure checkRequest(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: Boolean);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  LoginHandler: TLoginHandler;

implementation

{$R *.lfm}

{ TLoginHandler }

procedure TLoginHandler.checkRequest(Sender: TObject; ARequest: TRequest;
  AResponse: TResponse; var Handled: Boolean);
var
  lJSON: TJSONObject;

begin
  try
    lJSON := TJSONObject.Create;
    if (ARequest.ContentFields.Values['userName']='admin') and (ARequest.ContentFields.Values['passWord']='admin') then
    begin
      lJSON.Add('success', True);
    end
    else
    begin
      lJSON.Add('failure', True);
      lJSON.Add('msg', 'Incorrect User or Password.');
    end;
    AResponse.ContentType := 'application/json; charset=utf-8';
    AResponse.Content := AnsiToUtf8(lJSON.AsJSON);
  finally
    lJSON.Free;
  end;
  Handled := True;
end;

initialization
  RegisterHTTPModule('login', TLoginHandler);
end.

