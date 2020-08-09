//
//  ContactsViewModel.swift
//  Contact Book
//
//  Created by Shreyas Shetty on 07/08/20.
//  Copyright © 2020 Shreyas Shetty. All rights reserved.
//

import Foundation
import Contacts

class ContactsViewModel {
	var contacts:[CNContact]
	private var phoneContacts: PhoneContacts

	init(phoneContacts: PhoneContacts = .shared) {
		self.phoneContacts = phoneContacts
		self.contacts = self.phoneContacts.getContactList()
	}

	func getContact(index: Int) -> Contact? {
		return Contact(contact: contacts[index])
	}
	
	func deleteContact(index: Int) {
		guard let contact = getContact(index: index)?.identifier else { return }
		phoneContacts.deleteContact(id: contact)
		self.contacts = self.phoneContacts.getContactList()
	}

	func resetContactList() {
		self.contacts = self.phoneContacts.getContactList()
	}

	func updateSearchContacts(_ contacts: [CNContact]) {
		self.contacts.removeAll()
		self.contacts = contacts
	}

}

