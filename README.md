OVGap
=====

A light framework which is responsible for the communication between IOS native Objective-C code and Javascript. It's based on plugin architecture. You    can add plugins to the web view to offer your native functional interfaces  which can be invoked by Javascript code from the web view. The sample is following.

### Objective-C:
For native Objective C code, the configuration of plugins is pretty easy. All you have to do is to implement a class which is inherited from OGPlugin and then to fill it with methods whom you want to offer to Javascript Code from web view as native interface. Here is the sample plugin.
```ObjectiveC 

@interface InfoPlugin : OGPlugin

- (void)getDeviceInfo:(OGInvokeCommand *)command;

@end
``` 
Implementation:

```ObjectiveC 
@implementation InfoPlugin

- (void)getDeviceInfo:(OGInvokeCommand *)command {
    NSMutableDictionary *deviceInfo = [NSMutableDictionary dictionary];
    [deviceInfo setObject:[[UIDevice currentDevice] name] forKey:@"name"];
    [deviceInfo setObject:[[UIDevice currentDevice] systemName] forKey:@"systemName"];
    [deviceInfo setObject:[[UIDevice currentDevice] systemVersion] forKey:@"systemVersion"];
    [deviceInfo setObject:[[UIDevice currentDevice] model] forKey:@"model"];
    [deviceInfo setObject:[[UIDevice currentDevice] localizedModel] forKey:@"localizedModel"];
    [self toCallBackSuccess:deviceInfo callBackId:command.callBackId];
}

@end
``` 

Add a plugin to the OGWebView:
```ObjectiveC
// add plugin
InfoPlugin *infoPlugin = [[InfoPlugin alloc] init];
[self.webView addPlugin:infoPlugin];
``` 

Plugin Configuration is done. The sample of Javascript code is following.

### Javascript:
For Javascript development, you should add a framework before you want to call the interface from native Objective-C code. 
Import the framework:
```HTML
<script src="ovgap.js" type="text/javascript" charset="utf-8"></script>
```

Call a interface from native Objective-C in Javascript:
```Javascript
function testDeviceInfo() {
  var params = {};
  var success = function (callbackId, params) {
    alert(params);
  };
  var fail = function (callbackId, params) {
    alert(params);
  }
  window.ov_gap.invoke("getDeviceInfo", params, success, fail);
}
```

###Sum Up
The project is designed on purpose to build a light bridge between Objective-C and Javascript in IOS development. Please refer to the OVGap Demo Project and enjoy the beauty of coding.

