# Jedlix SDK

Jedlix SDK is part of our smart charging platform.

You can use it to connect a vehicle manufacturer account to a user in the Jedlix [Smart Charging API](https://api.jedlix.com/). It takes a user identifier and access token and presents a view to select a vehicle and authenticate with the manufacturer account.

## Requirements

- iOS 14.0+

## Installation

### Swift Package Manager

Use [Swift Package Manager](https://www.swift.org/package-manager/) to add Jedlix SDK to your project:

```swift
dependencies: [
    .package(url: "https://github.com/jedlix/jedlix-sdk-ios.git", .upToNextMajor(from: "1.0.0"))
]
```

## Usage

When you sign up for a [Smart Charging API](https://api.jedlix.com/) account, you get a custom `baseURL`. You need to provide it to the SDK, as well as an `accessToken` from your JWT and a `userIdentifier` from the Smart Charging API.

Configure the SDK:

```swift
import JedlixSDK

JedlixSDK.configure(with: baseURL)
```

To start a new connect session, present the following view:

```swift
JedlixConnectView(
    accessToken: accessToken,
    userIdentifier: userIdentifier
) { sessionIdentifier in
    // store session identifier
}
```

Because a user might leave the app at any moment, you should store the session identifier and continue when they come back using the following constructor:

```swift
JedlixConnectView(
    accessToken: accessToken,
    userIdentifier: userIdentifier,
    sessionIdentifier: // session identifier stored previously
)
```

## Example

See the included example to learn how to use the `JedlixConnectView`.

Open `AppDelegate.swift` and specify your baseURL:

```swift
JedlixSDK.configure(baseURL: "<YOUR BASE URL>")
```

(Optional) If you use [Auth0](https://auth0.com/), you can uncomment the following code to authenticate with an Auth0 account directly, assuming the user identifier is stored in JWT body under `userIdentifierKey`.

```swift
Authentication.enableAuth0(
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

