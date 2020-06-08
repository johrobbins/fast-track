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

  static func loadParcels() -> [Parcel]? {
    return nil
  }

  static func loadSampleParcels() -> [Parcel] {
    let parcel1 = Parcel(
      tackingNumber: "FT123",
      recipientName: "John Smith",
      deliveryAddress: "37 Main Street, Norwood, SA",
      deliveryDateAndTime: Date(),
      status: DeliveryStatus.onRoute,
      statusLastUpdate: Date(),
      notes: "Leave behind side gate")

    let parcel2 = Parcel(
    tackingNumber: "FT234",
    recipientName: "Mike Jones",
    deliveryAddress: "88 George Street, Gold Coast, QLD",
    deliveryDateAndTime: Date(),
    status: DeliveryStatus.delivered,
    statusLastUpdate: Date(),
    notes: "")

    return [parcel1, parcel2]
  }
}

enum DeliveryStatus: String, Codable {
  case delivered
  case onRoute
  case none
}
