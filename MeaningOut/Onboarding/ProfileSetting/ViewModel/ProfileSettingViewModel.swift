//
//  ProfileSettingViewModel.swift
//  MeaningOut
//
//  Created by 권대윤 on 7/9/24.
//

import UIKit

enum NicknameConditionError: LocalizedError {
    case dissatisfactionCount
    case dissatisfactionNumber
    case dissatisfactionSpecialSymbol
    
    var errorDescription: String? {
        switch self {
        case NicknameConditionError.dissatisfactionCount:
            "2글자 이상 10글자 미만으로 설정해주세요."
        case NicknameConditionError.dissatisfactionNumber:
            "닉네임에 숫자는 포함할 수 없어요."
        case NicknameConditionError.dissatisfactionSpecialSymbol:
            "닉네임에 @, #, $, % 는 포함할 수 없어요."
        }
    }
}

final class ProfileSettingViewModel {
    
    //MARK: - Properties
    
    enum ViewType {
        case profileSetting
        case editProfile
    }
    var viewType: ViewType = .profileSetting
    
    //MARK: - Input
    
    var inputText: Observable<String?> = Observable<String?>(UserDefaultsManager.shared.nickname)
    
    var inputProfileImage: Observable<UIImage?> = Observable<UIImage?>(nil)
    
    var inputCompleteButtonTapped: Observable<Void?> = Observable<Void?>(nil)
    
    //MARK: - Ouput
    
    var outputValidationText: Observable<String> = Observable("")
    
    var outputIsValid: Observable<Bool> = Observable(false)
    
    var outputCreateUserDataSucceed: Observable<Bool> = Observable(false)
    
    //MARK: - Init
    
    init() {
        inputText.bind { _ in
            self.updateStatusCompleteButton()
        }
        
        inputCompleteButtonTapped.bind { _ in
            if self.outputIsValid.value {
                guard let image = self.inputProfileImage.value else { return }
                self.createUserData(profileImage: image)
            }
        }
    }
    
    //MARK: - Functions

    private func updateStatusCompleteButton() {
        guard let text = self.inputText.value else { return }
        
        do {
            let result = try checkNicknameCondition(target: text)
            if result {
                self.outputValidationText.value = "사용 가능한 닉네임입니다 :D"
                self.outputIsValid.value = true
            }
        } catch {
            print("Error:", error, error.localizedDescription)

            self.outputValidationText.value = error.localizedDescription
            self.outputIsValid.value = false
        }
    }
    
    private func checkNicknameCondition(target text: String) throws -> Bool {
        
        let trimmedText = text.trimmingCharacters(in: .whitespaces)
        
        guard trimmedText.count >= 2 && trimmedText.count < 10 else {
            throw NicknameConditionError.dissatisfactionCount
        }
        
        guard !trimmedText.contains("@") && !trimmedText.contains("#") && !trimmedText.contains("$") && !trimmedText.contains("%") else {
            throw NicknameConditionError.dissatisfactionSpecialSymbol
        }
        
        guard !trimmedText.contains("1") && !trimmedText.contains("2") && !trimmedText.contains("3") && !trimmedText.contains("4") && !trimmedText.contains("5") && !trimmedText.contains("6") && !trimmedText.contains("7") && !trimmedText.contains("8") && !trimmedText.contains("9") && !trimmedText.contains("0") else {
            throw NicknameConditionError.dissatisfactionNumber
        }
        
        return true
    }
    
    private func createUserData(profileImage: UIImage?) {
        guard let nickname = self.inputText.value else { return }
        
        var profileImageName: String?
        for item in Constant.ProfileImage.allCases {
            if UIImage(named: item.rawValue) == profileImage {
                profileImageName = item.rawValue
            }
        }
        UserDefaultsManager.shared.profile = profileImageName
       
        UserDefaultsManager.shared.nickname = nickname
        
        switch viewType {
        case .profileSetting:
            let now = Date.todayDate
            UserDefaultsManager.shared.joinDate = now
        default:
            break
        }
        
        self.outputCreateUserDataSucceed.value = true
    }
    
}
