unit main; 

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, httpdefs, fpHTTP, fpWeb, fpjson, jsonparser;

type

  { TFPWebModule1 }

  TFPWebModule1 = class(TFPWebModule)
    procedure getCustomerListRequest(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: Boolean);
    procedure loginRequest(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: Boolean);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  FPWebModule1: TFPWebModule1; 

implementation

{$R *.lfm}

{ TFPWebModule1 }

procedure TFPWebModule1.getCustomerListRequest(Sender: TObject;
  ARequest: TRequest; AResponse: TResponse; var Handled: Boolean);
var
  lJSonParser: TJSONParser;
  lStr: TFileStream;
  lFile: string;
  lJSON: TJSONObject;

begin
  lFile := ExtractFilePath(ParamStr(0)) + 'users.json';
  lStr := TFileStream.Create(lFile, fmOpenRead);
  lJSonParser := TJSONParser.Create(lStr);
  try
    lJSON := lJSonParser.Parse as TJSonObject;
    AResponse.Content := lJSON.AsJSON;
  finally
    lJSonParser.Free;
    lStr.Free;
  end;
  Handled := True;
end;

procedure TFPWebModule1.loginRequest(Sender: TObject; ARequest: TRequest;
  AResponse: TResponse; var Handled: Boolean);
var
  lJSON: TJSONObject;
begin
  lJSON := TJSONObject.Create;
  try
    // user is registered?
    if (ARequest.ContentFields.Values['user'] = 'demo') and (ARequest.ContentFields.Values['password'] = 'demo') then
    begin
      lJSON.Add('success', true);
      lJSON.Add('msg', 'Logged in!');
    end
    else
    begin
      lJSON.Add('success', false);
      lJSON.Add('msg', 'User or Password is not correct.');
    end;

    AResponse.Content := lJSON.AsJSON;
  finally
    lJSON.Free;
  end;
  Handled := True;
end;

initialization
  RegisterHTTPModule('LoginHandler', TFPWebModule1);
end.

