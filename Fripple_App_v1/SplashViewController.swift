//
//  SplashViewController.swift
//  Fripple_App_v1
//
//  Created by Bob McGinn on 11/21/15.
//  Copyright © 2015 REM Designs. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Parse

class SplashViewController: UIViewController {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityLabel: UILabel!
    var timer = NSTimer()
    var counter = 4
    
    @IBOutlet weak var activityView: UIView!
    
    var soundEffect = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("rippleSound", ofType: "wav")!))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityView.layer.cornerRadius = 10
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        delay(1.0) {
            self.activityIndicator.stopAnimating()
            self.activityLabel.alpha = 0
            self.activityView.alpha = 0
            
            self.soundEffect!.play()
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "doAnimation", userInfo: nil, repeats: true)
        }
        
    }
    
    func doAnimation() {
        
        if counter == 22 {
            logo.image = UIImage(named: "Logo_main_22.png")
            timer.invalidate()
            
            if PFUser.currentUser() != nil {
                
                let container = self.storyboard?.instantiateViewControllerWithIdentifier("ContainerViewController") as! ContainerViewController
                self.presentViewController(container, animated: false, completion: nil)
                
            } else {
                
                let welcome = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! PageViewController
                self.presentViewController(welcome, animated: false, completion: nil)
                
            }
        }
        else {
            counter++
        }
        logo.image = UIImage(named: "Logo_main_\(counter).png")
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
}
