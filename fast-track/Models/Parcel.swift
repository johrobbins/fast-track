//
//  Created by Joh Robbins on 8/6/20.
//  Copyright © 2020 Joh Robbins. All rights reserved.
//

import Foundation

struct Parcel: Codable {
  var tackingNumber: String
  var recipientName: String
  var deliveryAddress: String
  var deliveryDateAndTime: Date
  var status: DeliveryStatus
  var statusLastUpdate: Date
  var notes: String
}

enum DeliveryStatus: String, Codable {
  case delivered
  case onRoute
  case none
}
