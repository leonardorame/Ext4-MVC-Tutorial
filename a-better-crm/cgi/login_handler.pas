unit login_handler;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, httpdefs, fpHTTP, fpWeb, fpjson, jsonparser,
  dateutils;

type

  { TLoginHandler }

  TLoginHandler = class(TFPWebModule)
    procedure checkRequest(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: Boolean);
    procedure controlExpirationRequest(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: Boolean);
    procedure deleteRequest(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: Boolean);
    procedure insertRequest(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: Boolean);
    procedure readRequest(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: Boolean);
    procedure updateRequest(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: Boolean);
  private
    function authenticate(AUser, APass: string; out AId: Integer): boolean;
  public
    { public declarations }
  end;

var
  LoginHandler: TLoginHandler;

implementation

{$R *.lfm}

{ TLoginHandler }

function TLoginHandler.authenticate(AUser, APass: string; out AId: Integer): boolean;
var
  lUsername: string;
  lPassword: string;
  lJSonParser: TJSONParser;
  lStr: TStringList;
  lFile: string;
  lJSON: TJSONObject;
  lArray: TJSONArray;
  I: Integer;

begin
  Result := False;
  lFile := 'users.json';
  lStr := TStringList.Create;
  lStr.LoadFromFile(lFile);
  lJSonParser := TJSONParser.Create(lStr.Text);
  try

    (* Traverse data finding by Id *)
    lJSON := lJSonParser.Parse as TJSonObject;
    lArray := lJSON.Arrays['root'];
    for I := 0 to lArray.Count - 1 do
    begin
      lUsername := (lArray.Objects[I] as TJsonObject).Strings['username'];
      lPassword := (lArray.Objects[I] as TJsonObject).Strings['password'];
      AId := (lArray.Objects[I] as TJsonObject).Integers['id'];
      if (AUser = lUsername) and (APass = lPassword) then
      begin
        (* Save last login time *)
        (lArray.Objects[I] as TJsonObject).Floats['lastlogin'] := Now;
        (* update the json file *)
        lStr.Text := lJSON.AsJSON;
        lStr.SaveToFile(lFile);
        Result := True;
        Break;
      end;
    end;
  finally
    lJSonParser.Free;
    lStr.Free;
  end;
end;

procedure TLoginHandler.checkRequest(Sender: TObject; ARequest: TRequest;
  AResponse: TResponse; var Handled: Boolean);
var
  lJSON: TJSONObject;
  lUser: string;
  lPass: string;
  lId: Integer;
begin
  try
    lJSON := TJSONObject.Create;

    // User and Password values sent by the browser
    lUser := ARequest.ContentFields.Values['userName'];
    lPass := ARequest.ContentFields.Values['passWord'];

    // authenticate using these variables
    if (authenticate(lUser, lPass, lId)) then
    begin
      lJSON.Add('success', True);
      lJSON.Add('data', TJSONObject.Create(['id', lId]));
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

procedure TLoginHandler.controlExpirationRequest(Sender: TObject;
  ARequest: TRequest; AResponse: TResponse; var Handled: Boolean);
var
  lResponse: TJSONObject;
  lLastLogin: TDateTime;
  lJSON: TJSONObject;
  lResult: TJSONObject;
  lArray: TJSONArray;
  lJSonParser: TJSONParser;
  lStr: TStringList;
  lFile: string;
  I: Integer;
  lAllow: boolean;
  lFound: boolean;
  lMsg: string;
