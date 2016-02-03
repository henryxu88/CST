//
//  CommentApi.swift
//  CST
//
//  Created by henry on 16/2/3.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import Alamofire

class CommentApi {
    
    class func getCommentList(catalog: Int, pageIndex: Int, keyword: String = "", targetId: String = "" ,resultClosure:((Bool,[Comment]?) -> Void)){
        
        var parameters = [String:AnyObject]()
        
        parameters["catalog"] = catalog // 6:所有批注 51:某一文档下的批注 11:和我有关的批注
        parameters["pageIndex"] = pageIndex // 1
        parameters["pageSize"] = NetManager.pageSize // 20
        
        var url: String
        if catalog == 11 {
            url = NetManager.COMMENT_LIST_ABOUTME
        } else {
            if targetId.isEmpty {
                url = NetManager.COMMENT_LIST
            } else {
                parameters["ctargetId"] = targetId
                parameters["commentId"] = keyword
                url = NetManager.COMMENT_LIST_TARGET
            }
        }
        
        let urlHandler = {(response: Response<AnyObject, NSError>) -> Void in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let commentList = CommentList.parse(value)
                    let res = commentList.result
                    if res.OK() {
                        let objs = commentList.list
                        //                            print("objs.count: \(objs.count)")
                        if objs.count == 0 {
                            resultClosure(true,nil)
                        } else {
                            resultClosure(true,objs)
                        }
                        
                    } else {
                        print("code:\(res.errorCode) msg:\(res.errorMessage)")
                        resultClosure(false,nil)
                    }
                }
            case .Failure(let error):
                print(error)
                resultClosure(false,nil)
            }
        }
        
        BaseApi.postResult(url, parameters: parameters, handler: urlHandler)
    }
    
    // 创建批注
    

}