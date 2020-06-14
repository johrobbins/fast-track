//
//  Created by Joh Robbins on 8/6/20.
//  Copyright © 2020 Joh Robbins. All rights reserved.
//

import UIKit

class ParcelListTableViewController: UITableViewController {
  private var parcels = [Parcel]()

  override func viewDidLoad() {
    super.viewDidLoad()

    if let savedParcels = Parcel.loadParcels() {
      parcels = savedParcels
    } else {
      parcels = Parcel.loadSampleParcels()
    }
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return parcels.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: ParcelTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ParcelCell", for: indexPath) as! ParcelTableViewCell
    let parcel = parcels[indexPath.row]

    cell.update(with: parcel)

    return cell
  }

  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      return true
  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        parcels.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        Parcel.saveParcels(parcels)
      }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "EditParcel",
    let navController = segue.destination as? UINavigationController,
    let parcelDetailViewController = navController.topViewController as?
      ParcelDetailTableViewController {
      let indexPath = tableView.indexPathForSelectedRow!
      let selectedParcel = parcels[indexPath.row]
      parcelDetailViewController.parcel = selectedParcel
    }
  }

  // MARK: - IBActions
  @IBAction func unwindToParcelList(segue: UIStoryboardSegue) {
    guard segue.identifier == "saveUnwind" || segue.identifier == "deleteUnwind" else { return }
    let sourceViewController = segue.source as! ParcelDetailTableViewController

    if let parcel = sourceViewController.parcel {
      if let selectedIndexPath = tableView.indexPathForSelectedRow {
        if segue.identifier == "saveUnwind" {
          parcels[selectedIndexPath.row] = parcel
          tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else if segue.identifier == "deleteUnwind" {
          parcels.remove(at: selectedIndexPath.row)
          tableView.deleteRows(at: [selectedIndexPath], with: .none)
        }
      } else {
        let newIndexPath =  IndexPath(row: parcels.count, section: 0)
        parcels.append(parcel)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
      }
    }
    Parcel.saveParcels(parcels)
  }
}
