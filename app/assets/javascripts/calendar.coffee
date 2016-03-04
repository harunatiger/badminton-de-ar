$ ->
  #---------------------------------------------------------------------
  # fullCalendar Setting Init
  #---------------------------------------------------------------------
  #delete_mode = false
  #calendar = ''
  g_current_dow = []
  g_delFlag = 0
  g_weekdelFlag = 0
  g_mode = 0
  g_current_mode = 0
  g_event_className = []

  #use when create event
  g_listing_id = ''
  g_event_id = ''
  g_dow = -1

  #use when selected event and drop event
  g_select_listing = ''
  g_select_listing_week = ''
  g_select_dow = ''


  #---------------------------------------------------------------------
  # Set Listing
  #---------------------------------------------------------------------
  if $('#calendar_listing').val() == ''
    g_listing_id = 0
    g_mode = 3 #Common NGDay
  else
    g_listing_id = $('#calendar_listing').val()
    g_mode = 0 #Listing NGDay

  ## listing change
  $(document).on 'change', '#calendar_listing', ->
    $.each $('#calendar').fullCalendar('clientEvents'), (index, elem) ->
      console.log elem._start._d
    #Set listing
    if $('#calendar_listing').val() == ''
      g_listing_id = 0
      g_mode = 3 #Common NGDay
    else
      g_listing_id = $('#calendar_listing').val()
      g_mode = 0 #Listing NGDay

  #---------------------------------------------------------------------
  # Format functions
  #---------------------------------------------------------------------
  formatDate = (date) ->
    year = date.getFullYear()
    month = date.getMonth() + 1
    day = date.getDate()
    if month < 10
      month = '0' + month
    if day < 10
      day = '0' + day
    DateF = year + '-' + month + '-' + day
    return DateF

  formatWeek = (dow) ->
    switch parseInt(dow)
      when 0
        strweek = '日曜日'
      when 1
        strweek = '月曜日'
      when 2
        strweek = '火曜日'
      when 3
        strweek = '水曜日'
      when 4
        strweek = '木曜日'
      when 5
        strweek = '金曜日'
      when 6
        strweek = '土曜日'
      else
    strweek

  #---------------------------------------------------------------------
  # Confirm Modal
  #---------------------------------------------------------------------
  ##Confirm Modal for Day
  confirmModal = (event) ->
    g_event_id = event.id
    g_select_dow = event.dow

    g_event_className = ''
    g_event_className = event.className

    g_select_listing = ''
    g_event_className.forEach (val, index, ar) ->
      if val.match(/^listing/) != null
        g_select_listing = val.replace(/listing/g,"")
        return

    g_current_mode = 0
    g_event_className.forEach (val, index, ar) ->
      if val.match(/^mode/) != null
        g_current_mode = val.replace(/mode/g,"")
        return

    $.ajax(
      type: 'GET'
      url: '/ngevents/set_ngday_listing'
      data: {
        listing_id: g_select_listing
      }
    ).done (data) ->
      if g_event_className.indexOf('ng-event-week') != -1
        afterText = 'の'+formatWeek(g_select_dow)+'がNG日に設定されています。'
        comment = '解除する場合は曜日タイトルをクリックしてください。'
        $('#calendar_confirm').find('#ngdel').addClass('disabled')
      else
        if g_current_mode == '1'
          afterText = '予約確定'
          comment = ''
          $('#calendar_confirm').find('#ngdel').addClass('disabled')
        else if g_current_mode == '2'
          afterText = 'リクエスト'
          comment = ''
          $('#calendar_confirm').find('#ngdel').addClass('disabled')
        else if g_current_mode == '3'
          afterText = 'NG'
          comment = ''
          $('#calendar_confirm').find('#ngdel').removeClass('disabled')
        else
          afterText = 'NG'
          comment = ''
          $('#calendar_confirm').find('#ngdel').removeClass('disabled')

      $('#calendar_confirm').find('#listing_title').html('[ '+data.title+' ] ' + afterText)
      $('#calendar_confirm').find('#comment').html(comment)
      $('#calendar_confirm').modal()
    return

  ##Confirm Modal for Week
  confirmModalWeek = (element) ->
    g_select_listing_week = $(element).attr('id').replace(/listing/g,"")
    if parseInt(g_select_listing_week) == 0
      g_current_mode = 1
    else
      g_current_mode = 0
    $.ajax(
      type: 'GET'
      url: '/ngevent_weeks/set_ngweek_listing'
      data: {
        listing_id: g_select_listing_week
      }
    ).done (data) ->
      g_weekdelFlag = 1
      afterText = 'の'+formatWeek(g_dow)+'がNG日に設定されています。'
      comment = ''
      $('#calendar_confirm').find('#listing_title').html('[ '+data.title+' ] ' + afterText)
      $('#calendar_confirm').find('#comment').html(comment)
      $('#calendar_confirm').find('#ngdel').removeClass('disabled')
      $('#calendar_confirm').modal()

  modalyesClick = ->
    $('#calendar_confirm').modal('hide')
    if g_weekdelFlag == 1
      removeWeek()
      return false
    else
      removeEvent()
      return false

  $('#calendar_confirm #ngdel').on 'click', -> modalyesClick()

  #---------------------------------------------------------------------
  # Event Create
  #---------------------------------------------------------------------
  ## Set Event day
  select = (start, end) ->
    if g_delFlag == 0
      if eventExist(start.format()) == false
        return false

      #Common NGDay
      if g_mode == 3
        ajaxUrl = '/ngevents'
      #listing NGDay
      else
        ajaxUrl = '/listings/' + g_listing_id + '/ngevents'

      data = event:
        start: start._d,
        end: end._d,
        mode: g_mode,
      $.ajax
        type: 'POST'
        url: ajaxUrl
        data: data
        dataType: 'json'
        success: ->
          if $('.fc-highlight').length
            $('.fc-highlight').css('background', 'gray')
          calendar.fullCalendar 'refetchEvents'
          return
        error: ->
          calendar.fullCalendar 'refetchEvents'
          console.log 'error-select'
    else
      g_delFlag = 0
      return

  ## Set Event each week
  selectWeek = (element) ->
    if $.inArray(g_dow, g_current_dow) == -1
      if confirm 'この曜日は全てNG日に設定されます。よろしいですか？'
        if g_mode == 3
          ajaxUrl = '/ngevent_weeks'
          week_mode = 1
        else
          ajaxUrl = '/listings/' + g_listing_id + '/ngevent_weeks'
          week_mode = 0
        data = event:
          dow: g_dow,
          mode: week_mode,
        $.ajax
          type: 'POST'
          url: ajaxUrl
          data: data
          dataType: 'json'
          success: ->
            g_current_dow.push(g_dow)
            calendar.fullCalendar 'refetchEvents'
            return
          error: (status) ->
            calendar.fullCalendar 'refetchEvents'
            console.log 'error-select'
            return
    else
      confirmModalWeek(element)

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

  #---------------------------------------------------------------------
  # Event Remove
  #---------------------------------------------------------------------
  ## remove event day
  removeEvent = ->
    $('.fc-day-number').removeClass('smd-td')
    if g_event_className.indexOf('ng-event-week') != -1
      return false
    data =
      _method: 'DELETE',
      mode: g_mode,
    $.ajax
      type: 'DELETE'
      url: '/ngevents/' + g_event_id
      data: data
      dataType: 'json'
      success: ->
        clearColor()
        calendar.fullCalendar 'refetchEvents'
        return false
      error: ->
        calendar.fullCalendar 'refetchEvents'
        console.log 'removeEvent-fail'

  ## remove event each week
  removeWeek = ->
    #Common NGDay
    if g_current_mode == 1
      ajaxUrl = '/ngevent_weeks/unset'
    #listing NGDay
    else
      ajaxUrl = '/listings/' + g_select_listing_week + '/ngevent_weeks/unset'

    data =
      _method: 'put'
      event:
        dow: g_dow,
        mode: g_current_mode,
    $.ajax
      type: 'PUT'
      url: ajaxUrl
      data: data
      dataType: 'json'
      success: ->
        clearColor()
        g_weekdelFlag = 0
        i = $.inArray(g_dow, g_current_dow)
        if i != -1
          g_current_dow.splice(i)
        calendar.fullCalendar 'refetchEvents'
        return false
      error: ->
        g_weekdelFlag = 0
        calendar.fullCalendar 'refetchEvents'
        console.log 'removeEvent-fail'

  #---------------------------------------------------------------------
  # Function for Week Settings
  #---------------------------------------------------------------------
  ## Week Click Event
  setWeekevent = (event, element) ->
    $('.fc-content-skeleton tbody tr').css('background', '#DF1717')
    $('thead.fc-head .fc-widget-header').on 'click', ->
      if $(this).hasClass("fc-sun")
        g_dow = 0
      else if  $(this).hasClass("fc-mon")
        g_dow = 1
      else if  $(this).hasClass("fc-tue")
        g_dow = 2
      else if  $(this).hasClass("fc-wed")
        g_dow = 3
      else if  $(this).hasClass("fc-thu")
        g_dow = 4
      else if  $(this).hasClass("fc-fri")
        g_dow = 5
      else if  $(this).hasClass("fc-sat")
        g_dow = 6

      selectWeek($(this))
      return false

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
  setWeekHeaderElement = (element, listing) ->
    switch element
      when 0
        $fcheader = $('.fc-day-header.fc-sun')
        $('.fc-day-header.fc-sun').attr('id', 'listing'+listing)
      when 1
        $fcheader = $('.fc-day-header.fc-mon')
        $('.fc-day-header.fc-mon').attr('id', 'listing'+listing)
      when 2
        $fcheader = $('.fc-day-header.fc-tue')
        $('.fc-day-header.fc-tue').attr('id', 'listing'+listing)
      when 3
        $fcheader = $('.fc-day-header.fc-wed')
        $('.fc-day-header.fc-wed').attr('id', 'listing'+listing)
      when 4
        $fcheader = $('.fc-day-header.fc-thu')
        $('.fc-day-header.fc-thu').attr('id', 'listing'+listing)
      when 5
        $fcheader = $('.fc-day-header.fc-fri')
        $('.fc-day-header.fc-fri').attr('id', 'listing'+listing)
      when 6
        $fcheader = $('.fc-day-header.fc-sat')
        $('.fc-day-header.fc-sat').attr('id', 'listing'+listing)
      else
    $fcheader

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
    iconSize = (addSize / 4) + 10
    # alert addSize
    if $('.manage-listing-nav').css('position') == "absolute"
      $('.fc-body .fc-row').height(addSize)
      $('.fc-content-skeleton table').height(addSize)
      $('.fc-event').css('top', '-' + iconSize + 'px')

    # for drag multiselect
    $('.fc-event-container').each ->
      bgColor = $('a', this).attr('style')
      colNum = Number($(this).attr('colspan'))
      if colNum && !bgColor.match(/lightgray/)
        $(this).css('background', 'gray')
        arcIndex = 0
        $(this).prevAll('td').each ->
          arcIndex += @colSpan
          return
        thead = $(this).closest('tbody').prev()
        colCount = arcIndex + colNum
        i = arcIndex
        while i < colCount
          targetTd = $('td', thead).eq(i)
          targetTd.addClass('smd-td')
          i++
      else
        return
    return

  ## BackgroundColor initiarized when event render
  eventSetting = (event, element, view) ->
    if $.inArray('ng-event-week', event.className) != -1
      event.className.forEach (val, index, ar) ->
        if val.match(/^listing/) != null
          g_select_listing_week = val.replace(/listing/g,"")

      arry_redDay = []

      if $.inArray(event.dow[0], g_current_dow) == -1
        g_current_dow.push(event.dow[0])

        $.each $('#calendar').fullCalendar('clientEvents'), (index, elem) ->
          if elem.color == 'red'
            eventDay = new Date(elem._start._i)
            redWeek = eventDay.getDay()
            if redWeek == event.dow[0]
              arry_redDay.push(elem._start._i)

      setWeekElement(event.dow[0]).css('background', event.color)
      setWeekNumElement(event.dow[0]).css('color','white')
      setWeekHeaderElement(event.dow[0],g_select_listing_week).css('background', event.color)

      $.each arry_redDay, (index, elem) ->
        $('.fc-day[data-date="' + elem + '"]').css('background', 'red')
      return
    else
      startDay = new Date(event._start._i)
      endDay = new Date(event._end._i)
      while startDay < endDay
        $('.fc-day[data-date="' + formatDate(startDay) + '"]').css('background', event.color)
        $('.fc-day-number[data-date="' + formatDate(startDay) + '"]').css('color','white')
        newDate = startDay.setDate(startDay.getDate() + 1)
        startDay = new Date(newDate)
      return

  ## if exist event, disallow add event when drop
  disallowOverlap = (stillEvent, movingEvent) ->
    return false

  ## if exist event, disallow add event when dayClick
  eventExist = (start) ->
    evExist = true
    eventDay = new Date(start)
    if $.inArray(eventDay.getDay(), g_current_dow) != -1
      evExist = false
      return false
    $.each $('#calendar').fullCalendar('clientEvents'), (index, elem) ->
      if start == elem._start._i
        evExist = false
        return false
    return evExist

  #eventExistLoad = (event, element) ->
  #  current_startdate = event._start._d
  #  $.each array_startdate, (index, elem) ->
  #    if formatDate(current_startdate) == formatDate(elem)
  #      $(array_event[index]).addClass('hide')
  #  array_event.push(element)
  #  array_startdate.push(current_startdate)
  #  return


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
    eventClick: confirmModal,
    eventResize: resizeEvent,
    eventDrop: dropEvent,
    viewRender: setWeekevent,
    eventRender: eventSetting,
    eventOverlap: disallowOverlap,
    eventSources: [
      { url: '/ngevent_weeks/common_ngweeks.json' },
      { url: '/ngevent_weeks/except_common_ngweeks.json' },
      { url: '/ngevents.json'},
      { url: '/ngevents/common_ngdays.json'},
      { url: '/ngevents/request_ngdays.json'},
      { url: '/ngevents/reservation_ngdays.json'},
    ]
    eventStartEditable: false,
    eventAfterAllRender: ->
      smDick()
      return
    windowResize: ->
      smDick()
      return
    dayClick: (date, jsEvent) ->
      count = 0
      startDate = new Date(date.year(), date.month(), date.date(), 0, 0, 0)
      endDate = new Date(date.year(), date.month(), date.date(), 23, 59, 59)
      jsEvent.preventDefault()
      $('#calendar').fullCalendar 'clientEvents', (event) ->
        eventStart = event.start
        eventEnd = event.end
        if eventStart >= startDate && eventStart <= endDate
          confirmModal(event)
          g_delFlag = 1
        else if eventEnd >= startDate && eventEnd >= endDate
          if startDate <= eventStart && endDate <= eventStart
          else
            confirmModal(event)
            g_delFlag = 1
        else
        return
  )

