//
//  ProfileModuleDomainModel.swift
//  Profile
//
//  Created by Yudi Marta on 13/09/25.
//

import Foundation
import UIKit

public class ProfileModuleDomainModel {
    
    public let name: String
    public let email: String
    public let photo: String
    public let role: [String]
    public let site: String
    
    public init(name: String, email: String, photo: String, role: [String], site: String) {
        self.name = name
        self.email = email
        self.photo = photo
        self.role = role
        self.site = site
    }
}