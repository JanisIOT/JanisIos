//
//  MGHelpers.m
//  
//
//  Created by Meridian Group on 9/9/14.
//  Copyright (c) 2014 Meridian Group. All rights reserved.
//

#import "MGHelpers.h"

#import <CommonCrypto/CommonDigest.h>

static inline char _to_hex(int v) {
	if (v < 10) return ('0' + v);
	return ('a' + (v-10));
}


NSString* AR_SHA1HashOf(NSString *str) {
	const char *strUTF = [str UTF8String];
	unsigned char strSHA1[512];
	unsigned char resSHA1[512];
	CC_SHA1(strUTF, strlen(strUTF), strSHA1);
	int p = 0;
	for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
		resSHA1[p] = _to_hex(strSHA1[i] >> 4);
		resSHA1[p+1] = _to_hex(strSHA1[i] & 0x0F);
		p += 2;
	}
	resSHA1[p] = 0;
	return [NSString stringWithFormat:@"%s", resSHA1];
}


NSString* AR_MD5HashOf(NSString *str) {
	const char *strUTF = [str UTF8String];
	unsigned char strMD5[512];
	unsigned char resMD5[512];
	CC_MD5(strUTF, strlen(strUTF), strMD5);
	int p = 0;
	for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
		resMD5[p] = _to_hex(strMD5[i] >> 4);
		resMD5[p+1] = _to_hex(strMD5[i] & 0x0F);
		p += 2;
	}
	resMD5[p] = 0;
	return [NSString stringWithFormat:@"%s", resMD5];
}

void print_free_memory ()
{
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    
    vm_statistics_data_t vm_stat;
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS)
        NSLog(@"Failed to fetch vm statistics");
    
    /* Stats in bytes */
    natural_t mem_used = (vm_stat.active_count +
                          vm_stat.inactive_count +
                          vm_stat.wire_count) * pagesize;
    natural_t mem_free = vm_stat.free_count * pagesize;
    natural_t mem_total = mem_used + mem_free;
    NSLog(@"used: %u free: %u total: %u", mem_used, mem_free, mem_total);
}

/* Safe gets */

inline BOOL GET_EXISTENCE_AR(NSDictionary *dic, NSString *key) {
	id obj = [dic objectForKey:key];
	if ([obj isKindOfClass:[NSNull class]]) return NO;
	return YES;
}

inline BOOL GET_BOOL_AR(NSDictionary *dic, NSString *key) {
	id obj = [dic objectForKey:key];
	if ([obj isKindOfClass:[NSNull class]]) return NO;
	return [obj boolValue];
}

inline long GET_LONG_AR(NSDictionary *dic, NSString *key) {
	id obj = [dic objectForKey:key];
	if ([obj isKindOfClass:[NSNull class]]) return 0;
	return [obj longValue];
}

inline long long GET_LONGLONG_AR(NSDictionary *dic, NSString *key) {
	id obj = [dic objectForKey:key];
	if ([obj isKindOfClass:[NSNull class]]) return 0;
	return [obj longLongValue];
}

inline double GET_DOUBLE_AR(NSDictionary *dic, NSString *key) {
	id obj = [dic objectForKey:key];
	if ([obj isKindOfClass:[NSNull class]]) return 0.0;
	return [obj doubleValue];
}

inline NSString* GET_STRING_AR(NSDictionary *dic, NSString *key) {
	id obj = [dic objectForKey:key];
	if ([obj isKindOfClass:[NSNull class]]) return nil;
	return obj;
}

inline id GET_OBJ_AR(NSDictionary *dic, NSString *key) {
	id obj = [dic objectForKey:key];
	if ([obj isKindOfClass:[NSNull class]]) return nil;
	return obj;
}


/* Current location */
CLLocation *gps_MTCurrentLocation = nil;


NSDateFormatter *dateFormatter;


@implementation MGHelpers

@end
