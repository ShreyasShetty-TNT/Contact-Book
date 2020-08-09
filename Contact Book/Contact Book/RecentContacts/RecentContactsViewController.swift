//
//  RecentContactsViewController.swift
//  Contact Book
//
//  Created by Shreyas Shetty on 08/08/20.
//  Copyright © 2020 Shreyas Shetty. All rights reserved.
//

import UIKit

class RecentContactsViewController: UIViewController {
	
	@IBOutlet weak var recentTableView: UITableView!
	var viewModel: RecentContactsViewModel?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
		setupContactList()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		viewModel?.updateRecentContacts()
		recentTableView.reloadData()
	}
	
	private func setupContactList() {
		viewModel = RecentContactsViewModel()
	}


	private func setupTableView() {
		recentTableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactTableViewCell")
		recentTableView.delegate = self
		recentTableView.dataSource = self
	}

}

extension RecentContactsViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel?.contacts.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as? ContactTableViewCell
		guard let contact = viewModel?.getContact(index: indexPath.row), let contactsCell = cell else {
			return UITableViewCell()
		}
		contactsCell.setupView(ContactViewModel(contact: contact))
		return contactsCell
	}


}

