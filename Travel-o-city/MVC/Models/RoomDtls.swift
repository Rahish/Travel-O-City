//
//  RoomDtls.swift
//  Travelocity
//
//  Created by mac on 16/04/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RoomDtls
{
    var hotelId: String = ""
    var isAvailable: String = ""
    var price: String = ""
    var roomDesc: String = ""
    var roomId: String = ""
    var roomTypeId: String = ""
    var roomDtls: RoomTypesHandler? = nil
    
    init()
    {
        hotelId = ""
        isAvailable = ""
        price = ""
        roomDesc = ""
        roomId = ""
        roomTypeId = ""
    }
    
    init(_ data: [String:Any])
    {
        let key = Constants.RoomDtlsKey()
        hotelId =  data[key.hotelId] as? String ?? ""
        isAvailable = data[key.isAvailable] as? String ?? ""
        price = data[key.price] as? String ?? ""
        roomDesc = data[key.roomDesc] as? String ?? ""
        roomId = data[key.roomId] as? String ?? ""
        roomId = data[key.roomTypeId] as? String ?? ""
        roomDtls = RoomTypesHandler.init(roomId)
    }
}

class RoomTypesHandler: FIRObserverManager
{
    var roomTypeDtls = RoomTypes()
    
    init(_ roomId: String)
    {
        let roomTypeRef = Database.database().reference().child("room_types").child(roomId)
        
        super.init(roomTypeRef)
        self.fetchData()
    }
    
    override func dataFetched(_ data: [String : AnyObject])
    {
        self.roomTypeDtls = RoomTypes.init(data)
    }
    
    override func dataAlreadyFetched()
    {
        print("Parent dataAlreadyFetched")
    }
    
    override func requestTimeOut()
    {
        print("Request Timed Out")
    }
}
