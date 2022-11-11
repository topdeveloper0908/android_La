//
//  TabBarController.swift
//  streamingSong
//
//  Created by Kurt Warson on 17/08/2018.
//  Copyright © 2018 Stars. All rights reserved.
//

import UIKit

class TabBarController:UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = .black
        self.tabBar.barTintColor = .white
        if #available(iOS 10.0, *) {
            self.tabBar.unselectedItemTintColor = .black
        } else {
            
        }
        self.addTabs()
    }
    
    private func addTabs(){
//        let tabBarOne = Controller.scrollView.vc //Later Instantiate your actual viewcontroller
//        let navOne = UINavigationController(rootViewController: tabBarOne)
//        navOne.tabBarItem = createTabBarWithItems(" ", tabIcoName: "icons8-loudspeaker-filled-28")
        
        let tabBarOne = Controller.scrollView.vc //Later Instantiate your actual viewcontroller
        
        tabBarOne.tabBarItem = createTabBarWithItems("Home", tabIcoName: "icons8-speaker-27.png")
        
        let tabBarTwo = Controller.messageView.vc //Later Instantiate your actual viewcontroller
      
        tabBarTwo.tabBarItem = createTabBarWithItems("Bericht versturen en programma", tabIcoName: "icons8-sms-28")
        
        let tabBarThree = Controller.newsView.vc //Later Instantiate your actual viewcontroller
       
        tabBarThree.tabBarItem = createTabBarWithItems("uitzending herbeluisteren", tabIcoName: "icons8-headset-28")
        
        let tabBarFour = Controller.knipoogView.vc //Later Instantiate your actual viewcontroller
        
        tabBarFour.tabBarItem = createTabBarWithItems("Video streaming", tabIcoName: "icons8-tv-show-filled-28")
        
//        let tabBarFive = Controller.viewController.vc //Later Instantiate your actual viewcontroller
//
//        tabBarFive.tabBarItem = createTabBarWithItems("Advertenties", tabIcoName: "icons8-news-28-2")
        
        self.viewControllers = [tabBarOne,tabBarThree,tabBarFour,tabBarTwo]
    }
    
    private func createTabBarWithItems(_ title:String, tabIcoName:String) -> UITabBarItem{
        let image = UIImage(named: tabIcoName)
       let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: image)
        tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.clear], for: .normal)
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        return tabBarItem
    }
    
}