begin
  (* Load "database" *)
  lAllow := false;
  lFound := false;
  lFile := 'users.json';
  lStr := TStringList.Create;
  lStr.LoadFromFile(lFile);
  lJSonParser := TJSONParser.Create(lStr.Text);


  lResponse :=TJSONObject.Create;
  try
    try
      (* Assign values to local variables *)
      (* Traverse data finding by Id *)
      lJSON := lJSonParser.Parse as TJSonObject;
      lArray := lJSON.Arrays['root'];
      for I := 0 to lArray.Count - 1 do
      begin
        if ARequest.QueryFields.Values['id'] = (lArray.Objects[I] as TJsonObject).Strings['id'] then
        begin
          (* If the last time the user logged in was less than 5 seconds,
             we don't force him to re-login, otherwise the user is forced
             to enter user/password again *)
          lLastLogin := 0;
          if (lArray.Objects[I] as TJsonObject).IndexOfName('lastlogin') <> -1 then
            lLastLogin := (lArray.Objects[I] as TJsonObject).Floats['lastlogin'];
          if IncSecond(lLastLogin, 5) > now then
            lAllow := true
          else
            lMsg := 'Session expired.';

          lFound := True;
          Break;
        end;
      end;

      if not lFound then
        lMsg := 'User Id not found.';

      if lAllow then
        lResponse.Add('success', true)
      else
      begin
        lResponse.Add('success', false);
        lResponse.Add('data', TJSONObject.Create(['msg', lMsg]));
      end;

      AResponse.ContentType := 'application/json; charset=utf-8';
      AResponse.Content := AnsiToUtf8(lResponse.AsJSON);
    except
      on E: Exception do
      begin
        lResponse.Add('success', false);
        lResponse.Add('msg', E.Message);
        AResponse.Content := lResponse.AsJSON;
      end;
    end;
  finally
    lResponse.Free;
    lJSonParser.Free;
    lStr.Free;
  end;

  Handled := True;
end;

procedure TLoginHandler.deleteRequest(Sender: TObject; ARequest: TRequest;
  AResponse: TResponse; var Handled: Boolean);
var
  lResponse: TJSONObject;
  lJSON: TJSONObject;
  lResult: TJSONObject;
  lArray: TJSONArray;
  lJSonParser: TJSONParser;
  lStr: TStringList;
  lFile: string;
  I: Integer;

begin
  (* Load "database" *)
  lFile := 'users.json';
  lStr := TStringList.Create;
  lStr.LoadFromFile(lFile);
  lJSonParser := TJSONParser.Create(lStr.Text);
  lResponse :=TJSONObject.Create;
  try
    try
      (* Assign values to local variables *)
      lResult := TJSONParser.Create(ARequest.Content).Parse as TJSONObject;

      (* Traverse data finding by Id *)
      lJSON := lJSonParser.Parse as TJSonObject;
      lArray := lJSON.Arrays['root'];
      for I := 0 to lArray.Count - 1 do
      begin
        if lResult.Integers['id'] = (lArray.Objects[I] as TJsonObject).Integers['id'] then
        begin
          lArray.Delete(I);
          lStr.Text := lJSon.AsJSON;
          lStr.SaveToFile(lFile);
          Break;
        end;
      end;
      lResponse.Add('success', true);
      lResponse.Add('root', lResult);
      AResponse.ContentType := 'application/json; charset=utf-8';
      AResponse.Content := AnsiToUtf8(lResponse.AsJSON);
    except
      on E: Exception do
      begin
        lResponse.Add('success', false);
        lResponse.Add('msg', E.Message);
        AResponse.Content := lResponse.AsJSON;
      end;
    end;
  finally
    lResponse.Free;
    lJSonParser.Free;
    lStr.Free;
  end;

  Handled := True;
end;

procedure TLoginHandler.insertRequest(Sender: TObject; ARequest: TRequest;
  AResponse: TResponse; var Handled: Boolean);
var
  lResponse: TJSONObject;
  lJSON: TJSONObject;
  lResult: TJSONObject;
  lArray: TJSONArray;
  lJSonParser: TJSONParser;
  lStr: TStringList;
  lFile: string;

