//
//  ProfileImageSettingViewModel.swift
//  MeaningOut
//
//  Created by 권대윤 on 7/9/24.
//

import Foundation

final class ProfileImageSettingViewModel {
    
    //MARK: - Properties
    
    enum ViewType {
        case profileSetting
        case editProfile
    }
    var viewType: ViewType = .profileSetting
    
    //MARK: - Input
    
    var inputViewModelInitTrigger = Observable<Void?>(nil)
    
    var inputSelectedRow = Observable<Int?>(nil)
    
    //MARK: - Ouput
    
    private(set) var outputProfileImageNameList: Observable<[String]> = Observable([])
    
    private(set) var outputSelectedProfileImageName = Observable<String?>("")
    
    //MARK: - Init
    
    init() {
        inputViewModelInitTrigger.bind { _ in
            Constant.ProfileImage.allCases.forEach { item in
                self.outputProfileImageNameList.value.append(item.rawValue)
            }
        }
        
        inputSelectedRow.bind { row in
            guard let row = row else { return }
            
            self.outputSelectedProfileImageName.value = self.outputProfileImageNameList.value[row]
        }
    }
}
