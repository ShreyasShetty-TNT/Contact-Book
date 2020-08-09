//
//  PhoneContacts.swift
//  Contact Book
//
//  Created by Shreyas Shetty on 07/08/20.
//  Copyright © 2020 Shreyas Shetty. All rights reserved.
//

import Foundation
import Contacts
import UIKit

class PhoneContacts {
	static let shared = PhoneContacts()
	private let contactStore = CNContactStore()
	private var isAccessGranted = false
	
	init() {
		checkContactsAccess()
	}
	
	private func checkContactsAccess() {
		switch CNContactStore.authorizationStatus(for: .contacts) {
			
		case .notDetermined :
			self.requestContactsAccess()
			
		case .denied, .restricted:
			print("contacts access error")
		case .authorized:
			isAccessGranted = true
		@unknown default:
			break
		}
	}
	
	private func requestContactsAccess() {
		contactStore.requestAccess(for: .contacts) { [weak self] granted, error in
			self?.isAccessGranted = granted
		}
	}
	
	func getContactList() -> [CNContact] {
		guard isAccessGranted else { return [] }
		let keysToFetch = [
			CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
			CNContactPhoneNumbersKey,
			CNContactEmailAddressesKey,
			CNContactThumbnailImageDataKey] as [Any]
		
		var allContainers: [CNContainer] = []
		do {
			allContainers = try contactStore.containers(matching: nil)
		} catch {
			print("Error fetching containers")
		}
		
		var results: [CNContact] = []
		
		for container in allContainers {
			let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
			
			do {
				let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
				results.append(contentsOf: containerResults)
			} catch {
				print("Error fetching containers")
			}
		}
		return results
	}
	
	func deleteContact(id: String) {
		let toFetch = [CNContactEmailAddressesKey] as [CNKeyDescriptor]
		let contact = try? contactStore.unifiedContact(withIdentifier: id, keysToFetch: toFetch)
		let request = CNSaveRequest()
		guard let mutableContact = contact?.mutableCopy() as? CNMutableContact else { return }
		request.delete(mutableContact)
		do {
			try contactStore.execute(request)
		} catch let error {
			print(error.localizedDescription)
		}
	}
	
	func saveContact(firstName: String, lastName: String,phoneNumber: String, emailAddress: String, completionHandler: ()->()) {
		let newContact = CNMutableContact()
		newContact.givenName = firstName
		newContact.familyName = lastName
		let contactNumber = CNLabeledValue(label: CNLabelWork, value: CNPhoneNumber(stringValue: phoneNumber))
		newContact.phoneNumbers = [contactNumber]
		let email = CNLabeledValue(label: CNLabelWork, value: NSString(string: emailAddress))
		newContact.emailAddresses = [email]
		
		let request = CNSaveRequest()
		request.add(newContact, toContainerWithIdentifier: nil)
		do {
			try contactStore.execute(request)
		} catch let error {
			print(error.localizedDescription)
		}
		completionHandler()
	}

	func updateContact(contact: CNContact, firstName: String? = nil, lastName: String? = nil, phoneNumber: String? = nil, emailAddress: String? = nil, completionHandler: ()->()) {
		let predicate =  CNContact.predicateForContacts(matchingName: contact.givenName)
		let keysToFetch = [
		CNContactGivenNameKey,
		CNContactFamilyNameKey,
		CNContactPhoneNumbersKey,
		CNContactEmailAddressesKey,
		CNContactThumbnailImageDataKey] as [CNKeyDescriptor]
		let unifiedContact = try? contactStore.unifiedContacts(matching: predicate, keysToFetch: keysToFetch).first
		guard let mutableContact = unifiedContact?.mutableCopy() as? CNMutableContact else { return }

		// Update firstName
		if let updatedFirstName = firstName {
			mutableContact.givenName = updatedFirstName
		}
		// Update lastName
		if let updatedLastName = lastName {
			mutableContact.familyName = updatedLastName
		}
		// update phoneNumber
		if let updatedPhoneNumber = phoneNumber {
			let contactNumber = CNLabeledValue(label: CNLabelWork, value: CNPhoneNumber(stringValue: updatedPhoneNumber))
			mutableContact.phoneNumbers = [contactNumber]
		}
		// update email
		if let updatedEmail = emailAddress {
			let email = CNLabeledValue(label: CNLabelWork, value: NSString(string: updatedEmail))
			mutableContact.emailAddresses = [email]
		}

		let request = CNSaveRequest()
		request.update(mutableContact)
		do {
			try contactStore.execute(request)
		} catch let error {
			print(error.localizedDescription)
		}
		completionHandler()
	}
}
