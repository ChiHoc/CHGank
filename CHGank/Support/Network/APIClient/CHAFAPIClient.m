//
//  CHAFAPIClient.m
//  CHNetwork
//
//  Created by ChiHo on 6/28/15.
//  Copyright (c) 2015 ChiHo. All rights reserved.
//

#import "CHAFAPIClient.h"

@interface CHHTTPRequestSerializer : AFHTTPRequestSerializer

@end

@implementation CHHTTPRequestSerializer

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(request);
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    [self.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        if (![request valueForHTTPHeaderField:field]) {
            [mutableRequest setValue:value forHTTPHeaderField:field];
        }
    }];
    
    if (parameters) {
        for (int i = 0; i < [parameters count]; i ++) {
            NSString *param = parameters[@(i)];
            if (param) {
                mutableRequest.URL = [NSURL URLWithString:[[mutableRequest.URL absoluteString] stringByAppendingPathComponent:param]];
            }
        }
    }
    return mutableRequest;
}

@end

@implementation CHAFAPIClient

static dispatch_once_t onceToken;

#if DEBUG
static const NSTimeInterval kDefaultTimeoutInterval = 60;
#else
static const NSTimeInterval kDefaultTimeoutInterval = 7;
#endif

+ (id)sharedClient
{
    static CHAFAPIClient *_sharedClient = nil;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[CHAFAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kAppDomain]];
        _sharedClient.responseSerializer = [AFCompoundResponseSerializer serializer];
        _sharedClient.requestSerializer.timeoutInterval = kDefaultTimeoutInterval;
        [_sharedClient.operationQueue setMaxConcurrentOperationCount:3];
        // optional
        _sharedClient.requestSerializer = [CHHTTPRequestSerializer serializer];
    });
    
    return _sharedClient;
}

+ (void)resetSharedClient
{
    onceToken = 0;
}

- (id)addHeader:(NSString *)headerData forField:(NSString *)fieldString
{
    [self.requestSerializer setValue:headerData forHTTPHeaderField:fieldString];
    return self;
}

- (BOOL)isNetworkReachable
{
    AFNetworkReachabilityManager *reach = [AFNetworkReachabilityManager sharedManager];
    [reach startMonitoring];
    return [reach isReachable];
}

#pragma mark - 网络请求

- (NSURLSessionDataTask *)requestDataWithPath:(NSString *)path
                                       method:(NSString *)method
                                   parameters:(NSDictionary *)params
                              timeoutInterval:(NSTimeInterval)timeoutInterval
                                     formData:(NSDictionary *)formData
                                     progress:(void (^)(NSProgress *))progress
                                      success:(void (^)(id responseObject))success
                                      failure:(void (^)(NSError *error))failure
{
    if (timeoutInterval) {
        self.requestSerializer.timeoutInterval = timeoutInterval;
    } else {
        self.requestSerializer.timeoutInterval = kDefaultTimeoutInterval;
    }
    if ([method isEqualToString:@"POST"]) {
        void (^formDataBlock)(id<AFMultipartFormData> formData) = nil;
        if (formData && [formData count]) {
            NSArray *keys = [formData allKeys];
            for (NSString *key in keys) {
                if ([key isEqualToString:@"image"]) {
                    NSDictionary *imagesDic = formData[@"image"];
                    NSArray *imagesKeys = [imagesDic allKeys];
                    formDataBlock = ^(id<AFMultipartFormData> formData) {
                        for (NSString *imageKey in imagesKeys) {
                            [formData appendPartWithFileData:imagesDic[imageKey]
                                                        name:@"file"
                                                    fileName:[NSString stringWithFormat:@"%@.jpeg", imageKey]
                                                    mimeType:@"image/jpeg"];
                        }
                    };
                } else if ([key isEqualToString:@"formData"]){
                    NSDictionary *formDic = formData[@"formData"];
                    NSArray *formKeys = [formDic allKeys];
                    formDataBlock = ^(id<AFMultipartFormData> formData) {
                        for (NSString *formKey in formKeys) {
                            [formData appendPartWithFormData:formDic[formKey]
                                                        name:formKey];
                        }
                    };
                }
            }
        }
        
        return [self POST:path parameters:params constructingBodyWithBlock:formDataBlock progress:progress success:^(NSURLSessionDataTask *task, id responseObject) {
            NSError *error = nil;
            id responseDic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:NSJSONReadingAllowFragments
                                                               error:&error];
            if (error) {
                CHLOG(@"\npath: %@\n%@\n%@", path, [params description], [[NSString alloc] initWithData:responseObject encoding:kCFStringEncodingUTF8]);
                if (failure) {
                    failure(error);
                }
            } else {
                if (success) {
                    success(responseDic);
                }
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    } else {
        return [self GET:path parameters:params progress:progress success:^(NSURLSessionDataTask *task, id responseObject) {
            NSError *error = nil;
            id responseDic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:NSJSONReadingAllowFragments
                                                               error:&error];
            if (error) {
                CHLOG(@"\npath: %@\n%@\n%@", path, [params description], [[NSString alloc] initWithData:responseObject encoding:kCFStringEncodingUTF8]);
                if (failure) {
                    failure(error);
                }
            } else {
                if (success) {
                    success(responseDic);
                }
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    }
}


@end
