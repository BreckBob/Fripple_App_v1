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
    var identifiers: NSArray = ["WelcomeViewController", "CreateExampleOneViewController", "CreateExampleTwoViewController", "CreateExampleThreeViewController", "ResultsViewController"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
        
        let startingViewController = self.viewControllerAtIndex(self.index)
        let viewControllers: NSArray = [startingViewController]
        self.setViewControllers(viewControllers as? [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let identifier = viewController.restorationIdentifier
        var newIndex = self.identifiers.indexOfObject(identifier!)
        newIndex++
        if(newIndex >= self.identifiers.count) {
            return nil
        }
        return self.viewControllerAtIndex(newIndex)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let identifier = viewController.restorationIdentifier
        var newIndex = self.identifiers.indexOfObject(identifier!)
        if(newIndex <= 0) {
            return nil
        }
        newIndex--
        return self.viewControllerAtIndex(newIndex)
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController! {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        if index == 0 {
            return storyBoard.instantiateViewControllerWithIdentifier("WelcomeViewController")
        }
        
        if index == 1 {
            return storyBoard.instantiateViewControllerWithIdentifier("CreateExampleOneViewController")
        }
        
        if index == 2 {
            return storyBoard.instantiateViewControllerWithIdentifier("CreateExampleTwoViewController")
        }
        
        if index == 3 {
            return storyBoard.instantiateViewControllerWithIdentifier("CreateExampleThreeViewController")
        }
        
        if index == 4 {
            return storyBoard.instantiateViewControllerWithIdentifier("ResultsViewController")
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
