
import Foundation

class EDMApushNotif
{
    
    // Please set here the URL of the register.devicetoken.php script
    let phpRegisterDeviceURL = String("http://www.cocoonplace.com/be/registerkompas.devicetoken.php")
    
    // Private var
    var deviceToken: Data
    
    
    init(token:Data){
        self.deviceToken = token
    }
    
    /*
     register()
     make an http get request to register the device on database trough php
     retun Bool
     */
    func register() -> Bool {
        //Clean the token data and convert in string to pass it to server
        //  let tokenstring = String(describing: self.deviceToken)
        //  print(tokenstring)
        
        
        
        
        
        let tokenstring = self.deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("Decoded: \(tokenstring)")
        
        
        
        let tokenNSS: NSString = NSString(string: tokenstring)
        let tokenUTF8 = tokenNSS.data(using: String.Encoding.utf8.rawValue)!
        let tokenEncoded = tokenUTF8.base64EncodedString(options: [])
        let url = self.phpRegisterDeviceURL + "?device=ios&token=\(tokenEncoded)"
        
        print(url)
        
        var ret: Bool = false
        let nUrl = URL(string: url)
        
        let sem = DispatchSemaphore(value: 0);
        
        let task = URLSession.shared.dataTask(with: nUrl!, completionHandler: { (data, response, error) in
            if(error != nil){
                print("Error in NSURLSession: \(error)")
            }else{
                //print("NSUrlSession passed")
                if data != nil {
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [[String:AnyObject]]
                        //print(jsonResult)
                        
                        let result = jsonResult[0]["response"] as! String
                        print("Result: \(result)")
                        if(result == "success"){
                            ret = true
                        }else{
                            ret = false
                        }
                    } catch {
                        print("i c processing JSON")
                    }
                }
            }
            
            sem.signal();
        })
        task.resume()
        
        _ = sem.wait(timeout: DispatchTime.distantFuture);
        
        return ret
    }
    
}
/* register() make an http get request to register the device on database trough php retun Bool */


