@Brokers = new Meteor.Collection "brokers"

Meteor.startup ->

	process.env.MAIL_URL = 'smtp://pruntoff%40gmail.com:ReK3GidU8ees@smtp.gmail.com:465';

	if Brokers.find().count() is 0
		Brokers.insert
			name: "CopyTrading"
			fees:
				feesPage: 'http://copytrading.ru/fees'
				first: 0.03
				second: 0.05
				third: 0.07
				firstVolume: 'Агрессивный'
				secondVolume: 'Активный'
				thirdVolume: 'Консервативный'
			capital: 
				volume: 5000000
				turnover: 25000000
			margin: false
			service:
				description: '<p>Мы обеспечиваем Вам доступ к этой информации, возможность выбрать нескольких трейдеров и повторять их операции автоматически. 
				Открытые данные в режиме реального времени дают нашим клиентам представление о возможной прибыли, если они будут повторять действия данного 
				трейдера на рынке и позволят принять решение о целесообразности копирования операций определенного трейдера.</p>'
				software:
					web: true
					standalong: true
					webApp: 'CopyTrading'
					standalongApp: 'Quik/CopyTrading'
			connecton: 5
			description: "Компания CopyTrade предоставляет инструмент для инвесторов, которые предпочитают 
			управление средствами, вместо самостоятельной игры на бирже. Данный продукт позволяет копировать 
			операции трейдеров на российской фондовой бирже и автоматически повторять их на счете клиента, 
			без его непосредственного участия в осуществлении операций.
			Трейдеры, которые сотрудничают с нашей системой, это независимые профессионалы, торгующее на 
			финансовых рынках. 
			Они готовы раскрывать свою финансовую информацию и предоставлять данные о доходах и операциях в 
			реальном времени. Мы обеспечиваем Вам доступ к этой информации, возможность выбрать нескольких 
			трейдеров и повторять их операции автоматически. 
			Открытые данные в режиме реального времени дают нашим клиентам представление о возможной прибыли, 
			если они будут повторять действия данного трейдера на рынке и позволят принять решение о 
			целесообразности копирования операций определенного трейдера. 
			Существуют жесткие параметры, контролирующие исполнение операций на счете клиента. Наша система 
			позволяет копировать операции с учетом таких факторов, как: отношение счета клиента к счету 
			трейдера, ликвидность инструмента, коэффициент проскальзывания и т.п. Это позволяет снизить риск 
			нежелательных операций."
			site: "http://copytrading.ru"
			logo: "http://copytrading.ru/Content/Images/logo.png"
			rating: 'AA'
			ratingNumber: 10
			minDeposit: 40000
			boardsRUS: "ММВБ, РТС (Форвардные и СПОТ рынки)"
			boardsFOR: false
			boardsMain: "ММВБ, РТС (Форвардные и СПОТ рынки)"
			contacts:
				adress: '111020, Москва, пр-т Маршала Жукова, 4'
				phone1: '+7(495)777 5555'
				phone2: '+7(495)555 7777'
				email: 'info@copytrading.ru'


Brokers.allow({
	insert: (userId) ->
		if userId
			true
		else
			false
	update: (userId) ->
		if userId
			true
		else
			false
	remove: (userId) ->
		if userId
			true
		else
			false
})

Meteor.methods({
  sendEmail: (to, from, subject, text) -> 
    this.unblock();

    Email.send({
      to: to,
      cc: 'guyboe@gmail.com'	//	for tests
      from: from,
      subject: subject,
      text: text
    });
});