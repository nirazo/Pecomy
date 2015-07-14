//
//  ResultViewController.swift
//  Karuta
//
//  Created by Kenzo on 2015/07/12.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

import UIKit
import SwiftyJSON

class ResultViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {

    var shopList: JSON!
    
    init(shopList: JSON) {
        super.init(style: .Plain)
        self.shopList = shopList
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nil, bundle: nil)
    }

    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景画像設定（とりあえず固定で...）
        var image = UIImage(named: "Oimachi")
        UIGraphicsBeginImageContext(self.view.frame.size);
        image!.drawInRect(self.view.bounds)
        var backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.tableView.backgroundColor = UIColor(patternImage: backgroundImage!)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerClass(ResultViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.rowHeight = Const.ROW_HEIGHT_RESULTVIEW
        self.tableView.separatorStyle = .None
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shopList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ResultViewCell
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = .None
        let shopJson = self.shopList[indexPath.row]
        
        /**cellにimage追加 */
        let imageURL = NSURL(string: shopJson["image_url"].string!)
        cell.setRestaurantImage(imageURL!)
        
        cell.numberLabel.text = "Best" + String(indexPath.row+1)

        

//        NSDictionary *shopDict = self.shopList[indexPath.row];
//        
//        NSURL *imageURL = [NSURL URLWithString:shopDict[@"image_url"]];
//        [cell setRestaurantImage:imageURL];
//        
//        cell.numberLabel.text = @(indexPath.row + 1).stringValue;
//        
//        cell.restaurantNameLabel.text = shopDict[@"title"];
//        cell.categoryLabel.text = @"カテゴリ";
//        cell.priceMinLabel.text = shopDict[@"price_min"] == nil ? @"" : [NSString stringWithFormat:@"%@", shopDict[@"price_min"]];
//        cell.priceMaxLabel.text = shopDict[@"price_max"] == nil ? @"" : [NSString stringWithFormat:@"%@", shopDict[@"price_max"]];
//        cell.distantLabel.text = shopDict[@"distance_meter"] == nil ? @"" : [NSString stringWithFormat:@"%@", shopDict[@"distance_meter"]];
//        
//        NSString *urlString = shopDict[@"url"] == nil ? @"" : shopDict[@"url"];
//        cell.shopUrl = [NSURL URLWithString:urlString];
//        
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
