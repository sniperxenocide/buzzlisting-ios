//
//  favPropertiesTable.swift
//  BuzzListing
//
//  Created by InfoSapex on 4/24/18.
//  Copyright © 2018 InfoSapex. All rights reserved.
//

import Foundation
import RealmSwift


class favPropertiesTable: Object {
    @objc dynamic var id = ""
    @objc dynamic var username = ""
    @objc dynamic var property_id = ""
    @objc dynamic var property_type = ""
    @objc dynamic var address = ""
    @objc dynamic var price = ""
    @objc dynamic var municipality_area = ""
    @objc dynamic var mls = ""
    @objc dynamic var typeInt = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
