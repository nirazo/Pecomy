//
//  CardProgressViewController.swift
//  Karuta
//
//  Created by Kenzo on 2015/08/11.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

import UIKit

class CardProgressViewController: UIViewController {

    var progressView: UIView
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.progressView = UIView()
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.progressView.frame = CGRectMake(0.0, 0.0, 0.0, self.view.frame.size.height)
        self.progressView.backgroundColor = Const.KARUTA_THEME_COLOR
        self.view.addSubview(self.progressView)
    }

    // 進捗率を渡してプログレスバーを進める（戻す）
    func progressWithRatio(ratio: Float) {
        UIView.animateWithDuration(0.5, animations: { [unowned self] () in
            var r = ratio > 0.95 ? 0.95 : ratio
            self.progressView.frame.size = CGSizeMake(self.view.frame.size.width * CGFloat(r), self.view.frame.size.height)
        })
    }
    
    // プログレスバーをリセット
    func reset() {
        self.progressView.frame.size = CGSizeMake(0.0, self.view.frame.size.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
