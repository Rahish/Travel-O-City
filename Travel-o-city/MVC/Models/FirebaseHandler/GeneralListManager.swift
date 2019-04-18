//
//  GeneralListManager.swift
//  POSAPP
//
//  Created by intersoft-admin on 01/02/19.
//  Copyright © 2019 intersoft-kansal. All rights reserved.
//

import Foundation
import Firebase

enum FIRRequestStatus: Int8
{
    case none
    case pending
    case dataReceived
    case done
}

class ListManager
{
    private(set) var requestStatus: FIRRequestStatus = .none

    private var listRef: DatabaseReference? = nil
    
    private var childAddedRef: DatabaseHandle? = 0
    private var childRemovedRef: DatabaseHandle? = 0
    private var childChangedRef: DatabaseHandle? = 0

    //If no Response within the given time, then List Fetched Function will be called
    private var timerChildAddedDelay: Timer? = nil
    
    //When This much Delay will be there in Child Added functionality
    //We will consider this as list loaded
    private var CHILD_ADDED_INTERVAL = TimeInterval(0.05)
    
    //If no Response within the given time, then No Internet Function will be called
    private var timerRequestTimeOut: Timer? = nil
    
    //When This much Delay will be there and no child is added yet
    //then No internet Available will considered
    private var REQUEST_TIMEOUT_INTERVAL = TimeInterval(1.0)
    
