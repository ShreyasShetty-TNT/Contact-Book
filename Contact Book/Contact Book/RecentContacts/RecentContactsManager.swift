//
//  RecentContactsManager.swift
//  Contact Book
//
//  Created by Shreyas Shetty on 08/08/20.
//  Copyright © 2020 Shreyas Shetty. All rights reserved.
//

import Foundation
import Contacts

class RecentContactsManager {
	static let shared = RecentContactsManager()
	private let key = "RecentsContacts"
	private let maxContactsToStore = 30
	private var contactLists = [CNContact]()

	  func getRecentContacts() -> [CNContact] {
		if let storedData = UserDefaults.standard.object(forKey: key) as? Data {
			if let contacts = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(storedData) as? [CNContact] {
				contactLists = contacts
			}
		}
		return contactLists.reversed()
	}

	func saveRecentContact( contact: CNContact) {
		if contactLists.count > maxContactsToStore {
			contactLists.removeLast()
		}
		contactLists.append(contact)
		if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: contactLists, requiringSecureCoding: true) {
			UserDefaults.standard.set(savedData, forKey: key)
		}
	}
}
