//
//  MIMovieObject.m
//  MyInsight
//
//  Created by SongMengLong on 2018/9/25.
//  Copyright © 2018 SongMenglong. All rights reserved.
//

#import "MIMovieObject.h"

@interface MIMovieObject()

@property (nonatomic, copy) NSString *cruutenPath;

@end

@implementation MIMovieObject
{
    AVFormatContext     *MIFormatCtx;
    AVCodecContext      *MICodecCtx;
    AVFrame             *MIFrame;
    AVStream            *stream;
    AVPacket            packet;
    AVPicture           picture;
    int                 videoStream;
    double              fps;
    BOOL                isReleaseResources;
}

#pragma mark ------------------------------------
#pragma mark  初始化
- (instancetype)initWithVideo:(NSString *)moviePath {
    
    if (!(self=[super init])) return nil;
    if ([self initializeResources:[moviePath UTF8String]]) {
        self.cruutenPath = [moviePath copy];
        return self;
    } else {
        return nil;
    }
}
- (BOOL)initializeResources:(const char *)filePath {
    
    isReleaseResources = NO;
    AVCodec *pCodec;
    // 注册所有解码器
    avcodec_register_all();
    av_register_all();
    avformat_network_init();
    // 打开视频文件
    if (avformat_open_input(&MIFormatCtx, filePath, NULL, NULL) != 0) {
        NSLog(@"打开文件失败");
        goto initError;
    }
    // 检查数据流
    if (avformat_find_stream_info(MIFormatCtx, NULL) < 0) {
        NSLog(@"检查数据流失败");
        goto initError;
    }
    // 根据数据流,找到第一个视频流
    if ((videoStream =  av_find_best_stream(MIFormatCtx, AVMEDIA_TYPE_VIDEO, -1, -1, &pCodec, 0)) < 0) {
        NSLog(@"没有找到第一个视频流");
        goto initError;
    }
    // 获取视频流的编解码上下文的指针
    stream      = MIFormatCtx->streams[videoStream];
    MICodecCtx  = stream->codec;
#if DEBUG
    // 打印视频流的详细信息
    av_dump_format(MIFormatCtx, videoStream, filePath, 0);
#endif
    if(stream->avg_frame_rate.den && stream->avg_frame_rate.num) {
        fps = av_q2d(stream->avg_frame_rate);
    } else { fps = 30; }
    // 查找解码器
    pCodec = avcodec_find_decoder(MICodecCtx->codec_id);
    if (pCodec == NULL) {
        NSLog(@"没有找到解码器");
        goto initError;
    }
    // 打开解码器
    if(avcodec_open2(MICodecCtx, pCodec, NULL) < 0) {
        NSLog(@"打开解码器失败");
        goto initError;
    }
    // 分配视频帧
    MIFrame = av_frame_alloc();
    _outputWidth = MICodecCtx->width;
    _outputHeight = MICodecCtx->height;
    return YES;
initError:
    return NO;
}

- (void)seekTime:(double)seconds {
    AVRational timeBase = MIFormatCtx->streams[videoStream]->time_base;
    int64_t targetFrame = (int64_t)((double)timeBase.den / timeBase.num * seconds);
    avformat_seek_file(MIFormatCtx,
                       videoStream,
                       0,
                       targetFrame,
                       targetFrame,
                       AVSEEK_FLAG_FRAME);
    avcodec_flush_buffers(MICodecCtx);
}

- (BOOL)stepFrame {
    int frameFinished = 0;
    while (!frameFinished && av_read_frame(MIFormatCtx, &packet) >= 0) {
        if (packet.stream_index == videoStream) {
            avcodec_decode_video2(MICodecCtx,
                                  MIFrame,
                                  &frameFinished,
                                  &packet);
        }
    }
    if (frameFinished == 0 && isReleaseResources == NO) {
        [self releaseResources];
    }
    return frameFinished != 0;
}

- (void)replaceTheResources:(NSString *)moviePath {
    if (!isReleaseResources) {
        [self releaseResources];
    }
    self.cruutenPath = [moviePath copy];
    [self initializeResources:[moviePath UTF8String]];
}

- (void)redialPaly {
    [self initializeResources:[self.cruutenPath UTF8String]];
}

#pragma mark ------------------------------------
#pragma mark  重写属性访问方法
-(void)setOutputWidth:(int)newValue {
    if (_outputWidth == newValue) return;
    _outputWidth = newValue;
}

-(void)setOutputHeight:(int)newValue {
    if (_outputHeight == newValue) return;
    _outputHeight = newValue;
}

-(UIImage *)currentImage {
    if (!MIFrame->data[0]) return nil;
    return [self imageFromAVPicture];
}

-(double)duration {
    return (double)MIFormatCtx->duration / AV_TIME_BASE;
}

- (double)currentTime {
    AVRational timeBase = MIFormatCtx->streams[videoStream]->time_base;
    return packet.pts * (double)timeBase.num / timeBase.den;
}

- (int)sourceWidth {
    return MICodecCtx->width;
}

- (int)sourceHeight {
    return MICodecCtx->height;
}

- (double)fps {
    return fps;
}

#pragma mark --------------------------
#pragma mark - 内部方法

- (UIImage *)imageFromAVPicture {
    avpicture_free(&picture);
    avpicture_alloc(&picture, AV_PIX_FMT_RGB24, _outputWidth, _outputHeight);
    struct SwsContext * imgConvertCtx = sws_getContext(MIFrame->width,
                                                       MIFrame->height,
                                                       AV_PIX_FMT_YUV420P,
                                                       _outputWidth,
                                                       _outputHeight,
                                                       AV_PIX_FMT_RGB24,
                                                       SWS_FAST_BILINEAR,
                                                       NULL,
                                                       NULL,
                                                       NULL);
    if(imgConvertCtx == nil) return nil;
    sws_scale(imgConvertCtx,
              MIFrame->data,
              MIFrame->linesize,
              0,
              MIFrame->height,
              picture.data,
              picture.linesize);
    sws_freeContext(imgConvertCtx);
    
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CFDataRef data = CFDataCreate(kCFAllocatorDefault,
                                  picture.data[0],
                                  picture.linesize[0] * _outputHeight);
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(data);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef cgImage = CGImageCreate(_outputWidth,
                                       _outputHeight,
                                       8,
                                       24,
                                       picture.linesize[0],
                                       colorSpace,
                                       bitmapInfo,
                                       provider,
                                       NULL,
                                       NO,
                                       kCGRenderingIntentDefault);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    CGColorSpaceRelease(colorSpace);
    CGDataProviderRelease(provider);
    CFRelease(data);
    
    return image;
}

#pragma mark --------------------------
#pragma mark - 释放资源
- (void)releaseResources {
    NSLog(@"释放资源");
    //    SJLogFunc
    isReleaseResources = YES;
    // 释放RGB
    avpicture_free(&picture);
    // 释放frame
    av_packet_unref(&packet);
    // 释放YUV frame
    av_free(MIFrame);
    // 关闭解码器
    if (MICodecCtx) avcodec_close(MICodecCtx);
    // 关闭文件
    if (MIFormatCtx) avformat_close_input(&MIFormatCtx);
    avformat_network_deinit();
}

@end
