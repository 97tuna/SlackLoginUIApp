//
//  ViewController.swift
//  SlackLoginUI
//
//  Created by LDH on 2021/07/06.
//

import UIKit

class ViewController: UIViewController {
    
    // 새 캐릭터 셋 추가하기
    let charSet: CharacterSet = {
        var cs = CharacterSet.lowercaseLetters
        cs.insert(charactersIn: "0123456789")
        cs.insert(charactersIn: "-")
        return cs.inverted // 캐릭터 속성을 뒤집어서 전달, 허용되지 않는 문자 검색이 더 편함
    }()

    @IBOutlet weak var placeholderLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    var tokens = [NSObjectProtocol]()
    
    deinit {
        tokens.forEach { NotificationCenter.default.removeObserver($0) }
    }
    
    override func viewWillAppear(_ animated: Bool) { // 화면이 표시되기 직전에 사용
        super.viewWillAppear(animated)
        
        urlField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.isEnabled = false // 처음에는 일단 비활성화
        
        var token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            if let frameValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keykoardFrame = frameValue.cgRectValue
                
                self?.bottomConstraint.constant = keykoardFrame.size.height
                
                UIView.animate(withDuration: 0.3, animations: {
                    self?.view.layoutIfNeeded()
                }, completion: { finished in
                    UIView.setAnimationsEnabled(true)
                })
            }
        } // 정말 잘 쓰이는 코드, 필히 알고있을 것.
        tokens.append(token)
        
        token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            self?.bottomConstraint.constant = 0
            
            UIView.animate(withDuration: 0.3) {
                self?.view.layoutIfNeeded()
            }
        })
        tokens.append(token)
    }
}

extension ViewController: UITextFieldDelegate {
    // 메소드 호출 후 키보드 생성, 여기서 애니메이션 비활성화 하기
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.setAnimationsEnabled(false) // 모든 애니메이션 비활성화, 키보드가 표시된 다음 애니메이션 다시 활성화 할 것.
    }
    
    // 소문자, 대문자, 하이픈만 쓸 수 있도록 제한
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if string.count > 0 { // 입력 모드
            guard string.rangeOfCharacter(from: charSet) == nil else {
                return false
            } // nil이 아니면 통과, 맞으면 입력 안되서 허용된 문자만 입력됨
        }
        
        let finalText = NSMutableString(string: textField.text ?? "") // 텍스트 문자열로 미리 초기화
        finalText.replaceCharacters(in: range, with: string)
        // 위처럼하면 입력과 삭제가 선 반영된 텍스트를 알 수 있음
        
        let font = textField.font ?? UIFont.systemFont(ofSize: 16) // 폰트가 없으면 시스템 16포인트 사용
        
        let dict = [NSAttributedString.Key.font: font]
        let width = finalText.size(withAttributes: dict).width // 문자열 너비 계산이 너무 쉬워서 사용 NSA
        
        placeholderLeadingConstraint.constant = width
        
        if finalText.length == 0 {
            placeholderLabel.text = "workspace-url.slack.com"
        } else {
            placeholderLabel.text = ".slack.com"
        }
        
        nextButton.isEnabled = finalText.length > 0
        
        return true
    }
}
