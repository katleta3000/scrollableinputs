//
//  InputViewController.swift
//  ScrollableTextInput
//
//  Created by Evgenii Rtishchev on 07/02/2019.
//  Copyright © 2019 Evgenii Rtishchev. All rights reserved.
//

import UIKit

protocol InputViewControllerDelegate: class {
	func didBecomeActive(input: InputViewController)
	func didResignActive(input: InputViewController)
	func changedCursorRect(input: InputViewController, rect: CGRect)
}

final class InputViewController: UIViewController {
	@IBOutlet weak var textView: UITextView!
	weak var delegate: InputViewControllerDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		textView.font = UIFont.systemFont(ofSize: 48)
		textView.text = "Input your value here"
		textView.isScrollEnabled = false
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		preferredContentSize = CGSize(width: view.frame.size.width, height: textHeight())
		delegate?.changedCursorRect(input: self, rect: cursorRect())
	}
}

extension InputViewController: UITextViewDelegate {
	
	func textView(_ textView: UITextView, shouldChangeTextIn _: NSRange, replacementText text: String) -> Bool {
		let resultRange = text.rangeOfCharacter(from: CharacterSet.newlines, options: .backwards)
		if text.count == 1 && resultRange != nil {
			textView.resignFirstResponder()
			return false
		}
		return true
	}
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		delegate?.didBecomeActive(input: self)
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		delegate?.didResignActive(input: self)
	}
	
	func textViewDidChangeSelection(_ textView: UITextView) {
		delegate?.changedCursorRect(input: self, rect: cursorRect())
	}
}

extension InputViewController {
	
	func textHeight() -> CGFloat {
		let width = textView.frame.size.width
		let size = textView.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
		return size.height
	}
	
	func cursorRect() -> CGRect {
		if let position = textView.selectedTextRange?.end {
			return textView.caretRect(for: position)
		}
		return CGRect()
	}
}
