//
//  EmailViewController.swift
//  SlackLoginUI
//
//  Created by LDH on 2021/07/06.
//

import UIKit

class EmailViewController: UIViewController {
    
    var bottomMargin: CGFloat?

    @IBOutlet weak var titleLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    
    var tokens = [NSObjectProtocol]()
    
    deinit {
        tokens.forEach { NotificationCenter.default.removeObserver($0) }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailField.becomeFirstResponder()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.alpha = 0.0
        titleLabelBottomConstraint.constant = -20
        
        // 첫번째 화면에서 전달해 준 값 저장, 없으면 0
        bottomConstraint.constant = bottomMargin ?? 0.0
        UIView.performWithoutAnimation {
            self.view.layoutIfNeeded() // 여백 설정하고 바로 업데이트
        }
        
        // 옵저버 추가(키보드)
        var token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            if let frameValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardFrame = frameValue.cgRectValue
                self?.bottomConstraint.constant = self?.bottomMargin ?? keyboardFrame.size.height
                
                UIView.animate(withDuration: 0.3, animations: {
                    self?.view.layoutIfNeeded()
                })
            }
        }
        tokens.append(token)
        
        token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            self?.bottomConstraint.constant = 0
            
            UIView.animate(withDuration: 0.3, animations: {
                self?.view.layoutIfNeeded()
            })
        })
        tokens.append(token)
    }
    
    @IBAction func movePrevious(_ sender: Any) {
        // 뒤로 가기 구현, POP 요청하기, navigationController가 담당
        navigationController?.popViewController(animated: true)
    }
}

extension EmailViewController: UITextFieldDelegate {
    // 입력이 활성화 되기 직전에 시작, true는 입력 가능
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        placeholderLabel.alpha = (textField.text ?? "").count > 0 ? 0.0 : 1.0
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let finaltext = NSMutableString(string: textField.text ?? "")
        finaltext.replaceCharacters(in: range, with: string)
        // 최종 텍스트 구성

        // 길이에 따라서 알파값 변경
        placeholderLabel.alpha = finaltext.length > 0 ? 0.0 : 1.0
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.titleLabel.alpha = finaltext.length > 0 ? 1.0 : 0.0
            self?.titleLabelBottomConstraint.constant = finaltext.length > 0 ? 0 : -20
            self?.view.layoutIfNeeded()
        }
        return true
    }
}
