//
//  SHMIDNetUtil.m
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 7/1/16.
//
//

#import "SHMIDNetUtil.h"
#import <arpa/inet.h>
#import <getgateway.h>
#import <getmacaddress.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation SHMIDNetUtil

#pragma mark - Gateway

+ (NSString *)getDefaultGatewayIPAddress {
    NSString *ipAddr = @"";
    struct in_addr gatewayaddr;
    int r = getdefaultgateway(&(gatewayaddr.s_addr));
    if(r >= 0) {
        ipAddr = [NSString stringWithFormat:@"%s", inet_ntoa(gatewayaddr)];
    }
    NSLog(@"%s - Default Gateway(ipv4) is %@", __PRETTY_FUNCTION__, ipAddr);
    return ipAddr;
}

+ (NSString *)getDefaultGatewayMacAddress {
    NSString *macAddr = @"";
    struct in_addr gatewayaddr;
    int r = getdefaultgateway(&(gatewayaddr.s_addr));
    if(r >= 0) {
        u_char *cp = getmacaddress(gatewayaddr.s_addr);
        if (strlen(cp) > 0) {
            macAddr = [NSString stringWithFormat:@"%x:%x:%x:%x:%x:%x", cp[0], cp[1], cp[2], cp[3], cp[4], cp[5]];
        }
    }
    NSLog(@"%s - Default Gateway(mac-addr) is %@", __PRETTY_FUNCTION__, macAddr);
    return macAddr;
}

+ (NSString *)getMACAddressForDeviceWithIP:(NSString *)ipAddress {
    NSString *macAddr = @"";
    u_char *cp = getmacaddress(inet_addr([ipAddress UTF8String]));
    if (strlen(cp) > 0) {
        macAddr = [NSString stringWithFormat:@"%x:%x:%x:%x:%x:%x", cp[0], cp[1], cp[2], cp[3], cp[4], cp[5]];
    }
    return macAddr;
}

#pragma mark - AP

+ (NSString *)getCurrentAPMacAddress {
    NSString *ssidMacAddress = @"";
    NSDictionary *ssidInfo = [[self class] getNetInterfaceInfo];
    if (ssidInfo.count > 0) {
        ssidMacAddress = ssidInfo[@"BSSID"];
    }
    return ssidMacAddress;
}

+ (NSString *)getCurrentAPSSIDString {
    return [[self class] getNetInterfaceInfo][@"SSID"];
}

+ (NSDictionary *)getNetInterfaceInfo {
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    NSLog(@"%s: Supported Interfaces: %@", __PRETTY_FUNCTION__, interfaceNames);
    NSDictionary *ssidInfo;
    for (NSString *interfaceName in interfaceNames) {
        ssidInfo = CFBridgingRelease(CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        NSLog(@"%s: %@ => %@", __PRETTY_FUNCTION__, interfaceName, ssidInfo);
        BOOL isNotEmpty = (ssidInfo.count > 0);
        if (isNotEmpty) {
            break;
        }
    }
    return ssidInfo;
}

@end