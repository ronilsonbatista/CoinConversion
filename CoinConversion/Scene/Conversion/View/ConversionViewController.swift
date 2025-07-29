//
//  ConversionViewController.swift
//  CoinConversion
//
//  Created by Ronilson Batista on 18/07/20.
//  Copyright © 2020 Ronilson Batista. All rights reserved.
//

import UIKit

// MARK: - Main
class ConversionViewController: UIViewController {
    
    private let customView = ConversionView()
    private var presenter: ConversionPresenting
    private var currentString = ""
    
    // MARK: - Init
    init(presenter: ConversionPresenting) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UIViewController lifecycle
extension ConversionViewController {
    override func loadView() {
        self.view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .colorBackground
        
        setupNavigationBar()
        setupBarButton()
        addDoneButtonOnKeyboard()
        
        presenter.delegate = self
        presenter.fetchQuotes(isRefresh: false)
        
        toViewTapGestureRecognizer(customView.toView)
        fromViewTapGestureRecognizer(customView.fromView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Private methods
extension ConversionViewController {
    private func setupNavigationBar() {
        configureNavigationBar(largeTitleColor: .white,
                               backgoundColor: .colorDarkishPink,
                               tintColor: .white,
                               title: "Conversão",
                               preferredLargeTitle: true,
                               isSearch: false,
                               searchController: nil
        )
    }
    
    private func setupBarButton() {
        let button = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(self.refreshButtonTouched)
        )
        button.tintColor = .white
        navigationItem.rightBarButtonItem = button
    }
    
    @objc private dynamic func refreshButtonTouched() {
        presenter.fetchQuotes(isRefresh: true)
    }
    
    private func doLoading(action: UIAlertAction) {
        presenter.fetchQuotes(isRefresh: true)
    }
    
    private func toViewTapGestureRecognizer(_ view: UIView) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizedToView(sender:)))
        view.addGestureRecognizer(gesture)
    }
    
    private func fromViewTapGestureRecognizer(_ view: UIView) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizedFromView(sender:)))
        view.addGestureRecognizer(gesture)
    }
    
    @objc private dynamic func tapGestureRecognizedToView(sender: UITapGestureRecognizer) {
        presenter.fetchCurrencies(.to)
    }
    
    @objc private dynamic func tapGestureRecognizedFromView(sender: UITapGestureRecognizer) {
        presenter.fetchCurrencies(.from)
    }
    
    @objc private func keyboardWillShow(notification:NSNotification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        
        var keyboardFrame:CGRect = (
            userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        ).cgRectValue
        keyboardFrame = view.convert(keyboardFrame, from: nil)
        
        var contentInset: UIEdgeInsets = customView.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        customView.scrollView.contentInset = contentInset
    }
    
    @objc private func keyboardWillHide(notification:NSNotification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        customView.scrollView.contentInset = contentInset
    }
    
    private func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(
            frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        )
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        let done: UIBarButtonItem = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(self.doneButtonAction)
        )
        done.title = "Ok"
        done.tintColor = .colorDarkishPink
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        customView.valueTextField.inputAccessoryView = doneToolbar
    }
    
    @objc private func doneButtonAction() {
        customView.valueTextField.resignFirstResponder()
    }
}
// MARK: - UITextFieldDelegate
extension ConversionViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let fromCode = customView.fromCurrencyCodeLabel.text,
              let toCode = customView.toCurrencyCodeLabel.text  else {
            return true
        }
        
        if (textField.text!.count <= 30 && string == "") || (textField.text!.count < 30 && string != "") {
            switch string {
            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                currentString += string
                formatCurrency(currentString, textField: textField, currencyCode: fromCode)
            default:
                if string.count == 0 && currentString.count != 0 {
                    currentString = String(currentString.dropLast())
                    formatCurrency(currentString, textField: textField, currencyCode: fromCode)
                }
            }
        }
        presenter.fetchConvert(fromCode: fromCode, toCode: toCode, value: currentString)
        return false
    }
}


// MARK: - Format Currency
extension ConversionViewController {
    private func formatCurrency(_ string: String, textField: UITextField, currencyCode: String) {
        if let formatCurrency = presenter.formatCurrency(currencyCode: currencyCode, amount: string) {
            textField.text = formatCurrency
        }
    }
}

// MARK: - ConversionPresenterDelegate
extension ConversionViewController: ConversionPresenterDelegate {
    func didStartLoading() {
        showActivityIndicator()
    }
    
    func didHideLoading() {
        hideActivityIndicator()
    }
    
    func didReloadData(code: String, name: String, conversion: Conversion) {
        switch conversion {
        case .from:
            customView.fromView.isHidden = true
            customView.fromWithCurrencyView.isHidden = false
            customView.fromCurrencyNameLabel.text = name
            customView.fromCurrencyCodeLabel.text = code
        case .to:
            customView.toView.isHidden = true
            customView.toWithCurrencyView.isHidden = false
            customView.toCurrencyCodeLabel.text = code
            customView.toCurrencyNameLabel.text = name
        }
        
        if customView.fromView.isHidden && customView.toView.isHidden {
            customView.conversionStackView.isHidden = false
        }
        customView.resultLabel.text = "-"
        customView.resultView.setCardLayout()
        customView.valueTextField.text = ""
        currentString = ""
    }
    
    func didReloadResult(with value: String, color: UIColor) {
        customView.resultLabel.text = value
        customView.resultView.setCardLayout(color)
    }
    
    func didUpdateDate(with date: String) {
        customView.updateDateLabel.text = date
    }
    
    func didFail(with title: String, message: String, buttonTitle: String, noConnection: Bool, dataSave: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        if noConnection && !dataSave {
            alert.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: doLoading))
        } else {
            alert.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: nil))
        }
        present(alert, animated: true, completion: nil)
    }
}
