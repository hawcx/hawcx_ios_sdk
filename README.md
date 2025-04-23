# Hawcx iOS SDK

Hawcx provides enterprise-grade passwordless authentication for iOS applications, delivering a secure and frictionless login experience across all user devices.

[![Swift Version](https://img.shields.io/badge/Swift-5.0+-orange.svg)](https://swift.org)

[![Platform](https://img.shields.io/badge/platform-iOS_17.0+-blue.svg)](https://developer.apple.com/ios/)

[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager)

## Table of Contents

- [Installation](#installation)
- [Getting Started](#getting-started)
- [Core Features](#core-features)
  - [User Registration](#user-registration)
  - [User Authentication](#user-authentication)
  - [Biometric Authentication](#biometric-authentication)
  - [Device Session Management](#device-session-management)
- [Advanced Features](#advanced-features)
  - [Multi-Device Support](#multi-device-support)
  - [Error Handling](#error-handling)
- [API Reference](#api-reference)
- [Samples & Resources](#samples--resources)

## Installation

### Requirements
- iOS 14.0+
- Swift 5.0+

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/hawcx/hawcx_ios_sdk.git", .upToNextMajor(from: "1.0.0"))
]
```

### Manual Installation

1. Download the latest [HawcxSDK.xcframework](https://github.com/hawcx/hawcx_ios_sdk/releases/latest)
2. Add to your project and set "Embed & Sign" in the "Frameworks, Libraries, and Embedded Content" section

## Getting Started

### Initialize the SDK

```swift
import HawcxSDK

// In your AppDelegate or SceneDelegate
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    HawcxInitializer.shared.initialize(apiKey: "YOUR_API_KEY")
    return true
}
```

## Core Features

### User Registration

Register new users with a simple, secure process.

```swift
// Initialize the SignUp manager
let signUp = SignUp(apiKey: "YOUR_API_KEY")

// Start registration process
signUp.signUp(userid: "user@example.com", callback: self)

// MARK: - SignUpCallback methods
func onGenerateOTPSuccess() {
    // Show OTP verification UI
}

func handleVerifyOTP(otp: String) {
    signUp.handleVerifyOTP(otp: otp, callback: self)
}

func onSuccessfulSignUp() {
    // Registration complete, proceed to home screen
}

func showError(signUpErrorCode: SignUpErrorCode, errorMessage: String) {
    // Handle specific error
}
```

### User Authentication

Authenticate returning users with a passwordless flow.

```swift
// Initialize the SignIn manager
let signIn = SignIn(apiKey: "YOUR_API_KEY")

// Authenticate user
signIn.signIn(userid: "user@example.com", callback: self)

// MARK: - SignInCallback methods
func onSuccessfulLogin(_ email: String) {
    // User authenticated successfully
}

func navigateToRegistration(for email: String) {
    // User doesn't exist, show registration
}

func initiateAddDeviceRegistrationFlow(for email: String) {
    // This device needs to be added to the user's account
}

func showError(signInErrorCode: SignInErrorCode, errorMessage: String) {
    // Handle specific error
}
```

### Biometric Authentication

Enhance security with Face ID or Touch ID integration.

```swift
import LocalAuthentication

func authenticateWithBiometrics(username: String) {
    let context = LAContext()
    var error: NSError?
    
    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, 
                              localizedReason: "Log in to your account") { success, error in
            if success {
                // Proceed with Hawcx authentication
                self.signIn.signIn(userid: username, callback: self)
            } else {
                // Handle biometric authentication error
            }
        }
    }
}
```

> **Important:** Add `NSFaceIDUsageDescription` to your Info.plist to enable Face ID authentication.

### Device Session Management

Fetch and manage information about user sessions across devices.

```swift
// Initialize DevSession manager
let devSession = DevSession(apiKey: "YOUR_API_KEY")

// Fetch device details
devSession.GetDeviceDetails(callback: self)

// MARK: - DevSessionCallback methods
func onSuccess() {
    // Access device information from UserDefaults
    if let data = UserDefaults.standard.data(forKey: "devDetails") {
        let decoder = JSONDecoder()
        let devices = try? decoder.decode([DeviceSessionInfo].self, from: data)
        // Use devices data
    }
}

func showError() {
    // Handle error
}
```

## Advanced Features

### Multi-Device Support

Enable users to securely access their accounts across multiple devices.

```swift
// Initialize the AddDeviceManager
let addDeviceManager = AddDeviceManager(apiKey: "YOUR_API_KEY")

// Start the Add Device flow
addDeviceManager.startAddDeviceFlow(userid: "user@example.com", callback: self)

// MARK: - AddDeviceCallback methods
func onGenerateOTPSuccess() {
    // Show OTP verification UI
}

func handleVerifyOTP(otp: String) {
    addDeviceManager.handleVerifyOTP(otp: otp)
}

func onAddDeviceSuccess() {
    // Device successfully added, proceed to home screen
}

func showError(addDeviceErrorCode: AddDeviceErrorCode, errorMessage: String) {
    // Handle specific error
}
```

### Error Handling

Implement robust error handling for different scenarios.

```swift
func showError(signInErrorCode: SignInErrorCode, errorMessage: String) {
    switch signInErrorCode {
    case .userNotFound:
        // Show registration option
        
    case .addDeviceRequired:
        // Redirect to Add Device flow
        
    case .networkError:
        // Show connectivity error
        
    default:
        // Handle other errors
    }
}
```

## API Reference

### Core Classes

#### SignUp
| Method | Description |
| ------ | ----------- |
| `init(apiKey: String)` | Initialize with your API key |
| `signUp(userid: String, callback: SignUpCallback)` | Start the registration process |
| `handleVerifyOTP(otp: String, callback: SignUpCallback)` | Verify the OTP during registration |

#### SignIn
| Method | Description |
| ------ | ----------- |
| `init(apiKey: String)` | Initialize with your API key |
| `signIn(userid: String, callback: SignInCallback)` | Authenticate a user |

#### AddDeviceManager
| Method | Description |
| ------ | ----------- |
| `init(apiKey: String)` | Initialize with your API key |
| `startAddDeviceFlow(userid: String, callback: AddDeviceCallback)` | Start the device addition flow |
| `handleVerifyOTP(otp: String)` | Verify the OTP during device addition |

#### DevSession
| Method | Description |
| ------ | ----------- |
| `init(apiKey: String)` | Initialize with your API key |
| `GetDeviceDetails(callback: DevSessionCallback)` | Fetch device session details |

### Callback Protocols

#### SignUpCallback
```swift
public protocol SignUpCallback {
    func showError(signUpErrorCode: SignUpErrorCode, errorMessage: String)
    func onSuccessfulSignUp()
    func onGenerateOTPSuccess()
}
```

#### SignInCallback
```swift
public protocol SignInCallback {
    func showError(signInErrorCode: SignInErrorCode, errorMessage: String)
    func onSuccessfulLogin(_ email: String)
    func navigateToRegistration(for email: String)
    func initiateAddDeviceRegistrationFlow(for email: String)
}
```

#### AddDeviceCallback
```swift
public protocol AddDeviceCallback {
    func showError(addDeviceErrorCode: AddDeviceErrorCode, errorMessage: String)
    func onAddDeviceSuccess()
    func onGenerateOTPSuccess()
}
```

#### DevSessionCallback
```swift
public protocol DevSessionCallback {
    func onSuccess()
    func showError()
}
```

## Samples & Resources

### Sample App

Explore our [sample application](https://github.com/hawcx/hawcx_ios_demo) for complete implementations of:
- User registration
- Authentication
- Multi-device support
- Web login approval
- Session management

### Common Patterns

#### Automatic Login After Registration
```swift
func onSuccessfulSignUp() {
    // Auto-login after registration
    signIn.signIn(userid: email, callback: loginCallback)
}
```

#### Handling Device Addition During Login
```swift
func initiateAddDeviceRegistrationFlow(for email: String) {
    // Navigate to add device screen
    let addDeviceVC = AddDeviceViewController(email: email)
    navigationController?.pushViewController(addDeviceVC, animated: true)
}
```

## Support

- [Documentation](https://docs.hawcx.com)
- [API Reference](https://docs.hawcx.com/ios/quickstart)
- [Website](https://www.hawcx.com)
- [Support Email](mailto:info@hawcx.com)
