//
//  RoomTypesListManager.swift
//  Travelocity
//
//  Created by mac on 16/04/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RoomTypesListManager: ListManager
{
    static var shared = RoomTypesListManager()
    
    var roomsTypeList: [RoomTypes] = []
    
    override init()
    {
        let dbRef = Database.database().reference().child("room_types")
        super.init(dbRef)
    }
    
    override func listDataFetched()
    {
        print("RoomTypListManager Child listDataFetched")
        NotificationCenter.default.post(name: Constants.Notifications().roomTypDtlsFetched, object: self.roomsTypeList, userInfo: nil)
    }
    
    override func childAdded(_ data: [String : AnyObject])
    {
        print("RoomTypListManager Child childAdded", data)
        let roomTypData = RoomTypes.init(data as! [String : NSObject])
        
        self.checkAddUpdateRoomTypData(roomTypData)
    }
    
    override func childRemoved(_ data: [String : AnyObject])
    {
        print("RoomTypListManager Child childRemoved", data)
        
        let roomTypData = RoomTypes.init(data as! [String : NSObject])
        
        var index: Int = 0
        for roomTypFrmList in roomsTypeList
        {
            if roomTypFrmList.roomTypeId == roomTypData.roomTypeId
            {
                roomsTypeList.remove(at: index)
                NotificationCenter.default.post(name: Constants.Notifications().roomTypDtlsFetched, object: self.roomsTypeList, userInfo: nil)
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
        print("RoomTypListManager Child childChanged", data)
        
        let roomTypData = RoomTypes.init(data as! [String : NSObject])
        self.checkAddUpdateRoomTypData(roomTypData)
    }
    
    private func checkAddUpdateRoomTypData(_ roomTypData: RoomTypes)
    {
        var index: Int = 0
        for roomTypFrmList in roomsTypeList
        {
            if roomTypFrmList.roomTypeId == roomTypData.roomTypeId
            {
                roomsTypeList.remove(at: index)
                roomsTypeList.insert(roomTypData, at: index)
                NotificationCenter.default.post(name: Constants.Notifications().roomTypDtlsFetched, object: self.roomsTypeList, userInfo: nil)
                break
            }
            else
            {
                index += 1
            }
        }
        
        if index >= roomsTypeList.count
        {
            roomsTypeList.append(roomTypData)
            NotificationCenter.default.post(name: Constants.Notifications().roomTypDtlsFetched, object: self.roomsTypeList, userInfo: nil)
        }
    }
    
    override func requestTimeOut()
    {
        //        SnackBarHandler.shared.snackBar("Unable To Fetch Data")
        NotificationCenter.default.post(name: Constants.Notifications().roomTypDtlsFetched, object: self.roomsTypeList, userInfo: nil)
    }
    
    override func internetAvailableButRequestTimeOut()
    {
        //        SnackBarHandler.shared.snackBar("Fetching data in progress..!")
        NotificationCenter.default.post(name: Constants.Notifications().roomTypDtlsFetched, object: self.roomsTypeList, userInfo: nil)
    }
}
