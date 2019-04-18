//
//  RoomTypes.swift
//  Travelocity
//
//  Created by mac on 16/04/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class RoomTypes
{
    var bedSize: String = ""
    var roomCapacity: String = ""
    var roomType: String = ""
    var roomTypeId: String = ""
    
    init()
    {
        bedSize = ""
        roomCapacity = ""
        roomType = ""
        roomTypeId = ""
    }
    
    init(_ data: [String:Any])
    {
        let key = Constants.RoomTypeKey()
        bedSize = data[key.bedSize] as? String ?? ""
        roomCapacity = data[key.roomCapacity] as? String ?? ""
        roomType = data[key.roomType] as? String ?? ""
        roomTypeId = data[key.roomTypeId] as? String ?? ""
    }
}
