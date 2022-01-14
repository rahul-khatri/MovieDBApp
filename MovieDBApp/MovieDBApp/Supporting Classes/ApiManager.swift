//
//  ServiceManager.swift
//  MovieDBApp
//
//  Created by RWS Macbook on 13/01/22.

import Foundation
import Alamofire

enum RequestMethod: String {
    case kMethodGet = "GET"
    case kMethodPost = "POST"
    case kMethodPUT = "PUT"
    case kMethodDelete = "DELETE"
}

class ApiManager {
    
    static var shared: ApiManager = {
        ApiManager()
    }()
    
    func executeApiWithRequestUrl(urlStr:String, dicParams:[String:Any], method:RequestMethod,isShowingLoader:Bool, completionHandler:@escaping (_ response:AnyObject,_ error:Error?)->(Void)) {
        
        if !Reachability.isConnectedToNetwork() {
            showAlert("", "Unable to connect to the internet")
            return
        }
        
        if(isShowingLoader) {
            LoadingView.shared.showOverlay(nil)
        }
        
        guard var url:NSURL = NSURL(string: urlStr) else { return }
        
        if method == .kMethodGet {
            
            var urlComponents = URLComponents()
            urlComponents.queryItems = []
            for (key, value) in dicParams {
                urlComponents.queryItems?.append(URLQueryItem(name: key , value: value as? String ?? ""))
            }
            
            guard let componentString = urlComponents.url?.absoluteString else { return }
            var str = "\(urlStr)\(String(describing: componentString))"
            str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            guard let combinedUrl = NSURL(string: str) else { return }
            url = combinedUrl
        }
        
        let mutableURLRequest = NSMutableURLRequest(url: url as URL)
        mutableURLRequest.httpMethod = method.rawValue
        
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        mutableURLRequest.timeoutInterval = 90
        
        if method != RequestMethod.kMethodGet {
            
            let data = try? JSONSerialization.data(withJSONObject: dicParams, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            guard let data = data else { return }
            
            guard let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return }
            
            mutableURLRequest.httpBody = json.data(using: String.Encoding.utf8.rawValue);
        }
        print("Complite request is ",mutableURLRequest)
        print("params-\(dicParams)-")
        
        Alamofire.request(mutableURLRequest as URLRequest)
            .responseJSON { response in
                
                
                LoadingView.shared.hideOverlayView()
                
                
                print("Request: \(String(describing: response.request))")
                print("result: \(response.result)")   // result of response serialization
                print("statusCode :  \(String(describing: response.response?.statusCode))" )
                
                if let JSON = response.result.value {
                    
                    print("JSON: \(JSON)")
                    do{
                        
                        guard let data = response.data else { return }
                        
                        let jsonObj = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        let jsonDict = jsonObj as? Dictionary<String, Any>
                        
                        switch response.result {
                        
                        case .success(let data):
                            
                            completionHandler(data as AnyObject, nil)
                            
                        case .failure(let error):
                            completionHandler(jsonDict as AnyObject,error)
                        }
                        
                        if isShowingLoader {
                            LoadingView.shared.hideOverlayView()
                        }
                        
                    } catch {
                        if isShowingLoader {
                            LoadingView.shared.hideOverlayView()
                        }
                    }
                }else{
                    
                    if isShowingLoader {
                        LoadingView.shared.hideOverlayView()
                    }
                    showAlert("Server not responding", "Please try again later")
                }
            }
    }
}
