//
//  ContainerViewController.swift
//  Fripple_App_v1
//
//  Created by Bob McGinn on 11/28/15.
//  Copyright © 2015 REM Designs. All rights reserved.
//

import UIKit
import QuartzCore

class ContainerViewController: UIViewController {
    
    @IBOutlet weak var mainContainer: UIView!
    var currentState = String()
    
    override func viewDidAppear(animated: Bool) {
        currentState = "BothCollapsed"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Notifications to listen for left/right swipes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ContainerViewController.toggleMenuLeft), name: "toggleMenuLeft", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ContainerViewController.swipedRight), name: "swipedRight", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ContainerViewController.swipedLeft), name: "swipedLeft", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Cleanup notifications added in viewDidLoad
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func toggleMenuLeft(){
        let notAlreadyExpanded = (currentState != "LeftPanelExpanded")
        
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func animateLeftPanel(shouldExpand shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = "LeftPanelExpanded"
            
            let menuView = MenuTableViewController()
            UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.mainContainer.frame.origin.x += menuView.view.frame.width/2
                }, completion: nil)
        }
        else {
            let menuView = MenuTableViewController()
            UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.mainContainer.frame.origin.x -= menuView.view.frame.width/2
                }, completion: nil)
            currentState = "BothCollapsed"
        }
    }
    
    func swipedRight() {
        if currentState == "BothCollapsed" {
            let menuView = MenuTableViewController()
            UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.mainContainer.frame.origin.x += menuView.view.frame.width/2
                }, completion: nil)
            currentState = "LeftPanelExpanded"
        }
        if currentState == "LeftPanelExpanded" {
            //Do nothing
        }
    }
    
    func swipedLeft() {
        if currentState == "LeftPanelExpanded" {
            let menuView = MenuTableViewController()
            UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.mainContainer.frame.origin.x -= menuView.view.frame.width/2
                }, completion: nil)
            currentState = "BothCollapsed"
        }
        if currentState == "RightPanelExpanded" {
            //Do nothing
        }
    }

}
