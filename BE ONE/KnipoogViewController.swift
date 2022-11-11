//
//  KnipoogViewController.swift
//  streamingSong
//
//  Created by Kurt Warson on 29/06/2018.
//  Copyright © 2018 Stars. All rights reserved.
//

import UIKit

class KnipoogViewController: UIViewController {
    
    @IBOutlet weak var KnipoogView: UIView!
    
    @IBOutlet weak var Twitch: UIButton!
    
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
   
    
  

    
    @IBAction func TVFMGOUD(_ sender: Any) {
        
        
         UIApplication.shared.openURL(URL(string: "https://www.fmgoud.be/tvgoud.html")!)
    }
    
    
    @IBAction func Twitch2(_ sender: Any) {
        
        UIApplication.shared.openURL(URL(string: "https://soundcloud.com/fmgoud")!)
    }
    
    
    
    @IBAction func twitch(_ sender: Any) {
        //
        UIApplication.shared.openURL(URL(string: "https://soundcloud.com/fmgoud")!)    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
