//
//  NewsViewController.swift
//  starIndustry
//
//  Created by kurt warson on 09/03/16.
//  Copyright © 2016 kurt warson. All rights reserved.
//

import UIKit
import SystemConfiguration

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HomeModelProtocal {
    
    
    
    var feedItems: NSArray = NSArray()
    var selectedLocation : LocationModel = LocationModel()
    var locationForSegu : LocationModel = LocationModel()
    
    
    @IBOutlet weak var newsTableView: UITableView!
    
    
    // let bandmanager = BandManager.sharedmanager
    
    var posterSession = URLSession(configuration: URLSessionConfiguration.default)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       newsTableView.backgroundView = UIImageView(image: UIImage(named: "blankenberge"))
        
        self.newsTableView
            .tableFooterView = UIView()
   
        
        self.newsTableView.delegate = self
        self.newsTableView.dataSource = self
        
        let homeModel = HomeModel()
        homeModel.delegate = self
        homeModel.downloadItems()
        
        
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(UIApplicationDelegate.applicationDidBecomeActive(_:)),
//            name: NSNotification.Name.UIApplicationDidBecomeActive,
//            object: nil)
        
//        navigationController!.navigationBar.barTintColor = UIColor(hue: 0.9972, saturation: 0.77, brightness: 0.02, alpha: 1.0)
//        navigationController!.navigationBar.tintColor = UIColor.black
        
        
//        newsTableView.backgroundView = UIImageView(image: UIImage(named: "80"))
        // starindustryImage!.image = UIImage(named: "starindustrys")
        
        
          
        
//        newsTableView.backgroundColor = UIColor.gray
        
        // Do any additional setup after loading the view.
        
        //newsTableView.rowHeight = UITableViewAutomaticDimension
        //newsTableView.estimatedRowHeight = 300
    }
    
    //    func applicationDidBecomeActive(notification: NSNotification) {
    //
    //        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    //
    //        if let tabBarController = appDel.window?.rootViewController as? UITabBarController,
    //            viewControllers = tabBarController.viewControllers  {
    //            for viewController in viewControllers {
    //
    //                if let fetchViewController = viewController as? UINavigationController {
    //
    //                    let fetchVC = fetchViewController.viewControllers[0] as? NewsViewController
    //                    fetchVC!.reload()
    //                    print ("finished")
    //
    //
    //                    print(self.tabBarController!.viewControllers)
    //
    //                }
    //                else
    //                {
    //
    //                }
    //
    //            }
    //        }
    //    }
    func applicationDidBecomeActive(_ notification: Notification) {
        
        let appDel = UIApplication.shared.delegate as! AppDelegate
        
        if let tabBarController = appDel.window?.rootViewController as? UITabBarController,
            let viewControllers = tabBarController.viewControllers  {
            for nav in viewControllers {
                
                // TabBar - > NavigationController
                
                if let navigationController = nav as? UINavigationController {
                    
                    // Navigation - > ViewControllers
                    for vcontrol in navigationController.viewControllers
                    {
                        // check to avoid crash
                        if vcontrol.isKind(of: NewsViewController.self) {
                            
                            let vc = vcontrol as! NewsViewController
                            vc.reload()
                        }
                    }
                    
                }
                else
                {
                    
                }
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if Reachability.shared.isConnectedToNetwork(){
            
   
            
            print("Connected")
        }
        else
        {
            let controller = UIAlertController(title: "Geen internetverbinding", message: "Zet je wifi of mobiele data aan", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            controller.addAction(ok)
            controller.addAction(cancel)
            
            present(controller, animated: true, completion: nil)
        }
        
        self.reload()
    }
    
    func reload() {
        
        
        
        let homeModel = HomeModel()
        homeModel.delegate = self
        homeModel.downloadItems()
        
    }
    
    
    func itemsDownloaded(items: NSArray) {
        
        
        feedItems = items
        self.newsTableView.reloadData()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return feedItems.count  //bandmanager.news.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat
    {
        return 15.0;//Choose your custom row height
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath) as! ReplayTableViewCell
        
        // Configure the cell...
        //        let backgroundView = UIView()
        //
        if (indexPath as NSIndexPath).row % 2 == 0 {
            
            cell.backgroundColor = UIColor(hue: 208/360, saturation: 98/100, brightness: 5/100, alpha: 0.7)
            
            
        }
        else
        {
            cell.backgroundColor = UIColor(hue: 202/360, saturation: 79/100, brightness: 12/100, alpha: 0.7)
            
        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(hue: 202/360, saturation: 79/100, brightness: 12/100, alpha: 0.4)
//        newsTableView.separatorColor = UIColor.blue
        cell.selectedBackgroundView = backgroundView
        
        let new: LocationModel = self.feedItems[(indexPath as NSIndexPath).row] as! LocationModel
        //let new = self.bandmanager.news[indexPath.row]
        
        //        cell.newsLabel.text = new.name
        cell.newsLabel.text = "PLAY"
        cell.newsLabel.tag = indexPath.row
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapNewsLabel(sender:)))
        cell.newsLabel.isUserInteractionEnabled = true
        cell.newsLabel.addGestureRecognizer(tap)
        
        
        cell.timeLabel.text = new.datum
        
        cell.time2Label.text = new.beschrijving
        
       
        //heel deze code toevoegen voor foto!!
//        let urlString = new.imagename
//        
//        let myString: String = new.imagename!
//        let myStringArr:NSArray = myString.components(separatedBy: "/") as! [String] as NSArray
//        
//        print(myStringArr.lastObject)
//        
//        let  imageNameStr  = myStringArr.lastObject as! String
//        
//        let getImagePath = getDocumentsDirectory().appendingPathComponent(imageNameStr)
//        
//        let checkValidation = FileManager.default
//        
//        if (checkValidation.fileExists(atPath: getImagePath))
//        {
//            // print("FILE AVAILABLE");
//            
//            let getImagePath = getDocumentsDirectory().appendingPathComponent(imageNameStr)
//            
//            
//            
//            cell.imageView?.image = UIImage(contentsOfFile: getImagePath)
//        }
//        else
//        {
//            // print("FILE NOT AVAILABLE");
//            
//            
//            cell.imageView?.image = UIImage(contentsOfFile: getImagePath)
//            
//            if let url = URL(string: urlString!)  {
//                
//                let task_ = posterSession.dataTask(with: url, completionHandler: { (data, response, error) in
//                    
//                    if let data = data {
//                        
//                        DispatchQueue.main.async(execute: {
//                            
//                            if let cell = tableView.cellForRow(at: indexPath)  {
//                                
//                                cell.imageView?.image = UIImage(data: data)
//                                cell.setNeedsLayout()   //  past image aan aan de cell, anders heel klein fotootje
//                                
//                                let filename = self.getDocumentsDirectory().appendingPathComponent(imageNameStr)
//                                
//                                if  (try? data.write(to: URL(fileURLWithPath: filename), options: [])) != nil
//                                {
//                                    print("success");
//                                }else
//                                {
//                                    print("fail");
//                                }
//                                
//                            }
//                        })
//                        
//                    }
//                    
//                })
//                
//                task_.resume()
//                
//            }
//        }
//        
//        
        
        return cell
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @objc func tapNewsLabel(sender : UITapGestureRecognizer) {
        if let newsLabel = sender.view as? UILabel{
            
            let tag = newsLabel.tag
            let new: LocationModel = self.feedItems[tag] as! LocationModel
            print("\(new.name)")
            if let urlStr = new.name{
                if let url = URL(string: urlStr){
                    UIApplication.shared.openURL(url)
                }
            }
        }
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

