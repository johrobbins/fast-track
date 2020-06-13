//
//  ParcelDetailsTableViewController.swift
//  fast-track
//
//  Created by Joh Robbins on 11/6/20.
//  Copyright © 2020 Joh Robbins. All rights reserved.
//

import UIKit

class ParcelDetailTableViewController: UITableViewController {
  // Navigation
  @IBOutlet private var saveButton: UIBarButtonItem!

  // Recipient
  @IBOutlet private var recipientNameTextField: UITextField!
  @IBOutlet private var recipientAddressTextField: UITextField!

  // Parcel Status
  @IBOutlet private var statusTextField: UITextField!
  @IBOutlet private var statusLastUpdateLabel: UILabel!
  @IBOutlet private var statusLastUpdateDatePicker: UIDatePicker!

  // Delivery
  @IBOutlet private var trackingNumberTextField: UITextField!
  @IBOutlet private var deliveryDateLabel: UILabel!
  @IBOutlet private var deliveryDatePicker: UIDatePicker!

  // Notes
  @IBOutlet private var notesTextView: UITextView!

  var parcel: Parcel?

  private var statusLastUpdateHasBeenSet = false
  private var isStatusLastUpdateDatePickerHidden = true
  private let statusLastUpdateLabelIndexPath = IndexPath(row: 1, section: 1)
  private let statusLastUpdateDatePickerIndexPath = IndexPath(row: 2, section: 1)

  private var deliveryDateHasBeenSet = false
  private var isDeliveryDatePickerHidden = true
  private let deliveryDateLabelIndexPath = IndexPath(row: 1, section: 2)
  private let deliveryDatePickerIndexPath = IndexPath(row: 2, section: 2)

  private let notesTextViewIndexPath = IndexPath(row: 0, section: 3)

  private let normalCellHeight: CGFloat = 44
  private let largeCellHeight: CGFloat = 200

  override func viewDidLoad() {
    super.viewDidLoad()

    if let parcel = parcel {
      recipientNameTextField.text = parcel.recipientName
      recipientAddressTextField.text = parcel.deliveryAddress
      statusTextField.text = parcel.status
      updateDatePickerLabel(label: statusLastUpdateLabel, date: parcel.statusLastUpdate)
      statusLastUpdateHasBeenSet = true
      statusLastUpdateDatePicker.date = parcel.statusLastUpdate
      trackingNumberTextField.text = parcel.tackingNumber
      if let deliveryDate = parcel.deliveryDateAndTime {
        updateDatePickerLabel(label: deliveryDateLabel, date: deliveryDate)
        deliveryDateHasBeenSet = true
        deliveryDatePicker.date = deliveryDate
      }
      notesTextView.text = parcel.notes
    }

    updateSaveButtonState()
  }

  @IBAction func textEditingDidBegin(_ sender: UITextField) {
    hideStatusLastUpdateDatePickerIfRevelaed()
    hideDeliveryDatePickerIfRevelaed()
  }

  @IBAction func textEditingChanged(_ sender: UITextField) {
    updateSaveButtonState()
  }

  @IBAction func statusLastUpdateDatePickerChanged(_ sender: UIDatePicker) {
    statusLastUpdateHasBeenSet = true
    updateDatePickerLabel(label: statusLastUpdateLabel, date: statusLastUpdateDatePicker.date)
  }

  @IBAction func deliveryDatePickerChanged(_ sender: UIDatePicker) {
    deliveryDateHasBeenSet = true
    updateDatePickerLabel(label: deliveryDateLabel, date: deliveryDatePicker.date)
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath {
    case statusLastUpdateDatePickerIndexPath:
      return isStatusLastUpdateDatePickerHidden ? 0 : statusLastUpdateDatePicker.frame.height
    case deliveryDatePickerIndexPath:
      return isDeliveryDatePickerHidden ? 0 : deliveryDatePicker.frame.height
    case notesTextViewIndexPath:
      return largeCellHeight
    default:
      return normalCellHeight
    }
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    switch indexPath {
    case statusLastUpdateLabelIndexPath:
      hideDeliveryDatePickerIfRevelaed()
      isStatusLastUpdateDatePickerHidden = !isStatusLastUpdateDatePickerHidden
      updateDatePickerCell(label: statusLastUpdateLabel, with: isStatusLastUpdateDatePickerHidden)
    case deliveryDateLabelIndexPath:
      hideStatusLastUpdateDatePickerIfRevelaed()
      isDeliveryDatePickerHidden = !isDeliveryDatePickerHidden
      updateDatePickerCell(label: deliveryDateLabel, with: isDeliveryDatePickerHidden)
    default:
      break
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)

    guard segue.identifier == "saveUnwind" else { return }

    parcel = Parcel(
      recipientName: recipientNameTextField.text!,
      deliveryAddress: recipientAddressTextField.text!,
      status: statusTextField.text!,
      statusLastUpdate: statusLastUpdateDatePicker.date,
      tackingNumber: trackingNumberTextField.text,
      deliveryDateAndTime: deliveryDateHasBeenSet ? deliveryDatePicker.date : nil,
      notes: notesTextView.text)
  }

  private func updateSaveButtonState() {
    let recipientName = recipientNameTextField.text ?? ""
    let recipientAddress = recipientAddressTextField.text ?? ""
    let parcelStatus = statusTextField.text ?? ""

    saveButton.isEnabled = !recipientName.isEmpty && !recipientAddress.isEmpty && !parcelStatus.isEmpty && statusLastUpdateHasBeenSet
  }

  private func updateDatePickerLabel(label: UILabel, date: Date) {
    label.text = Parcel.dateFormatter.string(from: date)
    label.font = label.font.withSize(16)
    updateSaveButtonState()
  }

  private func updateDatePickerCell(label: UILabel, with isCellHidden: Bool) {
    label.textColor = isCellHidden ? .darkGray : tableView.tintColor
    tableView.beginUpdates()
    tableView.endUpdates()
  }

  private func hideStatusLastUpdateDatePickerIfRevelaed() {
    if(!isStatusLastUpdateDatePickerHidden) {
      isStatusLastUpdateDatePickerHidden = true
      updateDatePickerCell(label: statusLastUpdateLabel, with: isStatusLastUpdateDatePickerHidden)
    }
  }

  private func hideDeliveryDatePickerIfRevelaed() {
    if(!isDeliveryDatePickerHidden) {
      isDeliveryDatePickerHidden = true
      updateDatePickerCell(label: deliveryDateLabel, with: isDeliveryDatePickerHidden)
    }
  }
}
