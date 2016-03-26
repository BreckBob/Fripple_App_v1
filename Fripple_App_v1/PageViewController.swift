//
//  PageViewController.swift
//  Fripple_App_v1
//
//  Created by Bob McGinn on 11/28/15.
//  Copyright © 2015 REM Designs. All rights reserved.
//

import UIKit
import Foundation

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var index = 0
    var identifiers: NSArray = ["WelcomeViewController", "CommandCentralPreviewViewController", "CreateExampleOneViewController", "CreateExampleTwoViewController", "CreateExampleThreeViewController", "ResultsViewController", "CommentsPreviewViewController"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Make this view the datasource and delegate
        self.dataSource = self
        self.delegate = self
        
        //Create array of viewcontrollers for the pageview
        let startingViewController = self.viewControllerAtIndex(self.index)
        let viewControllers = [startingViewController]
        self.setViewControllers(viewControllers as? [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //Layout the pageviews
        let subViews: NSArray = view.subviews
        var scrollView: UIScrollView? = nil
        var pageControl: UIPageControl? = nil
        
        for view in subViews {
            if view.isKindOfClass(UIScrollView) {
                scrollView = view as? UIScrollView
            }
            else if view.isKindOfClass(UIPageControl) {
                pageControl = view as? UIPageControl
                pageControl?.currentPageIndicatorTintColor = UIColor(colorLiteralRed: 98.0/255.0, green: 87.0/255.0, blue: 91.0/255.0, alpha: 1.0)
                pageControl?.pageIndicatorTintColor = UIColor.lightGrayColor()
            }
        }
        
        if (scrollView != nil && pageControl != nil) {
            scrollView?.frame = view.bounds
            view.bringSubviewToFront(pageControl!)
        }
    }
    
    //Handle moving forward in pageview
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let identifier = viewController.restorationIdentifier
        var newIndex = self.identifiers.indexOfObject(identifier!)
        newIndex++
        if(newIndex >= self.identifiers.count) {
            return nil
        }
        return self.viewControllerAtIndex(newIndex)
    }
    
    //Moving backwards in pageview
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let identifier = viewController.restorationIdentifier
        var newIndex = self.identifiers.indexOfObject(identifier!)
        if(newIndex <= 0) {
            return nil
        }
        newIndex--
        return self.viewControllerAtIndex(newIndex)
    }
    
    //Tell view which view controller to insert based on location in array
    func viewControllerAtIndex(index: Int) -> UIViewController! {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        if index == 0 {
            return storyBoard.instantiateViewControllerWithIdentifier("WelcomeViewController")
        }
        
        if index == 1 {
            return storyBoard.instantiateViewControllerWithIdentifier("CommandCentralPreviewViewController")
        }
        
        if index == 2 {
            return storyBoard.instantiateViewControllerWithIdentifier("CreateExampleOneViewController")
        }
        
        if index == 3 {
            return storyBoard.instantiateViewControllerWithIdentifier("CreateExampleTwoViewController")
        }
        
        if index == 4 {
            return storyBoard.instantiateViewControllerWithIdentifier("CreateExampleThreeViewController")
        }
        
        if index == 5 {
            return storyBoard.instantiateViewControllerWithIdentifier("ResultsViewController")
        }
        
        if index == 6 {
            return storyBoard.instantiateViewControllerWithIdentifier("CommentsPreviewViewController")
        }
        return nil
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.identifiers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    

}
