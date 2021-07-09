//
//  HttpMacro.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/9.
//
 
enum HTTPMethod {
    case HTTPMethodPOST //the way you accessed to server is POST.
    case HTTPMethodGET //the way you accessed to server is GET
    case HTTPMethodPUT //the way you accessed to server is PUT
    case HTTPMethodDELETE //the way you accessed to server is Delete
}

enum HTTPCacheType {
    case HTTPCacheTypeServerOnly           //just returned the response data after request from Server.the data didn't save.and not read the data which in sandbox as the same time.
    case HTTPCacheTypeCacheOnly             //just returned the local data which in sandbox,it didn't request from Server.it will request the server to get real response data if the data isn't existing.the data which is gotten from server will be save at sandbox.
    case HTTPCacheTypeCacheDataThenServerData //the first,you will get local data which is in sandbox,and then you will get the real response data which is gotten from Server.the data which is gotten from server will be save at sandbox.
}

enum HTTPStatusCode:Int {
    case HTTPStatusCodeDetaultCode = 0  //the connection didn't begun yet.
    case HTTPStatusCodeRequestUrlIsNilOrNotCorrect//the url of httpItem is nil or empty string url.
    case HTTPStatusCodeParseError                  = 700000//the the format of response which be gotten from Server is not correct.parse error.
    case HTTPStatusCodeResponseDataIsNil           = 700001//the response data from Server is nil.
    case HTTPStatusCodeConnectedFailed             = 700002//the connection between server and client is not suitable to using.
    case HTTPStatusCodeNoNetwork                   = 700003//the connection of this device can't be reached.because of no network now.
    case HTTPStatusCodePostFileIsNil               = 700004//the file you post to server is nil.
    case HTTPStatusCodePostFileKeyIsNull           = 700005//the key matched the file you post to server is null
    case HTTPStatusCodeNoConfigFile                = 700006//there's no httpConfig file yet,user should call - (void)setupHttpEngineWithConfig first
}

enum HTTPRequestStatus {
    case HTTPRequestStatusPrepared  //the request of httpItem is wating for request.
    case HTTPRequestIsConnecting    //the request of httpItem is connecting.
    case HTTPRequestStatusHasFinished//the request of httpItem has already been finished.
}

enum HTTPRequestType {
    case HTTPRequestTypeRequestJsonDataType//normal http request,send data to server,then get the jsonString from server.
    case HTTPRequestTypeDownloadFilesType  //download some files or pictures.
    case HTTPRequestTypeUploadFilesType     //upload some files or pictures.
}

enum HTTPResponseDataType {
    case HTTPResponseDataTypeUnknownType         //the response didn't loaded yet,default it is.
    case HTTPResponseDataTypeLoadedFromServer    //the response which loaded from Server
    case HTTPResponseDataTypeLoadedFromLocalCache //the response which loaded from local files or memories.
    case HTTPResponseDataTypeLoadedFromMockingResponse//the response loaded from local data which mocked by developer
}

enum HTTPConnectionCompletedStatus {
    case HTTPConnectionCompletedStatusUnknowStatus                              //didn't request server at all.
    case HTTPConnectionCompletedStatusConnectedSuccessed                      //your connection is completed and the response you got from server is correct.
    case HTTPConnectionCompletedStatusConnectedException                        //your connection is completed ,but the response you got from server is not correct.
    case HTTPConnectionCompletedStatusConnectedFailed                            //your connection is failed.because of none network or request time out.
}

enum HTTPRepeatActionType {
    case HTTPRepeatActionTypeNone              //didn't do anything yet.
    case HTTPRepeatActionTypeUploading         //you are receiving the data while you uploaded.
    case HTTPRepeatActionTypeDownloading       //you are receiving the data while you downloaded.
}

enum HTTPRequestResultType {
    case HTTPRequestResultTypeSuccessed        //http request successed.
    case HTTPRequestResultTypeFailed           //http request failed,maybe your code or result is not match
    case HTTPRequestResultTypeAnotherType      //http request will be determinal
}

public let HTTPWAYPOST : String = "POST";
public let HTTPWAYGET : String = "GET";
public let HTTPWAYDELETE : String = "DELETE";
public let HTTPWAYPUT : String = "PUT";
