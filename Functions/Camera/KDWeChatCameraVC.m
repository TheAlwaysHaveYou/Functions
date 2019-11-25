//
//  KDWeChatCameraVC.m
//  Functions
//
//  Created by 范魁东 on 2019/11/22.
//  Copyright © 2019 FanKD. All rights reserved.
//

#import "KDWeChatCameraVC.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

#import "KDWeChatPhotoPreviewView.h"
#import "KDWeChatCaptureButton.h"
#import "KDWeChatVideoPreviewVC.h"

@interface KDWeChatCameraVC ()<KDWeChatPhotoPreviewViewDelegate,UIGestureRecognizerDelegate,KDWeChatCaptureButtonDelegate,AVCaptureFileOutputRecordingDelegate>
//捕获设备 , 摄像头, 麦克风
@property (nonatomic , strong) AVCaptureDevice *device;
//输入设备
@property (nonatomic , strong) AVCaptureDeviceInput *input;

@property (nonatomic , strong) AVCaptureDeviceInput *audioInput;//音频输入

@property (nonatomic , strong) AVCaptureStillImageOutput *imageOutput;//输出图片

@property (nonatomic , strong) AVCaptureMovieFileOutput *movieFileOutput;//声音视频同时有,方便

//@property (nonatomic , strong) AVCaptureVideoDataOutput *videoOutput;//输出视频  AVCaptureMovieFileOutput自定义有局限
//
//@property (nonatomic , strong) AVCaptureAudioDataOutput *audioOutput;//输出音频

//将输入输出结合在一起 , 启动捕获设备
@property (nonatomic , strong) AVCaptureSession *session;
//即时预览图层
@property (nonatomic , strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic , strong) UIView *focusView;//对焦的方框

@property (nonatomic , strong) KDWeChatPhotoPreviewView *prePhotoView;//预览拍的照片

@property (nonatomic , assign) CGFloat beginGestureScale;//起始缩放比例
@property (nonatomic , assign) CGFloat effectiveScale;//最终缩放比例

@end

@implementation KDWeChatCameraVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //判断相册权限
    //    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    //    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
    //        return;
    //    }
    //判断相机权限
    //    AVAuthorizationStatus videoStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    //    if (videoStatus == AVAuthorizationStatusRestricted || videoStatus ==AVAuthorizationStatusDenied) {
    //        return;
    //    }
    
    //判断麦克风权限
    //    AVAuthorizationStatus audioStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    //    if (audioStatus == AVAuthorizationStatusRestricted || audioStatus == AVAuthorizationStatusDenied) {
    //        return;
    //    }
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setupSubviews];
    
    [self setAccessoryView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.session) {
        [self.session startRunning];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.session) {
        [self.session stopRunning];
    }
}

- (void)setupSubviews {
    
    //AVCaptureDevicePositionBack  后置摄像头
    //AVCaptureDevicePositionFront 前置摄像头
    self.device = [self cameraWithPosition:AVCaptureDevicePositionBack];
    NSError *inputError;
    self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:&inputError];
    if (inputError) {
        NSLog(@"self.input 的ERROR ------ (%@)",inputError);
    }
    
    NSError *audioError;
    self.audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio] error:&audioError];
    if (audioError) {
        NSLog(@"音频设备添加出错 -----  (%@)",audioError);
    }
    
    self.imageOutput = [[AVCaptureStillImageOutput alloc] init];
    //    NSDictionary *outputSetting = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.imageOutput setOutputSettings:@{AVVideoCodecKey:AVVideoCodecJPEG}];//输出编码
    
    self.movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    self.session = [[AVCaptureSession alloc] init];
    //设置拿到图像的尺寸
    self.session.sessionPreset = AVCaptureSessionPreset1280x720;
    
    //输入输出设备结合
    if ([self.session canAddInput:self.input]) {//相机的画面的输入
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.imageOutput]) {//拍照的输出
        [self.session addOutput:self.imageOutput];
    }
    
    if ([self.session canAddInput:self.audioInput]) {//音频的输入
        [self.session addInput:self.audioInput];
    }
    if ([self.session canAddOutput:self.movieFileOutput]) {//视频的输出
        [self.session addOutput:self.movieFileOutput];
    }
    
    //监听自动对焦
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidAutoChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:self.device];
    
    //预览曾
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.frame = self.view.bounds;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];
    
    if ([self.device lockForConfiguration:nil]) {
        //闪光灯自动
        if ([self.device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [self.device setFlashMode:AVCaptureFlashModeAuto];
        }else {
            NSLog(@"不支持自动闪光灯自动调节");
        }
        
        [self.device unlockForConfiguration];
    }
    
    UITapGestureRecognizer *focusTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusViewWithTapGesture:)];
    [self.view addGestureRecognizer:focusTap];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinchGesture.delegate = self;
    [self.view addGestureRecognizer:pinchGesture];
    
    self.beginGestureScale = 1.0f;
    self.effectiveScale = 1.0f;
}

