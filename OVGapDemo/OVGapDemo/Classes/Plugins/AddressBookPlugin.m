//
//  AddressBookPlugin.m
//  OVGapDemo
//
//  Created by Vinson.D.Warm on 9/17/13.
//  Copyright (c) 2013 vepace. All rights reserved.
//

#import "AddressBookPlugin.h"
#import <AddressBook/AddressBook.h>

NSString *const kDenied = @"Access to address book is denied";
NSString *const kNotDetermined = @"Access to address book is not determined";
NSString *const kRestricted = @"Access to address book is restricted";

ABAddressBookRef addressBook;

@implementation AddressBookPlugin

- (void)testAddressBook:(OGInvokeCommand *)command {
    
    CFErrorRef error = NULL;
    switch (ABAddressBookGetAuthorizationStatus()){
        case kABAuthorizationStatusAuthorized:{
        addressBook = ABAddressBookCreateWithOptions(NULL, &error);
        [self readFromAddressBook:addressBook];
        if (addressBook != NULL){
            CFRelease(addressBook);
        }
        break;
        }
        case kABAuthorizationStatusDenied:{
            [self displayMessage:kDenied];
            break; }
        case kABAuthorizationStatusNotDetermined:{
            addressBook = ABAddressBookCreateWithOptions(NULL, &error); ABAddressBookRequestAccessWithCompletion
            (addressBook, ^(bool granted, CFErrorRef error) {
                [self displayMessage:kNotDetermined];
                if (granted){
                    NSLog(@"Access was granted");
                    [self readFromAddressBook:addressBook];
                } else {
                    NSLog(@"Access was not granted");
                }
                if (addressBook != NULL){
                    CFRelease(addressBook);
                }
            });
            break; }
        case kABAuthorizationStatusRestricted:{
            [self displayMessage:kRestricted];
            break;
        }
    }
}

- (void) readFromAddressBook:(ABAddressBookRef)paramAddressBook{
    NSArray *allPeople = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(paramAddressBook);
    NSUInteger peopleCounter = 0;
    NSMutableArray *peopleArray = [NSMutableArray array];
    for (peopleCounter = 0; peopleCounter < [allPeople count]; peopleCounter++) {
        ABRecordRef thisPerson = (__bridge ABRecordRef) [allPeople objectAtIndex:peopleCounter];
        NSString *firstName = (__bridge_transfer NSString *) ABRecordCopyValue(thisPerson, kABPersonFirstNameProperty);
        NSString *lastName = (__bridge_transfer NSString *) ABRecordCopyValue(thisPerson, kABPersonLastNameProperty);
        
        NSMutableDictionary *personInfo = [NSMutableDictionary dictionary];
        [personInfo setValue:firstName forKey:@"FirstName"];
        [personInfo setValue:lastName forKey:@"LastName"];
        [peopleArray addObject:personInfo];
        
        [self logPersonEmails:thisPerson];
    }
}

- (void) logPersonEmails:(ABRecordRef)paramPerson{
    if (paramPerson == NULL){
        NSLog(@"The given person is NULL."); return;
    }
    ABMultiValueRef emails =
    ABRecordCopyValue(paramPerson, kABPersonEmailProperty);
    if (emails == NULL){
        NSLog(@"This contact does not have any emails."); return;
    }
    /* Go through all the emails */
    NSUInteger emailCounter = 0;
    for (emailCounter = 0; emailCounter < ABMultiValueGetCount(emails); emailCounter++){
        /* Get the label of the email (if any) */
        NSString *emailLabel = (__bridge_transfer NSString *) ABMultiValueCopyLabelAtIndex(emails, emailCounter);
        NSString *localizedEmailLabel = (__bridge_transfer NSString *) ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)emailLabel);
        /* And then get the email address itself */
        NSString *email = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(emails, emailCounter);
        NSLog(@"Label = %@, Localized Label = %@, Email = %@", emailLabel, localizedEmailLabel, email);
    }
    CFRelease(emails);
}

- (void) displayMessage:(NSString *)paramMessage{
    NSLog(@"param message: %@", paramMessage);
}

@end
