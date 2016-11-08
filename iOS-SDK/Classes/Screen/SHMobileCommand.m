//
//  SHMobileCommand.m
//  ShodoggSDK
//
//  Created by Aamir Khan on 12/12/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import "SHMobileCommand.h"
#import "SHScreenSesssion.h"
#import "SHScreenAssetState.h"
#import "SHUtilities.h"

@implementation SHMobileCommand

+ (SHMobileCommand *)fromJSON:(id)JSON {
    SHMobileCommand *mobileCommand = [[SHMobileCommand alloc] init];
    [mobileCommand setScreenSessionId:NilToEmptyString(JSON[@"screenSessionId"])];
    [mobileCommand setScreenId:NilToEmptyString(JSON[@"screenId"])];
    [mobileCommand setTimestamp:dateString([NilToEmptyString(JSON[@"timestamp"]) doubleValue])];
    [mobileCommand setCmd:NilToEmptyString(JSON[@"cmd"])];
    [mobileCommand setCmdParams:JSONToDictionaryOrEmpty(JSON[@"cmdParms"])];
    NSArray *assetStateNodes = (NSArray *)JSONToArrayOrEmpty(JSON[@"states"]);
    [mobileCommand setStates:[SHMobileCommand convertToStateObjects:assetStateNodes]];
    return mobileCommand;
}

+ (NSMutableArray *)convertToStateObjects:(NSArray *)nodes {
    NSMutableArray *assetStates = [[NSMutableArray alloc] initWithCapacity:nodes.count];
    for (id object in nodes) {
        SHScreenAssetState *assetState = [SHScreenAssetState fromJSON:object];
        if (assetState) {
            [assetStates addObject:assetState];
        }
    }
    return assetStates;
}

+ (NSDictionary *)commandAsDictionaryForScreenAssetStates:(NSArray *)states {
    NSMutableDictionary *command = [[NSMutableDictionary alloc] init];
    command[@"screenSessionId"] = [SHScreenSesssion getCurrentScreenSessionId];
    command[@"screenId"] = nil;
    command[@"states"] = states;
    command[@"cmd"] = @"DISPLAY";
    command[@"cmdParms"] = @{};
    command[@"timestamp"] = timestamp([NSDate date]);
    return command;
}

@end