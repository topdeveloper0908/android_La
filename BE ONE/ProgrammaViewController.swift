//
//  ProgrammaViewController.swift
//  streamingSong
//
//  Created by Kurt Warson on 02/07/2018.
//  Copyright © 2018 Stars. All rights reserved.
//

import UIKit
import SystemConfiguration

class ProgrammaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HomeModelProtocal2 {
    
    
    
    var feedItems2: NSArray = NSArray()
    var feedDic = [String:[LocationModel]]()
    var selectedLocation : LocationModel = LocationModel()
    var locationForSegu : LocationModel = LocationModel()
    
    var keyArrayList:[String] = []
    
    
    
    
    @IBOutlet weak var ProgrammaTableView: UITableView!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProgrammaTableView.rowHeight = 45
        
        self.ProgrammaTableView.delegate = self
        self.ProgrammaTableView.dataSource = self
        
        let homeModel = HomeModel2()
        homeModel.delegate = self
        homeModel.downloadItems()
        
        // Do any additional setup after loading the view.
    }
    
    func itemsDownloaded2(items: NSArray) {
        feedItems2 = items
        if var localArray = feedItems2 as? [LocationModel] {
            localArray = localArray.sorted { (s1, s2) -> Bool in
                return s1.id! < s2.id!
            }
            
            if (!localArray.isEmpty) {
                feedDic = localArray.group(by: { $0.dag! })
            }
            
            
        }
        keyArrayList = Array(feedDic.keys)
        keyArrayList.sort { (s1, s2) -> Bool in
            
            return  self.getDayIdFrom(str: s1.lowercased()) < self.getDayIdFrom(str: s2.lowercased())
            
        }
        
        
        self.ProgrammaTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 60
    }
    
    func getDayIdFrom(str:String) -> Int {
        // maandag, dinsdag, woensdag, donderdag, vrijdag, zaterdag, zondag
        switch str {
        case "maandag":
            return 1
        case "dinsdag":
            return 2
        case "woensdag":
            return 3
        case "donderdag":
            return 4
        case "vrijdag":
            return 5
        case "zaterdag":
            return 6
        case "zondag":
            return 7
        default:
            return 0
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return feedDic.count
        
        //        return 1
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (feedDic.isEmpty){
            return 0
        }
        let key = keyArrayList[section]
        return feedDic[key]!.count
        
        //        return feedItems2.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProgrammaCell", for: indexPath) as! ProgrammaTableViewCell
        
        if (indexPath as NSIndexPath).row % 2 == 0 {
            
            cell.backgroundColor = UIColor(hue: 7/360, saturation: 14/100, brightness: 90/100, alpha: 1.0)
            
            
        }
        else
        {
            cell.backgroundColor = UIColor.white
            
        }
        
        
        //        let new2: LocationModel = self.feedItems2[(indexPath as NSIndexPath).row] as! LocationModel
        let key = keyArrayList[indexPath.section]
        let new2 = feedDic[key]![indexPath.row]
        
     
        cell.uurLabel.text = new2.uur
        cell.programmaLabel.text = new2.programma
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if let view = view as? UITableViewHeaderFooterView {
            
            
            view.textLabel!.textColor = UIColor.white
            view.textLabel!.backgroundColor = UIColor.red
            view.backgroundColor = UIColor.red
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UILabel(frame: CGRect(x: 10, y: 10, width: 200, height: 70))
        headerView.text = self.keyArrayList[section]
        headerView.backgroundColor = UIColor.red
        headerView.textColor = UIColor.white
        return headerView
    }
    
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 50
    //    }
    
    
    @IBAction func back(_ sender: Any) {
        
self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reload2() {
        
        
        
        let homeModel = HomeModel2()
        homeModel.delegate = self
        homeModel.downloadItems()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
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
        self.reload2()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
  
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

extension Sequence {
    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        return Dictionary.init(grouping: self, by: key)
    }
}
