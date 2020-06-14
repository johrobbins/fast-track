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

    // Enable for editing rows e.g delete
    //navigationItem.leftBarButtonItem = editButtonItem


    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return parcels.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ParcelCell", for: indexPath)

    let parcel = parcels[indexPath.row]
    cell.textLabel?.text = parcel.recipientName

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

  /*
  // Override to support rearranging the table view.
  override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

  }
  */

  /*
  // Override to support conditional rearranging of the table view.
  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
      // Return false if you do not want the item to be re-orderable.
      return true
  }
  */

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      // Get the new view controller using segue.destination.
      // Pass the selected object to the new view controller.
  }
  */

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
