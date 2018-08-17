//
//  News2ViewController.swift
//  SidebarMenu
//
//  Created by kurt warson on 22/11/16.
//  Copyright © 2016 Kurt Warson. All rights reserved.
//

import UIKit

import SystemConfiguration


class News2ViewController: UIViewController, UIScrollViewDelegate {
    
    var feedItems: NSArray = NSArray()
  
    
    var posterSession = URLSession(configuration: URLSessionConfiguration.default)
  
    //   @IBOutlet weak var blueimage: UIImageView!
    
    
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet var Instagram3: UIButton!
    
    
    //    @IBOutlet var celebrating: UITextView!
    
    
    
    @IBOutlet var facebook3: UIButton!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
 
    
    
    @IBOutlet weak var menu10Button: UIBarButtonItem!
    
    
    var blurEffectView: UIVisualEffectView?
    
    
    @IBOutlet weak var revealButton: UIButton!
    
    
    @IBOutlet weak var reveal2Button: UIButton!
    
    
    @IBOutlet weak var reveal3Button: UIButton!
    
    
    @IBAction func ButtonImage(_ sender: UIButton) {
        
        tabBarController?.selectedIndex = 1
    }
    
    
    @IBAction func ButtonImage2(_ sender: UIButton) {
        tabBarController?.selectedIndex = 1
    }
    
    @IBOutlet var roosenLogoImageView: UIImageView!
    
    
    @IBOutlet weak var bottomView: UIView!
    @IBAction func ButtonImage3(_ sender: UIButton) {
        
        tabBarController?.selectedIndex = 1
    }
    
    //@IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    
    //   @IBOutlet weak var greyimage: UIView!
    
    
  
    
    @IBOutlet weak var mainViewHeighr: NSLayoutConstraint!
    
    // Do any additional setup after loading the view.
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func phones(_ sender: Any) {
        
        
        
        let url = URL(string:"tel:003216811841")!
        
        print("Test")
        if UIApplication.shared.canOpenURL(url) {
            
            
            
            if #available(iOS 11.0, *) {
                
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                
                UIApplication.shared.openURL(url as URL)
            }
        } else {
            
            print("Phone not available")
        }
        
    }
    
    
    @IBAction func callToThisNumber(_ sender: UIButton) {
        let url = URL(string:"tel:003216811841")!
        
        print("Test")
        if UIApplication.shared.canOpenURL(url) {
            
            UIApplication.shared.openURL(url)
            
        } else {
            
            print("Phone not available")
            let controller = UIAlertController(title: "Phone not Available", message: "Phone not Available", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            
            controller.addAction(ok)
            
            
            present(controller, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func emailToThisEmail(_ sender: UIButton) {
        print("Test")
        sendEmail()
    }
    
    
    @IBAction func email(_ sender: Any) {
        
        print("Test")
        sendEmail()
    }
    func sendEmail() {
        
        let mailUrl = URL(string: "mailto:" + "peter@roosenfashion.be")!
        
        
        if UIApplication.shared.canOpenURL(mailUrl) {
            
            UIApplication.shared.openURL(mailUrl as URL)
            
        } else {
            
            print("Email setup not available")
            let controller = UIAlertController(title: "Email setup not available", message: "Email setup not available", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            
            controller.addAction(ok)
            
            
            present(controller, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func socialmedia2(_ sender: Any) {
        
        let activityController = UIActivityViewController(activityItems: ["De Roosen Leuven Fashion App: nu beschikbaar op de app store!"], applicationActivities: nil)
        
        
        activityController.excludedActivityTypes = [ UIActivityType.print, UIActivityType.airDrop]
        
        
        
        activityController.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        
        //          activityController.popoverPresentationController?.backgroundColor = UIColor.greenColor()
        
        self.present(activityController, animated: true, completion: nil)
        
        //        activityController.view.backgroundColor = UIColor.lightGrayColor()
        
    }
    
    
    @IBAction func instagram3(_ sender: Any) {
        
        UIApplication.shared.openURL(URL(string: "https://www.instagram.com/explore/locations/497126747/roosen-leuven/")!)
    }
    
    @IBAction func facebook3(_ sender: Any) {
        
        UIApplication.shared.openURL(URL(string: "https://nl-nl.facebook.com/RoosenLeuven/")!)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        self.emailButton.isExclusiveTouch = true
//        self.phoneButton.isExclusiveTouch = true
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: 700)
        print(self.scrollView.contentSize)
        

        
        /*
         //let size = self.bottomView.frame.origin.y + self.bottomView.frame.height + 50.0
         
         let size = self.bottomView.frame.origin.y + self.roosenLogoImageView.frame.origin.y + self.roosenLogoImageView.frame.height + 50.0
         print("roosenLogoImageView Size", size)
         self.scrollView.contentSize = CGSize.init(width: self.view.frame.size.width, height: size)
         
         print("Current Size",self.scrollView.contentSize)
         self.mainViewHeighr.constant = size
         //self.scrollView.canCancelContentTouches = false
         
         
         
         //        if UIDevice.current.userInterfaceIdiom == .pad{
         //scrollViewHeightConstraint.constant = self.view.frame.size.height
         //        }
         */
        
        //        self.maatwerk.text = NSLocalizedString("maatwerk", comment: "")
        
        
        
        //          self.celebrating.text =  NSLocalizedString("celebrating", comment: "")
        //        let locale = Locale.current
        
        
        //        if let countryCodes = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
        
        
        //            print(countryCode)
        //        }  else  {
        //            print("raar")
        //            countryCode.text = "hallo"
        //        }
        
        
        
        
     
        
        
        //        tabBarController?.tabBar.barTintColor = UIColor(hue: 336/360, saturation: 2/100, brightness: 97/100, alpha: 1.0)
        
        
        
   
        
        
        
        
        //        UINavigationBar.appearance().backgroundColor = UIColor.white
        
        
        // Do any additional setup after loading the view, typically from a nib.
        //1
        
        //        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        //        backgroundImage.image = UIImage(named: "grey")
        //        self.view.insertSubview(backgroundImage, at: 0)
        
        //   self.greyimage.backgroundColor = UIColor(patternImage: UIImage(named:"luxury.jpg")!)
        
        
        //         self.blueimage.backgroundColor = UIColor(patternImage: UIImage(named:"HelsenTicker.jpg")!)
        
        //  musicTableView.backgroundView = UIImageView(image: UIImage(named: "helsenmanwoman"))
        
        

//        let time5 = check(time: formatter.date(from: hours)! as NSDate)
        
  
        
        
        //        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        //
        //        blurEffectView = UIVisualEffectView(effect: blurEffect)
        //        blurEffectView?.frame = view.bounds
        //        blueimage.addSubview(blurEffectView!)
        
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        // ViewControllers view ist fully loaded and could present further ViewController
        //Here you could do any other UI operations
        
        print(self.scrollView.contentSize)
        
        //let size = self.bottomView.frame.origin.y + self.bottomView.frame.height + 50.0
        
//        let bottomViewHeight = self.roosenLogoImageView.frame.origin.y + self.roosenLogoImageView.frame.height + 20
//
//        let size1 = self.bottomView.frame.origin.y + bottomViewHeight + 50
//        print("roosenLogoImageView Size", self.bottomView.frame)
//
//        self.scrollView.contentSize = CGSize.init(width: self.view.frame.size.width, height: size1)
//        self.mainViewHeighr.constant = size1
        print("Current Size",self.scrollView.contentSize)
    }
  
}

    
   
    
   

