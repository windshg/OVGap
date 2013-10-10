;(function() {

var require, define;

(function () {
    var modules = {},
    // Stack of moduleIds currently being built.
        requireStack = [],
    // Map of module ID -> index into requireStack of modules currently being built.
        inProgressModules = {},
        SEPERATOR = ".";

    function build(module) {
        var factory = module.factory,
            localRequire = function (id) {
                var resultantId = id;
                //Its a relative path, so lop off the last portion and add the id (minus "./")
                if (id.charAt(0) === ".") {
                    resultantId = module.id.slice(0, module.id.lastIndexOf(SEPERATOR)) + SEPERATOR + id.slice(2);
                }
                return require(resultantId);
            };
        module.exports = {};
        delete module.factory;
        factory(localRequire, module.exports, module);
        return module.exports;
    }

    require = function (id) {
        if (!modules[id]) {
            throw "module " + id + " not found";
        } else if (id in inProgressModules) {
            var cycle = requireStack.slice(inProgressModules[id]).join('->') + '->' + id;
            throw "Cycle in require graph: " + cycle;
        }
        if (modules[id].factory) {
            try {
                inProgressModules[id] = requireStack.length;
                requireStack.push(id);
                return build(modules[id]);
            } finally {
                delete inProgressModules[id];
                requireStack.pop();
            }
        }
        return modules[id].exports;
    };

    define = function (id, factory) {
        if (modules[id]) {
            throw "module " + id + " already defined";
        }

        modules[id] = {
            id: id,
            factory: factory
        };
    };

    define.remove = function (id) {
        delete modules[id];
    };

    define.moduleMap = modules;
})();



define("ov_gap", function(require, exports, module) {

var ovGap = {
    callbackId: Math.floor(Math.random() * 2000000000),
    callbacks: {},
    commandQueue: [],
    groupId: Math.floor(Math.random() * 300),
    groups: {},
    listeners: {},
    invoke: function(cmd, params, onSuccess, onFail) {
        if(!cmd) cmd = "defaultCommand";
        if(!params) params = {};
        this.callbackId ++;
        this.callbacks[this.callbackId] = {
            success: onSuccess,
            fail: onFail
        };
        var rurl = "ovgap://" + cmd + "/" + JSON.stringify(params) + "/" + this.callbackId;
        document.location = rurl;
    }, 
    dispatchCommand: function(cmd, params, onSuccess, onFail) {
        if(!cmd) cmd = "defaultCommand";
        if(!params) params = {};
        this.callbackId ++;
        this.callbacks[this.callbackId] = {
            success: onSuccess,
            fail: onFail
        };
        var command = cmd + "/" + JSON.stringify(params) + "/" + this.callbackId;
        this.commandQueue.push(command);
    },
    fetchNativeCommands: function() {
        var json = JSON.stringify(this.commandQueue);
        this.commandQueue = [];
        return json;
    },
    activate: function() {
        document.location = "ovgap://ready";
    },
    // return group ID
    createGroup: function() {
        this.groupId ++;
        this.groups[this.groupId] = [];
        return this.groupId;
    },
    dispatchCommandInGroup: function(cmd, params, onSuccess, onFail, groupId) {
        if (!this.groups[groupId]) return false;

        if(!cmd) cmd = "defaultCommand";
        if(!params) params = {};
        this.callbackId ++;
        this.callbacks[this.callbackId] = {
            success: onSuccess,
            fail: onFail
        };
        var command = cmd + "/" + JSON.stringify(params) + "/" + this.callbackId;
        this.groups[groupId].push(command);
        return true;
    },
    activateGroup: function(groupId) {
        if (!this.groups[groupId]) return false;
        document.location = "ovgap://group/" + groupId;
    },
    fetchNativeGroupCommands: function(groupId) {
        if (!this.groups[groupId]) return [];
        var json = JSON.stringify(this.groups[groupId]);
        this.groups[groupId] = [];
        return json;
    },
    callbackSuccess: function(callbackId, params) {
        try {
            ovGap.callbackFromNative(callbackId, params, true);
        } catch (e) {
            console.log("Error in error callback: " + callbackId + " = " + e);
        }
    },
    callbackError: function(callbackId, params) {
        try {
            ovGap.callbackFromNative(callbackId, params, false);
        } catch (e) {
            console.log("Error in error callback: " + callbackId + " = " + e);
        } 
    }, 
    callbackFromNative: function(callbackId, params, isSuccess) {
        var callback = this.callbacks[callbackId];
        if (callback) {
            if (isSuccess) {
                callback.success && callback.success(callbackId, params);
            } else {
                callback.fail && callback.fail(callbackId, params);
            }
            delete ovGap.callbacks[callbackId];
        };
    },
    addGapListener: function(listenId, onSuccess, onFail) {
        if (!listenId || !onSuccess || !onFail) return;
        this.listeners[listenId] = {
            success : onSuccess, 
            fail : onFail
        };
    },
    removeListener: function(listenId) {
        if (!this.listeners[listenId]) return;
        this.listeners[listenId] = null;
    },
    triggerListenerSuccess: function(listenId, params) {
        if (!this.listeners[listenId]) return;
        var listener = this.listeners[listenId];
        listener.success && listener.success(listenId, params);
    },
    triggerListenerFail: function(listenId, params) {
        if (!this.listeners[listenId]) return;
        var listener = this.listeners[listenId];
        listener.fail && listener.fail(listenId, params);
    }
};

module.exports = ovGap;

});

window.ov_gap = require("ov_gap");

}) ();