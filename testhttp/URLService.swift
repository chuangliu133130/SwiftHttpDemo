//
//  URLService.swift
//  testhttp
//
//  Created by liuchaoyang18 on 2021/3/1.
//

import UIKit

class URLService: NSObject
{
    func getNewsData(channel:String,startNum:Int,completion:@escaping (Any,Bool) -> Void) {
    //使用GET请求数据
    //1.网址字符串拼接
    var urlStr = "http://api.jisuapi.com/news/get?channel=(channel)&start=(startNum)&num=10&appkey=de394933e1a3e2db"
    //2.转码 (把中文转码)
    urlStr = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!
    //3.封装为URL对象
    let url = URL(string: urlStr)
    //4.封装为URLRequest对象(目的:设置请求超时时间)
    let req = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15.0)


  
        
        //5.URLSession请求网络数据   //6.开启任务
        URLSession.shared.dataTask(with: req) { (data, response, error) in
            //如果发生错误
            if error != nil{
                //参数闭包的调用
                completion("网络服务器错误", false)
                return
            }
            //json数据解析
            let jsonData = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)

            //json解析失败 返回错误
            if jsonData == nil{
                completion("json解析错误",false)
                return
            }

            let status = (jsonData as! NSDictionary).value(forKey: "status") as! String

            let msg = (jsonData as! NSDictionary).value(forKey: "msg") as! String

            if Int(status)! != 0 {
                completion(msg, false)
                return
            }
            let result = (jsonData as! NSDictionary).value(forKey: "result") as! NSDictionary

            let list = result.value(forKey: "list") as! NSArray

            var newsArr:[News] = []
            for item in list{
                let dic = item as! NSDictionary

                let oneNew = News()
                oneNew.title = dic.value(forKey: "title") as! String
                oneNew.content = dic.value(forKey: "content") as! String
                oneNew.time = dic.value(forKey: "time") as! String
                oneNew.url = dic.value(forKey: "url") as! String
                oneNew.weburl = dic.value(forKey: "weburl") as! String
                newsArr.append(oneNew)
            }
            completion(newsArr, true)
        }.resume()
    }


    
    
}
