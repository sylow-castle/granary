//solitudejs
(function (root) {
    //solitudejs default configulation
    let config = {
        app: {
            version: ["201906.09"],
            file: "app.html",
        },

        data: {
            schema: {
                version: [
                    "201906"
                ]
            },
            dir: null,
            default: "iceberg.json",
            param: "data",
            format: "json",
        },

        exporter: {
            clipboard: "true",
            vscode: "true",
        }
    };

    const status = {
        configtest: false,
        initialized: false,
        uninitialized: false,
        loaded: false,
        changed: false,
    };

    const selectors = {
        cliper: "#cliper",
        system: {
            edit: "#solo_system_edit",
            dynamic_href: 'a[href="solo_dynamic_defined"]'
        }

    }

    //handling root objects
    const solo = root.solitude = initialize(root.solitude || {});
    const copy = function () {
        root.document.execCommand('copy');
    };
    const location = root.document.location;
    config = root.solitude.conf || config;

    //initialize solitude object
    function initialize(solo) {
        configtest(config);

        //fields
        solo.config = config;
        solo.status = status;
        solo.selectors = selectors;
        solo.data = {};
        /*
        solo.prototypes = {
            domain: new Domain()
        }
        */

        //関数化しちゃうと補完できなくなるからこう書く
        solo.events = {
            failFetch: {
                name: "failFetch",
                listeners: [],
            },

            successFetch: {
                name: "successFetch",
                listeners: [],
            },

            add: {
                name: "add",
                listeners: [],
            }

        }


        //public methods
        solo.start = main;
        solo.setUpElements = setUpElements;
        solo.setUpKeyDown = doNothing;
        solo.decideData = decideData;
        solo.receiveData = receive;
        solo.recoverNWError = recoverNetError;
        solo.clip = function (target) {
            return clip(target, solo.selectors.cliper);
        };
        solo.addEvent = addEvent;
        solo.fire = fire;
        solo.addEventListener = addEventListener;
        solo.removeEventListener = removeEventListener;
        solo.formatDate = formatDate;
        solo.jsonHook = doNothing;
        solo.exportToClipboard = exportToClipboard;
        solo.exportAsJson = exportAsJson;

        return solo;
    };


    //functions
    function configtest(config) {
        //unimplement
    }

    function main() {
        solo.fetch();
        solo.setUpElement();
        solo.setUpKeyDown();
    }

    function addEvent(name) {
        //Todo validate
        var eventObj = {};
        eventObj.name = name;
        eventObj.lisnters = [];
        solo.events[name] = solo.events[name] || eventObj;
    }

    function addEventListener(name, callback) {
        var event = solo.events[name];
        return event.listeners.push(callback);
    }

    function removeEventListener(name, index) {
        solo.events[name].listeners[index] = null;
    }

    function clip(value, selector) {
        const in_selector = selector || solo.selectors.cliper;
        const input = document.querySelector(in_selector);
        input.value = value;
        input.select();
        copy();
    }

    function receive(response) {
        if (response.ok) {
            let handler;
            switch (solo.config.data.format) {
                case "json":
                    handler = response.json();
                    break;
                case "text":
                default:
                    handler = response.text();
                    break;
            }

            handler.then(receiveData)
                .catch(function (value) {
                    console.log(value);
                    fireEvent(solo.events.failFetch, value);
                });
        } else {
            fireEvent(solo.events.failFetch, value);
        }

    }

    function receiveData(value) {
        solo.data = value;
        fireEvent(solo.events.successFetch, value);
    }

    function recoverNetError() {
        fireEvent(solo.events.failFetch)
    }

    function decideData() {
        const url = (new URL(location)).searchParams;
        const file = url.get(config.data.param) || config.data.default;
        const dir = config.data.dir ? config.data.dir + "/" : "";
        return dir + file;
    }

    function fire(name, args) {
        //TODO validate argments
        if(typeof name === 'string' && solo.events[name]) {
            fireEvent(solo.events[name], args)
        }
    }

    function fireEvent(event, arg) {
        event.listeners.forEach(function (callback) {
            callback.call(solo.data, arg)
        });
    }

    function doNothing() {
        return;
    }

    function formatDate(datetime) {
        if (datetime instanceof Date) {
            return `${datetime.getHours()}:${datetime.getMinutes()}:${datetime.getSeconds()}  ${datetime.getFullYear()}-${1 + datetime.getMonth()}-${datetime.getDate()}`
        }

        return '';
    }

    function getVscodeUrl(filePath) {
        return 'vscode://file' + filePath
    }

    function exportToClipboard(data) {
        clip(exportAsJson(data));
    }

    function exportAsJson(data) {
        const in_data = data || solo.data;
        return JSON.stringify(solo.jsonHook(in_data));
    }

    function setUpElements(document) {
        document.querySelectorAll(solo.selectors.system.dynamic_href).forEach(function (element) {
            if (solo.selectors.system.edit === ("#" + element.getAttribute("id"))) {
                const fileName = location.pathname.replace(solo.config.app.file, solitude.decideData());
                element.setAttribute("href", getVscodeUrl(fileName));
            }
        });
    }

    /*
    function InitializeDomain(name) {        
        solo.Domain = Domain;
        solo.TableDomain =
        solo.Domain.prototype = {
            add: add,
            update: update,
            remove: remove,
        }

        function Domain() {
            this.name = name;
            solo.data[name] = {
                header: [],
                body: [],
            };
            this.header = [];
            this.body = []

            this.on = [];    
            return this;
        }

        function add(value) {
            const index = this.list.push(value);
            notify('add', index, null, value);
            return index;
        }

        function update(index, value) {
            const oldValue = this.list[index];
            notify('update', index, oldValue, value);
            this.list[index] = value;
        }

        function remove(index) {
            const value = this.list[index];
            notify('remove', index, value, null);
            this.list[index] = null;
        }

        function notify(type) {
            for(let i = 0; this.on.length; i++) {
                this.on[i].call(type, index, old_value, new_value);             
            }
        }
    }
    */


})(solitude_root);