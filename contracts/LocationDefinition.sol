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
pragma solidity ^0.4.19;

/// @title the locationDefinition for the contracts
contract LocationDefinition {

    struct Location {
        bytes32 country; //why do you use bytes32 for everything instead of string, uint, ...?
        bytes32 region;
        bytes32 city;
        bytes32 street;
        bytes32 zip;
        bytes32 houseNumber;
        bytes32 gpsLatitude;
        bytes32 gpsLongitude;
        bool exists;
    }


}