function refresh() {
  document.location.reload();
}

function testDeviceInfo() {

  document.getElementById("consoleBar").innerHTML += "testDeviceInfo" + "\n";
  var success = function (callbackId, params) {
    document.getElementById("consoleBar").innerHTML += JSON.stringify(params) + "\n";
  };
  var fail = function (callbackId, params) {
    document.getElementById("consoleBar").innerHTML += "fail\n";
  }
  window.ov_gap.invoke("testDeviceInfo", null, success, fail);
}

function testCamera() {

  document.getElementById("consoleBar").innerHTML += "testCamera" + "\n";

  window.ov_gap.invoke("testCamera", {}, function (callbackId, params) {
    alert("testCamera success");
  }, function (callbackId, params) {
    alert("testCamera fail");
  });
}

var audioOn = false;
function testAudio() {

  document.getElementById("consoleBar").innerHTML += "testAudio" + "\n";

  var params = {'currentState' : audioOn};
  var onSuccess = function (callbackId, params) {
    audioOn = params['currentState'];
    var audioBtn = document.getElementById('audioBtn');
    if (audioOn) {
      audioBtn.innerHTML = "Audio Stop";
    } else {
      audioBtn.innerHTML = "Audio Play";
    };
  };
  var onFail = function (callbackId, params) {
  };
  window.ov_gap.invoke("testAudio", params, onSuccess, onFail);
}

function testAddressBook() {

  document.getElementById("consoleBar").innerHTML += "testAddressBook" + "\n";

  var params = {};
  var onSuccess = function (callbackId, params) {
  };
  var onFail = function (callbackId, params) {
  };
  window.ov_gap.invoke("testAddressBook", params, onSuccess, onFail);
}

function testDispatch() {
  var dispatchId = Math.floor(Math.random() * 2000000);

  document.getElementById("consoleBar").innerHTML += "dispatch: " + dispatchId + '\n';

  var params = {'val' : dispatchId};
  var onSuccess = function (callbackId, params) {
    document.getElementById("consoleBar").innerHTML += "excute: " + params['val'] + '\n';
  };
  var onFail = function (callbackId, params) {
  };
  window.ov_gap.dispatchCommand("testDispatch", params, onSuccess, onFail);
}

function testActivate() {

  document.getElementById("consoleBar").innerHTML += "activate" + "\n";

  window.ov_gap.activate();
}

var testGroup1 = window.ov_gap.createGroup();
var testGroup2 = window.ov_gap.createGroup();

function testGroup1Dispatch() {
  var dispatchId = Math.floor(Math.random() * 2000000);

  document.getElementById("consoleBar").innerHTML += "dispatch: " + dispatchId + " in group " + testGroup1 + '\n';

  var params = {'val' : dispatchId};
  var onSuccess = function (callbackId, params) {
    document.getElementById("consoleBar").innerHTML += "excute: " + params['val'] + " in group " + testGroup1 + '\n';
  };
  var onFail = function (callbackId, params) {
  };
  window.ov_gap.dispatchCommandInGroup("testGroupDispatch", params, onSuccess, onFail, testGroup1);
}

function testGroup1Activate() {

  document.getElementById("consoleBar").innerHTML += "activate " + testGroup1 + "\n";

  window.ov_gap.activateGroup(testGroup1);
}

function testGroup2Dispatch() {
  var dispatchId = Math.floor(Math.random() * 2000000);

  document.getElementById("consoleBar").innerHTML += "dispatch: " + dispatchId + " in group " + testGroup2 + '\n';

  var params = {'val' : dispatchId};
  var onSuccess = function (callbackId, params) {
    document.getElementById("consoleBar").innerHTML += "excute: " + params['val'] + " in group " + testGroup2 + '\n';
  };
  var onFail = function (callbackId, params) {
  };
  window.ov_gap.dispatchCommandInGroup("testGroupDispatch", params, onSuccess, onFail, testGroup2);
}

function testGroup2Activate() {

  document.getElementById("consoleBar").innerHTML += "activate " + testGroup2 + "\n";

  window.ov_gap.activateGroup(testGroup2);
}

function clearConsoleBar() {
  document.getElementById("consoleBar").innerHTML = "";
}

function setFocusLast(obj){     
  obj.focus();      
  var r = obj.createTextRange();       
  r.moveStart("character",obj.value.length);      
  r.collapse(true);      
  r.select();        
}    

window.onload = function() {
  window.ov_gap.addGapListener(1001, function(listenId, params){
    audioOn = params['currentState'];
    var audioBtn = document.getElementById('audioBtn');
    if (audioOn) {
      audioBtn.innerHTML = "Audio Stop";
    } else {
      audioBtn.innerHTML = "Audio Play";
    };
  }, function(listenId, params){
    alert('fail ' + JSON.stringify(params));
  });
}