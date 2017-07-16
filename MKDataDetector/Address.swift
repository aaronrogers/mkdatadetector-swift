//
//  Address.swift
//  MKDataDetector
//
//  Created by Mayank Kumar on 7/9/17.
//  Copyright © 2017 Mayank Kumar. Available under the MIT license.
//

import Foundation
import CoreLocation

extension MKDataDetectorService {
    
    public func extractAddresses(fromTextBody textBody: String) -> [AddressAnalysisResult?]? {
        
   if let result :[AddressAnalysisResult] =  ((extractData(fromTextBody: textBody, withResultType: .address)))
      {
        processLocation(result)
      }
        else
        {
        
        }
        return extractData(fromTextBody: textBody, withResultType: .address)
    }
    
    public func extractAddresses(fromTextBodies textBodies: [String]) -> [[AddressAnalysisResult?]?]? {
        
        return extractData(fromTextBodies: textBodies, withResultType: .address)
    }
    
    public func processLocation(_ addresses: [AddressAnalysisResult]) -> [CLLocation]
    {
        var geocoder = CLGeocoder()
        var locations: [CLLocation]?
        let test = geocoder.isGeocoding
        for address in addresses
        {
            geocoder.geocodeAddressString(address.source, completionHandler: { (placemarks: [CLPlacemark]?, error: Error?) -> Void in
                // Process Response
                let location = self.processResponse(withPlacemarks: placemarks, error: error)
                locations?.append(location)
            })
            
        }
        if(locations != nil)
        {
            return locations!
        }
        else
        {
            return []
        }
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) -> CLLocation {
        
        var location: CLLocation?
        if let error = error {
            print("Unable to Forward Geocode Address (\(error))")
            print( "Unable to Find Location for Address")
        }
        else
        {
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
        }
        return location!
    }
}
