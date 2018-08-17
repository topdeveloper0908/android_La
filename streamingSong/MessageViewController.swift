//
//  MessageViewController.swift
//  streamingSong
//
//  Created by Kurt Warson on 16/06/2018.
//  Copyright © 2018 Stars. All rights reserved.
//

import UIKit
import SystemConfiguration

class MessageViewController: UIViewController {
    
    
    @IBOutlet weak var ProgrammaSchema: UIButton!
    
    @IBOutlet weak var textField: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround2()
        

        
        
        let myColor : UIColor = UIColor.black
        
        textField.layer.borderWidth = 1.5
        textField.layer.borderColor = myColor.cgColor
        // Do any additional setup after loading the view.
     textField.tintColor = UIColor.red   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    if Reachability.shared.isConnectedToNetwork(){
    

    
    print("Connected")
    }
    else
    {
    let controller = UIAlertController(title: "Geen internetverbinding", message: "Zet je wifi of mobiele data aan.", preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    controller.addAction(ok)
    controller.addAction(cancel)
    
    present(controller, animated: true, completion: nil)
    }
        
    }
    
    
    @IBAction func Verstuur(_ sender: Any) {
        
      let userEmail = "kurtwarson@hotmail.com"
        let usertextfield = textField.text
        
        if(usertextfield!.isEmpty)   {

            displayMyAlertMessage(userMessage: "Er is geen tekst ingevuld")


        }  else {

            textField.text = ""

            displayMyAlertMessage(userMessage: "Uw bericht is verzonden")
        
        
         let session = URLSession(configuration: URLSessionConfiguration.default)
        let myUrl = NSURL(string: "https://www.cocoonplace.com/be/userRegisterKompas.php")
        let request = NSMutableURLRequest(url: myUrl! as URL)
        
        let bodyData = "data=\(usertextfield!)&email=\(userEmail)"
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        let task = session.dataTask(with: request as URLRequest)
        
        
        task.resume()
        
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func displayMyAlertMessage(userMessage:String) {
        
        var myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.present(myAlert,   animated: true, completion: nil)
        
        
    }
    
    final class Reachability {
        
        private init () {}
        class var shared: Reachability {
            struct Static {
                static let instance: Reachability = Reachability()
            }
            return Static.instance
        }
        
        func isConnectedToNetwork() -> Bool {
            guard let flags = getFlags() else { return false }
            let isReachable = flags.contains(.reachable)
            let needsConnection = flags.contains(.connectionRequired)
            return (isReachable && !needsConnection)
        }
        
        private func getFlags() -> SCNetworkReachabilityFlags? {
            guard let reachability = ipv4Reachability() ?? ipv6Reachability() else {
                return nil
            }
            var flags = SCNetworkReachabilityFlags()
            if !SCNetworkReachabilityGetFlags(reachability, &flags) {
                return nil
            }
            return flags
        }
        
        private func ipv6Reachability() -> SCNetworkReachability? {
            var zeroAddress = sockaddr_in6()
            zeroAddress.sin6_len = UInt8(MemoryLayout<sockaddr_in>.size)
            zeroAddress.sin6_family = sa_family_t(AF_INET6)
            
            return withUnsafePointer(to: &zeroAddress, {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                    SCNetworkReachabilityCreateWithAddress(nil, $0)
                }
            })
        }
        private func ipv4Reachability() -> SCNetworkReachability? {
            var zeroAddress = sockaddr_in()
            zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
            zeroAddress.sin_family = sa_family_t(AF_INET)
            
            return withUnsafePointer(to: &zeroAddress, {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                    SCNetworkReachabilityCreateWithAddress(nil, $0)
                }
            })
        }
    }
    

}
extension UIViewController {
    func hideKeyboardWhenTappedAround3() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard3))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard3() {
        view.endEditing(true)
    }
}

