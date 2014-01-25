if(s.length>=3){
	if(p==-1){
		var o=e.ajax({
			url:"http://search.elasticsearch.org/search/",
			data:{q:s},
			dataType:"jsonp"
		});
		o.success( function(u) {
			var t=u.hits.hits;
			e.Mustache.add(
				"search-result-template",
				'<li><a href="{{fields.url}}"><h4>{{fields.title}}</h4><p class="result_url">{{fields.path}}</p></a></li>');
				e(".blog_search_wrapper ul").empty().mustache("search-result-template",
				t);
			e("#results").show();
			if(e("#results a").length) {
				e("#results a").keynav();
			}
		});
	}
} 	else {
		e(".blog_search_wrapper ul").empty();
		e("#results").hide();
	}
})
