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

##Dispatch and Activiate
As we know, the raw communication between Objective-C and Javascript is based on URL redirection which delay a lot actually. Sometimes we want to invoke several methods almost simultaneously. In this situation, the invoke method introduced above might be incompetent and unsuitable. Here introduce another way to invoke the native code.

###Dispatch
When you want to call several methods almost simultaneously, for example, get some information from native by several different interfaces right after the window is loaded, you should use dispatch:
```Javascript
function testDeviceInfo() {
  var params = {};
  var success = function (callbackId, params) {
    alert(params);
  };
  var fail = function (callbackId, params) {
    alert(params);
  }
  window.ov_gap.dispatchCommand("getDeviceInfo", params, success, fail);
}
```
Interestingly, the code using dispatch is always the same with the one using invoke. But the logic won't be executed immediately until you call the active function.
```Javascript
window.ov_gap.activate();
```
After this, all the commands in default group dispatched before will be executed.

###Dispatch in Group
If you want your function callings to be seperated by some specific groups， dispatching in group will be a good option.
```Javascript
var testGroup1 = window.ov_gap.createGroup();
var testGroup2 = window.ov_gap.createGroup();

function testGroup1Dispatch() {
  var dispatchId = Math.floor(Math.random() * 2000000);
  var params = {'val' : dispatchId};
  var onSuccess = function (callbackId, params) {
    alert(params);
  };
  var onFail = function (callbackId, params) {
    alert(params);
  };
  window.ov_gap.dispatchCommandInGroup("testGroupDispatch", params, onSuccess, onFail, testGroup1);
}

function testGroup2Dispatch() {
  var dispatchId = Math.floor(Math.random() * 2000000);
  var params = {'val' : dispatchId};
  var onSuccess = function (callbackId, params) {
    alert(params);
  };
  var onFail = function (callbackId, params) {
    alert(params);
  };
  window.ov_gap.dispatchCommandInGroup("testGroupDispatch", params, onSuccess, onFail, testGroup2);
}
```
And the activiation for group is here.
```Javascript
function testGroup1Activate() {
  window.ov_gap.activateGroup(testGroup1);
}

function testGroup2Activate() {
  window.ov_gap.activateGroup(testGroup2);
}
```

It's basically the same with the pure dispatch one with limitation in group.

##Sum Up
The project is designed on purpose to build a light bridge between Objective-C and Javascript in IOS development. Please refer to the OVGap Demo Project and enjoy the beauty of coding.

