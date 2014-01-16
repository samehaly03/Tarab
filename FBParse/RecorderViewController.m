//
//  RecorderViewController.m
//  AudioSample
//
//  Created by Sameh Aly on 11/12/13.
//
////#1abc9c // 26 188 156

#import "RecorderViewController.h"
#import "CMOpenALSoundManager.h"


enum mySoundIds {
	AUDIOEFFECT
};

@interface RecorderViewController ()
@property (nonatomic, retain) CMOpenALSoundManager *soundMgr;
@end

@implementation RecorderViewController
@synthesize soundMgr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:@"سمعنا"];
    [self.navigationController.navigationBar.topItem setTitleView:titleLabel];
    
    self.navigationController.navigationBar.hidden = NO;
    
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]];
    
    recordEncoding = ENC_PCM;
    
    //start the audio manager...
	self.soundMgr = [[[CMOpenALSoundManager alloc] init] autorelease];

    
    NSLog(@"songfile: %@", self.songPath);
    
    //right button
    _btnUpload = [[CustomButton alloc] initWithImage:[UIImage imageNamed:@"upload.png"]];
    [_btnUpload addTarget:self action:@selector(uploadAudio) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:_btnUpload];
    self.navigationItem.rightBarButtonItem = rightButton;
    

    CustomButton *button = [[CustomButton alloc] initWithImage:[UIImage imageNamed:@"menu.png"]];
    
    [button addTarget:self action:@selector(menuPressed) forControlEvents:UIControlEventTouchUpInside];
    
    //[button addTarget:(DEMONavigationController *)self.navigationController action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    self.navigationController.navigationBar.hidden = NO;
    
    [self.lblSongName setText:self.songName];
    [self.lblSongName setTextColor:[UIColor colorWithRed:243.0/255 green:156.0/255 blue:18.0/255 alpha:1.0]];
    self.lblSongName.layer.borderWidth = 0.5;
    self.lblSongName.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.lblSongName.layer.cornerRadius = 5.0;
    self.lblSongName.layer.masksToBounds = YES;
    
    [_progressUpload setProgressTintColor:[UIColor colorWithRed:26.0/255.0 green:188.0/255.0 blue:156.0/255.0 alpha:1.0]];
    [_progressUpload setTintColor:[UIColor colorWithRed:26.0/255.0 green:188.0/255.0 blue:156.0/255.0 alpha:1.0]];
    [_progressUpload setTrackTintColor:[UIColor clearColor]];

    self.playButton.layer.borderColor = [[UIColor colorWithRed:155.0/255 green:89.0/255 blue:182.0/255 alpha:1.0] CGColor];
    self.playButton.layer.backgroundColor = [[UIColor colorWithRed:155.0/255 green:89.0/255 blue:182.0/255 alpha:1.0] CGColor];
    
    [self.playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.playButton.layer.cornerRadius = 5.0;
    self.playButton.layer.borderWidth = 0.0;
    self.playButton.layer.masksToBounds = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    //self.viewForWave.hidden = YES;
    NSLog(@"stopped");
    [self stopDisplayLink];
    self.shapeLayer.path = [[self pathAtInterval:0] CGPath];
    [timerForPitch invalidate];
    timerForPitch = nil;
    _customRangeBar.value = 0.0;
    
    [soundMgr stopBackgroundMusic];
    NSLog(@"Stop recording");
    [audioRecorder stop];
    
    if (audioPlayer) [audioPlayer stop];
    
    [self.soundMgr purgeSounds];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)menuPressed
{
    [self stop];
    [(DEMONavigationController *)self.navigationController showMenu];
}

