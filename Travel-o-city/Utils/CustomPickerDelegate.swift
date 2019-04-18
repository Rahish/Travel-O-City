//
//  CustomPickerDelegate.swift
//  Travelocity
//
//  Created by mac on 16/04/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

extension AddRoomPriceVC: UIPickerViewDataSource, UIPickerViewDelegate
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        switch selectedtxtFld {
        case .AVAILABILITY:
            return 2
        
        case .HOTELNAME:
            return HotelListManager.shared.hotelsList.count
            
        case .ROOMTYPE:
            return RoomTypesListManager.shared.roomsTypeList.count
            
        default:
            return 0
        }
    }
    
    //MARK: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
        switch selectedtxtFld {
        case .AVAILABILITY:
            return ["Yes", "No"][row]
            
        case .HOTELNAME:
            return (HotelListManager.shared.hotelsList[row]).hotelName
            
        case .ROOMTYPE:
            return (RoomTypesListManager.shared.roomsTypeList[row]).roomType
            
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        switch selectedtxtFld {
        case .AVAILABILITY:
            isAvailableTxt.text = ["Yes", "No"][row]
            break
            
        case .HOTELNAME:
            selectedHotelIndex = row
            hotelNameTxt.text = (HotelListManager.shared.hotelsList[row]).hotelName
            break
            
        case .ROOMTYPE:
            selectedRoomTypIndex = row
            roomTypeTxt.text = (RoomTypesListManager.shared.roomsTypeList[row]).roomType
            break
            
        default:
            break
        }
    }
}


extension AddRoomTypeVC: UIPickerViewDataSource, UIPickerViewDelegate
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return self.roomTypes().count
    }
    
    //MARK: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return self.roomTypes()[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        typeTxt.text = self.roomTypes()[row]
    }
}
