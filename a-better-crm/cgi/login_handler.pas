unit login_handler;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, httpdefs, fpHTTP, fpWeb, fpjson,
  IniFiles;

type

  { TLoginHandler }

  TLoginHandler = class(TFPWebModule)
    procedure checkRequest(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: Boolean);
  private
    function authenticate(AUser, APass: string): boolean;
  public
    { public declarations }
  end;

var
  LoginHandler: TLoginHandler;

implementation

{$R *.lfm}

{ TLoginHandler }

function TLoginHandler.authenticate(AUser, APass: string): boolean;
var
  lIni: TIniFile;
  lUsername: string;
  lPassword: string;
begin
  Result := False;
  lIni := TIniFile.Create('users.ini');
  try
    lUsername := lIni.ReadString('default', 'UserName', 'admin');  
    lPassword := lIni.ReadString('default', 'Password', 'admin');  
    if (AUser = lUsername) and (APass = lPassword) then
    begin
      Result := True;
    end;
  finally
    lIni.Free;
  end;
end;

procedure TLoginHandler.checkRequest(Sender: TObject; ARequest: TRequest;
  AResponse: TResponse; var Handled: Boolean);
var
  lJSON: TJSONObject;
  lUser: string;
  lPass: string;
begin
  try
    lJSON := TJSONObject.Create;

    // User and Password values sent by the browser
    lUser := ARequest.ContentFields.Values['userName'];
    lPass := ARequest.ContentFields.Values['passWord'];

    // authenticate using these variables
    if (authenticate(lUser, lPass)) then
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

