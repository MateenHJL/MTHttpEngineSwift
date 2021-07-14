//
//  HttpMacro.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/9.
//
 
enum HTTPMethod {
    case POST //the way you accessed to server is POST.
    case GET //the way you accessed to server is GET
    case PUT //the way you accessed to server is PUT
    case DELETE //the way you accessed to server is Delete
}

enum HTTPCacheType {
    case ServerOnly           //just returned the response data after request from Server.the data didn't save.and not read the data which in sandbox as the same time.
    case CacheOnly             //just returned the local data which in sandbox,it didn't request from Server.it will request the server to get real response data if the data isn't existing.the data which is gotten from server will be save at sandbox.
    case DataThenServerData //the first,you will get local data which is in sandbox,and then you will get the real response data which is gotten from Server.the data which is gotten from server will be save at sandbox.
}

enum HTTPStatusCode:Int {
    case DetaultCode = 0  //the connection didn't begun yet.
    case NoneError          = 200
    case RequestUrlIsNilOrNotCorrect//the url of httpItem is nil or empty string url.
    case ParseError                  = 700000//the the format of response which be gotten from Server is not correct.parse error.
    case ResponseDataIsNil           = 700001//the response data from Server is nil.
    case ConnectedFailed             = 700002//the connection between server and client is not suitable to using.
    case NoNetwork                   = 700003//the connection of this device can't be reached.because of no network now.
    case PostFileIsNil               = 700004//the file you post to server is nil.
    case PostFileKeyIsNull           = 700005//the key matched the file you post to server is null
    case NoConfigFile                = 700006//there's no httpConfig file yet,user should call - (void)setupHttpEngineWithConfig first
}

enum HTTPRequestStatus {
    case Prepared  //the request of httpItem is wating for request.
    case Connecting    //the request of httpItem is connecting.
    case HasFinished//the request of httpItem has already been finished.
}

enum HTTPRequestType {
    case RequestJsonDataType//normal http request,send data to server,then get the jsonString from server.
    case DownloadFilesType  //download some files or pictures.
    case FilesType     //upload some files or pictures.
}

enum HTTPResponseDataType {
    case UnknownType         //the response didn't loaded yet,default it is.
    case LoadedFromServer    //the response which loaded from Server
    case LoadedFromLocalCache //the response which loaded from local files or memories.
    case LoadedFromMockingResponse//the response loaded from local data which mocked by developer
}

enum HTTPConnectionCompletedStatus {
    case UnknowStatus                              //didn't request server at all.
    case ConnectedSuccessed                      //your connection is completed and the response you got from server is correct.
    case ConnectedException                        //your connection is completed ,but the response you got from server is not correct.
    case ConnectedFailed                            //your connection is failed.because of none network or request time out.
}

enum HTTPRepeatActionType {
    case None              //didn't do anything yet.
    case Uploading         //you are receiving the data while you uploaded.
    case Downloading       //you are receiving the data while you downloaded.
}

enum HTTPRequestResultType {
    case Successed        //http request successed.
    case Failed           //http request failed,maybe your code or result is not match
    case AnotherType      //http request will be determinal
}

public let HTTPWAYPOST : String = "POST";
public let HTTPWAYGET : String = "GET";
public let HTTPWAYDELETE : String = "DELETE";
public let HTTPWAYPUT : String = "PUT";
