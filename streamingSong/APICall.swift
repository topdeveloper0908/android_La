//
//  APICall.swift
//  SampleData
//
//  Created by MERCEDES on 27/06/18.
//  Copyright © 2018 SampleData. All rights reserved.
//

import UIKit

func makeGetCall(complete : @escaping (_ dic : [String : Any]?, _ errorDesc : String?) -> Void) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    // Set up the URL request
    let nowplayingEndpoint: String = "http://www.danspaleis.be/rds/nowplaying.txt"
    guard let url = URL(string: nowplayingEndpoint) else {
        print("Error: cannot create URL")
        return
    }
    let urlRequest = URLRequest(url: url)
    
    // set up the session
    let config = URLSessionConfiguration.default
    let session = URLSession.init(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
    
    // make the request
    let task = session.dataTask(with: urlRequest) {
        (data, response, error) in
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        // check for any errors
        guard error == nil else {
            print("error calling GET on /nowplaying.txt")
            print(error!)
            complete(nil, error.debugDescription)
            return
        }
        // make sure we got data
        guard let responseData = data else {
            print("Error: did not receive data")
            complete(nil, error.debugDescription)
            return
        }
        // now we have the Text
        // let's just print it to prove we can access it
        //let str = String.init(data: responseData, encoding: .utf8)
        let str = String.init(bytes: responseData, encoding: String.Encoding.ascii)
        print("Response String \(str ?? "NAN")")
        
        
        var dic = [String : Any]()
        dic["TEXT"] = str
        dic["RESPONSE_DATA"] = (NSData.init(data: responseData).description as NSString).trimmingCharacters(in: CharacterSet.init(charactersIn: "<>"))
        complete(dic, nil)
        return
    }
    task.resume()
}
func decodeNumericEntities(_ input: String) -> String {
    let nsMutableString = NSMutableString(string: input)
    CFStringTransform(nsMutableString, nil, "Any-Hex/XML10" as CFString, true)
    return nsMutableString as String
}

