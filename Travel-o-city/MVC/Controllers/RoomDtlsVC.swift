//
//  RoomDtlsVC.swift
//  Travelocity
//
//  Created by mac on 17/04/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class RoomDtlsVC: UIViewController
{
    var selectedIndex: Int = 0
    @IBOutlet weak var roomsTbl: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        var addBtn = RightBarBtn()
        addBtn = addBtn.initWithImage(UIImage.init(named: "add"), "")
        addBtn.addTarget(self, action: #selector(addBtnActn), for: .touchUpInside)
        Utils.setNavigationBarWithVC(self, withTitle: "Room Details", withLeftBarButton: UIBarButtonItem.init(title: "Home", style: .plain, target: self, action: #selector(backBtnActn)), rigBarBtn: addBtn)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        roomsTbl.reloadData()
    }
    
    @objc private func addBtnActn()
    {
        self.pushToView("Main", "AddRoomPriceVC")
    }
    
    @objc private func backBtnActn()
    {
        self.navigationController?.popViewController(animated: true)
    }
}

extension RoomDtlsVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return HotelListManager.shared.hotelsList[selectedIndex].roomDtls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: HotelDtlsCell = tableView.dequeueReusableCell(withIdentifier: "HotelDtlsCell") as! HotelDtlsCell!
        cell.setData(HotelListManager.shared.hotelsList[selectedIndex].roomDtls[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
}
