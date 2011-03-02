(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  $(function() {
    var ArticleCollection, ArticleDetailView, ArticleListView, ArticleModel, articleDetailView, articleListView, articles;
    ArticleModel = (function() {
      function ArticleModel() {
        ArticleModel.__super__.constructor.apply(this, arguments);
      }
      __extends(ArticleModel, Backbone.Model);
      return ArticleModel;
    })();
    ArticleCollection = (function() {
      function ArticleCollection() {
        this.updateFromHN = __bind(this.updateFromHN, this);;
        this.downloadArticle = __bind(this.downloadArticle, this);;        ArticleCollection.__super__.constructor.apply(this, arguments);
      }
      __extends(ArticleCollection, Backbone.Collection);
      ArticleCollection.prototype.model = ArticleModel;
      ArticleCollection.prototype.localStorage = new Store("articles");
      ArticleCollection.prototype.comparator = function(article) {
        return -1 * article.get("timeStamp");
      };
      ArticleCollection.prototype.downloadArticle = function(link, title) {
        console.log('GETing ' + title + ' ' + link);
        return $.getJSON("http://viewtext.org/api/text?url=" + link + "&callback=?", function(data) {
          console.log('Got ' + link);
          return articles.create({
            title: title,
            link: link,
            timeStamp: new Date(),
            content: data.content
          });
        });
      };
      ArticleCollection.prototype.updateFromHN = function(callback) {
        console.log('Starting update of hnews');
        return $.ajax({
          url: typeof device != "undefined" && device !== null ? "http://longink.ampdat.com/articles" : "/articles",
          dataType: "xml",
          error: function(xhr, errMsg, err) {
            return console.log("Error getting hnews rss feed " + errMsg);
          },
          success: __bind(function(data) {
            console.log('Received updated hnews rss feed');
            $(data).find('item').each(function(item) {
              var link, title;
              link = $(this).find('link').text();
              title = $(this).find('title').text();
              if (!articles.detect((function(article) {
                return article.get("link") === link;
              }))) {
                console.log('New article: ' + title);
                return articles.downloadArticle(link, title);
              }
            });
            return callback();
          }, this)
        });
      };
      return ArticleCollection;
    })();
    articles = new ArticleCollection();
    articles.fetch();
    ArticleDetailView = (function() {
      function ArticleDetailView() {
        this.render = __bind(this.render, this);;        ArticleDetailView.__super__.constructor.apply(this, arguments);
      }
      __extends(ArticleDetailView, Backbone.View);
      ArticleDetailView.prototype.template = _.template($('#article-detail-view-template').html());
      ArticleDetailView.prototype.render = function() {
        $('#article-title').text(this.model.get('title'));
        $('#article-original-button').attr('href', this.model.get('link'));
        return this.el.html(this.template({
          article: this.model
        }));
      };
      return ArticleDetailView;
    })();
    articleDetailView = new ArticleDetailView({
      el: $('#article-detail-view')
    });
    ArticleListView = (function() {
      __extends(ArticleListView, Backbone.View);
      ArticleListView.prototype.template = _.template($('#article-list-view-template').html());
      ArticleListView.prototype.events = {
        "click": "handleShowArticleDetail"
      };
      function ArticleListView() {
        this.render = __bind(this.render, this);;        ArticleListView.__super__.constructor.apply(this, arguments);
        _.bindAll(this, 'render');
        this.collection.bind('all', this.render);
      }
      ArticleListView.prototype.handleShowArticleDetail = function(e) {
        articleDetailView.model = this.collection.getByCid(e.target.getAttribute("data-cid"));
        articleDetailView.render();
        return $.mobile.changePage("#article-detail-page");
      };
      ArticleListView.prototype.render = function() {
        this.el.html(this.template({
          articles: this.collection
        }));
        return this.el.find('ul[data-role]').listview();
      };
      return ArticleListView;
    })();
    articleListView = new ArticleListView({
      collection: articles,
      el: $("#article-list-view")
    });
    articleListView.render();
    $('#refresh-button').click(function() {
      $.mobile.loadingMessage = 'Refreshing articles...';
      $.mobile.pageLoading(false);
      return articles.updateFromHN(function() {
        return $.mobile.pageLoading(true);
      });
    });
    $('#clear-button').click(function() {
      var _results;
      _results = [];
      while (articles.length) {
        _results.push(articles.first().destroy());
      }
      return _results;
    });
    $('#article-detail-view').bind('swipeleft', function() {
      var i;
      i = articles.indexOf(articleDetailView.model);
      if (i < articles.length - 1) {
        articleDetailView.model = articles.at(i + 1);
        return articleDetailView.render();
      }
    });
    return $('#article-detail-view').bind('swiperight', function() {
      var i;
      i = articles.indexOf(articleDetailView.model);
      if (i > 0) {
        articleDetailView.model = articles.at(i - 1);
        return articleDetailView.render();
      }
    });
  });
}).call(this);