- (void)setAccessoryView {
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 30, 30, 30)];
    backBtn.backgroundColor = [UIColor redColor];
    [backBtn addTarget:self action:@selector(dismissCurrentViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    
    UIButton *changeCameraBtn = [[UIButton alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH - 60, 30, 30, 30)];
    changeCameraBtn.backgroundColor = [UIColor redColor];
    [changeCameraBtn addTarget:self action:@selector(changeCameraDirction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeCameraBtn];
    
    KDWeChatCaptureButton *actionBtn = [[KDWeChatCaptureButton alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH/2-50, kSCREEN_HEIGHT - 200, 100, 100)];
    actionBtn.delegate = self;
    [self.view addSubview:actionBtn];
    
    
    self.focusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    self.focusView.backgroundColor = [UIColor clearColor];
    self.focusView.layer.borderWidth = 1;
    self.focusView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.focusView.hidden = YES;
    [self.view addSubview:self.focusView];
    
    self.prePhotoView = [[KDWeChatPhotoPreviewView alloc] initWithFrame:self.view.bounds];
    self.prePhotoView.delegate = self;
    self.prePhotoView.hidden = YES;
    [self.view addSubview:self.prePhotoView];
}

//获取前后摄像头
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

#pragma mark - 对焦 手势点击
//点击手势对焦
- (void)focusViewWithTapGesture:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self.view];
    
    CGSize size = self.view.bounds.size;
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1-point.x/size.width );
    NSError *error;
    if ([self.device lockForConfiguration:&error]) {
        //对焦模式和对焦点
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        //曝光模式和曝光点
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
            [self.device setExposurePointOfInterest:focusPoint];
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        
        //设置对焦动画
        self.focusView.center = point;
        self.focusView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                self.focusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                self.focusView.hidden = YES;
            }];
        }];
    }
    
    if (error) {
        NSLog(@"锁定相机配置------ERROR  (%@)",error);
    }
}

