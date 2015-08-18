(function ($) {
    "use strict";
    // ace editor
    // http://ace.c9.io/#nav=howto
    var editor = ace.edit("editor");
    editor.setTheme("ace/theme/monokai");
    editor.getSession().setMode("ace/mode/markdown");
    marked.setOptions({
        highlight: function (code) {
            return hljs.highlightAuto(code).value;
        }
    });
    var markdown = marked(editor.getValue());
    console.log(markdown);
    $(".markdown-preview").html(markdown);
    editor.getSession().on("change", function (e) {
        console.log(e);
        var markdown = marked(editor.getValue());
        console.log(markdown);
        $(".markdown-preview").html(markdown);
    });
    $(".submit-post").on("click", function () {
        var title, summary, markdown, image, tags, data;
        title = $("input[name='title']").val();
        console.log(title);
        summary = $("textarea[name='summary']").val();
        console.log(summary);
        markdown = editor.getValue();
        console.log(markdown);
        image = $("input[name='image']").val();
        console.log(image);
        tags = $("input[name='tags']").val();
        console.log(tags);
        data = {
            title: title,
            image: image,
            summary: summary,
            markdown: markdown,
            tags: tags
        };
        var url = $("form").attr("action");
        console.log(url);
        var type, successMsg;
        if (url === "/posts/create") {
            type = "POST";
            successMsg = "创建成功";
        }
        else {
            type = "PUT";
            successMsg = "更新成功";
        }
        // 创建/更新博客
        $.ajax({
            type: type,
            url: url,
            dataType: "json",
            data: data,
            success: function (data, textStatus, jqXHR) {
                console.log(data);
                if (data.error !== undefined) {
                    alert(data.error);
                }
                else {
                    alert(successMsg);
                    window.location.href = "/";
                }
            },
            error: function (jqXHR, textStatus, errorThrown) {
                console.log(errorThrown);
            }
        });
        return false;
    });
    // jquery file uploader
    $("#fileupload").fileupload({
        url: "/uploader",
        dataType: "json",
        done: function (e, data) {
            console.dir(data);
            $("input[name='image']").val(data.result.url);
            $(".img-view img").attr("src", data.result.url);
            $(".img-view").show();
        }
    });
    if ($(".img-view img").attr("src") !== "") {
        $(".img-view").show();
    }
    // jquery tags input
    // https://github.com/xoxco/jQuery-Tags-Input#options
    $("#tags").tagsInput();
}(jQuery));
