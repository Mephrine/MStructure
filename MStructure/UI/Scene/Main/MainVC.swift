//
//  MainVC.swift
//  MStructure
//
//  Created by Mephrine on 2020/05/22.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import Foundation
import ReactorKit
import Reusable
import SwiftyUserDefaults

/**
 # (C) MainVC
 - Author: Mephrine
 - Date: 20.01.13
 - Note: 권한 고지 화면 ViewController
*/
class MainVC: BasePopupVC, StoryboardView, StoryboardBased {
 
    @IBOutlet weak var btnAccept: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: Bind
    /**
     # bind
     - Author: Mephrine
     - Date: 20.01.13
     - Parameters:
        - reactor: 사용될 ViewModel 주입
     - Returns:
     - Note: view가 모두 로드된 이후 (ViewDidLoad 및 storyboard instaniate) bind를 진행.
    */
    func bind(reactor: MainVM) {
        //Action
        
        //State
        
        //Navigation
        
    }
}
