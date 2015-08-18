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
    $(".markdown-preview").html(markdown);

    editor.getSession().on("change", function (e) {
        var markdown = marked(editor.getValue());
        $(".markdown-preview").html(markdown);
    });

    // blockUI
    var prompt = function(msg) {
        $.blockUI({ css: {
            border: "none",
            padding: "15px",
            backgroundColor: "#000",
            "-webkit-border-radius": "10px",
            "-moz-border-radius": "10px",
            opacity: .5,
            color: "#fff"
        },
            message: msg
        });
        setTimeout($.unblockUI, 5000);
    };

    $(".submit-post").on("click", function () {
        var title, summary, markdown, image, tags, data;
        title = $("input[name='title']").val();
        summary = $("textarea[name='summary']").val();
        markdown = editor.getValue();
        image = $("input[name='image']").val();
        tags = $("input[name='tags']").val();

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
        } else {
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
                console.log(jqXHR);
                if (data.error !== undefined) {
                    prompt(data.error);
                } else {
                    // FIXME Need to fix blockUI not work for location
                    prompt(successMsg);
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
            $("input[name='image']").val(data.result.url);
            $(".img-view img").attr("src", data.result.url);
            $(".img-view").show();
        }
    });


    // edit or new page
    if($(".img-view img").attr("src") !== "") {
        $(".img-view").show();
    }

    // jquery tags input
    // https://github.com/xoxco/jQuery-Tags-Input#options
    $("#tags").tagsInput();
}(jQuery));