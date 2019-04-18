//
//  HotelListManager.swift
//  Travelocity
//
//  Created by mac on 16/04/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import FirebaseDatabase

class HotelListManager: ListManager
{
    static var shared = HotelListManager()
    
    var hotelsList: [HotelDtls] = []
    
    override init()
    {
        let dbRef = Database.database().reference().child("hotels")
        super.init(dbRef)
    }
    
    override func listDataFetched()
    {
        print("HotelListManager Child listDataFetched")
        NotificationCenter.default.post(name: Constants.Notifications().hotelDtlsFetched, object: self.hotelsList, userInfo: nil)
    }
    
    override func childAdded(_ data: [String : AnyObject])
    {
        print("HotelListManager Child childAdded", data)
        let hotelData = HotelDtls.init(data as! [String : NSObject])
        
        self.checkAddUpdateHotelData(hotelData)
    }
    
    override func childRemoved(_ data: [String : AnyObject])
    {
        print("HotelListManager Child childRemoved", data)
        
        let hotelData = HotelDtls.init(data as! [String : NSObject])
        
        var index: Int = 0
        for hotelFrmList in hotelsList
        {
            if hotelFrmList.hotelId == hotelData.hotelId
            {
                hotelsList.remove(at: index)
                NotificationCenter.default.post(name: Constants.Notifications().hotelDtlsFetched, object: self.hotelsList, userInfo: nil)
                break
            }
            else
            {
                index += 1
            }
        }
    }
    
    override func childChanged(_ data: [String : AnyObject])
    {
        print("HotelListManager Child childChanged", data)
        
        let hotelData = HotelDtls.init(data as! [String : NSObject])
        self.checkAddUpdateHotelData(hotelData)
    }
    
    private func checkAddUpdateHotelData(_ hotelData: HotelDtls)
    {
        var hasUpdated: Bool = false
        for (index, hotelFrmList) in hotelsList.enumerated()
        {
            if hotelFrmList.hotelId == hotelData.hotelId
            {
                hotelsList.remove(at: index)
                hotelsList.insert(hotelData, at: index)
                hasUpdated = true
                NotificationCenter.default.post(name: Constants.Notifications().hotelDtlsFetched, object: self.hotelsList, userInfo: nil)
                break
            }
        }
        
        if hasUpdated == false
        {
            hotelsList.append(hotelData)
            NotificationCenter.default.post(name: Constants.Notifications().hotelDtlsFetched, object: self.hotelsList, userInfo: nil)
        }
    }
    
    override func requestTimeOut()
    {
//        SnackBarHandler.shared.snackBar("Unable To Fetch Data")
        NotificationCenter.default.post(name: Constants.Notifications().hotelDtlsFetched, object: self.hotelsList, userInfo: nil)
    }
    
    override func internetAvailableButRequestTimeOut()
    {
//        SnackBarHandler.shared.snackBar("Fetching data in progress..!")
        NotificationCenter.default.post(name: Constants.Notifications().hotelDtlsFetched, object: self.hotelsList, userInfo: nil)
    }
}
