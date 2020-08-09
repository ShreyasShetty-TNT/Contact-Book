//
//  ContactTableViewCell.swift
//  Contact Book
//
//  Created by Shreyas Shetty on 06/08/20.
//  Copyright © 2020 Shreyas Shetty. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
	
	@IBOutlet private weak var phoneNumber: UILabel!
	@IBOutlet private weak var name: UILabel!
	@IBOutlet private weak var contactProfilePicture: UIImageView!

	private var viewModel: ContactViewModel? {
		didSet {
			self.phoneNumber.text = viewModel?.contactNumber
			self.name.text = viewModel?.contactName
			if let profileImage = viewModel?.profilePicture {
				self.contactProfilePicture.image = profileImage
			}
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	func setupView(_ contact: ContactViewModel) {
		self.viewModel = contact
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
	
}
