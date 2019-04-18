//
//  AddHotelVC.swift
//  Travelocity
//
//  Created by mac on 15/04/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class AddHotelVC: UIViewController
{
    @IBOutlet weak private var nameTxt: UITextField!
    @IBOutlet weak private var ratingsTxt: UITextField!
    @IBOutlet weak private var locationTxt: UITextField!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        Utils.setNavigationBarWithVC(self, withTitle: "Add Hotel", withLeftBarButton: UIBarButtonItem.init(title: "Home", style: .plain, target: self, action: #selector(backBtnActn)), rigBarBtn: nil)
    }
    
    @objc private func backBtnActn()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func addHotelBtn(_ sender: Any)
    {
        if nameTxt.text?.count == 0
        {
            Utils.showAlert("Alert", "Please enter hotel name.", self)
        }
        else if ratingsTxt.text?.count == 0
        {
            Utils.showAlert("Alert", "Please entervalid ratings.", self)
        }
        else
        {
            FirebaseManager.shared.addHotel(["hotel_name" : nameTxt.text!,
                                             "hotel_rating" : ratingsTxt.text!,
                                             "location" : locationTxt.text!], { status in
                                                self.navigationController?.popViewController(animated: true)
                                                
            })
        }
    }
}

extension AddHotelVC: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == nameTxt || textField == locationTxt
        {
            return true
        }
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        let newText = textField.text!.replacingCharacters(in: r, with: string)
        let isNumeric = newText.isEmpty || (Double(newText) != nil)
        
        return isNumeric && newText.count <= 2
    }
}
