// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

$(document).on('page:load', function() {
	var url = window.location.href;

	$('.downvote').on('click', function(e) {
		e.preventDefault();
		$.ajax({
			type: 'POST',
			url: url + '/downvote',
			dataType: 'JSON',
			success: function(response) {
				var current_count = $('.vote_count#' + response.book_id).html();
				var current_count_int = parseInt(current_count, 10) - 1;
				$('.vote_count#' + response.book_id).html(current_count_int);
				$('.downvote').remove();
				$('.upvote').remove();
			}
		});
	});

	$('.upvote').on('click', function(e) {
		e.preventDefault();
		$.ajax({
			type: 'POST',
			url: url + '/upvote',
			dataType: 'JSON',
			success: function(response) {
				var current_count = $('.vote_count#' + response.book_id).html();
				var current_count_int = parseInt(current_count, 10) + 1;
				$('.vote_count#' + response.book_id).html(current_count_int);
				$('.downvote').remove();
				$('.upvote').remove();
			}
		});
	});
});
