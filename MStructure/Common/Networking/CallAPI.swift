//
//  CallAPI.swift
//  MStructure
//
//  Created by Mephrine on 2019/12/03.
//  Copyright © 2019 MStructure. All rights reserved.
//

import Alamofire
import Moya
import RxSwift
import SwiftyJSON
import MUtils


/**
 # (E) CallAPI.swift
 - Author: Mephrine
 - Date: 20.01.16
 - Note: 사용할 API enum으로 관리.
*/
// MARK: Enum
enum CallAPI {
    ///// e.g.
//    case GetWeather(lat: String, lon: String)
//    case GetObject
    
    // 버전정보 조회
    case AppVersion
    
    // 서버 인증서 가져오기
    case ServerCert
    
}

// MARK: Extension CallAPI
extension CallAPI: TargetType, AccessTokenAuthorizable {
    // 각 case의 도메인
    var baseURL: URL {
        switch self {
            //test
//            case .ServerCert:
//                return URL(string: "https://m.8899.or.kr/kica_kb_cert.do")!
        default:
            return URL(string: API_DOMAIN)!
        }
    }
    
    // 각 case의 URL Path
    var path: String {
        switch self {
        case .AppVersion:
            return "/ws/app/version"
        case .ServerCert:
            return "/ws/app/server_authorization_certificate"
            
        default:
            return ""
        }
        
        /* example
         case .Component(_, _, _):
         return "/api/comp/IfCom001"
         */
    }
    
    var task: Task {
        
        /* example
         Body로 보내는 거면 하단 처럼 따로 설정.
         
         case .MAMAVoteSend(let bodyRequest):
                    return Task.requestCompositeData(bodyData: bodyRequest.data(using:.utf8)!, urlParameters: [:])
        */
        return .requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
    }
    
    // 각 case의 메소드 타입 get / post
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    // 테스트용도로 제공하는 데이터. 로컬에 json파일 넣고 해당 파일명으로 설정해주면 사용 가능. - Unit Test시 사용
    var sampleData: Data {
        return stubbedResponseFromJSONFile(filename: "object_response")
    }
    
//    var responseType: ALSwiftyJSONAble.Type {
//        switch self {
//        case .ForcedUpdate:
//            return ForcedUpdate.self
//        }
//    }
    
    // 헤더에 추가할 내용 정의
    var headers: [String: String]? {
        switch self {
        default :
            return nil
        }
    }
    
    // 파라미터
    /**
     e.g.)
     // GET으로 보낼 경우.
     case .VoteDetail(let showLoCd, let langCd, let voteSeq):
         parameters = ["showLoCd":showLoCd, "langCd":langCd, "voteSeq":voteSeq]
         break
     
     // POST로 보낼 경우.
     case .VoteSend(let bodyRequest):
          return Task.requestCompositeData(bodyData: bodyRequest.data(using:.utf8)!, urlParameters: [:])
     
     */
    var parameters: [String: Any]? {
        switch self {
//        case .GetWeather(let lat, let lon):
//            return ["lat": lat, "lon": lon, "appid": "7af0f9566df99bbd8c44509bcb4d72e2"]
        default :
            return nil
        }
    }
    
    
    var authorizationType: AuthorizationType? {
        /*
         Header 사용 여부. bearer, basic 방식으로 보낼 수 있음.
         case .MwaveVoteSend:
         return .bearer
         */
        switch self {
        default:
            return .none
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        /* 아래와 같이도 사용 가능.
         case .sendChatData:
         return URLEncoding.httpBody
         */
        return URLEncoding.default
    }

    // 파일 전송등 multipart 사용 시 사용.
    var multipartBody: [Moya.MultipartFormData]? {
        return nil
    }
    
     /*
         # stubbedResponseFromJSONFile
           - Author: Mephrine.
           - Date: 20.03.17
           - parameters:
            - filename : 테스트 json 파일명
            - inDirectory : 테스트 json 경로
            - bundle : 테스트 json 접근을 위한 앱 번들
           - returns: Data
           - Note: 테스트 JSON File 경로 정의 - Unit Test시 사용
       */
    private func stubbedResponseFromJSONFile(filename: String, inDirectory subpath: String = "", bundle:Bundle = Bundle.main ) -> Data {
        guard let path = bundle.path(forResource: filename, ofType: "json",
                                     inDirectory: subpath)
            else {
                return Data()
        }
        
        if let dataString = try? String(contentsOfFile: path),
            let data = dataString.data(using: String.Encoding.utf8){
            return data
        } else {
            return Data()
        }
    }
    
}

/*
jsonArray로 보낼때는 하단과 같이 작업.
parameters =  ["jsonArray":["contsMetaDivCd": contsMetaDivCd, "contsMetaId": snsKey, "snsKey": snsTypeCd, "snsTypeCd": replSbst, "replSbst": contsMetaId, "langCd": Defaults[.USER_INTERFACE_LANGCD] ?? ""]]

*/
// JsonArray로 보낼 경우 사용.
struct JsonArrayEncoding: Moya.ParameterEncoding {
    public static var `default`: JsonArrayEncoding { return JsonArrayEncoding() }
    
    /*
      # encode
        - Author: Mephrine.
        - Date: 20.03.17
        - parameters:
         - urlRequest : 전달할 URL
         - with : 파라미터
        - returns: URLRequest
        - Note: JsonArray으로 파라미터를 인코딩해서 전달할 경우에 사용.
    */
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var req = try urlRequest.asURLRequest()
        let json = try JSONSerialization.data(withJSONObject: parameters!["jsonArray"]!, options: JSONSerialization.WritingOptions.prettyPrinted)
        req.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        req.httpBody = json
        return req
    }
    
}