begin
  Randomize;
  (* Load "users database" *)
  lFile := 'users.json';
  lStr := TStringList.Create;
  lStr.LoadFromFile(lFile);
  lJSonParser := TJSONParser.Create(lStr.Text);
  lResponse :=TJSONObject.Create;
  try
    try
      lJSON := lJSonParser.Parse as TJSonObject;
      lArray := lJSON.Arrays['root'];
      (* Assign values to local variables *)
      lResult := TJSONParser.Create(ARequest.Content).Parse as TJSONObject;
      lResult.Integers['id'] := Random(1000);
      lArray.Add(lResult);
      (* Save the file *)
      lStr.Text:= lJSON.AsJSON;
      lStr.SaveToFile(lFile);

      lResponse.Add('success', true);
      lResponse.Add('root', lResult);

      AResponse.ContentType := 'application/json; charset=utf-8';
      AResponse.Content := AnsiToUtf8(lResponse.AsJSON);
    except
      on E: Exception do
      begin
        lResponse.Add('success', false);
        lResponse.Add('msg', E.Message);
        AResponse.Content := lResponse.AsJSON;
      end;
    end;
  finally
    lResponse.Free;
    lJSonParser.Free;
    lStr.Free;
  end;
  Handled := True;
end;

procedure TLoginHandler.readRequest(Sender: TObject; ARequest: TRequest;
  AResponse: TResponse; var Handled: Boolean);
var
  lJSonParser: TJSONParser;
  lStr: TFileStream;
  lFile: string;
  lJSON: TJSONObject;

begin
  lFile := 'users.json';
  lStr := TFileStream.Create(lFile, fmOpenRead);
  lJSonParser := TJSONParser.Create(lStr);
  try
    lJSON := lJSonParser.Parse as TJSonObject;
    AResponse.ContentType := 'application/json; charset=utf-8';
    AResponse.Content := AnsiToUtf8(lJSON.AsJSON);
  finally
    lJSonParser.Free;
    lStr.Free;
  end;
  Handled := True;
end;

procedure TLoginHandler.updateRequest(Sender: TObject; ARequest: TRequest;
  AResponse: TResponse; var Handled: Boolean);
var
  lResponse: TJSONObject;
  lJSON: TJSONObject;
  lResult: TJSONObject;
  lArray: TJSONArray;
  lJSonParser: TJSONParser;
  lStr: TStringList;
  lFile: string;
  I: Integer;
begin
  (* Load "database" *)
  lFile := 'users.json';
  lStr := TStringList.Create;
  lStr.LoadFromFile(lFile);
  lJSonParser := TJSONParser.Create(lStr.Text);
  lResponse :=TJSONObject.Create;
  try
    try
      (* Assign values to local variables *)
      lResult := TJSONParser.Create(ARequest.Content).Parse as TJSONObject;

      (* Traverse data finding by Id *)
      lJSON := lJSonParser.Parse as TJSonObject;
      lArray := lJSON.Arrays['root'];
      for I := 0 to lArray.Count - 1 do
      begin
        if lResult.Integers['id'] = (lArray.Objects[I] as TJsonObject).Integers['id'] then
        begin
          (* Assign field values *)
          (lArray.Objects[I] as TJsonObject).Strings['username'] := lResult.Strings['username'];
          (lArray.Objects[I] as TJsonObject).Strings['password'] := lResult.Strings['password'];
          lStr.Text := lJSon.AsJSON;
          lStr.SaveToFile(lFile);
          Break;
        end;
      end;
      lResponse.Add('success', true);
      lResponse.Add('root', lResult);

      AResponse.ContentType := 'application/json; charset=utf-8';
      AResponse.Content := AnsiToUtf8(lResponse.AsJSON);
    except
      on E: Exception do
      begin
        lResponse.Add('success', false);
        lResponse.Add('msg', E.Message);
        AResponse.Content := lResponse.AsJSON;
      end;
    end;
  finally
    lResponse.Free;
    lJSonParser.Free;
    lStr.Free;
  end;

  Handled := True;
end;

initialization
  RegisterHTTPModule('users', TLoginHandler);
end.

