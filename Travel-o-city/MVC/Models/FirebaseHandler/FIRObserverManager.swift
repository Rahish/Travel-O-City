//
//  FIRObserverManager.swift
//  POSAPP
//
//  Created by maosx on 04/04/19.
//  Copyright © 2019 intersoft-kansal. All rights reserved.
//

import UIKit
import Firebase

class FIRObserverManager: NSObject
{
    private(set) var requestStatus: FIRRequestStatus = .none
    
    private var dbRef: DatabaseReference? = nil
    
    private var valueRef: DatabaseHandle? = 0

    //If no Response within the given time, then No Internet Function will be called
    private var timerRequestTimeOut: Timer? = nil
    
    //When This much Delay will be there and no child is added yet
    //then No internet Available will considered
    private var REQUEST_TIMEOUT_INTERVAL = TimeInterval(1.0)
    
    init(_ dbRefL: DatabaseReference)
    {
        dbRef = dbRefL
    }
    
    override init()
    {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(removeFBObserver(_:)), name: Constants.Notifications().removeFirebaseObserver, object: nil)
    }
    
    @objc func removeFBObserver(_ notification: Notification)
    {
        self.removeAllObservers()
    }
    
    deinit
    {
        print("FIRObserverManager Deinit")
    }
    
    func fetchData(_ dbRefL: DatabaseReference, _ singleValueObserver: Bool = false)
    {
        dbRef = dbRefL
        self.fetchData(singleValueObserver)
    }
    
    func fetchData(_ singleValueObserver: Bool = false)
    {
        if requestStatus == .none
        {
            //Value Listner
            requestStatus = .pending
            
            self.timerRequestTimeOut = Timer.scheduledTimer(timeInterval: self.REQUEST_TIMEOUT_INTERVAL, target: self, selector: #selector(self.checkRequestTimedOut(_:)), userInfo: nil, repeats: false)
            
            unowned let weakSelf = self
            if singleValueObserver
            {
                dbRef?.observeSingleEvent(of: .value, with: { (snapShotData) in
                    
                    weakSelf.dataFetched(snapShotData)
                })
            }
            else
            {
                valueRef = dbRef?.observe(.value) { (snapShotData) in
                    
                    weakSelf.dataFetched(snapShotData)
                }
            }
        }
        else if requestStatus == .pending
        {
            //Means User Mention Request Timeout Interval
            self.timerRequestTimeOut?.invalidate()
            self.timerRequestTimeOut = nil
            self.timerRequestTimeOut = Timer.scheduledTimer(timeInterval: self.REQUEST_TIMEOUT_INTERVAL, target: self, selector: #selector(self.checkRequestTimedOut(_:)), userInfo: nil, repeats: false)
        }
        else
        {
            self.dataAlreadyFetched()
        }
    }
    
    private func dataFetched(_ snapShot: DataSnapshot)
    {
        let value = (snapShot.value as? [String: AnyObject]) ?? [:]
        self.dataFetched(value)
    }
    
    @objc private func checkRequestTimedOut(_ timer: Timer)
    {
        timerRequestTimeOut?.invalidate()
        timerRequestTimeOut = nil
        if self.requestStatus == .pending
        {
            self.requestTimeOut()
        }
    }

    func removeAllObservers()
    {
        dbRef?.removeAllObservers()
    }
    
    //Delegate Functions
    func dataFetched(_ data: [String: AnyObject])
    {
        print("Parent dataFetched")
    }
    
    func dataAlreadyFetched()
    {
        print("Parent dataAlreadyFetched")
    }
    
    func requestTimeOut()
    {
        print("Request Timed Out, Mentioned Timeout Value is \(REQUEST_TIMEOUT_INTERVAL)")
    }
}
