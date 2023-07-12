//
//  PaymentSheetError.swift
//  StripePaymentSheet
//
//  Created by Yuki Tokuhiro on 12/7/20.
//  Copyright © 2020 Stripe, Inc. All rights reserved.
//

import Foundation
@_spi(STP) import StripeCore
import StripePayments

/// Errors specific to PaymentSheet itself
///
/// Most errors do not originate from PaymentSheet itself; instead, they come from the Stripe API
/// or other SDK components like STPPaymentHandler, PassKit (Apple Pay), etc.
public enum PaymentSheetError: Error {
    
    /// An unknown error.
    @available(*, deprecated, message: "Depcreated in favor of specfic errors defined in PaymentSheetError.")
    case unknown(debugDescription: String)

    // MARK: Generic errors
    case missingClientSecret
    case invalidClientSecret
    case unexpectedResponseFromStripeAPI
    case applePayNotSupported
    case alreadyPresented
    case flowControllerConfirmFailed(message: String)
    case errorHandlingNextAction
    case unrecognizedHandlerStatus
    case accountLinkFailure
    /// No payment method types available error.
    case noPaymentMethodTypesAvailable(intentPaymentMethods: [STPPaymentMethodType])

    // MARK: Loading errors
    case paymentIntentInTerminalState(status: STPPaymentIntentStatus)
    case setupIntentInTerminalState(status: STPSetupIntentStatus)
    case fetchPaymentMethodsFailure

    // MARK: Deferred intent errors
    case deferredIntentValidationFailed(message: String)

    // MARK: - Link errors
    case linkSignUpNotRequired
    case linkCallVerifyNotRequired
    case linkingWithoutValidSession
    case savingWithoutValidLinkSession
    case payingWithoutValidLinkSession
    case deletingWithoutValidLinkSession
    case updatingWithoutValidLinkSession
    case linkLookupNotFound
    case failedToCreateLinkSession
    case linkNotAuthorized

    /// Localized description of the error
    public var localizedDescription: String {
        return NSError.stp_unexpectedErrorMessage()
    }
}

extension PaymentSheetError: CustomDebugStringConvertible {
    /// Returns true if the error is un-fixable; e.g. no amount of retrying or customer action will result in something different
    static func isUnrecoverable(error: Error) -> Bool {
        // TODO: Expired ephemeral key
        return false
    }

    public var debugDescription: String {
        switch self {
        case .missingClientSecret:
            return "The client secret is missing"
        case .unexpectedResponseFromStripeAPI:
            return "Unexpected response from Stripe API."
        case .applePayNotSupported:
            return "Attempted Apple Pay but it's not supported by the device, not configured, or missing a presenter"
        case .deferredIntentValidationFailed(message: let message):
            return message
        case .alreadyPresented:
            return "presentingViewController is already presenting a view controller"
        case .flowControllerConfirmFailed(message: let message):
            return message
        case .errorHandlingNextAction:
            return "Unknown error occured while handling intent next action"
        case .unrecognizedHandlerStatus:
            return "Unrecognized STPPaymentHandlerActionStatus status"
        case .invalidClientSecret:
            return "Invalid client secret"
        case .accountLinkFailure:
            return STPLocalizedString(
                "Something went wrong when linking your account.\nPlease try again later.",
                "Error message when an error case happens when linking your account"
            )
        case .paymentIntentInTerminalState(status: let status):
            return "PaymentSheet received a PaymentIntent in a terminal state: \(status)"
        case .setupIntentInTerminalState(status: let status):
            return "PaymentSheet received a SetupIntent in a terminal state: \(status)"
        case .fetchPaymentMethodsFailure:
            return "Failed to retrieve PaymentMethods for the customer"
        case .linkSignUpNotRequired:
            return "Don't call sign up if not needed"
        case .noPaymentMethodTypesAvailable(intentPaymentMethods: let intentPaymentMethods):
            return "None of the payment methods on the PaymentIntent/SetupIntent can be used in PaymentSheet: \(intentPaymentMethods). You may need to set `allowsDelayedPaymentMethods` or `allowsPaymentMethodsRequiringShippingAddress` in your PaymentSheet.Configuration object."
        case .linkCallVerifyNotRequired:
            return "Don't call verify if not needed"
        case .linkingWithoutValidSession:
            return "Linking account session without valid consumer session"
        case .savingWithoutValidLinkSession:
            return "Saving to Link without valid session"
        case .payingWithoutValidLinkSession:
            return "Paying with Link without valid session"
        case .deletingWithoutValidLinkSession:
            return "Deleting Link payment details without valid session"
        case .updatingWithoutValidLinkSession:
            return "Updating Link payment details without valid session"
        case .linkLookupNotFound:
            return "Link account not found"
        case .failedToCreateLinkSession:
            return "Failed to create Link account session"
        case .linkNotAuthorized:
            return "confirm called without authorizing Link"
        case .unknown(debugDescription: let debugDescription):
            return debugDescription
        }
    }
}
