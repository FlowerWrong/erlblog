declare var jQuery: any;

(function($) {
	"use strict";
	$(function() {
		$(".the-content").fitVids();

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

		$(".del-post").on("click", function () {
			var url = $(this).attr("href");
			// 删除博客
			$.ajax({
				type: "DELETE",
				url: url,
				dataType: "json",
				success: function (data, textStatus, jqXHR) {
					console.log(jqXHR);
					if (data.error !== undefined) {
						prompt(data.error);
					} else {
						prompt("删除成功");
						window.location.href = "/";
					}
				},
				error: function (jqXHR, textStatus, errorThrown) {
					console.log(errorThrown);
				}
			});
            return false;
		});
	});
}(jQuery));
