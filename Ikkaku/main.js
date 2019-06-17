function main(global) {
    var templates = {
        "tmpl_iceberg": null,
        "tmpl_ice": null,
    };
    var HandlingData = [];
    var conf = {};
    conf.file_name = "app.html";

    setupTemplates(document);
    LoadMainData(HandlingData);
    solitude.setUpElements(document);
    return;
    //宣言色々
    function setupTemplates() {
        var templs = document.querySelectorAll("template");
        templs.forEach(function(element) {
            var identity = element.getAttribute("id");
            templates[identity] = element.content.childNodes[1];
        });
    }


    function LoadMainData(receiver) {
        //先に実行されるものを先に書きたかった。
        const execution = function() {
            fetch(solitude.decideData())
            .then(solitude.receiveData)
            .catch(solitude.recoverNWError)
        };


        solitude.addEventListener('successFetch', addIceberg);
        solitude.addEventListener('failFetch', function() {
            addIceberg({
                "name": "ロードに失敗しました。",
                "tips": {
                    "tips": ["foo", "bar"],
                    "can_a_little":["fuga"],
                    "orienteds":["foo"]
                }
            });
        });
        execution();
    };


    function addIceberg(icebergObj) {
        var newIceberg = templates["tmpl_iceberg"];
        document.querySelector("#main_contents").appendChild(newIceberg);
        newIceberg.querySelector("h2").innerHTML = icebergObj.name;
        var orienteds = icebergObj.tips.orienteds;

        const tips = newIceberg.querySelector("div.tags ul");
        discriminate(icebergObj.tips.tips, tips);

        const can_a_little = newIceberg.querySelector("div.can_a_little ul");
        discriminate(icebergObj.tips.can_a_little, can_a_little);

        function discriminate(list, target) {
            list.forEach(function(elements) {
                var ice = templates["tmpl_ice"].cloneNode();
                target.appendChild(ice);
                ice.textContent = elements;
                if(orienteds.lastIndexOf(elements) >= 0) {
                    ice.classList.add("oriented");
                }
            
            });
        }



    }

    function addRecord(icon_url, message, time) {
        if (!('record' in templates)) {
            templates.record = global.document.querySelector("#tmpl_message");
        }

        var newRecord = templates.record.cloneNode(true);
        newRecord.removeAttribute("id");
        newRecord.classList.remove("template");
        if (typeof icon_url !== 'string') {
            icon_url = '';
        }
        if (typeof message !== 'string') {
            message = '';
        }
        if (!(time instanceof Date)) {
            time = new Date();
        }

        newRecord.querySelector('span.icon').innerHTML = `<img src="${icon_url}" class="avatar_icon">`;
        newRecord.querySelector('span.message').innerText = message;
        newRecord.querySelector('span.time').innerText = solitude.formatDate(time);

        const list = global.document.querySelector('#command_list tbody');
        list.insertBefore(newRecord, templates.record.nextSibling);
    }

    function addSpeakerNode(speaker_id) {
        if (!('speaker' in templates)) {
            templates.speaker = global.document.querySelector("#tmpl_speaker");
        }
        var newSpeaker = templates.speaker.cloneNode(true);
        newSpeaker.removeAttribute("id");

        const icon_url = HandlingData.getIconURL(speaker_id);
        newSpeaker.querySelector('img').setAttribute('src', icon_url);
        newSpeaker.querySelector('textarea').addEventListener('focus', function () {
            document.querySelectorAll('div.role').forEach(function (element, index) {
                if (newSpeaker === element) {
                    element.classList.add("comment_target");
                } else {
                    element.classList.remove("comment_target");
                }
            });
            global.keyDownState = speaker_id;
            console.log(speaker_id);
        });

        speaker_nodes[speaker_id] = newSpeaker;

        const list = global.document.querySelector('#comment_form');
        list.appendChild(newSpeaker);
        newSpeaker.classList.remove("template");
    }

    function decideSpeaker(speakerNode) {
        const keys = Object.keys(speaker_nodes);
        for (let index = 0; index < keys.length; index++) {
            if (speakerNode === speaker_nodes[keys[index]]) {
                return keys[index];
            }
        }

        return "";
    }

    function readToDo() {
        return ToDoSection.parentNode.querySelector("textarea").value || "";
    }

    function writeToDo(value) {
        ToDoSection.parentNode.querySelector("textarea").value = value || "";
    }

}
