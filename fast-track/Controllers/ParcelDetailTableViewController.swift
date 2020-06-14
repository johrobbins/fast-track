//
//  Created by Joh Robbins on 11/6/20.
//  Copyright © 2020 Joh Robbins. All rights reserved.
//

import UIKit

class ParcelDetailTableViewController: UITableViewController, UITextFieldDelegate {
  // Navigation
  @IBOutlet private var saveButton: UIBarButtonItem!

  // Section 0: Recipient
  @IBOutlet private var recipientNameTextField: UITextField!
  @IBOutlet private var recipientDeliveryAddressTextField: UITextField!

  // Section 1: Tracking Number
  @IBOutlet private var trackingNumberTextField: UITextField!

  // Section 2: Parcel Status
  @IBOutlet private var statusTextField: UITextField!
  @IBOutlet private var statusLastUpdateLabel: UILabel!
  @IBOutlet private var statusLastUpdateDatePicker: UIDatePicker!
  @IBOutlet private var deliveryDateLabel: UILabel!
  @IBOutlet private var deliveryDatePicker: UIDatePicker!

  // Section 3: Notes
  @IBOutlet private var notesTextView: UITextView!

  var parcel: Parcel?

  private var isStatusLastUpdateDatePickerHidden = true
  private let statusLastUpdateLabelIndexPath = IndexPath(row: 1, section: 2)
  private let statusLastUpdateDatePickerIndexPath = IndexPath(row: 2, section: 2)

  private var isDeliveryDatePickerHidden = true
  private let deliveryDateLabelIndexPath = IndexPath(row: 3, section: 2)
  private let deliveryDatePickerIndexPath = IndexPath(row: 4, section: 2)

  private let notesTextViewIndexPath = IndexPath(row: 0, section: 3)

  private let normalCellHeight: CGFloat = 44
  private let largeCellHeight: CGFloat = 200

  override func viewDidLoad() {
    super.viewDidLoad()

    if let parcel = parcel {
      navigationItem.title = "Edit Parcel"
      navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteTapped))

      recipientNameTextField.text = parcel.recipientName
      recipientDeliveryAddressTextField.text = parcel.deliveryAddress
      statusTextField.text = parcel.status
      updateDatePickerLabel(with: statusLastUpdateLabel, date: parcel.statusLastUpdate)
      statusLastUpdateDatePicker.date = parcel.statusLastUpdate
      trackingNumberTextField.text = parcel.tackingNumber

      if let deliveryDate = parcel.deliveryDateAndTime {
        updateDatePickerLabel(with: deliveryDateLabel, date: deliveryDate)
        deliveryDatePicker.date = deliveryDate
      }
      notesTextView.text = parcel.notes
    } else {
      navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
    }

    navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "PrimaryOverlay")
    updateSaveButtonState()
  }

  // MARK: - IBAction

  @IBAction func textEditingDidBegin(_ sender: UITextField) {
    hideStatusLastUpdateDatePickerIfRevelaed()
    hideDeliveryDatePickerIfRevelaed()
  }

  @IBAction func textEditingChanged(_ sender: UITextField) {
    updateSaveButtonState()
  }

  @IBAction func statusLastUpdateDatePickerChanged(_ sender: UIDatePicker) {
    statusLastUpdateLabel.text = Parcel.dateFormatter.string(from: statusLastUpdateDatePicker.date)
    statusLastUpdateLabel.isEnabled = true
    updateSaveButtonState()
  }

  @IBAction func deliveryDatePickerChanged(_ sender: UIDatePicker) {
    deliveryDateLabel.text = Parcel.dateFormatter.string(from: deliveryDatePicker.date)
    deliveryDateLabel.isEnabled = true
  }

  // MARK: - Table View Functions

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
      // Dismiss keyboard if presented
      self.view.endEditing(true)

      hideDeliveryDatePickerIfRevelaed()
      isStatusLastUpdateDatePickerHidden = !isStatusLastUpdateDatePickerHidden
      updateDatePickerCell(label: statusLastUpdateLabel, with: isStatusLastUpdateDatePickerHidden)
    case deliveryDateLabelIndexPath:
      // Dismiss keyboard if presented
      self.view.endEditing(true)

      hideStatusLastUpdateDatePickerIfRevelaed()
      isDeliveryDatePickerHidden = !isDeliveryDatePickerHidden
      updateDatePickerCell(label: deliveryDateLabel, with: isDeliveryDatePickerHidden)
    default:
      break
    }
  }

  // MARK: - Segue Handler

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)

    guard segue.identifier == "saveUnwind" else { return }

    parcel = Parcel(
      recipientName: recipientNameTextField.text!,
      deliveryAddress: recipientDeliveryAddressTextField.text!,
      status: statusTextField.text!,
      statusLastUpdate: statusLastUpdateDatePicker.date,
      tackingNumber: trackingNumberTextField.text,
      deliveryDateAndTime: deliveryDateLabel.isEnabled ? deliveryDatePicker.date : nil,
      notes: notesTextView.text)
  }

  // MARK: - UITextFieldDelegate

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()

    switch textField {
    case recipientNameTextField:
      recipientDeliveryAddressTextField.becomeFirstResponder()
    case recipientDeliveryAddressTextField:
      trackingNumberTextField.becomeFirstResponder()
    case trackingNumberTextField:
      statusTextField.becomeFirstResponder()
    case statusTextField:
      isStatusLastUpdateDatePickerHidden = false
      updateDatePickerCell(label: statusLastUpdateLabel, with: isStatusLastUpdateDatePickerHidden)
    default:
      break
    }
    return true
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else {
      return false
    }

    var maxCharacters = 100
    let substringToReplace = textFieldText[rangeOfTextToReplace]
    let count = textFieldText.count - substringToReplace.count + string.count

    switch textField {
    case trackingNumberTextField:
      maxCharacters = 40
    case statusTextField:
      maxCharacters = 10
    default:
      break
    }

    return count <= maxCharacters
  }

  // MARK: - Private Functions

  @objc private func cancelTapped(_ sender: Any) {
    performSegue(withIdentifier: "cancelUnwind", sender: sender)
  }

  @objc private func deleteTapped(_ sender: Any) {
    let message = "Are you sure you want to permanently delete this parcel?"
    let alertController = UIAlertController(title: "Delete Parcel", message: message, preferredStyle: .alert)
    let deleteAction = UIAlertAction(title: "Delete", style: .default) { _ in
      self.performSegue(withIdentifier: "deleteUnwind", sender: sender)
    }
    deleteAction.setValue(UIColor.red, forKey: "titleTextColor")
    alertController.addAction(deleteAction)
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

    self.present(alertController, animated: true, completion: nil)
  }

  private func updateSaveButtonState() {
    let recipientName = recipientNameTextField.text ?? ""
    let recipientAddress = recipientDeliveryAddressTextField.text ?? ""
    let parcelStatus = statusTextField.text ?? ""

    saveButton.isEnabled = !recipientName.isEmpty && !recipientAddress.isEmpty && !parcelStatus.isEmpty && statusLastUpdateLabel.isEnabled
  }

  private func updateDatePickerLabel(with label: UILabel, date: Date) {
    label.text = Parcel.dateFormatter.string(from: date)
    label.isEnabled = true
  }
  
  private func updateDatePickerCell(label: UILabel, with isCellHidden: Bool) {
    label.textColor = isCellHidden ? UIColor(named: "TextMediumEmphasis") : tableView.tintColor
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
