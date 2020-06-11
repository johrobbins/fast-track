//
//  ParcelDetailsTableViewController.swift
//  fast-track
//
//  Created by Joh Robbins on 11/6/20.
//  Copyright © 2020 Joh Robbins. All rights reserved.
//

import UIKit

class ParcelDetailsTableViewController: UITableViewController {

  @IBOutlet private var recipientNameTextField: UITextField!
  @IBOutlet private var recipientAddressTextField: UITextField!

  @IBOutlet private var parcelStatusTextField: UITextField!
  @IBOutlet private var parcelStatusLastUpdateLabel: UILabel!
  @IBOutlet private var parcelStatusLastUpdateDatePicker: UIDatePicker!

  @IBOutlet private var trackingNumberTextField: UITextField!
  @IBOutlet private var deliveryDateLabel: UILabel!
  @IBOutlet private var deliveryDateDatePicker: UIDatePicker!

  @IBOutlet private var notesTextView: UITextView!

  @IBOutlet private var saveButton: UIBarButtonItem!


  override func viewDidLoad() {
    super.viewDidLoad()
    updateSaveButtonState()
  }

  private func updateSaveButtonState() {
    let recipientName = recipientNameTextField.text ?? ""
    let recipientAddress = recipientAddressTextField.text ?? ""
    let parcelStatus = parcelStatusTextField.text ?? ""

    saveButton.isEnabled = !recipientName.isEmpty && !recipientAddress.isEmpty && !parcelStatus.isEmpty
  }

  @IBAction func textEditingChanged(_ sender: Any) {
    updateSaveButtonState()
  }
}
