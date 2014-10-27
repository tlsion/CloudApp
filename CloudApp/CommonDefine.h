//
//  NSObject_CommonDefine.h
//  CloudApp
//
//  Created by Pro on 8/20/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//



#ifndef CloudApp_CommonDefine_h


#define EXTENSION_IMAGE @"jpg|jpeg|bmp|gif|png"
#define EXTENSION_COMPRESS @"rar|zip"
#define EXTENSION_TXT @"xml|html|aspx|cs|js|txt|sql|doc|docx|cc|c|php|py|pdf"
#define EXTENSION_AUIDO @"mp3|wav|mid|asf|tti|cda"
#define EXTENSION_VIDEO @"mpv|mpg|mpeg|avi|rm|rmvb|mov|wmv|asf|dat|asx|wvx|mpe|mpa|3gp|MP4|gdf"
// 255216 jpg;
// 7173 gif;
// 6677 bmp,
// 13780 png;
// 6787 swf
// 7790 exe dll,
// 8297 rar
// 8075 zip
// 55122 7z
// 6063 xml
// 6033 html
// 239187 aspx
// 117115 cs
// 119105 js
// 102100 txt
// 255254 sql
typedef NS_ENUM(NSInteger, CAFileTypeCode) {
    CAFileTypeCodeOther = 0,
    CAFileTypeCodeFolder,
    CAFileTypeCodeCompress,
    CAFileTypeCodeTxt,
    CAFileTypeCodeImage,
    CAFileTypeCodeAudio,
    CAFileTypeCodeVideo
//    CAFileTypeCodeApplication
};

#endif