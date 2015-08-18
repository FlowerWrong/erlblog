declare var jQuery: any;
declare var ace: any;
declare var marked: any;
declare var hljs: any;

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
        var title, summary, markdown, image, data;
        title = $("input[name='title']").val();
        console.log(title);
        summary = $("textarea[name='summary']").val();
        console.log(summary);
        markdown = editor.getValue();
        console.log(markdown);
        image = $("input[name='image']").val();
        console.log(image);

        data = {
            title: title,
            image: image,
            summary: summary,
            markdown: markdown
        };

        // 提交
        $.ajax({
            type: "POST",
            url: "/posts/create",
            dataType: "json",
            data: data,
            success: function (data, textStatus, jqXHR) {
                console.log(data);
                if (data.error !== undefined) {
                    alert(data.error);
                } else {
                    alert("创建成功");
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

    if($(".img-view img").attr("src") !== "") {
        $(".img-view").show();
    }
}(jQuery));