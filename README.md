# Realm Status for WoW

A modern World of Warcraft companion app for iOS, built with SwiftUI and supported by a lightweight Swift/Vapor backend.

> **Project status:** Early development. This repository is being prepared for a complete rewrite of the original application.

## Background

Over a decade ago, while working toward a career in iOS development, I created and published *Realm Status for WoW* on the Apple App Store.

As an avid World of Warcraft player, I wanted a simple way to check whether my favorite realms were online without launching the game. The application used Blizzard's World of Warcraft API to display realm availability across North America, with the ability to mark favorite realms and filter the list accordingly.

As my professional iOS career progressed, development on the application slowed. Eventually, changes to Blizzard's APIs rendered the application nonfunctional, and I removed it from the App Store.

Now, more than a decade later, I'm revisiting the project with the benefit of years of professional iOS development experience, modern Swift technologies, and a broader vision for what the application could become.

Rather than updating the original codebase, this project is a complete rewrite.

## Planned Features

### Realm Status

- Display realm availability for World of Warcraft Retail and Classic.
- Support multiple regions beyond North America.
- Mark favorite realms for quick access.
- Filter and search realms.
- Refresh realm status information.

### Character Profiles

- Authenticate with Battle.net.
- View characters associated with the authenticated account.
- Explore character details, including equipment, attributes, and progression, where supported by Blizzard's APIs.

### Future Possibilities

- Item information and lookup.
- Mount and pet collections.
- Additional World of Warcraft companion features.
- World of Warcraft Forever support once its API is officially documented.

These features represent the current direction of the project and may evolve during development.

## Technology

The new application is planned around:

- **Swift and SwiftUI** for the native iOS application.
- **URLSession and Swift concurrency** for networking.
- **Swift/Vapor** for a lightweight backend service.
- **Blizzard's Battle.net APIs** for game and account data.
- **OAuth 2.0** for authenticated account access.

The backend will manage application credentials and selected Blizzard API interactions, allowing the iOS application to remain focused on presentation, user interaction, and client-side functionality.

## Original Application

The original implementation is preserved in the [`legacy`](https://github.com/WERUreo/WoW-Realm-Status/tree/legacy) branch.

That branch contains the original iOS application, including its historical dependencies and implementation. The repository's original release tags and development history have also been retained.

## Development Status

The project is currently in its initial planning and setup phase. The first development milestone will focus on retrieving live realm-status data through the Vapor backend and displaying it in a SwiftUI application.

## Copyright

Copyright © 2026. All rights reserved.

This repository is publicly available for reference and portfolio purposes. No license is granted for redistribution or reuse of its source code.
