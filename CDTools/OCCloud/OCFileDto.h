//
//  OCFileDto.h
//  Owncloud iOs Client
//
// Copyright (C) 2014 ownCloud Inc. (http://www.owncloud.org/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//

#import <Foundation/Foundation.h>
#import "CommonDefine.h"
@protocol OCFileDtoDelegate;
@interface OCFileDto : NSObject

@property (nonatomic, copy) NSString *permissions;

@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *fileTitle;
@property (nonatomic, assign)BOOL isDirectory;
@property (nonatomic, assign)long long size;
@property (nonatomic, assign)long date;
@property (nonatomic, assign)long long etag;

@property (nonatomic, assign)BOOL isDelete;//只有传输列表用到

@property (nonatomic, assign)NSInteger fileStatus;//判断状态  0、未下载或未上传 1、已下载

@property (nonatomic , assign) BOOL isSelect;
@property (nonatomic, assign) CAFileTypeCode fileType;

//传输列表
@property (nonatomic, assign) BOOL isTransfer;
@property (nonatomic, assign) NSInteger bytes;
@property (nonatomic, assign) long long totalBytes;
@property (nonatomic, assign) CATransferStatus tranferStatus;
@property (nonatomic, weak) id<OCFileDtoDelegate>delegate;
@end

@protocol OCFileDtoDelegate <NSObject>

-(void)setDoTotalBytes:(long long)aTotalBytes;
-(void)setDoBytes:(NSInteger) aBytes;
@end