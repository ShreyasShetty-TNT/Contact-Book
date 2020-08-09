//
//  SaveContactViewModel.swift
//  Contact Book
//
//  Created by Shreyas Shetty on 08/08/20.
//  Copyright © 2020 Shreyas Shetty. All rights reserved.
//

import Foundation
import Contacts

class SaveContactViewModel {
	private var contact: CNContact?
	private var phoneContacts: PhoneContacts

	init(phoneContacts: PhoneContacts = .shared, contact: CNContact? = nil) {
		self.phoneContacts = phoneContacts
		self.contact = contact
	}

	func getContact() -> CNContact? {
		return contact
	}

	func updateContact(firstName: String? = nil, lastName: String? = nil, phoneNumber: String? = nil, emailAddress: String? = nil, completionHandler: ()->()) {
		guard let contact = self.contact else { return }
		phoneContacts.updateContact(contact: contact, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, emailAddress: emailAddress, completionHandler: completionHandler)
	}

	func addContact(firstName: String, lastName: String,phoneNumber: String, emailAddress: String, completionHandler: ()->()) {
		phoneContacts.saveContact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, emailAddress: emailAddress, completionHandler: completionHandler)
	}
}
