//
//  ProfileModuleEntity.swift
//  Profile
//
//  Created by Yudi Marta on 13/09/25.
//

import Foundation
import UIKit

public class ProfileModuleEntity {
    public let email: String
    public let name: String
    public let photo: String
    public let role: [String]
    public let site: String

    public init(email: String, name: String, photo: String, role: [String], site: String) {
        self.email = email
        self.name = name
        self.photo = photo
        self.role = role
        self.site = site
    }
}
