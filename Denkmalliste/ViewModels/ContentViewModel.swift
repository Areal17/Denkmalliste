//
//  ContentViewModel.swift
//  Denkmalliste
//
//  Created during Phase 2 refactoring
//

import Foundation
import CoreLocation
import MapKit
import Combine

/// ViewModel for ContentView - manages monument data and application state
@MainActor
class ContentViewModel: ObservableObject {

    // MARK: - Published Properties

    /// Dictionary of all monuments keyed by ID
    @Published var monuments: [Int: Monument] = [:]

    /// Dictionary of placemarks keyed by monument ID
    @Published var placemarks: [Int: Placemark] = [:]

    /// Current map region
    @Published var region: MKCoordinateRegion

    /// Currently selected monument
    @Published var currentMonument: Monument?

    /// ID of currently selected monument
    @Published var monumentID: Int?

    /// Whether to show detail view
    @Published var showDetail: Bool = false

    /// Current user location
    @Published var currentLocation: CLLocationCoordinate2D

    /// Error state
    @Published var error: MonumentRepositoryError?

    /// Loading state
    @Published var isLoading: Bool = false

    // MARK: - Dependencies

    private let repository: MonumentRepositoryProtocol
    private let geocoding: Geocoding
    private let kmlFileNames: [String]

    // MARK: - Initialization

    /// Initialize the ViewModel
    /// - Parameters:
    ///   - repository: Repository for monument data
    ///   - geocoding: Geocoding service
    ///   - kmlFileNames: Array of KML file names to load
    ///   - initialLocation: Initial map location
    init(
        repository: MonumentRepositoryProtocol = MonumentRepository(),
        geocoding: Geocoding = Geocoding(),
        kmlFileNames: [String] = ["baudenkmal"],
        initialLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(
            latitude: 48.631389,
            longitude: 8.073889
        )
    ) {
        self.repository = repository
        self.geocoding = geocoding
        self.kmlFileNames = kmlFileNames
        self.currentLocation = initialLocation
        self.region = MKCoordinateRegion(
            center: initialLocation,
            latitudinalMeters: 750,
            longitudinalMeters: 750
        )
    }

    // MARK: - Public Methods

    /// Load all monument data (CSV and KML)
    func loadData() async {
        isLoading = true
        error = nil

        do {
            // Load monuments from CSV
            monuments = try await repository.loadMonuments()

            // Load placemarks from KML
            placemarks = repository.loadPlacemarks(fileNames: kmlFileNames)

            // Update geocoding for current location
            geocoding.addressFromLocation(currentLocation)

        } catch let repositoryError as MonumentRepositoryError {
            error = repositoryError
            print("Error loading data: \(repositoryError.localizedDescription)")
        } catch {
            self.error = .invalidData
            print("Unexpected error: \(error)")
        }

        isLoading = false
    }

    /// Update current location and geocode address
    /// - Parameter location: New location coordinate
    func updateLocation(_ location: CLLocationCoordinate2D) {
        currentLocation = location
        geocoding.addressFromLocation(location)
    }

    /// Select a monument for detail view
    /// - Parameters:
    ///   - monument: Monument to select
    ///   - id: Monument ID
    func selectMonument(_ monument: Monument?, id: Int?) {
        currentMonument = monument
        monumentID = id
        showDetail = monument != nil
    }

    /// Get geocoded address for current location
    var currentAddress: String {
        geocoding.userPlacemark?.thoroughfare ?? "Hallo Denkmale in Berlin!"
    }

    /// Get placemark for a specific monument ID
    /// - Parameter id: Monument ID
    /// - Returns: Placemark if found
    func placemark(for id: Int?) -> Placemark? {
        guard let id = id else { return nil }
        return placemarks[id]
    }
}
