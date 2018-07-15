//
//  DetailVC.swift
//  ShopifyOrder
//
//  Created by Zhengyang Duan on 2018-07-15.
//  Copyright © 2018 Zhengyang Duan. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class DetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
   
    
    @IBOutlet weak var detailView: UITableView!
    var orders:[JSON] = []
    var dict = [String:Int]()
    var provinceSorted:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.delegate = self
        detailView.dataSource = self
        detailView.estimatedRowHeight = 100
        detailView.rowHeight = UITableViewAutomaticDimension
        provinceSorted.removeFirst()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return provinceSorted.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell3") as! detailcell
        cell.textView.isEditable = false
        
        let key = provinceSorted[indexPath.row]
        var s: String = "    \(dict[key]!) order(s) from \(key)"
        for i in 0..<orders.count{
            if orders[i]["shipping_address"]["province"].stringValue == key {
                s = s + "\n     -Order ID:\(orders[i]["id"])"
            }
        }
        cell.textView.text = s
        
        return cell
    }
}
