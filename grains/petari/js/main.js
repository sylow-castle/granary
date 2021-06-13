function check() {
  console.log("check");
}

function main() {
  var templates = {};
  templates.normal = document.querySelector("#tag_templates").content.querySelector("li");
  templates.linked = document.querySelector("#link_tag_templates").content.querySelector("li");
  document.querySelectorAll("span.remove").forEach(function(current) {
    current.onclick = remove;
  });
    


  document.querySelector("#add").onclick = function () {
    var label = document.querySelector('input[name="keyword"').value;
    var url = document.querySelector('input[name="url"]').value;

    var index = document.command_menu.category.selectedIndex;
    var category = document.command_menu.category.options[index].value;

    add(category, label, url);
  }

  document.querySelector("#save").onclick = save;

  function add(category, label, url) {
    url = url || "";
    var newItem;
    console.log(url.length);

    if (url.length > 0) {
      newItem = templates.linked.cloneNode(true);
      newItem.querySelector("a").setAttribute("href", url)
      newItem.querySelector("a span.label").innerText = label;
    } else {
      newItem = templates.normal.cloneNode(true);
      newItem.querySelector("span.label").innerText = label;
    }
    newItem.querySelector("span.remove").onclick = remove;

    var list = document.querySelector("#" + category + " ul");

    //最初の子要素として追加
    list.insertBefore(newItem, list.firstChild);

  }

  function save() {
    var content = "<!DOCTYPE html>\r\n";
    content += document.querySelector("html").outerHTML;

    /* const url = ""
     * putToWebDav(url, content)
     */
    download("keywords.html", content)
  }

  function remove() {
    //check();
    this.parentNode.classList.add("removed");
    //this.parentNode.remove();
  }

  function putToWebDav(url, content) {

    fetch(url, {
      method: "PUT",
      cache: "no-cache",
      body: body
    }).then(function (response) {
      document.querySelector("#add_result").innerText = "成功 " + (new Date()).toString();
    }).catch(function (response) {
      document.querySelector("#add_result").innerText = "失敗 " + (new Date()).toString();
    });
  }

  function download(filename, content) {
    const blob = new Blob([content], { "type": "text/plain" });
    const link = document.createElement('a');

    link.href = window.URL.createObjectURL(blob);
    link.download = filename;
    link.click()
  }      
}