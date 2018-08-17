//
//  ViewController.swift
//  Demo
//
//  Created by Codienix on 25/06/18.
//  Copyright © 2018 Codienix. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import SwiftyJSON

let IS_IPAD = (UI_USER_INTERFACE_IDIOM() == .pad)
let SCREEN_WIDTH = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
let SCREEN_HEIGHT = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) - Tab_Height

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tblView_Images: UITableView!
    var countdownTimer: Timer!
    var isFirstTime = true
    var imgHeight = 210 as CGFloat
    var jsonStr: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblView_Images.separatorColor = UIColor.clear
    }
    
    // --------------------------------- //
    //    Images Table View Delegate     //
    // --------------------------------- //
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return GlobalData.imgUrlArray.count;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(String(indexPath.row) + " Clicked")
        UIApplication.shared.openURL(URL(string: GlobalData.websiteUrlArray[indexPath.row])!)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_image", for: indexPath) as! ImagesTableViewCell
        cell.cell_imgView.kf.setImage(with: URL(string: GlobalData.imgUrlArray[indexPath.row]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return imgHeight
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getImages()
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(getImages)), userInfo: nil, repeats: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.orientationChanged(_:)), name: .UIDeviceOrientationDidChange, object: nil)
    }
    
    @objc func getImages() {
        Alamofire.request("https://cocoonplace.com/be/KompasFotos.php")
            .responseJSON { response in
                guard let object = response.result.value else {
                    print("Oh, no!!!")
                    return
                }
                let json = JSON(object)
                print(json)
                GlobalData.imgUrlArray = []
                GlobalData.websiteUrlArray = []
                self.jsonStr = ""
                for playList in json.array!{
                    GlobalData.imgUrlArray.append(playList["afbeelding"].stringValue)
                    GlobalData.websiteUrlArray.append(playList["url"].stringValue)
                    self.jsonStr = self.jsonStr! + playList["afbeelding"].stringValue
                }
                
                if (GlobalData.jsonStr != self.jsonStr) {
                    GlobalData.jsonStr = self.jsonStr
                    
                    print(GlobalData.imgUrlArray.count)
                    self.imgHeight = SCREEN_WIDTH*200/300
                    self.tblView_Images.delegate = self
                    self.tblView_Images.dataSource = self
                    self.tblView_Images.separatorStyle = .none
                    
                    if (GlobalData.imgUrlArray.count != 0) {
                        self.tblView_Images.reloadData()
                    }
                }
        }
    }

    @objc func orientationChanged(_ notification: Notification?) {
        adjustViews(for: UIApplication.shared.statusBarOrientation)
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .all
    }

    func adjustViews(for orientation: UIInterfaceOrientation) {
        var height = 0 as CGFloat
        if IS_IPAD && !isFirstTime {
            if (orientation == .portrait || orientation == .portraitUpsideDown) {
                height = (SCREEN_WIDTH)*200/300
            } else {
                height = SCREEN_WIDTH*200/300

            }
        } else { // iphone
            isFirstTime = false
            if (orientation == .portrait || orientation == .portraitUpsideDown) {
                height = SCREEN_WIDTH*200/300
            } else {
                height = (SCREEN_WIDTH)*200/300
            }
        }

        if (imgHeight != height) {
            imgHeight = height
            self.tblView_Images.delegate = self
            self.tblView_Images.dataSource = self
            self.tblView_Images.separatorStyle = .none
            
            if (GlobalData.imgUrlArray.count != 0) {
                self.tblView_Images.reloadData()
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if countdownTimer != nil {
            countdownTimer.invalidate()
            countdownTimer = nil
        }
        NotificationCenter.default.removeObserver(self, name: .UIDeviceOrientationDidChange, object: nil)
    }
    
}

