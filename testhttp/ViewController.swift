//
//  ViewController.swift
//  testhttp
//
//  Created by liuchaoyang18 on 2021/3/1.
//

import UIKit

class ViewController:UIViewController,UITableViewDataSource
{

    //表格属性
    var table:UITableView?
    var tableDataArr:[News]?

    var startNum = 0

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.requestNetWorkDataAndUpdateUI()
    }

    //MARK: ------MJRefreshBaseViewDelegate ----------

    func refreshViewBeginRefreshing() {
        //如果是下拉,startNum值为0
        self.requestNetWorkDataAndUpdateUI()
    }

    //MARK: ------请求网络数据 ----------
    func requestNetWorkDataAndUpdateUI() {
        //转动菊花
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        //请求网络数据

        let urlService = URLService()
        urlService.getNewsData(channel: "头条", startNum: self.startNum) { (data, success) in

            //先停止指示器
            DispatchQueue.main.sync {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                //把下拉控件停止
     
            }

            if !success {
                DispatchQueue.main.async {
                    let alertVC = UIAlertController(title: nil, message: data as?String, preferredStyle: .alert)
                    let confirmBtn = UIAlertAction(title: "确定", style: .default, handler: nil)
                    alertVC .addAction(confirmBtn)
                    self.present(alertVC, animated: true, completion: nil)
                }
                return
            }

//      
//
//            DispatchQueue.main.async(execute: {
//                self.table?.reloadData()
//            })
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.table = UITableView(frame: self.view.frame, style: .plain)
        self.table?.dataSource = self
        self.view.addSubview(self.table!)


    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = tableDataArr?.count {
            return count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: identifier)

        }
        let oneNew = self.tableDataArr![indexPath.row]

        cell?.textLabel?.text = oneNew.title
        cell?.detailTextLabel?.text = oneNew.content
        cell?.textLabel?.numberOfLines = 0

        return cell!
    }




}