#pragma mark - 手势调节缩放比例
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinch {
    BOOL allTouchesAreOnThePreviewLayer = YES;
    
    NSUInteger numTouches = [pinch numberOfTouches], i;
    for ( i = 0; i < numTouches; ++i ) {
        CGPoint location = [pinch locationOfTouch:i inView:self.view];
        CGPoint convertedLocation = [self.previewLayer convertPoint:location fromLayer:self.previewLayer.superlayer];
        if (![self.previewLayer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    if (allTouchesAreOnThePreviewLayer) {
        self.effectiveScale = self.beginGestureScale * pinch.scale;
        if (self.effectiveScale < 1.0){
            self.effectiveScale = 1.0;
        }
        
        CGFloat maxScaleAndCropFactor = [[self.imageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
        
        if (self.effectiveScale > maxScaleAndCropFactor) {
            self.effectiveScale = maxScaleAndCropFactor;
        }
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
        [CATransaction commit];
    }
}


#pragma mark - KDWeChatCaptureButtonDelegate 按钮执行的拍照和录制
- (void)captureButtonActoinWithMediaType:(CaptureMediaType)mediaType recordVideoFinish:(BOOL)recordFinish {
    if (![self authorizationStatusWithCamera_Photo_Micphone]) return;
    
    if (mediaType == CaptureMediaTypePhoto) {
        //拍照
        AVCaptureConnection *connection = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
        if (!connection) {
            NSLog(@"拍照失败");
            return;
        }
        
        //设置输出照片正确的方向
        UIDeviceOrientation currentDeviceOrientation = [[UIDevice currentDevice] orientation];
        AVCaptureVideoOrientation avCaptureOrientation = [self avOrientationForDeviceOrientation:currentDeviceOrientation];
        [connection setVideoOrientation:avCaptureOrientation];
        [connection setVideoScaleAndCropFactor:self.effectiveScale];//手动缩放的时候在改变参数
        
        [self.imageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
            if (!imageDataSampleBuffer) {
                return ;
            }
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            //得到拍摄的照片
            UIImage *getImage = [UIImage imageWithData:imageData];
            [self.session stopRunning];
            
            self.prePhotoView.hidden = NO;
            [self.prePhotoView setPreviewImage:getImage];
        }];
    }else {
        //视频录制
        
        if (!recordFinish) {//开始
            AVCaptureConnection *connection = [self.movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
            
            UIDeviceOrientation currentDeviceOrientation = [[UIDevice currentDevice] orientation];
            AVCaptureVideoOrientation avCaptureOrientation = [self avOrientationForDeviceOrientation:currentDeviceOrientation];
            [connection setVideoOrientation:avCaptureOrientation];
            [connection setVideoScaleAndCropFactor:self.effectiveScale];//手动缩放的时候在改变参数
            
            NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *name = [formatter stringFromDate:[NSDate date]];
            NSString *path = [file stringByAppendingFormat:@"/%@.mp4",name];
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                BOOL success = [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
                if (!success) {
                    NSLog(@"创建视频储存路径错误!!!!!!");
                }
            }
            
            NSURL *url = [NSURL fileURLWithPath:path];
            NSLog(@"自定义视频存储URL ---- (%@)",url);
            
            if (![self.movieFileOutput isRecording]) {
                [self.movieFileOutput startRecordingToOutputFileURL:url recordingDelegate:self];
            }
        }else {//结束
            if ([self.movieFileOutput isRecording]) {
                [self.movieFileOutput stopRecording];
            }
        }
    }
}

//获取当前设备的旋转方向,  配合拍照的时候输出正确方向的照片
- (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation {
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if (deviceOrientation == UIDeviceOrientationLandscapeLeft ) {
        result = AVCaptureVideoOrientationLandscapeRight;
    } else if ( deviceOrientation == UIDeviceOrientationLandscapeRight ) {
        result = AVCaptureVideoOrientationLandscapeLeft;
    }
    return result;
}

#pragma mark - AVCaptureFileOutputRecordingDelegate  录制视频的代理
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    if (error) NSLog(@"保存视频代理报错啦---------%@",error);
    
    if (CMTimeGetSeconds(captureOutput.recordedDuration) < 3) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"录制时间不少于3秒" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    
    NSLog(@"保存视频的URL = (%@) ,时长recode = %f , 大小 %lld kb    %lld MB", outputFileURL, CMTimeGetSeconds(captureOutput.recordedDuration), captureOutput.recordedFileSize/1024,(captureOutput.recordedFileSize/1024)/1024);
    
    
    KDWeChatVideoPreviewVC *videoPreView = [[KDWeChatVideoPreviewVC alloc] init];
    [videoPreView setManageVideo:^(BOOL isDelete) {
        if (isDelete) {
            [[NSFileManager defaultManager] removeItemAtURL:outputFileURL error:nil];
            
            return ;
        }else {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:outputFileURL];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (success) NSLog(@"++++++++保存视频成功");
                else NSLog(@"保存视频出错啦 ---------(%@)",error);
                
                [[NSFileManager defaultManager] removeItemAtURL:outputFileURL error:nil];
            }];
        }
    }];
    [videoPreView setVideoURL:outputFileURL];
    
    [self presentViewController:videoPreView animated:NO completion:nil];
}

#pragma mark - ACTION

- (void)dismissCurrentViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//切换前后摄像头
- (void)changeCameraDirction:(UIButton *)sender {
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        //        [self.session stopRunning];
        
        NSError *error;
        
        CATransition *animation = [CATransition animation];
        animation.duration = 0.5f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = @"oglFlip";
        
        AVCaptureDevice *newCamera = nil;
        AVCaptureDeviceInput *newInput = nil;
        
        AVCaptureDevicePosition position = [[self.input device] position];
        if (position == AVCaptureDevicePositionFront) {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            animation.subtype = kCATransitionFromLeft;
        }else {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            animation.subtype = kCATransitionFromRight;
        }
        
        newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:&error];
        [self.previewLayer addAnimation:animation forKey:nil];
        if (newInput) {
            [self.session beginConfiguration];
            [self.session removeInput:self.input];
            if ([self.session canAddInput:newInput]) {
                [self.session addInput:newInput];
                self.input = newInput;
            }else {
                [self.session addInput:self.input];
            }
            [self.session commitConfiguration];
        }else if (error) {
            NSLog(@"切换摄像头错误 -----  ERROR (%@)",error);
        }
        
        
        //        [self.session startRunning];
    }else {
        NSLog(@"设备只有一个单面的摄像头");
    }
}