- (void)levelTimerCallback:(NSTimer *)timer
{
	[audioRecorder updateMeters];
	//NSLog(@"Average input: %f Peak input: %f", [audioRecorder averagePowerForChannel:0], [audioRecorder peakPowerForChannel:0]);
    
    float linear = pow (10, [audioRecorder peakPowerForChannel:0] / 20);
    //NSLog(@"linear===%f",linear);
    float linear1 = pow (10, [audioRecorder averagePowerForChannel:0] / 20);
    //NSLog(@"linear1===%f",linear1);
    if (linear1>0.03) {
        
        Pitch = linear1+.20;//pow (10, [audioRecorder averagePowerForChannel:0] / 20);//[audioRecorder peakPowerForChannel:0];
    }
    else {
        
        Pitch = 0.0;
    }
    //Pitch =linear1;
    //NSLog(@"Pitch==%f",Pitch);
    _customRangeBar.value = Pitch;//linear1+.30;
    //[_progressView setProgress:Pitch];
    //float minutes = floor(audioRecorder.currentTime/60);
    //float seconds = audioRecorder.currentTime - (minutes * 60);
    
    //NSString *time = [NSString stringWithFormat:@"%0.0f.%0.0f",minutes, seconds];
    //[self.statusLabel setText:[NSString stringWithFormat:@"%@ sec", time]];
    //NSLog(@"recording");
    
}

- (IBAction)playRecorded:(id)sender
{
    NSLog(@"play Record");
    if (audioPlayerRecord) {
        if (audioPlayerRecord.isPlaying) [audioPlayerRecord stop];
        else [audioPlayerRecord play];
        
        return;
    }
    
    //Initialize playback audio session
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *recDir = [paths objectAtIndex:0];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/recordTest.caf", recDir]];
    
    
    
    NSError *error;
    audioPlayerRecord = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [audioPlayerRecord play];
    NSLog(@"Recoder file >");
    
}

- (void)stop
{

    //self.viewForWave.hidden = YES;
    NSLog(@"stopped");
    [self stopDisplayLink];
    self.shapeLayer.path = [[self pathAtInterval:0] CGPath];
    [timerForPitch invalidate];
    timerForPitch = nil;
    _customRangeBar.value = 0.0;
    
    [soundMgr stopBackgroundMusic];
    NSLog(@"Stop recording");
    [audioRecorder stop];
    
    if (audioPlayer) [audioPlayer stop];
    
    [self.soundMgr purgeSounds];
    
    isRecording = NO;
    
    [self.playButton setTitle:@"ابدأ" forState:UIControlStateNormal];
    //[self.playButton setBackgroundImage:[UIImage imageNamed:@"Untitled-1.png"] forState:UIControlStateNormal];
}

- (IBAction)startRecording:(id)sender
{
    if (isRecording)
    {
        [self stop];
    }
    else
    {
        [self start];
    }
    
}

- (IBAction)stopRecording:(id)sender
{
    [self stop];
}


