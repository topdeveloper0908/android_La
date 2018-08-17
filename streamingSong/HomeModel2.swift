//
//  HomeModel.swift
//  ROBarcodeScanner
//
//  Created by kurt warson on 24/04/16.
//  Copyright © 2016 RASCOR International AG. All rights reserved.
//

import Foundation
import SystemConfiguration

protocol HomeModelProtocal2: class {
    func itemsDownloaded2(items: NSArray)
}


class HomeModel2: NSObject, URLSessionDataDelegate {
    
    //properties
    var databasePath = NSString()
    var reachability: Reachability?
    var data : NSMutableData = NSMutableData()
    weak var delegate: HomeModelProtocal2!
    
    //    let urlPath: String = "http://www.starindustry.be/service2.php" //this will be changed to the path where service.php lives
    
    let urlPath: String = "http://www.cocoonplace.com/be/serviceKompasProgramma.php"
    //MARK: Setup Reachability for Network
    override init(){
        super.init()
        setupReachability(nil, useClosures: true)
        startNotifier()
        let dispatchTime = DispatchTime.now() + DispatchTimeInterval.seconds(0)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.stopNotifier()
            self.setupReachability("google.com", useClosures: true)
            self.startNotifier()
            let dispatchTime = DispatchTime.now() + DispatchTimeInterval.seconds(5)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                self.stopNotifier()
                self.setupReachability("invalidhost", useClosures: true)
                self.startNotifier()
            }
        }
    }
    
    func setupReachability(_ hostName: String?, useClosures: Bool) {
        let reachability = hostName == nil ? Reachability() : Reachability(hostname: hostName!)
        self.reachability = reachability
        if useClosures {
            reachability?.whenReachable = { reachability in
                DispatchQueue.main.async {
                }
            }
            reachability?.whenUnreachable = { reachability in
                DispatchQueue.main.async {
                }
            }
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(HomeModel.reachabilityChanged(_:)), name: ReachabilityChangedNotification, object: reachability)
        }
    }
    
    func startNotifier() {
        print("--- start notifier")
        do {
            try reachability?.startNotifier()
        } catch {
            return
        }
    }
    
    func stopNotifier() {
        print("--- stop notifier")
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: nil)
        reachability = nil
    }
    
    @objc func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        if reachability.isReachable {
            print("Reachable")
        } else {
            //            jsonOffline()
            print("Network not reachable")
        }
    }
    
    
    func downloadItems() {
        if (reachability?.isReachable)! {
            
            
            print("Loading data in online mode");
            
            let url: URL = URL(string: urlPath)!
            
            var session: Foundation.URLSession!
            
            let configuration = URLSessionConfiguration.default
            
            session = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
            
            let task = session.dataTask(with: url)
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshMyTableView"), object: nil)
            task.resume()
            print("available");
        }else{
            
            print("Loding data in offline mode")
            //            self.jsonOffline()
        }
    }
    
    
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.data.append(data);
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            print("Failed to download data")
        }else {
            print("Data downloaded")
            //            self.createDB()
            self.parseJSON()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshMyTableView"), object: nil)
            
        }
        
    }
    
    //    func createDB(){
    //
    //        let documents = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    //        let fileURL = documents.appendingPathComponent("starindustry.sqlite")
    //
    //        let database = FMDatabase(path: fileURL.path)
    //
    //        if !(database?.open())! {
    //            print("Unable to open database")
    //            return
    //        }
    //
    //        do {
    //            try database?.executeUpdate("CREATE TABLE IF NOT EXISTS ITEMS (ID INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT, Address TEXT, Latitude TEXT, Longitude TEXT, imagename TEXT, song TEXT)", values: nil)
    //            //            try database.executeUpdate("insert into test (x, y, z) values (?, ?, ?)", values: ["a", "b", "c"])
    //            //            try database.executeUpdate("insert into test (x, y, z) values (?, ?, ?)", values: ["e", "f", "g"])
    //
    //            //            let rs = try database.executeQuery("select x, y, z from test", values: nil)
    //            //            while rs.next() {
    //            //                let x = rs.stringForColumn("x")
    //            //                let y = rs.stringForColumn("y")
    //            //                let z = rs.stringForColumn("z")
    //            //                print("x = \(x); y = \(y); z = \(z)")
    //            //            }
    //        } catch let error as NSError {
    //            print("failed: \(error.localizedDescription)")
    //        }
    //
    //        database?.close()
    //    }
    func parseJSON() {
        
        
        var jsonResult: NSArray = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: self.data as Data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
        } catch let error as NSError {
            print(error)
            
        }
        
        var jsonElement: NSDictionary = NSDictionary()
        let locations: NSMutableArray = NSMutableArray()
        
        let documents = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = documents.appendingPathComponent("starindustry.sqlite")
        
        //        let database = FMDatabase(path: fileURL.path)
        //
        //        if !(database?.open())! {
        //            print("Unable to open database")
        //            return
        //        }
        
        do {
            if(jsonResult.count > 0)
            {
                
                //                try database?.executeUpdate("DELETE FROM ITEMS", values: nil)
                
            }
            
            for i in 0  ..< jsonResult.count
            {
                
                jsonElement = jsonResult[i] as! NSDictionary
                
                let location = LocationModel()
                print(jsonElement)
                location.dag = jsonElement["Dag"] as? String ?? ""
                location.uur = jsonElement["Uur"] as? String ?? ""
                location.programma = jsonElement["Programma"] as? String ?? ""
                location.id = jsonElement["id"] as? Int ?? 0
                locations.add(location)
                
                //                //the following insures none of the JsonElement values are nil through optional binding
                //                if let name = jsonElement["Name"] as? String,
                //                    let address = jsonElement["Address"] as? String,
                //                    let latitude = jsonElement["Latitude"] as? String,
                //                    let longitude = jsonElement["Longitude"] as? String,
                //                    let imagename = jsonElement["imagename"] as? String,
                //
                //                    let song = jsonElement["song"] as? String            {
                //
                //                    location.name = name
                //                    location.address = address
                //                    location.latitude = latitude
                //                    location.longitude = longitude
                //                    location.imagename = imagename
                //                    location.song = song
                //                    locations.add(location)
                //
                //
                //                    //                    try database?.executeUpdate("insert into ITEMS (Name, Address, Latitude, Longitude, imagename, song ) values (?, ?, ?, ?, ?, ?)", values: [name, address, latitude, longitude, imagename, song])
                //
                //                }
                
                
                
            }} catch let error as NSError {
                print("failed: \(error.localizedDescription)")
        }
        
        //        database?.close()
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.delegate.itemsDownloaded2(items: locations)
            
        })
        
    }
    
    //    func jsonOffline() {
    //
    //        let locations: NSMutableArray = NSMutableArray()
    //
    //        let documents = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    //        let fileURL = documents.appendingPathComponent("starindustry.sqlite")
    //
    //        let database = FMDatabase(path: fileURL.path)
    //
    //        if !(database?.open())! {
    //            print("Unable to open database")
    //            return
    //        }
    //
    //        do {
    //
    //            let rs = try database?.executeQuery("select * from Items", values: nil)
    //            while (rs?.next())! {
    //                let name = rs?.string(forColumn: "Name")
    //                let address = rs?.string(forColumn: "Address")
    //                let latitude = rs?.string(forColumn: "Longitude")
    //                let longitude = rs?.string(forColumn: "Longitude")
    //                let imagename = rs?.string(forColumn: "imagename")
    //                let song = rs?.string(forColumn: "song")
    //
    //                let location = LocationModel()
    //
    //                location.name = name
    //                location.address = address
    //                location.latitude = latitude
    //                location.longitude = longitude
    //                location.imagename = imagename
    //                location.song = song
    //
    //                locations.add(location)
    //
    //            }
    //
    //        } catch let error as NSError {
    //            print("failed: \(error.localizedDescription)")
    //        }
    //
    //
    //        database?.close()
    //
    //        DispatchQueue.main.async(execute: { () -> Void in
    //
    //            self.delegate.itemsDownloaded(items: locations)
    //
    //        })
    //    }
    //
    //    deinit {
    //
    //        stopNotifier()
    //}
}

