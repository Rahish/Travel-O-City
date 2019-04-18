//
//  HotelDtls.swift
//  Travelocity
//
//  Created by mac on 15/04/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class HotelDtls
{
    static let shared = HotelDtls()
    
    var hotelId: String = ""
    var hotelName: String = ""
    var hotelRating: String = ""
    var location: String = ""
    var roomDtls: [RoomDtls] = []
        
    init()
    {
        hotelId = ""
        hotelName = ""
        hotelRating = ""
        location = ""
        roomDtls = []
    }
    
    init(_ data: [String:Any])
    {
        let keys = Constants.HotleDtlsKey()
        hotelId = data[keys.hotelId] as? String ?? ""
        hotelName = data[keys.hotelName] as? String ?? ""
        hotelRating = data[keys.hotelRating] as? String ?? ""
        location = data[keys.location] as? String ?? ""
        
        for (_, value) in data[keys.rooms] as? [String : Any] ?? [:]
        {
            roomDtls.append(RoomDtls.init(value as? [String : Any] ?? [:]))
        }
    }
}
