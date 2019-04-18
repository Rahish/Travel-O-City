//
//  FirebaseManager.swift
//  Travelocity
//
//  Created by mac on 15/04/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

typealias FireBaseResultHandler = (_ status: Bool) -> Void

class FirebaseManager: NSObject
{
    
    static var shared = FirebaseManager()
    
    var addHotelRef: DatabaseReference!
    var getHotelRef: DatabaseReference!
    var addRoomRef: DatabaseReference!
    
    func addHotel(_ hotelDetails: [String:Any], _ status: FireBaseResultHandler?)
    {
        addHotelRef = Database.database().reference().child("hotels").childByAutoId()
        var hotelDetails:[String:Any] = hotelDetails
        hotelDetails["hotel_id"] = addHotelRef.key as Any
        addHotelRef.setValue(hotelDetails)
        addHotelRef.observe(.value) { (snapshot) in
            
            self.addHotelRef.removeAllObservers()
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            print(postDict)
            status!(true)
        }
    }
    
    func getHotels()
    {
        getHotelRef = Database.database().reference()
        getHotelRef.child("hotels").observe(.value, with: { (snapshot) in
            let _ = HotelDtls.init(snapshot.value as? [String : Any] ?? [:])
        })
    }
    
    func addRoom(_ roomDetails: [String:Any], _ hotelId: String, _ status: FireBaseResultHandler?)
    {
        addHotelRef = Database.database().reference().child("hotels").child(hotelId).child("rooms").childByAutoId()
        var roomDetails:[String:Any] = roomDetails
        roomDetails["room_id"] = addHotelRef.key as Any
        addHotelRef.setValue(roomDetails)
        addHotelRef.observe(.value) { (snapshot) in
            print(snapshot)
            status!(true)
        }
    }
    
    func addRoomType(_ roomTypes: [String:Any], _ status: FireBaseResultHandler?)
    {
        addHotelRef = Database.database().reference().child("room_types").childByAutoId()
        var roomTypes:[String:Any] = roomTypes
        roomTypes["room_type_id"] = addHotelRef.key as Any
        addHotelRef.setValue(roomTypes)
        addHotelRef.observe(.value) { (snapshot) in
            status!(true)
        }
    }
    
    func getRoomTypes()
    {
        getHotelRef = Database.database().reference()
        getHotelRef.child("room_types").observe(.value, with: { (snapshot) in
            let _ = RoomTypes.init(snapshot.value as? [String : Any] ?? [:])
        })
    }

    func getRoomTypes(_ roomId: String)
    {
        getHotelRef = Database.database().reference()
        getHotelRef.child("room_types").child(roomId).observe(.value, with: { (snapshot) in
            let _ = RoomTypes.init(snapshot.value as? [String : Any] ?? [:])
        })
    }
}
