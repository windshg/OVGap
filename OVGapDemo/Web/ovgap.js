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
    invoke: function(cmd, params, onSuccess, onFail) {
        if(!cmd) cmd = "defaultCommand";
        if(!params) params = {};
        this.callbackId ++;
        this.callbacks[this.callbackId] = {
            success: onSuccess,
            fail: onFail
        };
        document.location = "ovgap://" + cmd + "/" + JSON.stringify(params) + "/" + this.callbackId;
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
    activateCommandQueue: function() {
        document.location = "ovgap://ready";
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
    }
};

module.exports = ovGap;

});

window.ov_gap = require("ov_gap");

}) ();