//
//  NetworkHandler.swift
//  TeachUs
//
//  Created by ios on 11/4/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import Foundation
import Alamofire

class NetworkHandler:SessionManager{
    
    var url: String?
    
    func apiGet(apiName: String,
                completionHandler: @escaping (_ result: [String:Any], _ code: Int) -> Void,
                failure: @escaping (_ error: NSError, _ errorCode: Int,_ message: String) -> Void){
        
        #if DEBUG
            print("***** GET NETWORK CALL DETAILS *****")
            print("Api name: \(apiName), \(self.url!)")
        #endif
        
        if(Connectivity.isConnectedToInternet){
            
            Alamofire.request(self.url!).validate().responseJSON { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    #if DEBUG
                        print("***** NETWORK CALL RESPONSE *****")
                        print("status code: \((response.response?.statusCode)!), responseData: \(response.result.value ?? Dictionary<String, Any>())")
                    #endif
                    
                    if let responseDict = response.result.value as? [String: Any]{
                        completionHandler(responseDict, (response.response?.statusCode)!)
                    }else{
                        completionHandler(response.result.value! as! [String : Any], (response.response?.statusCode)!)
                    }
                    
                    
                case .failure(let error):
                    print(error)
                    let responseError:NSError = error as NSError
                    let errorString:String = responseError.localizedDescription
                    let errorCode:Int = responseError.code
                    let error = NSError(domain: "", code: 0, userInfo: nil)
                    #if DEBUG
                        print("***** NETWORK CALL FAILURE RESPONSE *****")
                        print("error code: \(errorCode), error String \(errorString)")
                    #endif
                    failure(error, errorCode, errorString)
                }
            }
        }else{
            
            
            print("NO INTERNET")
            /*
            let emptyMessageView:MessageView = MessageView.instanceFromNib() as! MessageView
            emptyMessageView.frame = (UIApplication.shared.keyWindow?.frame)!
            emptyMessageView.setUIforMessageType(MessageType.noInternet)
            emptyMessageView.showView(inView: UIApplication.shared.keyWindow!)
            */
            //            let error = NSError(domain: "", code: 0, userInfo: nil)
            //            failure(error, 0, Constants.errorMessages.noInternetMessage);
        }
    }
    
    
    func apiGetWithAnyResponse(apiName: String,
                completionHandler: @escaping (_ result: Any, _ code: Int) -> Void,
                failure: @escaping (_ error: NSError, _ errorCode: Int,_ message: String) -> Void){
        
        #if DEBUG
            print("***** GET NETWORK CALL DETAILS *****")
            print("Api name: \(apiName), \(self.url!)")
        #endif
        
        if(Connectivity.isConnectedToInternet){
            
            Alamofire.request(self.url!).validate().responseJSON { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    #if DEBUG
                        print("***** NETWORK CALL RESPONSE *****")
                        print("status code: \((response.response?.statusCode)!), responseData: \(response.result.value ?? Dictionary<String, Any>())")
                    #endif
                        completionHandler(response.result.value!, (response.response?.statusCode)!)
                case .failure(let error):
                    print(error)
                    let responseError:NSError = error as NSError
                    let errorString:String = responseError.localizedDescription
                    let errorCode:Int = responseError.code
                    let error = NSError(domain: "", code: 0, userInfo: nil)
                    #if DEBUG
                        print("***** NETWORK CALL FAILURE RESPONSE *****")
                        print("error code: \(errorCode), error String \(errorString)")
                    #endif
                    failure(error, errorCode, errorString)
                }
            }
        }else{
            
            
            print("NO INTERNET")
            /*
             let emptyMessageView:MessageView = MessageView.instanceFromNib() as! MessageView
             emptyMessageView.frame = (UIApplication.shared.keyWindow?.frame)!
             emptyMessageView.setUIforMessageType(MessageType.noInternet)
             emptyMessageView.showView(inView: UIApplication.shared.keyWindow!)
             */
            //            let error = NSError(domain: "", code: 0, userInfo: nil)
            //            failure(error, 0, Constants.errorMessages.noInternetMessage);
        }
    }
    
    func apiGetWithStringResponse(apiName: String,
                               completionHandler: @escaping (_ result: Any, _ code: Int) -> Void,
                               failure: @escaping (_ error: NSError, _ errorCode: Int,_ message: String) -> Void){
        
        #if DEBUG
            print("***** GET NETWORK CALL DETAILS *****")
            print("Api name: \(apiName), \(self.url!)")
        #endif
        
        if(Connectivity.isConnectedToInternet){
            
            
            Alamofire.request(self.url!).validate().responseString(completionHandler: { (response) in
                switch response.result{
                    
                case .success(_):
                    print("Validation Successful")
                    #if DEBUG
                        print("***** NETWORK CALL RESPONSE *****")
                        print("status code: \((response.response?.statusCode)!), responseData: \(response.result.value!)")
                    #endif
                    completionHandler(response.result.value!, (response.response?.statusCode)!)

                case .failure(let error):
                    print(error)
                    let responseError:NSError = error as NSError
                    let errorString:String = responseError.localizedDescription
                    let errorCode:Int = responseError.code
                    let error = NSError(domain: "", code: 0, userInfo: nil)
                    #if DEBUG
                        print("***** NETWORK CALL FAILURE RESPONSE *****")
                        print("error code: \(errorCode), error String \(errorString)")
                    #endif
                    failure(error, errorCode, errorString)

                }
            })
        }else{
            
            
            print("NO INTERNET")
            /*
             let emptyMessageView:MessageView = MessageView.instanceFromNib() as! MessageView
             emptyMessageView.frame = (UIApplication.shared.keyWindow?.frame)!
             emptyMessageView.setUIforMessageType(MessageType.noInternet)
             emptyMessageView.showView(inView: UIApplication.shared.keyWindow!)
             */
            //            let error = NSError(domain: "", code: 0, userInfo: nil)
            //            failure(error, 0, Constants.errorMessages.noInternetMessage);
        }
    }
    
    
    
}
