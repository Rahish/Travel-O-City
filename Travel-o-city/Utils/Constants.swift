//
//  Constants.swift
//  Travelocity
//
//  Created by mac on 15/04/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

struct Constants
{
    struct HotleDtlsKey
    {
        let hotelName = "hotel_name"
        let hotelRating = "hotel_rating"
        let hotelId = "hotel_id"
        let location = "location"
        let rooms = "rooms"
    }
    
    struct RoomTypeKey
    {
        let bedSize = "bed_size"
        let roomCapacity = "room_capacity"
        let roomType = "room_type"
        let roomTypeId = "room_type_id"
    }
    
    struct RoomDtlsKey
    {
        let hotelId = "hotel_id"
        let isAvailable = "is_available"
        let price = "price"
        let roomDesc = "room_desc"
        let roomId = "room_id"
        let roomTypeId = "room_type_id"
    }
    
    struct Notifications
    {
        let removeFirebaseObserver = Notification.Name(rawValue: "removeFirebaseObserver")
        let hotelDtlsFetched = Notification.Name(rawValue: "hotelDtlsFetched")
        let roomTypDtlsFetched = Notification.Name(rawValue: "roomTypDtlsFetched")
        let singleRoomTypDtlsFetched = Notification.Name(rawValue: "singleRoomTypDtlsFetched")
    }
    
    struct FireBase
    {
        let roomTypes = "room_types"
    }
}