- (void)start
{
    
    
    self.viewForWave.hidden = NO;
    [self addShapeLayer];
    [self startDisplayLink];
    
    NSLog(@"start record");
    [audioRecorder release];
    audioRecorder = nil;
    
    //Initialize audio session
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    //Override record to mix with other app audio, background audio not silenced on record
    OSStatus propertySetError = 0;
    UInt32 allowMixing = true;
    propertySetError = AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(allowMixing), &allowMixing);
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
    
    NSLog(@"Mixing: %lx", propertySetError); // This should be 0 or there was an issue somewhere
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    if (recordEncoding == ENC_PCM) {
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC]  forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithFloat:44100.0]              forKey:AVSampleRateKey];
        [recordSetting setValue:[NSNumber numberWithInt:2]                      forKey:AVNumberOfChannelsKey];
        
        [recordSetting setValue:[NSNumber numberWithInt:16]                     forKey:AVLinearPCMBitDepthKey];
        [recordSetting setValue:[NSNumber numberWithBool:NO]                    forKey:AVLinearPCMIsBigEndianKey];
        [recordSetting setValue:[NSNumber numberWithBool:NO]                    forKey:AVLinearPCMIsFloatKey];
    } else {
        
        NSNumber *formatObject;
        
        switch (recordEncoding) {
            case ENC_AAC:
                formatObject = [NSNumber numberWithInt:kAudioFormatMPEG4AAC];
                break;
                
            case ENC_ALAC:
                formatObject = [NSNumber numberWithInt:kAudioFormatAppleLossless];
                break;
                
            case ENC_IMA4:
                formatObject = [NSNumber numberWithInt:kAudioFormatAppleIMA4];
                break;
                
            case ENC_ILBC:
                formatObject = [NSNumber numberWithInt:kAudioFormatiLBC];
                break;
                
            case ENC_ULAW:
                formatObject = [NSNumber numberWithInt:kAudioFormatULaw];
                break;
                
            default:
                formatObject = [NSNumber numberWithInt:kAudioFormatAppleIMA4];
                break;
        }
        
        [recordSetting setValue:formatObject                                forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithFloat:44100.0]          forKey:AVSampleRateKey];
        [recordSetting setValue:[NSNumber numberWithInt:2]                  forKey:AVNumberOfChannelsKey];
        [recordSetting setValue:[NSNumber numberWithInt:6400]              forKey:AVEncoderBitRateKey];
        
        [recordSetting setValue:[NSNumber numberWithInt:16]                 forKey:AVLinearPCMBitDepthKey];
        [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityMedium] forKey:AVEncoderAudioQualityKey];
        
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *recDir = [paths objectAtIndex:0];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/recordTest.caf", recDir]];
    
    NSError *error = nil;
    audioRecorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&error];
    
    if (!audioRecorder) {
        NSLog(@"audioRecorder: %@ %d %@", [error domain], [error code], [[error userInfo] description]);
        return;
    }
    
    //    audioRecorder.meteringEnabled = YES;
    //
    BOOL audioHWAvailable = audioSession.inputIsAvailable;
    if (! audioHWAvailable) {
        UIAlertView *cantRecordAlert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
                                   message: @"Audio input hardware not available"
                                  delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [cantRecordAlert show];
        [cantRecordAlert release];
        return;
    }
    
    if ([audioRecorder prepareToRecord])
    {
        audioRecorder.meteringEnabled = YES;
        [audioRecorder record];
        
        timerForPitch =[NSTimer scheduledTimerWithTimeInterval: 0.01 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
        
        NSLog(@"recording");
    }
    else
    {
        //        int errorCode = CFSwapInt32HostToBig ([error code]);
        //        NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
        NSLog(@"recorder: %@ %d %@", [error domain], [error code], [[error userInfo] description]);
    }
    
    NSLog(@"before play %@", self.songPath);
    [soundMgr playBackgroundMusic:self.songPath];

    isRecording = YES;
    
     [self.playButton setTitle:@"توقف" forState:UIControlStateNormal];
    //[self.playButton setBackgroundImage:[UIImage imageNamed:@"Untitled-1b.png"] forState:UIControlStateNormal];
    
    
}



- (void) musicVolume:(id)sender
{
	soundMgr.backgroundMusicVolume = 5.0;
}

- (void) effectsVolume:(id)sender
{
	soundMgr.soundEffectsVolume = 5.0;
}

- (void)uploadAudio
{
    [_btnUpload setEnabled:NO];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *recDir = [paths objectAtIndex:0];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/recordTest.caf", recDir]];
    
    audioData = [NSData dataWithContentsOfURL:url];
    NSLog(@"%.2f",(float)audioData.length/1024.0f/1024.0f);
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"imageKey"];
    
    UIImage* image;
    
    if (imageData)
    {
        NSLog(@"there is myEncodedImageData");
        image = [UIImage imageWithData:imageData];
// #1abc9c
    }
    else
    {
        NSLog(@"there is NO myEncodedImageData");
        image = [UIImage imageNamed:@"user.png"];
    }
    
    if (audioData.length > 0)
    {
        NSString *name = @"غير معروف";
        
        if ([[NSUserDefaults standardUserDefaults] stringForKey:@"myName"]) {
            name = [[NSUserDefaults standardUserDefaults] stringForKey:@"myName"];
        }
        
        else if([[PFUser currentUser] username]) {
            name = [[PFUser currentUser] username];
        }
        
        // Upload the image to Parse
        [Comms uploadImage:image withAudio:audioData andSong:self.songName andSinger:name forDelegate:self];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"لا يوجد ملف صوتي" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        
        [alert show];
        
        [_btnUpload setEnabled:YES];
    }
    
    [_vProgressUpload setHidden:NO];
}

