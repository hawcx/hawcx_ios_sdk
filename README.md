# Hawcx iOS SDK V6.0.2

Hawcx delivers passwordless authentication for iOS with an adaptive V6 flow for new integrations, while keeping existing V4/V5 APIs available for apps that are already in production.

[![Swift Version](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-iOS_17.0+-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager)

## What This Release Includes

- V6 adaptive authentication via `HawcxV1SDK`
- Trusted-device handling and secure device credentials managed by the SDK
- Optional OAuth redirect and exchange helpers for V6 flows
- Existing `HawcxSDK` V4/V5 APIs for current integrations and incremental migration

## Requirements

- iOS 17.0+
- Swift 5.9+

## Installation

### Swift Package Manager

In Xcode:

1. Go to **File → Add Package Dependencies...**
2. Enter: `https://github.com/hawcx/hawcx_ios_sdk.git`
3. Choose **Up to Next Major Version**
4. Set the version to `6.0.2`
5. Select the product **HawcxFramework**

Using `Package.swift` directly:

```swift
dependencies: [
    .package(url: "https://github.com/hawcx/hawcx_ios_sdk.git", from: "6.0.2")
]
```

### Manual XCFramework

Download `HawcxFramework.xcframework.zip` from the [6.0.2 release](https://github.com/hawcx/hawcx_ios_sdk/releases/download/6.0.2/HawcxFramework.xcframework.zip), unzip it, and add `HawcxFramework.xcframework` to your Xcode project with **Embed & Sign**.

## V6 Quick Start

V6 is the public release name. The current iOS API surface uses `HawcxV1SDK` and related `HawcxV1*` types because the SDK is built on Hawcx protocol v1.

```swift
import HawcxFramework

let hawcx = HawcxV1SDK(
    configId: "<YOUR_CONFIG_ID>",
    baseURL: URL(string: "https://your-hawcx-host.example.com")!,
    primaryMethodSelectionPolicy: .automaticFromIdentifier
)
```

### Initialization Notes

- `configId` is the Hawcx value provisioned for this integration. In current public releases, this is the same value you may receive as your project API key / Config ID.
- `baseURL` should point to your Hawcx tenant host. You can pass either the host root or an existing `/v1` URL. The SDK normalizes it automatically. Do not append `/auth` yourself.
- `primaryMethodSelectionPolicy` defaults to `.manual`. The quick-start example opts into `.automaticFromIdentifier`.
- `relyingParty` is optional and should only be set when your backend expects the `X-Relying-Party` header.
- `autoPollApprovals` defaults to `true`, which is the right choice for most apps.
- `.automaticFromIdentifier` only auto-selects the initial primary method during `.signin` when the identifier already makes the correct email or phone path obvious.

## How V6 Works

1. Initialize `HawcxV1SDK` with your `configId` and tenant base URL.
2. Start a flow, usually `.signin`, with the user's identifier.
3. Render the prompt Hawcx returns.
4. Send the user's input back to the SDK.
5. Exchange the resulting authorization code on your backend.

The SDK handles protocol requests, PKCE when needed, trusted-device storage, internal device-trust processing, and approval polling.

## Starting Authentication

`HawcxV1FlowType` supports:

- `.signin`
- `.signup`
- `.accountManage`

Most apps should start with `.signin`:

```swift
hawcx.start(flowType: .signin, identifier: "user@example.com")
```

Additional fields are available when your tenant policy requires them:

```swift
hawcx.start(
    flowType: .signin,
    identifier: "user@example.com",
    startToken: "<optional-start-token>",
    inviteCode: "12345678"
)
```

`startToken` is optional and is only needed when your backend or hosted flow gives your app a pre-issued token to resume or continue a specific start path.

If you omit `codeChallenge`, the SDK generates PKCE automatically and returns `codeVerifier` in the completed update.

## Handling Flow Updates

Use `flow.onUpdate` to drive your UI:

```swift
hawcx.flow.onUpdate = { update in
    switch update {
    case .idle:
        break

    case .loading:
        break

    case let .prompt(context, prompt):
        switch prompt {
        case let .selectMethod(methods, _):
            print(methods.map(\.id))

        case let .enterCode(destination, _, _, _, resendAt):
            print(destination, resendAt ?? "")

        case let .setupSms(existingPhone):
            print(existingPhone ?? "")

        case let .setupTotp(secret, otpauthUrl, _):
            print(secret, otpauthUrl)

        case .enterTotp:
            break

        case let .redirect(url, returnScheme):
            print(url, returnScheme ?? "")

        case let .awaitApproval(qrData, expiresAt, pollInterval):
            print(qrData ?? "", expiresAt, pollInterval)
        }

        print(context.meta.traceId)

    case let .completed(session, authCode, expiresAt, codeVerifier, _):
        print(session, authCode, expiresAt, codeVerifier ?? "")

    case let .error(_, code, action, message, retryable, details, meta):
        print(code, action as Any, message, retryable, details as Any, meta?.traceId ?? "")
    }
}
```

Internal device-trust prompts are handled by the SDK automatically and should not be rendered in your UI.

## Redirect Handling

If the backend returns a `redirect` prompt, use the provided OAuth helpers:

```swift
import AuthenticationServices
import HawcxFramework
import UIKit

let redirectSession = HawcxV1OAuthRedirectSession {
    UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .flatMap(\.windows)
        .first(where: \.isKeyWindow) ?? ASPresentationAnchor()
}

func handleRedirect(url: String, returnScheme: String) {
    guard let redirectURL = URL(string: url) else { return }

    redirectSession.start(url: redirectURL, callbackScheme: returnScheme) { result in
        switch result {
        case let .success(callbackURL):
            if let callback = HawcxV1OAuthCallbackParser.parse(callbackURL) {
                hawcx.flow.oauthCallback(code: callback.code, state: callback.state)
            }
        case .failure:
            break
        }
    }
}
```

## Backend Exchange

When the flow completes, the SDK returns:

- `session`
- `authCode`
- `expiresAt`
- `codeVerifier` when PKCE was generated by the SDK

For most apps, send the authorization code to your backend and do the exchange there. Keep OAuth client credentials and token verification on the server.

If you truly need an SDK-managed exchange path, `HawcxV1OAuthExchangeService` is available as an advanced option. It verifies the returned ID token using the public key in your `HawcxOAuthConfig` and returns `HawcxV1OAuthToken` (`idToken`, `tokenType`, `expiresIn`).

## Trusted Devices and Secure Storage

The SDK manages trusted-device material for you:

- device-trust steps are handled internally
- device credentials are stored per app, per user, and per Hawcx project / Config ID
- secure storage is isolated so the same user in different apps does not share credentials
- invalid local trusted-device records are cleared and re-enrolled automatically when needed

## Existing V4/V5 APIs

This package still includes `HawcxSDK` for apps that already use the existing V4/V5 integration surface, including:

- V4/V5 authentication flows
- push approval handling
- device session APIs
- existing token-storage helpers

That makes incremental migration possible: new V6 flows can live on `HawcxV1SDK` while existing utilities remain on `HawcxSDK`.

## Documentation

- [V6 iOS guide](https://docs.hawcx.com/docs/v1/sdk-reference/frontend/ios/sdk-v6)
- [V5 iOS guide](https://docs.hawcx.com/docs/v1/sdk-reference/frontend/ios/sdk)
- [Documentation home](https://docs.hawcx.com)

## Support

- [Website](https://www.hawcx.com)
- [Support Email](mailto:info@hawcx.com)
