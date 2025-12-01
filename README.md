# Hawcx iOS SDK V5.2.2

Hawcx delivers enterprise-grade passwordless authentication for iOS with a unified V5 flow that mirrors the Android SDK and the latest Hawcx backend.

[![Swift Version](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-iOS_17.0+-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager)

## What's New in V5

- Hardware-backed security – Secure Enclave + HKDF salts wrap the Ed25519 keyset and store secrets in Keychain.
- OAuth-backed login – A single V5 flow (`authenticateV5` / `submitOtpV5`) returns OAuth codes or JWTs that align with the Hawcx server stack.
- Unified cross-platform API – Method signatures and callbacks match the Android SDK for smoother multi-platform adoption.

## Installation (SPM)

Requirements: iOS 17.0+, Swift 5.9+.

1) In Xcode, go to **File → Add Package Dependencies...**  
2) Enter: `https://github.com/hawcx/hawcx_ios_sdk.git`  
3) Choose **Up to Next Major Version** and set `5.2.2` (or `5.2` tag).  
4) Select the product **HawcxFramework**.

Using `Package.swift` directly:

```swift
dependencies: [
    .package(url: "https://github.com/hawcx/hawcx_ios_sdk.git", from: "5.2.2")
]
```

Manual option: download `HawcxFramework.xcframework.zip` from the [5.2.2 release](https://github.com/hawcx/hawcx_ios_sdk/releases/5.2.2), unzip, and embed the XCFramework with “Embed & Sign”.

## Getting Started (V5)

`baseURL` should be the host Hawcx provisioned for your tenant (scheme + host only is fine, e.g., `https://hawcx-api.hawcx.com`). The SDK appends `/hc_auth` and derives all V4/V5 endpoints from that host.

```swift
import HawcxFramework

let oauthConfig = HawcxOAuthConfig(
    tokenEndpoint: URL(string: "https://hawcx-api.hawcx.com/hc_auth/v5/oauth/token")!,
    clientId: "hawcx-mobile",
    publicKeyPem: """
    -----BEGIN PUBLIC KEY-----
    ...
    -----END PUBLIC KEY-----
    """
)

// If you omit oauthConfig, the SDK will call onAuthorizationCode(...) so you can redeem the code yourself.
let sdk = HawcxSDK(
    projectApiKey: "<HAWCX_PROJECT_API_KEY>",
    baseURL: "https://hawcx-api.hawcx.com",
    oauthConfig: oauthConfig // optional
)
```

### V5 Authentication Flow

```swift
final class AuthController: UIViewController, AuthV5Callback {
    private let sdk: HawcxSDK = {
        // Configure once, reuse across the app.
        let config = HawcxOAuthConfig(
            tokenEndpoint: URL(string: "https://hawcx-api.hawcx.com/hc_auth/v5/oauth/token")!,
            clientId: "hawcx-mobile",
            publicKeyPem: "<PEM_PUBLIC_KEY>"
        )
        return HawcxSDK(
            projectApiKey: "<PROJECT_API_KEY>",
            baseURL: "https://hawcx-api.hawcx.com",
            oauthConfig: config
        )
    }()

    func startLogin(email: String) {
        sdk.authenticateV5(userid: email, callback: self)
    }

    // MARK: - AuthV5Callback
    func onOtpRequired() {
        // Prompt user for the OTP, then call submitOtpV5(...)
    }

    func onAuthorizationCode(code: String, expiresIn: Int?) {
        // Only fired when no oauthConfig is provided. Exchange the code with your OAuth service, then continue your login flow.
    }

    func onAuthSuccess(accessToken: String?, refreshToken: String?, isLoginFlow: Bool) {
        // Tokens are also persisted securely. Use them immediately or load from the credential store later.
    }

    func onAdditionalVerificationRequired(sessionId: String, detail: String?) {
        // Present any required step-up / web approval UI.
    }

    func onError(errorCode: AuthV5ErrorCode, errorMessage: String) {
        // Surface to the user or log for analytics.
    }
}

// Submit OTP after the user types it
// sdk.submitOtpV5(otp: "<OTP_FROM_USER>")
```

- Device registration provisions salts, wraps keys with Secure Enclave metadata, and records device fingerprint data.  
- Returning users reuse stored material and only request an OTP when needed.  
- Tokens and the last logged-in user are persisted in Keychain-backed storage.

## Push Notifications (optional)

- In `application(_:didRegisterForRemoteNotificationsWithDeviceToken:)` forward the token:  
  `sdk.setAPNsDeviceToken(deviceToken)`
- After a successful V5 login/registration, call `sdk.userDidAuthenticate()` so the SDK binds the APNs token to the user.
- To handle Hawcx login push payloads inside `didReceiveRemoteNotification`, call `sdk.handlePushNotification(userInfo)`; it returns `true` when the payload belongs to Hawcx.

## Backwards Compatibility (V4)

V4 APIs (`authenticateV4`, `submitOtpV4`, web login, session utilities) remain for existing deployments. They share the same package and binary.

```swift
let sdk = HawcxSDK(
    projectApiKey: "<PROJECT_API_KEY>",
    baseURL: "https://hawcx-api.hawcx.com"
)

class LegacyController: AuthV4Callback {
    func start(email: String) {
        sdk.authenticateV4(userid: email, callback: self)
    }
    func onOtpRequired() { /* prompt user */ }
    func onAuthSuccess(accessToken: String?, refreshToken: String?, isLoginFlow: Bool) { /* handle */ }
    func onError(errorCode: AuthV4ErrorCode, errorMessage: String) { /* handle */ }
}
```

## Support

- [Documentation](https://docs.hawcx.com)
- [API Reference](https://docs.hawcx.com/ios/quickstart)
- [Website](https://www.hawcx.com)
- [Support Email](mailto:info@hawcx.com)
