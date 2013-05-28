@Brokers = new Meteor.Collection "brokers"

ballgameRouter = Backbone.Router.extend
	routes:
		''						: 'home'
		'about'					: 'about'
		'method'				: 'method'
		'room'					: 'room'
		'ranking'				: 'ranking'
		':company_id'			: 'brokerInfo'
		':choose'				: 'checkBox'

	home: ->
		Session.set 'page', 'home'

	about: ->
		Session.set 'page', 'about'

	method: ->
		Session.set 'page', 'method'

	ranking: (company_id, choose) ->
		Session.set 'page', 'ranking'
		Session.set 'company_id', company_id
		Session.set 'choose', choose

	brokerInfo: (company_id) ->
		Session.set 'page', 'brokerInfo'
		Session.set 'company_id', company_id

	setCompany: (company_id) ->
		@navigate company_id, true

	setCheckBox: (choose) ->
		Session.set 'choose', choose
		@navigate 'ranking', true

	room: ->
		Session.set 'page', 'room'


Router = new ballgameRouter

Meteor.startup -> Backbone.history.start pushState: true

Template.content.currentPage = (type) ->
	Session.equals 'page', type

Template.brokersList.companies = ->
	if Session.equals 'choose', undefined
		Brokers.find {}, sort: ratingNumber: -1
	else if Session.equals 'choose', 'under100'
		Brokers.find {under100: true}, sort: ratingNumber: -1	
	else if Session.equals 'choose', 'under1m'
		Brokers.find {under1m: true}, sort: ratingNumber: -1
	else if Session.equals 'choose', 'under10m'
		Brokers.find {under10m: true}, sort: ratingNumber: -1
	else if Session.equals 'choose', 'upper10m'
		Brokers.find {upper10m: true}, sort: ratingNumber: -1

Template.checkBox.events =
	'click #under100': (e) ->
		Router.setCheckBox('under100')

	'click #under1m': (e) ->
		Router.setCheckBox('under1m')

	'click #under10m': (e) ->
		Router.setCheckBox('under10m')

	'click #upper10m': (e) ->
		Router.setCheckBox('upper10m')

	'click #rankingAll': (e) ->
		Router.setCheckBox(undefined)

Template.company.selected = ->
	if Session.equals('company_id', @_id) then "selected" else ""

Template.company.events =
	'click, tap .view_company': (e) ->
		Router.setCompany(@_id)

Template.brokerInfo.brokerArr = ->
	company_id = Session.get 'company_id'
	selected = Brokers.findOne _id: company_id
		
Template.userInfo.userArr = ->
	Meteor.users.findOne({_id: this.userId})

Template.userInfo.events = 
	'focusout, keyup, keydown #user_name': (e) ->
		username = $('#user_name').val()
		if username
			Meteor.users.update({_id: this._id}, {$set: {username: username}})
	'focusout, keyup, keydown #profile_name': (e) ->
		profile_name = $('#profile_name').val()
		if profile_name
			Meteor.users.update({_id: this._id}, {$set: {'profile.name': profile_name}})

Template.about.events =
	'click, tap #send_email': (e) ->
		from = $('#user_email').val()
		to = "pruntoff@gmail.com"
		subject = $('#msg_theme').val()
		text = $('#msg_text').val()

		Meteor.call 'sendEmail', to, from, subject, text, ->
			$('.alert-success').addClass('visible')

Template.analytics.rendered = ->
	if !window._gaq?
		window._gaq = []
		_gaq.push(['_setAccount', 'UA-40685284-1'])
		_gaq.push(['_trackPageview'])

		(->
      		ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
      		gajs = '.google-analytics.com/ga.js'
      		ga.src = if 'https:' is document.location.protocol then 'https://ssl'+gajs else 'http://www'+gajs
      		s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s)
    	)()
