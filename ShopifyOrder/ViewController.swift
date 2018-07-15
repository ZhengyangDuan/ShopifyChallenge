//
//  ViewController.swift
//  ShopifyOrder
//
//  Created by Zhengyang Duan on 2018-07-14.
//  Copyright © 2018 Zhengyang Duan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    
    @IBOutlet weak var Category1: UILabel!
    @IBOutlet weak var yearview: UITableView!
    @IBOutlet weak var provinceview: UITableView!
    
    var orders:[JSON] = []
    var ordersByYear:[JSON] = []
    var dict = [String:Int]()
    var provinceSorted:[String] = []
    
    

    let url = NSURL(string: "https://shopicruit.myshopify.com/admin/orders.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6")
    var i = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let json:JSON = JSON(getJSONData(urlToRequest: url!))
        yearview.separatorStyle = .none
        provinceview.separatorStyle = .none
        yearview.estimatedRowHeight = 30
        provinceview.estimatedRowHeight = 30
        yearview.dataSource = self
        yearview.delegate = self
        provinceview.delegate = self
        provinceview.dataSource = self
        repeat{
            orders.append(json["orders"][i])
            i += 1
        }while json["orders"][i] != JSON.null
        
        sortByProvince()
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 1{
            findyear(year: 2017)
            if ordersByYear.count>10{
                return 11
            }else{
                return 1 + ordersByYear.count
            }
            
        }
        else if tableView.tag == 2{
            return provinceSorted.count
        }else{
            return 0
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if tableView.tag == 1 {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! yearcell
            if indexPath.row == 0 {
                cell1.yearView.text = "\(findyear(year: 2017)) orders created in 2017"
                return cell1
            }else{
                cell1.yearView.text = "    Order ID:\(ordersByYear[indexPath.row - 1]["id"])."
                return cell1
            }
            
        }else {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! provincecell
            if provinceSorted[indexPath.row] == ""{
                cell2.provinceView.text = "\(dict[provinceSorted[indexPath.row]]!) order(s) no province provided"
            }else{
                cell2.provinceView.text = "\(dict[provinceSorted[indexPath.row]]!) order(s) creted at \(provinceSorted[indexPath.row])"
            }
            
            
            return cell2
        }
        
    }
    
    func getJSONData(urlToRequest: NSURL) -> NSData?{
        return NSData(contentsOf: urlToRequest as URL)
    }
    
    func findyear(year:Int) -> Int{
        ordersByYear.removeAll()
        for i in 0..<orders.count{
            if orders[i]["created_at"].stringValue.contains("\(year)"){
                ordersByYear.append(orders[i])
            }
        }
        return ordersByYear.count
    }
    
    func sortByProvince(){
        for i in 0..<orders.count{
            let key = orders[i]["shipping_address"]["province"].stringValue
            if i == 0 {
                dict[key] = 1
            }else{
                if dict[key] != nil{
                    dict[key]! += 1
                }else{
                    dict[key] = 1
                }
            }
        }
        provinceSorted = Array(dict.keys).sorted{$0 < $1}
    }
    @IBAction func provincePressed(_ sender: Any) {
        performSegue(withIdentifier: "goToDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DetailVC
        destinationVC.dict = dict
        destinationVC.orders = orders
        destinationVC.provinceSorted = provinceSorted
    
    }
}

