//
//  ViewController.swift
//  streamingSong
//
//  Created by Stars on 5/6/18.
//  Copyright © 2018 Stars. All rights reserved.
//

import UIKit
import AVFoundation
import SystemConfiguration
import FRadioPlayer
import MediaPlayer
import  CoreTelephony

class ScrollViewController: UIViewController,FRadioPlayerDelegate{
    var playTime = 0
    let timerInterval: TimeInterval = 60
    func radioPlayer(_ player: FRadioPlayer, playerStateDidChange state: FRadioPlayerState) {
        
        if playflag{
            if player.rate == 0{
                player.play()
            }
            if reachability.isReachableViaWiFi || reachability.isReachableViaWWAN{
                if timeField.text != ""{
                    let time = Int(timeField.text!) ?? 0
                    self.playTime = time
                    if(self.timer == nil) {
                        self.timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: true)
                    }
                }
            }else{
                stopTimer1()
            }
        }
    }
    
    func radioPlayer(_ player: FRadioPlayer, playbackStateDidChange state: FRadioPlaybackState) {
        if playflag{
            if player.rate == 0{
                player.play()
            }
        }
    }
    
    func stopTimer1(){
        playflag = false
        if timer != nil{
            timer?.invalidate()
            timer = nil
        }
    }
    
    
    weak var delegate: FRadioPlayerDelegate?
    
    //*****************************************************************
    // MARK: - IB UI
    //*****************************************************************
    
    @IBOutlet weak var parsedTextResultLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var facebook3: UIButton!
    @IBOutlet weak var play3Button3: UIButton!
    @IBOutlet weak var phonebutton: UIButton!
    @IBOutlet weak var AantalLabel: UILabel!
    @IBOutlet weak var emailbutton: UIButton!
    @IBOutlet weak var timeField: UITextField!
    
    @IBOutlet weak var socialmedia: UIView!
    
    @IBOutlet weak var stopButton: UIButton!
    
    //*****************************************************************
    // MARK: - Properties
    //*****************************************************************
    
    var playflag = Bool()
    var timerCount = 5
    var timer2 : Timer?
    var date = Date()
    var songName : String?
    var formatter : DateFormatter?
    var player: FRadioPlayer = FRadioPlayer.shared
    
    
    
    //    var player : AVPlayer!
    //var playerItem : AVPlayerItem!
    var timer : Timer?
    var timePicker = UIPickerView()
    var pickerdata = ["2","15","30","45","60","75","90","105","120"]
    var reachability = Reachability()!
    var countdownTimer: Timer!
    //*****************************************************************
    // MARK: -  ViewDidLoad / Life cycle
    //*****************************************************************
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myColor = UIColor(hue: 353/360, saturation: 100/100, brightness: 73/100, alpha: 1.0)
        
        stopButton.layer.borderWidth = 1.0
        stopButton.layer.borderColor = myColor.cgColor
        
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        // 2. check the idiom
        switch (deviceIdiom) {
        case .pad:
            TimeLabel.font = TimeLabel.font.withSize(20.0)
            parsedTextResultLabel.font =
                parsedTextResultLabel.font.withSize(20.0)
            AantalLabel.font = AantalLabel.font.withSize(16.0)
        case .phone:
            TimeLabel.font = TimeLabel.font.withSize(17.0)
            
        default:
            print("Unspecified UI idiom")
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = NSTimeZone(name: "GMT") as TimeZone!
        
        let date = Date()
        let calendar = Calendar.current
        print(date)
        print(calendar)
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        print("hours = \(hour):\(minutes):\(seconds)")
        
        let strHours = String(format: "%02d", hour)
        let strMinutes = String(format: "%02d", minutes)
        
        let hours = strHours + ":" + strMinutes
        let time5 = check(time: formatter.date(from: hours)! as NSDate)
        
        TimeLabel.text = time5
        
        //Radio Player
        
        //        player = FRadioPlayer.shared
        player.delegate = self
        let url = URL(string: "http://mediaserv33.live-streams.nl:8052/")
        play3Button3!.setTitle("Play", for: UIControlState.normal)
        player.radioURL = url
        player.isAutoPlay = false
        
        setupRemoteTransportControls()
        //        do {
        //            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
        //            print("Playback OK")
        //            try AVAudioSession.sharedInstance().setActive(true)
        //            print("Session is Active")
        //        } catch {
        //            print(error)
        //        }
        
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            print("AVAudioSession Category Playback OK")
            //            do {
            //                try AVAudioSession.sharedInstance().setActive(true)
            //                print("AVAudioSession is Active")
            //            } catch let error as NSError {
            //                print(error.localizedDescription)
            //            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        //
//        NotificationCenter.default.addObserver(self, selector: #selector(internetChanged), name: ReachabilityChangedNotification, object: reachability)
        
        
        timePicker.dataSource = self
        timePicker.delegate = self
        self.hideKeyboardWhenTappedAround2()
        
        self.btnRefreshSelect(nil)
        NotificationCenter.default.addObserver(self, selector: #selector(internetChanged), name: ReachabilityChangedNotification, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("Could not start notification")
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        datePickerSet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if countdownTimer != nil {
            countdownTimer.invalidate()
            countdownTimer = nil
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        /*if Reachability.shared.isConnectedToNetwork(){
         
         print("Connected")
         }
         else
         {
         
         let controller = UIAlertController(title: "Geen internetverbinding", message: "Put on your mobile data or wifi", preferredStyle: .alert)
         let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
         let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
         
         controller.addAction(ok)
         controller.addAction(cancel)
         
         present(controller, animated: true, completion: nil)
         }*/
        
    }
    
    //*****************************************************************
    // MARK: - Button Action
    //*****************************************************************
    
    
    @IBAction func facebook3(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "https://www.facebook.com/radiokompas.eu/")!)
    }
    
    
    @IBAction func phone(_ sender: Any) {
        let url = URL(string:"tel:0032495202856")!
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
    
    @IBAction func email(_ sender: Any) {
        sendEmail()
    }
    
    
    
    func sendEmail() {
        
        let mailUrl = URL(string: "mailto:" + "studio@radiokompas.eu")!
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
    
    
    
    @objc func internetChanged(note : Notification){
        
        let reachability = note.object as! Reachability
        //        if reachability.isReachable{
        //            if reachability.isReachableViaWiFi{
        if playflag{
            if !player.isPlaying{
                player.play()
            }
            //                }
            //            }
        }
    }
    
    @IBAction func onReset(_ sender: Any) {
        //
        //            playflag = false
        //            player.stop()
        //            play3Button3!.setTitle("Play", for: UIControlState.normal)
        stopTimer1()
        timeField.text = ""
        
    }
    
    @IBAction func playButton(_ sender: Any) {
        
        if reachability.isReachable{
            if reachability.isReachableViaWiFi || reachability.isReachableViaWWAN{
                
                if !player.isPlaying
                {
                    let session = AVAudioSession.sharedInstance()
                    do{
                        try session.setCategory(AVAudioSessionCategoryPlayback)
                    }catch{
                        print("error")
                    }
                    playflag = true
                    player.play()
                    play3Button3!.setTitle("Stop", for: UIControlState.normal)
                    countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(checkPhoneCall)), userInfo: nil, repeats: true)
                    if timeField.text != ""{
                        let time = Int(timeField.text!) ?? 0
                        self.playTime = time
                        self.timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: true)
                    }
                } else {
                    playflag = false
                    player.stop()
                    if countdownTimer != nil {
                        countdownTimer.invalidate()
                        countdownTimer = nil
                    }
                    play3Button3!.setTitle("Play", for: UIControlState.normal)
                    stopTimer1()
                }
            }
        }
        //                if player.rate == 0
        //                {
        //                                let session = AVAudioSession.sharedInstance()
        //                                do{
        //                                    try session.setCategory(AVAudioSessionCategoryPlayback)
        //                                }catch{
        //                                    print("error")
        //                                }
        //                    playflag = true
        //                    player.play()
        //                    play3Button3!.setTitle("Stop", for: UIControlState.normal)
        //                    if timeField.text != ""{
        //                        let time = Double(timeField.text!)
        //                        self.timer = Timer.scheduledTimer(timeInterval: time!*60, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: true)
        //                    }
        //                } else {
        //                    playflag = false
        //                    player.pause()
        //                    play3Button3!.setTitle("Play", for: UIControlState.normal)
        //                    timer.invalidate()
        //                }
        
        
    }
    
    @objc func checkPhoneCall() {
        print("is on call", isOnPhoneCall())
        switch isOnPhoneCall()
        {
        case true:
            print("on phone call")
            player.stop()
        case false:
            print("no phone call")
            player.play()
        default: break
            print("done")
        }
    }
    private func isOnPhoneCall() -> Bool
    {
        let callCntr = CTCallCenter()
        
        if let calls = callCntr.currentCalls
        {
            for call in calls
            {
                if call.callState == CTCallStateConnected || call.callState == CTCallStateDialing || call.callState == CTCallStateIncoming
                {
                    print("In call")
                    return true
                }
            }
        }
        
        print("No calls")
        return false
    }
    
    //*****************************************************************
    // MARK: - Timer Function
    //*****************************************************************
    
    func check(time: NSDate) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        //    formatter.timeZone = NSTimeZone(name: "GMT") as TimeZone!
        guard let
            beginNight = formatter.date(from:"08:00"),
            let beginNoon = formatter.date(from: "13:00"),
            let beginAfternoon = formatter.date(from: "19:00"),
            let beginEvening = formatter.date(from: "23:59")
            else { return nil }
        if time.compare(beginNight) == .orderedAscending { return "Goedenacht" }
        if time.compare(beginNoon) == .orderedAscending { return "Goedemorgen!" }
        if time.compare(beginAfternoon) == .orderedAscending { return "Prettige namiddag" }
        if time.compare(beginEvening) == .orderedAscending { return "Goedenavond" }
        return "Goedenacht, welterusten"
    }
    
    func datePickerSet(){
        // set date picker
        self.timeField.inputView = timePicker
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        toolbar.tintColor = UIColor.black
      
        let doneButton = UIBarButtonItem(title: "START", style: .bordered, target: self, action: #selector(onDonebutton))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([space, doneButton], animated: true)
        self.timeField.inputAccessoryView = toolbar
        
    }
    
    @objc func onDonebutton(){
        if timeField.text == ""{
            timeField.text = "2"
        }
        
        if(player.isPlaying){
            stopTimer1()
            if(self.timer == nil) {
                self.playTime = Int(timeField.text!) ?? 0
                self.timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: true)
            }
        }
        self.view.endEditing(true)
    }
    
    @objc func timerFunction(){
        playTime = playTime - 1
        timeField.text = "\(playTime)"
        if(playTime <= 0) {
            timeField.text = ""
            print("working timer")
            //            player.pause()
            player.stop()
            if countdownTimer != nil {
                countdownTimer.invalidate()
                countdownTimer = nil
            }
            play3Button3!.setTitle("Play", for: UIControlState.normal)
            stopTimer1()
        }
    }
    
    @IBAction func btnRefreshSelect(_ sender: UIButton?) {
        timerCount = 5
        //        retryingSecLabel.text = "Retrying..."
        stopTimer()
        makeGetCall { (dic, errorDesc) in
            print("DIC \(dic ?? ["EMPTY" : "EMPTY"])")
            print("ERROR DESC \(errorDesc ?? "NAN")")
            
            // Display on UI
            self.setUIFor(dic: dic, errorDesc: errorDesc)
            //            self.showHideCoverView(show: false)
            self.startTimer()
        }
    }
    
    func stopTimer() {
        if timer2 != nil{
            timer2?.invalidate()
            timer2 = nil
        }
    }
    func startTimer() {
        stopTimer()
        
        timer2 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
    }
    @objc func updateTimer() {
        timerCount -= 1
        //        retryingSecLabel.text = "Retrying in \(timerCount)"
        if timerCount <= 0{
            self.btnRefreshSelect(nil)
        }
    }
    
    func getCurrentDate() -> String? {
        if formatter == nil{
            formatter = DateFormatter()
            formatter?.locale = Locale.current
            formatter?.dateStyle = .medium
            formatter?.timeStyle = .medium
            formatter?.timeZone = TimeZone.current
        }
        
        let string = formatter?.string(from: Date())
        return string;
    }
    
    func setUIFor(dic : [String : Any]?, errorDesc : String?) {
        if let errorDesc = errorDesc {
            //            resultTextView.text = errorDesc
            //            parsedTextStaticLabel.text = "Error Found:"
            parsedTextResultLabel.text = "U bent momenteel offline."
        }else{
            //            resultTextView.text = (dic!["RESPONSE_DATA"] as? String) ?? ""
            let song = (dic!["TEXT"] as? String) ?? ""
            if !String.checkEmpty(song), songName != song{
                songName = song
                let dateText = getCurrentDate()
                //                parsedTextStaticLabel.text = ((dateText ?? "").count > 0) ? "Updated Text: on \(dateText!)" : "Updated Text:"
            }
            parsedTextResultLabel.text = (dic!["TEXT"] as? String) ?? ""
        }
    }
    
    
}