- (void) commsUploadImageComplete:(BOOL)success
{
    /*
	// Reset the UI
	[_vProgressUpload setHidden:YES];
	[_btnUpload setEnabled:YES];
	[_lblChooseAnImage setHidden:NO];
	[_imgToUpload setImage:nil];
    [self.txtTitle setText:@""];
    [self.txtPrice setText:@""];
    */
    
    [_vProgressUpload setHidden:YES];
    [_btnUpload setEnabled:YES];
    
	// Did the upload work ?
	if (success) {
		[self.navigationController popViewControllerAnimated:YES];
        
        // Notify that a new image has been uploaded
        [[NSNotificationCenter defaultCenter] postNotificationName:N_ImageUploaded object:nil];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"شكرا" message:@"تم تحميل الاغنية بنجاح"
                                                       delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil];
        [alert show];
	}
    else
    {
		[[[UIAlertView alloc] initWithTitle:@"خطأ"
                                    message:@"عفوا، حدث خطأ اثناء التحميل"
                                   delegate:nil
                          cancelButtonTitle:@"موافق"
                          otherButtonTitles:nil] show];
	}
}

- (void) commsUploadImageProgress:(short)progress
{
	//NSLog(@"Uploaded: %d%%", progress);
	[_progressUpload setProgress:(progress/100.0f)];
}

- (void)addShapeLayer
{
    /*
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.path = [[self pathAtInterval:2.0] CGPath];
    self.shapeLayer.fillColor = [[UIColor redColor] CGColor];
    self.shapeLayer.lineWidth = 1.0;
    self.shapeLayer.strokeColor = [[UIColor whiteColor] CGColor];
    [self.viewForWave.layer addSublayer:self.shapeLayer];
     */
    
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.path = [[self pathAtInterval:2.0] CGPath];
    self.shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    self.shapeLayer.lineWidth = 1.0;
    self.shapeLayer.strokeColor = [[UIColor blueColor] CGColor];
    [self.viewForWave.layer addSublayer:self.shapeLayer];
}

- (void)startDisplayLink
{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)stopDisplayLink
{
    [self.displayLink invalidate];
    self.displayLink = nil;
    
}

- (void)handleDisplayLink:(CADisplayLink *)displayLink
{
    if (!self.firstTimestamp)
        self.firstTimestamp = displayLink.timestamp;
    
    self.loopCount++;
    
    NSTimeInterval elapsed = (displayLink.timestamp - self.firstTimestamp);
    
    self.shapeLayer.path = [[self pathAtInterval:elapsed] CGPath];
    
    //    if (elapsed >= kSeconds)
    //    {
    //       // [self stopDisplayLink];
    //        self.shapeLayer.path = [[self pathAtInterval:0] CGPath];
    //
    //        self.statusLabel.text = [NSString stringWithFormat:@"loopCount = %.1f frames/sec", self.loopCount / kSeconds];
    //    }
}

- (UIBezierPath *)pathAtInterval:(NSTimeInterval) interval
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(0, self.viewForWave.bounds.size.height / 2.0)];
    
    CGFloat fractionOfSecond = interval - floor(interval);
    
    CGFloat yOffset = self.viewForWave.bounds.size.height * sin(fractionOfSecond * M_PI * Pitch*8);
    
    [path addCurveToPoint:CGPointMake(self.viewForWave.bounds.size.width, self.viewForWave.bounds.size.height / 2.0)
            controlPoint1:CGPointMake(self.viewForWave.bounds.size.width / 2.0, self.viewForWave.bounds.size.height / 2.0 - yOffset)
            controlPoint2:CGPointMake(self.viewForWave.bounds.size.width / 2.0, self.viewForWave.bounds.size.height / 2.0 + yOffset)];
    
    return path;
}



@end
