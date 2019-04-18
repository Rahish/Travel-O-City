//
//  AddRoomDetailsVC.swift
//  Travelocity
//
//  Created by mac on 15/04/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class AddRoomTypeVC: UIViewController
{

    @IBOutlet weak var  typeTxt: UITextField!
    @IBOutlet weak private var bedSizeTxt: UITextField!
    @IBOutlet weak private var capacityTxt: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        Utils.setNavigationBarWithVC(self, withTitle: "Add Room Type", withLeftBarButton: UIBarButtonItem.init(title: "Back", style: .plain, target: self, action: #selector(backBtnActn)), rigBarBtn: nil)
        
        self.createPicker()
    }
    
    private func createPicker()
    {
        let picker = UIPickerView()
        picker.backgroundColor = .white
        
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneBtnActn))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        typeTxt.inputView = picker
        typeTxt.inputAccessoryView = toolBar
    }
    
    @objc private func doneBtnActn()
    {
        self.view.endEditing(true)
    }
    
    @objc private func backBtnActn()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func addTypeBtn(_ sender: Any)
    {
        FirebaseManager.shared.addRoomType(["room_type" : typeTxt.text!,
                                            "room_capacity" : capacityTxt.text!,
                                            "bed_size" : bedSizeTxt.text!], { status in
                                                self.navigationController?.popViewController(animated: true)
                                                
        })
    }
    
    func roomTypes() -> [String]
    {
        return ["Single","Double", "Triple", "Quad", "Queen", "King", "Twin"]
    }
}
