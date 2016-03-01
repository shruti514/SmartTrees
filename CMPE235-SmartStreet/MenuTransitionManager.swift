//
//  MenuTransitionManager.swift
//  CMPE235-SmartStreet
//
//  Created by Shrutee Gangras on 2/28/16.
//  Copyright © 2016 Shrutee Gangras. All rights reserved.
//

import UIKit
import UIKit

class MenuTransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    private var presenting = false
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView()
        
        let screens : (from:UIViewController, to:UIViewController) = (transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!, transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)
        
        let menuViewController = !self.presenting ? screens.from as! MenuViewController : screens.to as! MenuViewController
        let bottomViewController = !self.presenting ? screens.to as UIViewController : screens.from as UIViewController
        
        let menuView = menuViewController.view
        let bottomView = bottomViewController.view
        
        if (self.presenting) {
            
            self.offStageMenuController(menuViewController)
            
        }
        
        container!.addSubview(bottomView)
        container!.addSubview(menuView)
        
        let duration = self.transitionDuration(transitionContext)
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
            
            if (self.presenting){
                
                self.onStageMenuController(menuViewController)
                
            } else {
                
                self.offStageMenuController(menuViewController)
                
            }
            
            }, completion: { finished in
                
                transitionContext.completeTransition(true)
                UIApplication.sharedApplication().keyWindow!.addSubview(screens.to.view)
                
        })
        
        
        
    }
    
    
    func offstage(amount: CGFloat) ->CGAffineTransform {
        return CGAffineTransformMakeTranslation(amount, 0)
    }
    
    func offStageMenuController(menuViewController: MenuViewController) {
        
        menuViewController.view.alpha = 0
        
        let topRowOffset  : CGFloat = 300
        let middleRowOffset : CGFloat = 150
        let bottomRowOffset  : CGFloat = 50
        
        menuViewController.aboutButton.transform = self.offstage(-topRowOffset)
        menuViewController.aboutLabel.transform = self.offstage(-topRowOffset)
        
        menuViewController.interactButton.transform = self.offstage(-middleRowOffset)
        menuViewController.interactLabel.transform = self.offstage(-middleRowOffset)
        
        menuViewController.nearbyButton.transform = self.offstage(-bottomRowOffset)
        menuViewController.nearbyLabel.transform = self.offstage(-bottomRowOffset)
        
        menuViewController.photoButton.transform = self.offstage(topRowOffset)
        menuViewController.photoLabel.transform = self.offstage(topRowOffset)
        
        menuViewController.shareButton.transform = self.offstage(middleRowOffset)
        menuViewController.shareLabel.transform = self.offstage(middleRowOffset)
        
        menuViewController.commentButton.transform = self.offstage(bottomRowOffset)
        menuViewController.commentLabel.transform = self.offstage(bottomRowOffset)
        
    }
    
    func onStageMenuController(menuViewController: MenuViewController) {
        
        
        menuViewController.view.alpha = 1
        
        menuViewController.aboutButton.transform = CGAffineTransformIdentity
        menuViewController.aboutLabel.transform = CGAffineTransformIdentity
        menuViewController.interactButton.transform = CGAffineTransformIdentity
        menuViewController.interactLabel.transform = CGAffineTransformIdentity
        menuViewController.nearbyButton.transform = CGAffineTransformIdentity
        menuViewController.nearbyLabel.transform = CGAffineTransformIdentity
        menuViewController.photoButton.transform = CGAffineTransformIdentity
        menuViewController.photoLabel.transform = CGAffineTransformIdentity
        menuViewController.shareButton.transform = CGAffineTransformIdentity
        menuViewController.shareLabel.transform = CGAffineTransformIdentity
        menuViewController.commentButton.transform = CGAffineTransformIdentity
        menuViewController.commentLabel.transform = CGAffineTransformIdentity
        
    }
    
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.presenting = true
        return self
        
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.presenting = false
        return self
    }
    
}

