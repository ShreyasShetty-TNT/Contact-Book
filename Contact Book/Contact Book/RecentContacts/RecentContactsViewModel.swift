//
//  RecentContactsViewModel.swift
//  Contact Book
//
//  Created by Shreyas Shetty on 08/08/20.
//  Copyright © 2020 Shreyas Shetty. All rights reserved.
//

import Foundation
import Contacts

class RecentContactsViewModel {
	var contacts: [CNContact]
	private var recentContactsManager: RecentContactsManager

	init(recentContactsManager: RecentContactsManager = .shared) {
		self.recentContactsManager = recentContactsManager
		self.contacts = recentContactsManager.getRecentContacts()
	}

	func updateRecentContacts() {
		self.contacts = recentContactsManager.getRecentContacts()
	}
	
	func getContact(index: Int) -> Contact? {
		return Contact(contact: contacts[index])
	}
}
