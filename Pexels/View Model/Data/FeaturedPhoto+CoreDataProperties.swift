//
//  FeaturedPhoto+CoreDataProperties.swift
//  Pexels
//
//  Created by Kenes Yerassyl on 8/20/20.
//  Copyright © 2020 Tinker Tech. All rights reserved.
//
//

import Foundation
import CoreData


extension FeaturedPhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeaturedPhoto> {
        return NSFetchRequest<FeaturedPhoto>(entityName: "FeaturedPhoto")
    }

    @NSManaged public var id: Int64
    @NSManaged public var width: Float
    @NSManaged public var height: Float
    @NSManaged public var photographer: String?
    @NSManaged public var large: String?

}
