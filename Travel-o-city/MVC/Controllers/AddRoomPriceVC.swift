//
//  AddRoomPriceVC.swift
//  Travelocity
//
//  Created by mac on 16/04/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

enum TxtFldType
{
    case AVAILABILITY
    case HOTELNAME
    case ROOMTYPE
    case NOTSELECTED
}

class AddRoomPriceVC: UIViewController
{
    @IBOutlet weak private var descTxt: UITextField!
    @IBOutlet weak var isAvailableTxt: UITextField!
    @IBOutlet weak private var priceTxt: UITextField!
    @IBOutlet weak var hotelNameTxt: UITextField!
    @IBOutlet weak var roomTypeTxt: UITextField!
    
    var selectedtxtFld: TxtFldType = .NOTSELECTED
    var selectedHotelIndex = -1
    var selectedRoomTypIndex = -1
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        Utils.setNavigationBarWithVC(self, withTitle: "Add Room", withLeftBarButton: UIBarButtonItem.init(title: "Back", style: .plain, target: self, action: #selector(backBtnActn)), rigBarBtn: nil)
        
        self.createPicker()
    }
    
    @objc private func addBtnActn()
    {
        self.pushToView("Main", "AddRoomTypeVC")
    }
    
    private func createPicker()
    {
        let picker = UIPickerView()
        picker.backgroundColor = .white
        
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self
        
        hotelNameTxt.inputView = picker
        hotelNameTxt.inputAccessoryView = self.addToolBar(false)
        
        roomTypeTxt.inputView = picker
        roomTypeTxt.inputAccessoryView = self.addToolBar(true)
        
        isAvailableTxt.inputView = picker
        isAvailableTxt.inputAccessoryView = self.addToolBar(false)
    }
    
    private func addToolBar(_ needAdd: Bool) -> UIToolbar
    {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneBtnActn))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let addButton = UIBarButtonItem(title: "Add Room Type", style: UIBarButtonItem.Style.plain, target: self, action: #selector(addBtnActn))
        
        toolBar.setItems(needAdd ? [doneButton,spacer,addButton] : [doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
    @objc private func doneBtnActn()
    {
        self.view.endEditing(true)
    }
    
    @objc private func backBtnActn()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func addHotelPriceBtn(_ sender: Any)
    {
        FirebaseManager.shared.addRoom(["room_desc" : descTxt.text!,
                                        "is_available" : isAvailableTxt.text!,
                                        "price" : priceTxt.text!,
                                        "hotel_id" : HotelListManager.shared.hotelsList[selectedHotelIndex].hotelId,
                                        "room_type_id" : RoomTypesListManager.shared.roomsTypeList[selectedRoomTypIndex].roomTypeId], HotelListManager.shared.hotelsList[selectedHotelIndex].hotelId, { status in
                                            self.navigationController?.popViewController(animated: true)
                                            
        })
    }
}

extension AddRoomPriceVC: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == isAvailableTxt
        {
            selectedtxtFld = .AVAILABILITY
        }
        else if textField == hotelNameTxt
        {
            selectedtxtFld = .HOTELNAME
        }
        else if textField == roomTypeTxt
        {
            selectedtxtFld = .ROOMTYPE
        }
        else
        {
            selectedtxtFld = .NOTSELECTED
        }
        
        if let pickerVw = textField.inputView as? UIPickerView
        {
            pickerVw.reloadAllComponents()
        }
    }
}
