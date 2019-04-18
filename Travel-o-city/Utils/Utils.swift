//
//  Utils.swift
//  POS-Native
//
//  Created by intersoft-kansal on 27/11/17.
//  Copyright © 2017 intersoft-kansal. All rights reserved.
//

import Foundation
import UIKit
//import FirebaseAuth


typealias AlertHandler = () -> ()
//MARK: Alert Functions
typealias ActionDone = (_ action: Bool) -> ()
typealias Completed = () -> ()
typealias InputAlerthandler = (_ inputString: String) -> ()


class Utils: NSObject
{
    class func showAlert(_ title: String, _ message : String, _ onVC : UIViewController?)
    {
        Utils.showAlert(title, "OK", message, onVC, nil)
    }
    
    class func showAlert(_ title: String, _ buttonTitle: String, _ message : String, _ onVC : UIViewController?, _ completed: Completed?)
    {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: { _ in
            if completed != nil
            {
                completed!()
            }
        }))
        
        self.present(alert, onVC: onVC)
    }
    
    class func showConfirmAlert(_ title: String, _ message : String, _ okTitle: String, _ cancelTitle: String, eventHandler: @escaping ActionDone,  _ onVC : UIViewController?)
    {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        if okTitle.count > 0
        {
            alert.addAction(UIAlertAction.init(title: okTitle, style: .default, handler: { (response) in
                eventHandler(true)
            }))
        }
        
        if cancelTitle.count > 0
        {
            alert.addAction(UIAlertAction.init(title: cancelTitle, style: .default, handler: { (response) in
                eventHandler(false)
            }))
        }
        
        self.present(alert, onVC: onVC)
    }
    
    private class func present(_ alert: UIAlertController, onVC: UIViewController?)
    {
        if onVC != nil
        {
            onVC?.present(alert, animated: true, completion: nil)
        }
        else
        {
            print("Presenting VC not found")
            AppDelegate.sharedDelegate().window?.inputViewController?.present(alert, animated: true, completion: nil)
        }
    }

    /// Navigation Bar Methods
    
    class func setNavigationBarWithVC(_ vc: UIViewController, withTitle titleStr: String, withLeftBarButton letBarBtn: UIBarButtonItem?, rigBarBtn: RightBarBtn?)
    {
        vc.navigationController?.navigationBar.tintColor = UIColor.white
        vc.navigationController?.navigationBar.barTintColor = UIColor.init(red: 217/255.0, green: 25/255.0, blue: 68/255.0, alpha: 1.0)
        vc.navigationController?.view.backgroundColor = UIColor.init(red: 217/255.0, green: 25/255.0, blue: 68/255.0, alpha: 1.0)
        vc.navigationController?.isNavigationBarHidden = false
        vc.navigationItem.title = titleStr
        vc.navigationItem.leftBarButtonItem = letBarBtn
        if letBarBtn != nil
        {
            vc.navigationItem.leftBarButtonItem?.isEnabled = true
        }
        else
        {
            vc.navigationItem.hidesBackButton = true
            vc.navigationItem.leftBarButtonItem?.isEnabled = false
        }
        
        if rigBarBtn != nil
        {
            let btn : UIBarButtonItem = Utils.barItemWithView(view: rigBarBtn!, rect: CGRect(x: 0, y: 0, width: 35, height: 35))
            vc.navigationItem.rightBarButtonItem = btn
        }
        
        vc.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19)]
    }
    
    class func setNavigationBarWithVC1(_ vc: UIViewController, withTitle titleStr: String, withLeftBarButton letBarBtn: [UIBarButtonItem], rigBarBtn: [UIBarButtonItem])
    {
        vc.navigationController?.navigationBar.tintColor = UIColor.white
        vc.navigationController?.navigationBar.barTintColor = UIColor.init(red: 217/255.0, green: 25/255.0, blue: 68/255.0, alpha: 1.0)
        vc.navigationController?.view.backgroundColor = UIColor.init(red: 217/255.0, green: 25/255.0, blue: 68/255.0, alpha: 1.0)
        vc.navigationController?.isNavigationBarHidden = false
        vc.navigationItem.title = titleStr
        vc.navigationItem.leftBarButtonItems = letBarBtn
        if letBarBtn.count > 0
        {
            vc.navigationItem.leftBarButtonItem?.isEnabled = true
        }
        else
        {
            vc.navigationItem.hidesBackButton = true
            vc.navigationItem.leftBarButtonItem?.isEnabled = false
        }
        
        if rigBarBtn.count > 0
        {
            vc.navigationItem.rightBarButtonItems = rigBarBtn
        }
        
        vc.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19)]
    }
    
    class func barItemWithView(view: UIView, rect: CGRect) -> UIBarButtonItem
    {
        let container = UIView(frame: rect)
        container.addSubview(view)
        view.frame = rect
        return UIBarButtonItem(customView: container)
    }
}

class RightBarBtn: UIButton
{
    func initWithImage(_ image: UIImage?, _ title: String?) -> RightBarBtn
    {
        if image != nil
        {
            self.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.imageView?.contentMode = .scaleAspectFit
        }
        else if title != nil
        {
            super.layoutSubviews()
            self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.x, width: self.frame.width + 30, height: self.frame.height)
            self.setTitle(title, for: .normal)
            self.tintColor = UIColor.white
            self.titleLabel?.textAlignment = .center
            self.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            self.titleLabel?.textColor = .white
        }
        
        return self
    }
}


extension UIViewController
{
    func pushToView(_ storyBoardName: String, _ vcIdentifier: String)
    {
        let mainStoryBoard = UIStoryboard.init(name: storyBoardName, bundle: nil)
        let vcToPush = mainStoryBoard.instantiateViewController(withIdentifier: vcIdentifier)
        self.navigationController?.pushViewController(vcToPush, animated: true)
    }
}
