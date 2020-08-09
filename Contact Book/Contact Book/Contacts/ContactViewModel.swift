//
//  ContactViewModel.swift
//  Contact Book
//
//  Created by Shreyas Shetty on 06/08/20.
//  Copyright © 2020 Shreyas Shetty. All rights reserved.
//

import Foundation
import UIKit

class ContactViewModel {
	private var contact: Contact
	var contactName: String {
		return contact.firstName + " " + contact.lastName
	}
	var contactNumber: String {
		return contact.phoneNumberField?.value.stringValue ?? ""
	}
	var profilePicture: UIImage?
	
	init(contact: Contact) {
		self.contact = contact
	}
}



