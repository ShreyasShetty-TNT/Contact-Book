//
//  ViewController.swift
//  Contact Book
//
//  Created by Shreyas Shetty on 06/08/20.
//  Copyright © 2020 Shreyas Shetty. All rights reserved.
//

import UIKit
import Contacts

class ContactsViewController: UIViewController {
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var contactsTableView: UITableView!
	var viewModel:ContactsViewModel?

	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
		setupContactList()
	}

	private func setupContactList() {
		viewModel = ContactsViewModel()
	}

	private func setupSearchBarDelegate() {
		self.searchBar.delegate = self
	}
	
	private func setupTableView() {
		contactsTableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactTableViewCell")
		contactsTableView.delegate = self
		contactsTableView.dataSource = self
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		viewModel = ContactsViewModel()
		contactsTableView.reloadData()
	}

	private func showActionAlert(contact: CNContact) {
		guard let contactNumber = contact.phoneNumbers.first?.value.stringValue else { return }
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		let callAction = UIAlertAction(title: "Call", style: .default) { [weak self] (_) in
			let phoneNumber = "tel://\(contactNumber)"
			guard let url = URL(string: phoneNumber) else {
				alertController.dismiss(animated: true, completion: nil)
				self?.updateRecentContacts(contact: contact)
				return
			}
			UIApplication.shared.canOpenURL(url)
			self?.updateRecentContacts(contact: contact)
		}
		
		let copyAction = UIAlertAction(title: "Copy", style: .default) { (_) in
			UIPasteboard.general.strings?.append(contactNumber)
			alertController.dismiss(animated: true, completion: nil)
			return
		}
		
		alertController.addAction(callAction)
		alertController.addAction(copyAction)
		present(alertController, animated: true, completion: nil)
	}

	private func updateRecentContacts(contact: CNContact) {
		RecentContactsManager.shared.saveRecentContact(contact: contact)
	}

	private func goToEditContact(contact: CNContact) {
		let viewModel = SaveContactViewModel(contact: contact)
		let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
		guard let saveContactViewController = storyboard.instantiateViewController(withIdentifier: "SaveContactViewController") as? SaveContactViewController else { return }
		saveContactViewController.viewModel = viewModel
		self.navigationController?.pushViewController(saveContactViewController, animated: true)
	}
}

// MARK: TableView Data source and delegate methods
extension ContactsViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel?.contacts.count ?? 0
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as? ContactTableViewCell
		guard let contact = viewModel?.getContact(index: indexPath.row), let contactsCell = cell else {
			return UITableViewCell()
		}
		contactsCell.setupView(ContactViewModel(contact: contact))
		return contactsCell
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let contact = viewModel?.getContact(index: indexPath.row)?.contactValue else { return }
		showActionAlert(contact: contact)
	}

	func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
		let delete = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] action, index in
			self?.viewModel?.deleteContact(index: index.row)
			self?.contactsTableView.reloadData()
		}
		
		let edit = UITableViewRowAction(style: .default, title: "Edit") { [weak self] action, index in
			guard let contact = self?.viewModel?.getContact(index: index.row)?.contactValue else { return }
			self?.goToEditContact(contact: contact)
			
		}
		edit.backgroundColor = .blue
		return [delete, edit]
	}

	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
}

// Search Bar delegate methods

extension ContactsViewController: UISearchBarDelegate {
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		
		guard let searchText = searchBar.text, !searchText.isEmpty  else {
			self.viewModel?.resetContactList()
			self.contactsTableView.reloadData()
			return
		}
		if let updatedContacts = viewModel?.contacts.filter({ (contact) -> Bool in
			return contact.givenName.contains(searchText)  || contact.familyName.contains(searchText)  || String(contact.emailAddresses.first?.value ?? "").contains(searchText)
		}) {
			self.viewModel?.updateSearchContacts(updatedContacts)
			self.contactsTableView.reloadData()
		}
	}

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
	
}
