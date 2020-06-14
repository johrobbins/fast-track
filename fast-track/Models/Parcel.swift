//
//  Created by Joh Robbins on 8/6/20.
//  Copyright © 2020 Joh Robbins. All rights reserved.
//

import Foundation

struct Parcel: Codable {
  var recipientName: String
  var deliveryAddress: String
  var status: String
  var statusLastUpdate: Date
  var tackingNumber: String?
  var deliveryDateAndTime: Date?
  var notes: String?

  static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  static let ArchiveURL = DocumentsDirectory.appendingPathComponent("parcels").appendingPathExtension("plist")

  static func loadParcels() -> [Parcel]? {
    guard let codedParcel = try? Data(contentsOf: ArchiveURL) else { return nil }
    let propertyListDecoder = PropertyListDecoder()

    return try? propertyListDecoder.decode(Array<Parcel>.self, from: codedParcel)
  }

  static func saveParcels(_ parcels: [Parcel]) {
    let propertyListEncoder = PropertyListEncoder()
    let codedParcels = try? propertyListEncoder.encode(parcels)
    try? codedParcels?.write(to: ArchiveURL, options: .noFileProtection)
  }

  static func loadSampleParcels() -> [Parcel] {
    let parcel1 = Parcel(
      recipientName: "Jane Smith",
      deliveryAddress: "37 Main Street, Norwood, SA",
      status: "Dispatched",
      statusLastUpdate: dateFormatter.date(from: "15/06/20, 10:00 AM")!,
      tackingNumber: "FT82342918",
      deliveryDateAndTime: nil,
      notes: "Leave behind side gate")

    let parcel2 = Parcel(
      recipientName: "Mike Jones",
      deliveryAddress: "88 George Street, Gold Coast, QLD",
      status: "Delivered",
      statusLastUpdate: dateFormatter.date(from: "07/06/20, 01:15 PM")!,
      tackingNumber: "FT23412386",
      deliveryDateAndTime: dateFormatter.date(from: "15/06/20, 09:45 AM")!,
      notes: "")

    return [parcel1, parcel2]
  }

  static let dateFormatter: DateFormatter  = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yy, hh:mm a"
    return formatter
  }()
}
