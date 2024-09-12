function saveHistoryHandler(info) {
    window.webkit.messageHandlers.saveHistoryHandler.postMessage(info);
}

function getSettingHandler(info, callback) {
    window.webkit.messageHandlers.getSettingHandler.postMessage(info);
    return new Promise(function (resolve) {
        window.getSettingResolve = resolve;
    }).then(function (result) {
        callback(result);
    });
}

function saveSettingHandler(info, callback) {
    window.webkit.messageHandlers.saveSettingHandler.postMessage(info);
    return new Promise(function (resolve) {
        window.saveSettingResolve = resolve;
    }).then(function (result) {
        callback(result);
    });
}

function getOperationHistoryHandler(info, callback) {
    window.webkit.messageHandlers.getOperationHistoryHandler.postMessage(info);
    return new Promise(function (resolve) {
        window.getOperationHistoryHandlerResolve = resolve;
    }).then(function (result) {
        callback(result);
    });
}

function deleteAllOperationHistoryHandler(info, callback) {
    window.webkit.messageHandlers.deleteAllOperationHistoryHandler.postMessage(info);
    return new Promise(function (resolve) {
        window.deleteAllOperationHistoryHandlerResolve = resolve;
    }).then(function (result) {
        callback(result);
    });
}

function copyTextHandler(info) {
    window.webkit.messageHandlers.copyTextHandler.postMessage(info);
}

function importFileHandler(info, callback) {
    window.webkit.messageHandlers.importFileHandler.postMessage(info);
    return new Promise(function (resolve) {
        window.importFileResolve = resolve;
    }).then(function (result) {
        callback(result);
    });
}

function exportFileHandler(info) {
    window.webkit.messageHandlers.exportFileHandler.postMessage(info);
}
