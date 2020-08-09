//
//  SaveContactViewController.swift
//  Contact Book
//
//  Created by Shreyas Shetty on 08/08/20.
//  Copyright © 2020 Shreyas Shetty. All rights reserved.
//

import UIKit
import Contacts

class SaveContactViewController: UIViewController {
	@IBOutlet weak var firstNameTextFeild: UITextField!
	@IBOutlet weak var lastNameTextFeild: UITextField!
	@IBOutlet weak var emailTextFeild: UITextField!
	@IBOutlet weak var contactNumberTextFeild: UITextField!
	
	@IBOutlet weak var saveButton: UIButton!
	var viewModel: SaveContactViewModel?
	
	convenience init() {
		self.init()
	}

	required init?(coder: NSCoder) {
		self.viewModel = SaveContactViewModel()
		super.init(coder: coder)
	}

	override func viewDidLoad() {
        super.viewDidLoad()
		updateTextFeilds()
		enableSaveButtonIfNeeded()
    }
	
	// Tap gesture to dismiss the keyboard when taped outside the keyboard
	private func addTapGesture() {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
		view.addGestureRecognizer(tapGesture)
	}

	@objc
	private func hideKeyboard() {
		view.endEditing(true)
		enableSaveButtonIfNeeded()
	}
	
	private func updateTextFeilds() {
		guard let contact = viewModel?.getContact() else { return }
		firstNameTextFeild.text = contact.givenName
		lastNameTextFeild.text = contact.familyName
		emailTextFeild.text = String(contact.emailAddresses.first?.value ?? "")
		contactNumberTextFeild.text = contact.phoneNumbers.first?.value.stringValue ?? ""
	}

	@IBAction func saveClicked(_ sender: Any) {
		if let _ = viewModel?.getContact() {
			viewModel?.updateContact(firstName: firstNameTextFeild.text, lastName: lastNameTextFeild.text, phoneNumber: contactNumberTextFeild.text, emailAddress: emailTextFeild.text, completionHandler: {
				self.navigationController?.popViewController(animated: true)
			})
		} else {
			viewModel?.addContact(firstName: firstNameTextFeild.text ?? "", lastName: lastNameTextFeild.text ?? "", phoneNumber: contactNumberTextFeild.text ?? "", emailAddress: emailTextFeild.text ?? "", completionHandler: {
				self.navigationController?.popViewController(animated: true)
			})
		}
	}

	private func enableSaveButtonIfNeeded() {
		let shouldEnable = !(firstNameTextFeild.text?.isEmpty ?? true)  && !(contactNumberTextFeild.text?.isEmpty ?? true)
		saveButton.isEnabled = shouldEnable
	}
}

// TextFeild Delegate methods

extension SaveContactViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}

	func textFieldDidEndEditing(_ textField: UITextField) {
		enableSaveButtonIfNeeded()
	}
}