// MARK: - extension UIViewController/String/ScrollViewController
//*****************************************************************

extension UIViewController {
    func hideKeyboardWhenTappedAround2() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard2))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard2() {
        view.endEditing(true)
    }
}
extension String {
    static func checkEmpty(_ string : String?) -> Bool {
        return (string ?? "").isEmpty
    }
}
extension ScrollViewController : UIPickerViewDataSource, UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerdata.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerdata[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.timeField.text = pickerdata[row]
        if(player.isPlaying){
            stopTimer1()
            if(self.timer == nil) {
                self.playTime = Int(pickerdata[row]) ?? 0
                self.timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: true)
            }
        }
    }
    
    /*final class Reachability {
     
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
     }*/
}

// MARK: - Remote Controls / Lock screen

extension ScrollViewController {
    
    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            
            //            if self.player.rate == 0.0 {
            //                self.player.play()
            //                return .success
            //            }
            if !self.player.isPlaying {
                self.player.play()
                return .success
            }
            return .commandFailed
        }
        
        //        // Add handler for Pause Command
        //        commandCenter.pauseCommand.addTarget { [unowned self] event in
        //
        //            if self.player.isPlaying {
        //                self.player.pause()
        //                return .success
        //            }
        //            return .commandFailed
        //        }
        
        
    }
    
    //    func updateNowPlaying(with track: Track?) {
    //
    //        // Define Now Playing Info
    //        var nowPlayingInfo = [String : Any]()
    //
    //        if let artist = track?.artist {
    //            nowPlayingInfo[MPMediaItemPropertyArtist] = artist
    //        }
    //
    //        nowPlayingInfo[MPMediaItemPropertyTitle] = track?.name ?? stations[selectedIndex].name
    //
    //        if let image = track?.image ?? stations[selectedIndex].image {
    //            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: image)
    //        }
    //
    //        // Set the metadata
    //        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    //    }
}