    init(_ dbRef: DatabaseReference)
    {
        listRef = dbRef
        NotificationCenter.default.addObserver(self, selector: #selector(removeFBObserver(_:)), name: Constants.Notifications().removeFirebaseObserver, object: nil)
    }
    
    init()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(removeFBObserver(_:)), name: Constants.Notifications().removeFirebaseObserver, object: nil)
    }
    
    @objc func removeFBObserver(_ notification: Notification)
    {
        self.removeAllObservers()
    }
    
    deinit
    {
        print("ListManager Deinit")
    }
    
    func fetchListing(_ dbRef: DatabaseReference)
    {
        listRef = dbRef
        self.fetchListing()
    }
    
    func fetchListing()
    {
        if requestStatus == .none
        {
            //Value Listner
            requestStatus = .pending

            self.timerRequestTimeOut = Timer.scheduledTimer(timeInterval: self.REQUEST_TIMEOUT_INTERVAL, target: self, selector: #selector(self.checkRequestTimedOut(_:)), userInfo: nil, repeats: false)
            
            unowned let weakSelf = self
            childAddedRef = listRef?.observe(.childAdded) { (childAddedData) in
                
                print("Child added Called and self = \(weakSelf)")
                if weakSelf.requestStatus != .done
                {
                    weakSelf.requestStatus = .dataReceived
                    weakSelf.timerChildAddedDelay?.invalidate()
                    weakSelf.timerChildAddedDelay = nil
                    weakSelf.timerChildAddedDelay = Timer.scheduledTimer(timeInterval: weakSelf.CHILD_ADDED_INTERVAL, target: weakSelf, selector: #selector(weakSelf.stopTimerAndListObserver(_:)), userInfo: nil, repeats: false)
                }
                
                let value = (childAddedData.value as? [String: AnyObject]) ?? [:]
                weakSelf.childAdded(value)
            }
            
            childChangedRef = listRef?.observe(.childChanged) { (childChangedData) in
                
                print("Child Changed Called and weakSelf = \(weakSelf)")
                let value = (childChangedData.value as? [String: AnyObject]) ?? [:]
                weakSelf.childChanged(value)
            }
            
            childRemovedRef = listRef?.observe(.childRemoved) { (childRemovedData) in
                
                print("Child Removed Called and weakSelf = \(weakSelf)")
                let value = (childRemovedData.value as? [String: AnyObject]) ?? [:]
                weakSelf.childRemoved(value)
            }
        }
        else if requestStatus == .pending
        {
            //Means User Mention Request Timeout Interval
            self.timerRequestTimeOut?.invalidate()
            self.timerRequestTimeOut = nil
            self.timerRequestTimeOut = Timer.scheduledTimer(timeInterval: self.REQUEST_TIMEOUT_INTERVAL, target: self, selector: #selector(self.checkRequestTimedOut(_:)), userInfo: nil, repeats: false)
        }
        else if requestStatus == .dataReceived
        {
            print("Nothing to do, as data receiving task in underprocess")
            //Nothing to do, as data receiving task in underprocess
            //will notify on completion
        }
        else
        {
            self.postNotification()
        }
    }
    
    @objc private func checkRequestTimedOut(_ timer: Timer)
    {
        timerRequestTimeOut?.invalidate()
        timerRequestTimeOut = nil
        if self.requestStatus == .pending
        {
            self.ensureRequestTimeOut()
        }
    }
    
    //Some Time Give Node may not have any Child Object
    //So Putting Value Observer for the same Node to check
    //Otherwise will consider as Request timeOut
    private func ensureRequestTimeOut()
    {
        if AppDelegate.isInternetConnected()
        {
            var valueEventTimer: Timer? = nil
            
            unowned let weakSelf = self
            let listObserverRef = listRef?.observe(.value, with: { (dataArr) in
                
                valueEventTimer?.invalidate()
                //Other Event May Work in the Mean Time
                if weakSelf.requestStatus == .pending
                {
                    //State == pending and Objects Count == 0
                    //When there is no Child Object
                    if dataArr.children.allObjects.count == 0
                    {
                        weakSelf.requestStatus = .done
                        weakSelf.listDataFetched()
                    }
                    else
                    {
                        for snapShot in dataArr.children.allObjects as? [DataSnapshot] ?? []
                        {
                            self.childAdded(snapShot.value as? [String: AnyObject] ?? [:])
                        }
                    }
                }
            })
            
            valueEventTimer = Timer.scheduledTimer(timeInterval: TimeInterval(0.10), target: self, selector: #selector(valueEventTimer(_:)), userInfo: listObserverRef, repeats: false)
        }
        else
        {
            if self.requestStatus == .pending
            {
                self.requestTimeOut()
            }
        }
    }
    
    @objc private func valueEventTimer(_ timer: Timer)
    {
        if requestStatus == .pending
        {
            if let observerRef = timer.userInfo as? DatabaseHandle
            {
                listRef?.removeObserver(withHandle: observerRef)
            }
            
            timer.invalidate()
            
            if AppDelegate.isInternetConnected()
            {
                self.internetAvailableButRequestTimeOut()
            }
            else
            {
                self.requestTimeOut()
            }
        }
    }
    
    @objc private func stopTimerAndListObserver(_ timer: Timer)
    {
        print("stopTimerAndListObserver and self == \(self) and date == \(Date())")
        timerChildAddedDelay?.invalidate()
        timerChildAddedDelay = nil
        
        self.requestStatus = .done
        self.listDataFetched()
    }
    
    func removeAllObservers()
    {
        listRef?.removeAllObservers()
    }
    
    //Delegate Functions
    func listDataFetched()
    {
        print("Parent listDataFetched")
    }
    
    func childAdded(_ data: [String : AnyObject])
    {
        print("Parent childAdded")
    }
    
    func childRemoved(_ data: [String : AnyObject])
    {
        print("Parent childRemoved")
    }
    
    func childChanged(_ data: [String : AnyObject])
    {
        print("Parent childChanged")
    }
    
    func postNotification()
    {
        print("Parent postNotification as Data is already Loaded")
    }
    
    func requestTimeOut()
    {
        print("Request Timed Out, Mentioned Timeout Value is \(REQUEST_TIMEOUT_INTERVAL)")
    }
    
    func internetAvailableButRequestTimeOut()
    {
        print("Request Timed Out, Mentioned Timeout Value is \(REQUEST_TIMEOUT_INTERVAL)")
    }
}