/*
 保存拍摄图片和视频的方法
 第一个  就是下面的 UI方法  最常用
 
 第二个  AssetsLibrary 里面的  8.0后废弃
 ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
 [lib writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) { }];
 
 第三个  PhotoKit 里面的 8.0后出来的 可进行复杂性操作
 [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
 PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
 } completionHandler:^(BOOL success, NSError * _Nullable error) {
 NSLog(@"success = %d, error = %@", success, error);
 }];
 */

//保存图片到相册
- (void)saveImageToPhotoAlbum:(UIImage *)savedImage {
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"***************\n\n\n照片保存失败\n\n\n***************");
    }else {
        NSLog(@"照片保存成功~~~~~~~~~~~~~~~~~~~~~~~~");
    }
}
//保存视频到相册
- (void)saveVideoToPhotoAlbum:(NSString *)videoPath {
    UISaveVideoAtPathToSavedPhotosAlbum(videoPath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
}
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"!!!!!!!!!!!!!\n\n\n视频保存失败\n\n\n!!!!!!!!!!!!!!!");
    }else {
        NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~视频保存成功");
    }
}

#pragma makr - UIGestureRecognizerDelegate   缩放焦距的时候用到代理
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}

#pragma mark - KDWeChatPhotoPreviewViewDelegate
- (void)manageCurrentPreviewPhotoWithAction:(NSInteger)manage andImage:(UIImage *)image {
    if (manage == 0) {//删除
        
    }else {//保存
        [self saveImageToPhotoAlbum:image];
    }
    self.prePhotoView.hidden = YES;
    
    [self.session startRunning];
}

#pragma mark - 自动对焦的监听事件
//监听有效果,但是不执行这个方法啊?????????????  WTF
- (void)subjectAreaDidAutoChange:(NSNotification *)notification {
    NSError *error;
    if ([self.device lockForConfiguration:&error]) {
        //是否支持自动对焦
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus] && self.device.isFocusPointOfInterestSupported) {
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
            [self.device setFocusPointOfInterest:CGPointMake(0.5 ,0.5)];
        }
        
        [self.device unlockForConfiguration];
    }
    NSLog(@"监听自动对焦报错啦--%@",error);
}

#pragma mark - 相机,相册,麦克风的权限处理

- (BOOL)authorizationStatusWithCamera_Photo_Micphone {
    //判断相册权限
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"没有相册权限" message:@"无法正常使用拍摄功能" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
        return NO;
    }
    //判断相机权限
    AVAuthorizationStatus videoStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (videoStatus == AVAuthorizationStatusRestricted || videoStatus ==AVAuthorizationStatusDenied) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"没有相机权限" message:@"无法正常使用拍摄功能" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
        return NO;
    }
    
    //判断麦克风权限
    AVAuthorizationStatus audioStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (audioStatus == AVAuthorizationStatusRestricted || audioStatus == AVAuthorizationStatusDenied) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"没有麦克风权限" message:@"无法正常使用拍摄功能" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
        return NO;
    }
    
    return YES;
}

- (void)dealloc {
    //移除自动对焦监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:self.device];
}

@end
