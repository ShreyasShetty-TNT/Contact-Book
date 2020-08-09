//
//  Contact.swift
//  Contact Book
//
//  Created by Shreyas Shetty on 06/08/20.
//  Copyright © 2020 Shreyas Shetty. All rights reserved.
//

import UIKit
import Contacts

class Contact {
	
	let firstName: String
	let lastName: String
	let workEmail: String
	var identifier: String?
	let profilePicture: UIImage?
	var phoneNumberField: (CNLabeledValue<CNPhoneNumber>)?
	
	private init(firstName: String, lastName: String, workEmail: String, profilePicture: UIImage?, identifier: String? = nil, phoneNumberField: (CNLabeledValue<CNPhoneNumber>)? = nil ){
		self.firstName = firstName
		self.lastName = lastName
		self.workEmail = workEmail
		self.profilePicture = profilePicture
		self.phoneNumberField = phoneNumberField
		self.identifier = identifier
	}

	var contactValue: CNContact {
	  let contact = CNMutableContact()
	  contact.givenName = firstName
	  contact.familyName = lastName
	  contact.emailAddresses = [CNLabeledValue(label: CNLabelWork, value: workEmail as NSString)]
	  if let profilePicture = profilePicture {
		let imageData = profilePicture.jpegData(compressionQuality: 1)
		contact.imageData = imageData
	  }
	  if let phoneNumberField = phoneNumberField {
		contact.phoneNumbers.append(phoneNumberField)
	  }
	  return contact.copy() as! CNContact
	}
	
	convenience init?(contact: CNContact) {
	  guard let email = contact.emailAddresses.first else { return nil }
		let firstName = contact.givenName
		let lastName = contact.familyName
		let workEmail = email.value as String
		let id = contact.identifier
		var profilePicture: UIImage?
		if let imageData = contact.thumbnailImageData {
			profilePicture = UIImage(data: imageData)
		}
		self.init(firstName: firstName, lastName: lastName, workEmail: workEmail, profilePicture: profilePicture,identifier:id)
		if let contactPhone = contact.phoneNumbers.first {
			phoneNumberField = contactPhone
		}
	}
}
