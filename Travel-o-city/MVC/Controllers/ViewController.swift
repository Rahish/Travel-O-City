//
//  ViewController.swift
//  Travelocity
//
//  Created by mac on 15/04/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak private var hotelsTbl: UITableView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var addBtn = RightBarBtn()
        addBtn = addBtn.initWithImage(UIImage.init(named: "add"), "")
        addBtn.addTarget(self, action: #selector(addBtnActn), for: .touchUpInside)
        Utils.setNavigationBarWithVC(self, withTitle: "Travel-O-City", withLeftBarButton: nil, rigBarBtn: addBtn)
        
        NotificationCenter.default.addObserver(self, selector: #selector(hotelListFetched(_:)), name: Constants.Notifications().hotelDtlsFetched, object: nil)
        
        HotelListManager.shared.fetchListing()
        RoomTypesListManager.shared.fetchListing()
    }
    
    
    @objc private func hotelListFetched(_ notification: Notification)
    {
        print(notification)
        hotelsTbl.reloadData()
    }
    
    @objc private func addBtnActn()
    {
        self.pushToView("Main", "AddHotelVC")
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return HotelListManager.shared.hotelsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: HotelDtlsCell = tableView.dequeueReusableCell(withIdentifier: "HotelDtlsCell") as! HotelDtlsCell!
        cell.setData(HotelListManager.shared.hotelsList[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let mainStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let vcToPush = mainStoryBoard.instantiateViewController(withIdentifier: "RoomDtlsVC") as! RoomDtlsVC
        vcToPush.selectedIndex = indexPath.row
        self.navigationController?.pushViewController(vcToPush, animated: true)
    }
}

class HotelDtlsCell: UITableViewCell
{
    @IBOutlet weak private var nameLbl: UILabel!
    @IBOutlet weak private var ratingLbl: UILabel!
    @IBOutlet weak private var locationLbl: UILabel!
    @IBOutlet weak private var capacityLbl: UILabel!
    @IBOutlet weak private var bedSizeLbl: UILabel!
    @IBOutlet weak private var roomTypeLbl: UILabel!
    @IBOutlet weak private var bgView: UIView!
    
    override func awakeFromNib()
    {
        bgView.layer.cornerRadius = 12
        bgView.clipsToBounds = true
    }
    
    func setData(_ hotelDtl: HotelDtls)
    {
        nameLbl.text = "Hotel \(hotelDtl.hotelName)"
        ratingLbl.text = "\(hotelDtl.hotelRating) Ratings"
        locationLbl.text = hotelDtl.location
    }
    
    func setData(_ roomlDtl: RoomDtls)
    {
        nameLbl.text = "Description: \(roomlDtl.roomDesc)"
        ratingLbl.text = "Price: ₹ \(roomlDtl.price)"
        locationLbl.text = "Availability: \(roomlDtl.isAvailable)"
        capacityLbl.text = "Capacity: \(roomlDtl.roomDtls?.roomTypeDtls.roomCapacity ?? "")"
        bedSizeLbl.text = "Bed Size: \(roomlDtl.roomDtls?.roomTypeDtls.bedSize ?? "")"
        roomTypeLbl.text = "Availability: \(roomlDtl.roomDtls?.roomTypeDtls.roomType ?? "")"
    }
}
