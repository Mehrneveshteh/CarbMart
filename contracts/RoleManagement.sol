// Copyright 2018 Energy Web Foundation
// This file is part of the Origin Application brought to you by the Energy Web Foundation,
// a global non-profit organization focused on accelerating blockchain technology across the energy sector, 
// incorporated in Zug, Switzerland.
//
// The Origin Application is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// This is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY and without an implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details, at <http://www.gnu.org/licenses/>.
//
// @authors: slock.it GmbH, Martin Kuechler, martin.kuchler@slock.it


pragma solidity ^0.4.17;

import "./CoO.sol";
import "./RolesInterface.sol";

/// @notice contract for managing the rights and roles
contract RoleManagement {

    /// @notice central registry contract 
    CoO public cooContract;

    /// @notice all possible available roles
    /*
    no role:        0x0...0000000
    TopAdmin:       0x0...------1
    UserAdmin:      0x0...-----1-
    AssetAdmin:     0x0...----1--
    AgreementAdmin: 0x0...---1---
    AssetManager:   0x0...--1----
    Trader:         0x0...-1-----
    Matcher:        0x0...1-----
    */
    enum Role{
        TopAdmin, 
        UserAdmin,
        AssetAdmin,
        AgreementAdmin, 
        AssetManager,  
        Trader, 
        Matcher
    } 

    /// @notice modifier for checking if an user is allowed to execute the intended action
    modifier onlyRole (RoleManagement.Role _role) { 
        require (isRole(_role, msg.sender)); 
        _; 
    }

    modifier onlyAccount(address accountAddress) {
        require(msg.sender == accountAddress);
        _;
    }

    modifier userExists(address _user){
        require(RolesInterface(cooContract.userRegistry()).doesUserExist(_user));
        _;
    }

    modifier userHasRole(RoleManagement.Role _role, address _user){
        require (isRole(_role, _user)); 
        _; 
    }

    /// @notice constructor 
    /// @param _cooContract CoO.sol-registry contract
    function RoleManagement (CoO _cooContract) public {
        cooContract = _cooContract;
    }

    /// @notice funciton for comparing the role and the needed rights of an user
    /// @param _role role of a user
    /// @param _caller the address calling that function
    /// @return whether the user has the corresponding rights for the intended action
    function isRole(RoleManagement.Role _role, address _caller) public view returns (bool) { 
        require(uint(_role) <= 7);
        if (cooContract.owner() == _caller) {
            return true;
        }
        /// @dev reading the rights for the user from the userDB-contract
        uint rights = RolesInterface(cooContract.userRegistry()).getRolesRights(_caller);
        /// @dev converting the used enum to the corresponding bitmask 
        uint role = uint(2) ** uint(_role);
        /// @dev comparing rights and roles, if the result is not 0 the user has the right (bitwise comparison)
        /// we also don't have to check for a potential overflow here, because the used enum will prevent using roles that do not exist
        return (rights & role != 0);
    }
}