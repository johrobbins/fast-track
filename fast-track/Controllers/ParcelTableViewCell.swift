//
//  Created by Joh Robbins on 14/6/20.
//  Copyright © 2020 Joh Robbins. All rights reserved.
//

import UIKit

class ParcelTableViewCell: UITableViewCell {
  @IBOutlet private var recipientNameLabel: UILabel!
  @IBOutlet private var recipientAddressLabel: UILabel!
  @IBOutlet weak var parcelStatusLabel: UILabel!

  func update(with parcel: Parcel) {
    recipientNameLabel.text = parcel.recipientName
    recipientAddressLabel.text = parcel.deliveryAddress
    parcelStatusLabel.text = parcel.status
  }
}
