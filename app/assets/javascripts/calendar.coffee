$ ->
  #---------------------------------------------------------------------
  # fullcalendar setting init
  #---------------------------------------------------------------------
  listing_id = gon.listing_id
  console.log(listing_id)
  delete_mode = false
  current_dow = []

  #---------------------------------------------------------------------
  # Create Event
  #---------------------------------------------------------------------
  ## Set Event day
  select = (start, end) ->
    if eventExist(start.format()) == false
      return false

    data = event:
      start: start._d,
      end: end._d,
    $.ajax
      type: 'POST'
      url: '/listings/' + listing_id + '/ngevents'
      data: data
      dataType: 'json'
      success: ->
        calendar.fullCalendar 'refetchEvents'
        return
      error: ->
        calendar.fullCalendar 'refetchEvents'
        console.log 'error-select'
    return

  ## Set Event each week
  selectWeek = (dow) ->
    data = event:
      dow: dow,
    $.ajax
      type: 'POST'
      url: '/listings/' + listing_id + '/ngevent_weeks'
      data: data
      dataType: 'json'
      success: ->
        calendar.fullCalendar 'refetchEvents'
        return
      error: (status) ->
        if status.status == 4001
          removeWeek(status.responseJSON.event.dow)
        else
          calendar.fullCalendar 'refetchEvents'
          console.log 'error-select'
    return

  ## Resize Event
  resizeEvent = (event, revertFunc) ->
    data =
      _method: 'PUT'
      event:
        start: event.start._d
        end: event.end._d
    $.ajax
      type: 'PUT'
      url: '/ngevents/' + event.id
      data: data
      dataType: 'json'
      success: ->
        calendar.fullCalendar 'refetchEvents'
        return false
      error: ->
        calendar.fullCalendar 'refetchEvents'
        console.log 'resizeEvent-fail'
    return false

  ## Drag and Drop Event
  dropEvent = (event, revertFunc) ->
    if event.className.indexOf('ng-event-week') != -1
      calendar.fullCalendar 'refetchEvents'
      return false
    data =
      _method: 'PUT'
      event:
        start: event.start._d
        end: event.end._d
    $.ajax
      type: 'PUT'
      url: '/ngevents/' + event.id
      data: data
      dataType: 'json'
      success: ->
        clearColor()
        calendar.fullCalendar 'refetchEvents'
        return false
      error: ->
        calendar.fullCalendar 'refetchEvents'
        console.log 'dropEvent-fail'
    return false

  ## remove event day
  removeEvent = (event, revertFunc) ->
    if event.className.indexOf('ng-event-week') != -1
      return false

    data =
      _method: 'DELETE'
    $.ajax
      type: 'DELETE'
      url: '/ngevents/' + event.id
      data: data
      dataType: 'json'
      success: ->
        clearColor()
        calendar.fullCalendar 'refetchEvents'
        return false
      data =
        _method: 'DELETE'
      $.ajax
        type: 'DELETE'
        url: '/ngevents/' + event.id
        data: data
        dataType: 'json'
        success: ->
          calendar.fullCalendar 'refetchEvents'
          return false
        error: ->
          calendar.fullCalendar 'refetchEvents'
          console.log 'removeEvent-fail'
    else
      calendar.fullCalendar 'refetchEvents'
    return false

  smDick = ->
    calendarPosition = $('.fc-body').offset().top
    winHeight = $(window).height()
    rowSize = $('.fc-body .fc-row').size()
    addSize = (winHeight - calendarPosition - 40) / rowSize
    alert addSize
    $('.fc-body .fc-row').height(addSize)
    return

  ## Remove Event each week
  removeWeek = (dow) ->
    data =
      _method: 'unset'
      event:
        dow: dow
    $.ajax
      type: 'GET'
      url: '/listings/' + listing_id + '/ngevent_weeks/unset'
      data: data
      dataType: 'json'
      success: ->
        clearColor()
        calendar.fullCalendar 'refetchEvents'
        return false
      error: ->
        calendar.fullCalendar 'refetchEvents'
        console.log 'removeEvent-fail'

  ## Week Click Event
  setWeekevent = (event, element) ->
    $('.fc-content-skeleton tbody tr').css('background', 'red')
    $('thead.fc-head .fc-widget-header').on 'click', ->
      if $(this).hasClass("fc-sun")
        dow = 0
      else if  $(this).hasClass("fc-mon")
        dow = 1
      else if  $(this).hasClass("fc-tue")
        dow = 2
      else if  $(this).hasClass("fc-wed")
        dow = 3
      else if  $(this).hasClass("fc-thu")
        dow = 4
      else if  $(this).hasClass("fc-fri")
        dow = 5
      else if  $(this).hasClass("fc-sat")
        dow = 6

      selectWeek(dow)
      return false

  #---------------------------------------------------------------------
  # UI Setting
  #---------------------------------------------------------------------
  ## Color Init
  clearColor = ->
    $('.fc-day').css('background', 'white')
    $('.fc-day-number').css('color', 'black')
    $('.fc-day-header').css('background', 'transparent')

  smDick = ->
    calendarPosition = $('.fc-body').offset().top
    winHeight = $(window).height()
    rowSize = $('.fc-body .fc-row').size()
    addSize = (winHeight - calendarPosition - 40) / rowSize
    alert addSize
    $('.fc-body .fc-row').height(addSize)
    return

  ## Week Element(ex. all monday)
  setWeekElement = (element) ->
    switch element
      when 0
        $fcweek = $('.fc-day.fc-sun')
      when 1
        $fcweek = $('.fc-day.fc-mon')
      when 2
        $fcweek = $('.fc-day.fc-tue')
      when 3
        $fcweek = $('.fc-day.fc-wed')
      when 4
        $fcweek = $('.fc-day.fc-thu')
      when 5
        $fcweek = $('.fc-day.fc-fri')
      when 6
        $fcweek = $('.fc-day.fc-sat')
      else
    $fcweek

  ## Week Number Element(day)
  setWeekNumElement = (element) ->
    switch element
      when 0
        $fcnum = $('.fc-day-number.fc-sun')
      when 1
        $fcnum = $('.fc-day-number.fc-mon')
      when 2
        $fcnum = $('.fc-day-number.fc-tue')
      when 3
        $fcnum = $('.fc-day-number.fc-wed')
      when 4
        $fcnum = $('.fc-day-number.fc-thu')
      when 5
        $fcnum = $('.fc-day-number.fc-fri')
      when 6
        $fcnum = $('.fc-day-number.fc-sat')
      else
    $fcnum

  ## Week Header Element(ex. '月')
  setWeekHeaderElement = (element) ->
    switch element
      when 0
        $fcheader = $('.fc-day-header.fc-sun')
      when 1
        $fcheader = $('.fc-day-header.fc-mon')
      when 2
        $fcheader = $('.fc-day-header.fc-tue')
      when 3
        $fcheader = $('.fc-day-header.fc-wed')
      when 4
        $fcheader = $('.fc-day-header.fc-thu')
      when 5
        $fcheader = $('.fc-day-header.fc-fri')
      when 6
        $fcheader = $('.fc-day-header.fc-sat')
      else
    $fcheader

  ## BackgroundColor initiarized when event render
  eventSetting = (event, element, view) ->
    if $.inArray('ng-event-week', event.className) != -1
      #event.className.indexOf('ng-event-week') != -1
      setWeekElement(event.dow[0]).css('background', event.color)
      setWeekNumElement(event.dow[0]).css('color','white')
      setWeekHeaderElement(event.dow[0]).css('background',event.color)
      if $.inArray(event.dow[0], current_dow) == -1
        current_dow.push(event.dow[0])
    else
      #eventDay = new Date(event._start._i)
      #if $.inArray(eventDay.getDay(), current_dow) != -1
        #$('.fc-day[data-date="' + event._start._i + '"]').css('background', 'white')
      #else
        $('.fc-day[data-date="' + event._start._i + '"]').css('background', event.color)
        $('.fc-day-number[data-date="' + event._start._i + '"]').css('color','white')
    return

  ## if exist event, disallow add event when drop
  disallowOverlap = (stillEvent, movingEvent) ->
    return false

  ## if exist event, disallow add event when dayClick
  eventExist = (start) ->
    evExist = true
    eventDay = new Date(start)
    if $.inArray(eventDay.getDay(), current_dow) != -1
      evExist = false
      return false
    $.each $('#calendar').fullCalendar('clientEvents'), (index, elem) ->
      if start == elem._start._i
        evExist = false
        return false
    return evExist

  #---------------------------------------------------------------------
  # fullcalendar settings
  #---------------------------------------------------------------------
  calendar = $('#calendar').fullCalendar(
    header: {
      left: 'today prev',
      center: 'title',
      right: 'next'
    },
    defaultView: 'month',
    # 時間の書式
    timeFormat: 'H(:mm)',
    # 列の書式
    columnFormat: {
        month: 'ddd',    # 月
        week: "d'('ddd')'", # 7(月)
        day: "d'('ddd')'" # 7(月)
    },
    # タイトルの書式
    titleFormat: {
        month: 'YYYY年M月',                             # 2013年9月
        week: "YYYY年M月d日{ ～ }{[yyyy年]}{[M月]d日}", # 2013年9月7日 ～ 13日
        day: "YYYY年M月d日'('ddd')'"                  # 2013年9月7日(火)
    },
    buttonText: {
      prev: ' ◄ ',
      next: ' ► ',
      prevYear: ' << ',
      nextYear: ' >> ',
      today: '今日',
      month: '月',
      week: '週',
      day: '日'
    },
    # 月名称
    monthNames: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
    # 月略称
    monthNamesShort: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
    # 曜日名称
    dayNames: ['日曜日', '月曜日', '火曜日', '水曜日', '木曜日', '金曜日', '土曜日'],
    # 曜日略称
    dayNamesShort: ['日', '月', '火', '水', '木', '金', '土'],
    slotEventOverlap: false,
    selectable: true,
    selectHelper: true,
    ignoreTimezone: false,
    editable: true,
    select: select,
    eventClick: removeEvent,
    eventResize: resizeEvent,
    eventDrop: dropEvent,
    eventAfterAllRender: ->
      smDick()
      return
    windowResize: ->
      smDick()
      return
    viewRender: setWeekevent,
    eventRender: eventSetting,
    eventOverlap: disallowOverlap,
    eventSources: [
      { url: '/listings/' + listing_id + '/ngevents.json' },
      { url: '/listings/' + listing_id + '/ngevent_weeks.json' }
    ]
    eventAfterAllRender: ->
      smDick()
      return
    windowResize: ->
      smDick()
      return
  )

  ###
  timer = false

  $(window).resize ->
    if timer != false
      clearTimeout timer
    timer = setTimeout((->
      #smDick()
      return
    ), 200)
    return
  ###

  # delete_btn
  $('#delete_mode').on 'click', ->
    $(this).empty()
    if delete_mode == false
      $(this).append('<button id="no_delete">戻る</button> <span class="text-red">削除したいeventをクリック</span>')
      delete_mode = true
    else
      $(this).append('<button id="delete_btn">日程を削除する</button>')
      delete_mode = false
    console.log delete_mode
    return
  return
