//
//  EntityList.swift
//  CST
//
//  Created by henry on 16/1/27.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation

class EntityList<T: Entity>: Base {
    var result = Result()
    
    var pageNum = 0     //当前页
    var pageCount = 0   //总页数
    
    var pageSize = 0    //当前页中的条目数
    var totalCount = 0  //总条目数
    
    var itemIndex = 0   //当前页中的选中条目索引
    var list = [T]()    //返回的条目数组
    
}