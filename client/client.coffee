$ ->
	#==============================================================================
	# Models
	class ArticleModel extends Backbone.Model

	class ArticleCollection extends Backbone.Collection
		model: ArticleModel
		localStorage: new Store "articles"

		comparator: (article) ->
			-1 * article.get "timeStamp"

		downloadArticle: (link, title) =>
			# JSONP so we can get around the cross domain restrictions for HTML5
			console.log 'GETing ' + title + ' ' + link
			$.getJSON "http://viewtext.org/api/text?url=" + link + "&callback=?", (data) ->
				console.log 'Got ' + link
				articles.create {title: title, link: link, timeStamp: new Date(), content: data.content}

		updateFromHN: (callback) =>
			console.log 'Starting update of hnews'
			$.ajax {
				# relative url unless running inside phonegap
				url: if device? then "http://longink.ampdat.com/articles" else "/articles"
				dataType: "xml"
				error: (xhr, errMsg, err) ->
					console.log "Error getting hnews rss feed " + errMsg
				success: (data) =>
					console.log 'Received updated hnews rss feed'
					$(data).find('item').each (item) ->
						link = $(this).find('link').text()
						title = $(this).find('title').text()
						if not articles.detect ((article) -> article.get("link") is link)
							console.log 'New article: ' + title
							articles.downloadArticle link, title
					callback()
			}	

	articles = new ArticleCollection()
	articles.fetch()

	#==============================================================================
	# Views
	class ArticleDetailView extends Backbone.View
		template: _.template($('#article-detail-view-template').html())
		render: =>
			$('#article-title').text(@model.get('title'))
			$('#article-original-button').attr('href', @model.get('link'))
			@el.html(@template({article : @model}))

	articleDetailView = new ArticleDetailView {el: $('#article-detail-view')}
			
	class ArticleListView extends Backbone.View
		template: _.template($('#article-list-view-template').html())
		events : {
			"click" : "handleShowArticleDetail"
		}
		constructor: ->
			super
			_.bindAll(this, 'render');
			@collection.bind 'all', @render
			
		handleShowArticleDetail: (e) ->
			articleDetailView.model = this.collection.getByCid(e.target.getAttribute("data-cid"))
			articleDetailView.render()
			$.mobile.changePage("#article-detail-page")
			
		render: =>
			@el.html(@template({articles : @collection}))
			@el.find('ul[data-role]').listview()
			
	articleListView = new ArticleListView {collection: articles, el: $ "#article-list-view"}
	articleListView.render()
	
	#==============================================================================
	# Controllers
	$('#refresh-button').click ->
		$.mobile.loadingMessage = 'Refreshing articles...'
		$.mobile.pageLoading false
		articles.updateFromHN -> $.mobile.pageLoading true

	$('#clear-button').click ->
		# .each doesn't work, only deletes a handfull at a time, why?
		# articles.each (article) -> article.destroy()
		articles.first().destroy() while articles.length

	$('#article-detail-view').bind 'swipeleft', ->
		i = articles.indexOf(articleDetailView.model)
		if i < articles.length-1
			articleDetailView.model = articles.at(i+1)
			articleDetailView.render()
	
	$('#article-detail-view').bind 'swiperight', ->
		i = articles.indexOf(articleDetailView.model)
		if i > 0
			articleDetailView.model = articles.at(i-1)
			articleDetailView.render()
			
	console.log "Foobarl...sdf"