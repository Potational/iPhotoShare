//
//  Params.swift
//  PhotoShare
//
//  Created by ZEmac on 2015/12/02.
//  Copyright © 2015年 ie4a. All rights reserved.
//

import Foundation
import UIKit


class Params {
    
    static var LOGIN  = [
        "email":"",
        "password":"",
        "_token": Defaults.token
    ]
    
    static var NEW_EVENT  = [
        "event_name":"",
        "all_day " : "" ,
        "start_time":"",
        "end_time":"",
        "user_id":"",
        "_token":Defaults.token
    ]
    
}