Brokers = new Meteor.Collection "brokers"

ballgameRouter = Backbone.Router.extend
	routes:
		''						: 'home'
		'about'					: 'about'
		'room'					: 'room'
		'ranking'				: 'ranking'
		':company_id'			: 'brokerInfo'

	home: ->
		Session.set 'page', 'home'

	about: ->
		Session.set 'page', 'about'

	ranking: (company_id) ->
		Session.set 'page', 'ranking'
		Session.set 'company_id', company_id

	brokerInfo: (company_id) ->
		Session.set 'page', 'brokerInfo'
		Session.set 'company_id', company_id

	setCompany: (company_id) ->
		@navigate company_id, true

	room: ->
		Session.set 'page', 'room'


Router = new ballgameRouter

Meteor.startup -> Backbone.history.start pushState: true

Template.content.currentPage = (type) ->
	Session.equals 'page', type

Template.brokersList.companies = ->
	Brokers.find {}, sort: ratingNumber: -1

Template.company.selected = ->
	if Session.equals('company_id', @_id) then "selected" else ""

Template.company.events =
	'click .view_company': (e) ->
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
	'click #send_email': (e) ->
		from = $('#user_email').val()
		to = "pruntoff@gmail.com"
		subject = $('#msg_theme').val()
		text = $('#msg_text').val()

		Meteor.call 'sendEmail', to, from, subject, text, ->
			$('.alert-success').addClass('visible')
