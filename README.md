# Jedlix SDK

Jedlix SDK is part of our smart charging platform.

You can use it to connect a vehicle or charger manufacturer account to a user in the Jedlix [Smart Charging API](https://api.jedlix.com/). It presents a view to select a vehicle or charger and authenticate with the manufacturer account.

## Requirements

- iOS 14.0+

## Installation

Use [Swift Package Manager](https://www.swift.org/package-manager/) to add Jedlix SDK to your project:

```swift
dependencies: [
    .package(url: "https://github.com/jedlix/jedlix-sdk-ios.git", .upToNextMajor(from: "1.1.0"))
]
```

## Usage

When you sign up for a [Smart Charging API](https://api.jedlix.com/) account, you get a custom `baseURL`. You need to provide it to the SDK, as well as an `Authentication` implementation.

Configure the SDK:

```swift
import JedlixSDK

JedlixSDK.configure(
    baseURL: /* Base URL */,
    authentication: /* Authentication implementation */
)
```

`Authentication` provides your access token to the SDK. When the token becomes invalid, you should renew it before returning in `getAccessToken`.

```swift
protocol Authentication {
    func getAccessToken() async -> String?
}
```

To start a vehicle connect session, present the following view:

```swift
JedlixConnectView(
    userIdentifier: "<USER ID>",
    sessionType: .vehicle
)
```

To start a charger connect session, you need to specify a charging location identifier:

```swift
JedlixConnectView(
    userIdentifier: "<USER ID>",
    sessionType: .charger(chargingLocationId: "CHARGING LOCATION ID")
)
```

## Example

See the included example to learn how to use the SDK.

Open `AppDelegate.swift` and specify your `baseURL`:

```swift
baseURL = URL(string: "<YOUR BASE URL>")!
```

(Optional) If you use [Auth0](https://auth0.com/), you can uncomment the following code to authenticate with an Auth0 account directly, assuming the user identifier is stored in JWT body under `userIdentifierKey`.

```swift
authentication = Auth0Authentication(
    clientId: "<AUTH0 CLIENT ID>",
    domain: "<AUTH0 DOMAIN>",
    audience: "<AUTH0 AUDIENCE>",
    userIdentifierKey: "<USER IDENTIFIER KEY>"
)
```

## Documentation

You can find documentation and learn more about our APIs at [api.jedlix.com](https://api.jedlix.com)

## Contact

To set up an account, please contact us at [jedlix.zendesk.com](https://jedlix.zendesk.com/hc/en-us/requests/new)

## License

```markdown
Copyright 2022 Jedlix B.V.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

