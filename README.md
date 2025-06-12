# Hawcx iOS SDK V4

Hawcx provides enterprise-grade passwordless authentication for iOS applications, delivering a secure and frictionless login experience across all user devices with a unified authentication API.

[![Swift Version](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-iOS_14.0+-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager)

## What's New in V4

### 🚀 Unified Authentication API
- **Single method for everything** - `authenticateV4()` handles login, signup, and device registration
- **Intelligent flow detection** - SDK automatically determines the appropriate authentication flow
- **Simplified integration** - Reduce complexity with fewer methods and callbacks to manage

### 🔄 Enhanced User Experience
- **Seamless transitions** - Automatic progression from device registration to login
- **Better error handling** - More specific error codes with actionable error messages
- **Automatic session management** - JWT tokens managed securely in Keychain

## Table of Contents

- [Installation](#installation)
- [Getting Started](#getting-started)
- [Core Features](#core-features)
  - [Unified Authentication](#unified-authentication)
  - [Biometric Authentication](#biometric-authentication)
  - [Session Management](#session-management)
- [Advanced Features](#advanced-features)
  - [Web Authentication](#web-authentication)
  - [Error Handling](#error-handling)
- [Migration from V3](#migration-from-v3)
- [API Reference](#api-reference)
- [Samples & Resources](#samples--resources)

## Installation

### Requirements
- iOS 14.0+
- Swift 5.9+

### Swift Package Manager (Recommended)

1. In Xcode, go to **File** → **Add Package Dependencies...**
2. Enter the repository URL: `https://github.com/hawcx/hawcx_ios_sdk.git`
3. Select **Up to Next Major Version** and enter `4.0.2`
4. Choose **HawcxFramework** and click **Add Package**

### Package.swift

```swift
dependencies: [
    .package(url: "https://github.com/hawcx/hawcx_ios_sdk.git", from: "4.0.2")
]
```

### Manual Installation

1. Download the latest [HawcxFramework.xcframework](https://github.com/hawcx/hawcx_ios_sdk/releases/latest)
2. Drag the XCFramework into your project
3. Set "Embed & Sign" in "Frameworks, Libraries, and Embedded Content"

## Getting Started

### Initialize the SDK

```swift
import HawcxFramework

// Initialize the SDK (no global initialization required)
let sdk = HawcxSDK(projectApiKey: "YOUR_API_KEY")
```

### Basic Authentication Flow

```swift
class AuthenticationController: UIViewController, AuthV4Callback {
    private let sdk = HawcxSDK(projectApiKey: "YOUR_API_KEY")
    
    func authenticateUser(email: String) {
        // Single method handles all authentication scenarios
        sdk.authenticateV4(userid: email, callback: self)
    }
    
    // MARK: - AuthV4Callback
    func onOtpRequired() {
        // Show OTP input UI - user needs to verify email
        showOTPInput()
    }
    
    func onAuthSuccess(accessToken: String?, refreshToken: String?, isLoginFlow: Bool) {
        if isLoginFlow {
            // User successfully logged in
            navigateToHomeScreen()
        } else {
            // Device registration completed, login will happen automatically
            showMessage("Device registered successfully")
        }
    }
    
    func onError(errorCode: AuthV4ErrorCode, errorMessage: String) {
        // Handle authentication errors
        showError(message: errorMessage)
    }
    
    func submitOTP(_ otp: String) {
        sdk.submitOtpV4(otp: otp)
    }
}
```

## Core Features

### Unified Authentication

V4 uses a single method for all authentication scenarios:

```swift
// Handles all cases automatically:
// - New user registration
// - Existing user login  
// - New device registration
sdk.authenticateV4(userid: "user@example.com", callback: self)

// Submit OTP when required
sdk.submitOtpV4(otp: "123456")
```

**Authentication Flow Logic:**
- **New user**: `onOtpRequired()` → Registration → Auto-login
- **Existing user, known device**: Direct `onAuthSuccess()` 
- **Existing user, new device**: `onOtpRequired()` → Device registration → Auto-login

### Biometric Authentication

Integrate Face ID and Touch ID seamlessly:

```swift
import LocalAuthentication

class BiometricAuthController {
    private let sdk = HawcxSDK(projectApiKey: "YOUR_API_KEY")
    
    func authenticateWithBiometrics(username: String) {
        let biometricService = BiometricService()
        
        biometricService.authenticate { [weak self] success, error in
            if success {
                // Proceed with Hawcx authentication after biometric success
                self?.sdk.authenticateV4(userid: username, callback: self)
            } else {
                // Handle biometric failure
                print("Biometric authentication failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}

// BiometricService helper class
class BiometricService {
    func authenticate(completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            completion(false, error)
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                              localizedReason: "Authenticate to access your account") { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
    }
}
```

> **Important:** Add `NSFaceIDUsageDescription` to your Info.plist for Face ID support.

### Session Management

V4 provides enhanced session management with granular control:

```swift
// Get last logged in user for UI pre-filling
let lastUser = sdk.getLastLoggedInUser()
if !lastUser.isEmpty {
    emailField.text = lastUser
}

// Standard logout - keeps device registration, clears session tokens
sdk.clearSessionTokens(forUser: "user@example.com")

// Full device removal - user must re-register this device
sdk.clearUserKeychainData(forUser: "user@example.com")

// Clear last logged in user marker (for UI pre-fill)
sdk.clearLastLoggedInUser()
```

## Advanced Features

### Web Authentication

Support QR code and PIN-based web authentication:

```swift
class WebAuthController {
    private let sdk = HawcxSDK(projectApiKey: "YOUR_API_KEY")
    
    // Step 1: Submit PIN from web login
    func submitWebLoginPIN(_ pin: String) {
        sdk.webLogin(pin: pin, callback: self)
    }
    
    // Step 2: Approve the web login request
    func approveWebLogin(webToken: String) {
        sdk.webApprove(token: webToken, callback: self)
    }
}

extension WebAuthController: WebLoginCallback {
    func onWebLoginSuccess() {
        // Web login PIN submitted successfully
        showMessage("Web login initiated")
    }
    
    func onWebApproveSuccess() {
        // Web login approved successfully
        showMessage("Web login approved")
    }
    
    func onWebLoginError(errorCode: WebLoginErrorCode, errorMessage: String) {
        // Handle web authentication errors
        showError(message: errorMessage)
    }
}
```

### Error Handling

V4 provides comprehensive error codes for better user experience:

```swift
func onError(errorCode: AuthV4ErrorCode, errorMessage: String) {
    switch errorCode {
    case .networkError:
        showRetryableError("Please check your internet connection")
        
    case .otpVerificationFailed:
        showError("Invalid verification code. Please try again.")
        
    case .deviceVerificationFailed:
        showError("Device verification failed. Please try again.")
        
    case .fingerprintError:
        showError("Biometric authentication is not available")
        
    case .keychainSaveFailed:
        showError("Failed to save authentication data securely")
        
    case .authInitFailed:
        showError("Authentication initialization failed")
        
    case .cipherVerificationFailed:
        showError("Login verification failed")
        
    case .missingDeviceTokenSession:
        showError("Session expired. Please try again.")
        
    case .internalStateError:
        showError("An unexpected error occurred. Please update the app.")
        
    default:
        showError("Authentication failed: \(errorMessage)")
    }
}
```

## Migration from V3


### Before (V3):
```swift
// V3 required multiple managers and initialization
HawcxInitializer.shared.initialize(apiKey: "YOUR_API_KEY")

let signUp = SignUp(apiKey: "YOUR_API_KEY")
let signIn = SignIn(apiKey: "YOUR_API_KEY") 
let addDevice = AddDeviceManager(apiKey: "YOUR_API_KEY")

// Different methods for different scenarios
signUp.signUp(userid: email, callback: self)
signIn.signIn(userid: email, callback: self)
addDevice.startAddDeviceFlow(userid: email, callback: self)
```

### After (V4):
```swift
// V4 uses single SDK instance and method
let sdk = HawcxSDK(projectApiKey: "YOUR_API_KEY")

// One method handles all scenarios
sdk.authenticateV4(userid: email, callback: self)
```

### Callback Migration

**V3 had multiple callback protocols:**
- `SignUpCallback`
- `SignInCallback` 
- `AddDeviceCallback`

**V4 uses unified `AuthV4Callback`:**
```swift
protocol AuthV4Callback: AnyObject {
    func onOtpRequired()
    func onAuthSuccess(accessToken: String?, refreshToken: String?, isLoginFlow: Bool)
    func onError(errorCode: AuthV4ErrorCode, errorMessage: String)
}
```

## API Reference

### Core Classes

#### HawcxSDK
| Method | Description |
| ------ | ----------- |
| `init(projectApiKey: String)` | Initialize SDK with your API key |
| `authenticateV4(userid: String, callback: AuthV4Callback)` | Unified authentication method |
| `submitOtpV4(otp: String)` | Submit OTP during verification |
| `getLastLoggedInUser() -> String` | Get last logged in user for UI pre-fill |
| `clearSessionTokens(forUser: String)` | Standard logout (keeps device registration) |
| `clearUserKeychainData(forUser: String)` | Full device removal |
| `clearLastLoggedInUser()` | Clear last user marker |
| `webLogin(pin: String, callback: WebLoginCallback)` | Submit web login PIN |
| `webApprove(token: String, callback: WebLoginCallback)` | Approve web login |

### Callback Protocols

#### AuthV4Callback
```swift
public protocol AuthV4Callback: AnyObject {
    func onOtpRequired()
    func onAuthSuccess(accessToken: String?, refreshToken: String?, isLoginFlow: Bool)
    func onError(errorCode: AuthV4ErrorCode, errorMessage: String)
}
```

#### WebLoginCallback
```swift
public protocol WebLoginCallback: AnyObject {
    func onWebLoginSuccess()
    func onWebApproveSuccess() 
    func onWebLoginError(errorCode: WebLoginErrorCode, errorMessage: String)
}
```

### Error Codes

#### AuthV4ErrorCode
- `networkError` - Connectivity issues
- `otpVerificationFailed` - Invalid OTP
- `deviceVerificationFailed` - Device registration failed
- `fingerprintError` - Biometric authentication unavailable
- `keychainSaveFailed` - Secure storage failed
- `authInitFailed` - Authentication initialization failed
- `cipherVerificationFailed` - Login verification failed
- `missingDeviceTokenSession` - Session token lost
- `internalStateError` - Unexpected SDK state

## Samples & Resources

### Demo Application

Explore our [V4 demo application](https://github.com/hawcx/hawcx_ios_demo) featuring:
- Unified authentication implementation
- Biometric integration
- Session management
- Web authentication
- Modern SwiftUI architecture
- Complete error handling

### Best Practices

#### Biometric Authentication Flow
```swift
func attemptBiometricLogin() {
    guard let lastUser = getLastUser(), biometricsEnabled(for: lastUser) else { return }
    
    authenticateWithBiometrics(username: lastUser) { [weak self] success in
        if success {
            self?.sdk.authenticateV4(userid: lastUser, callback: self)
        }
    }
}
```

#### Session State Management
```swift
func handleAuthSuccess(isLoginFlow: Bool) {
    if isLoginFlow {
        // User is now logged in
        updateUIForLoggedInState()
        navigateToHomeScreen()
    } else {
        // Device was registered, login will happen automatically
        showTemporaryMessage("Device registered successfully")
    }
}
```

## Support

- [Documentation](https://docs.hawcx.com)
- [API Reference](https://docs.hawcx.com/ios/quickstart)
- [Website](https://www.hawcx.com)
- [Support Email](mailto:info@hawcx.com)
