$ ->
  #---------------------------------------------------------------------
  # fullCalendar Setting Init
  #---------------------------------------------------------------------
  g_delFlag = 0
  g_addFlag = 0
  g_start = ''
  g_end = ''
  g_weekdelFlag = 0
  g_mode = 0
  g_modenum = 0
  g_current_mode = 0
  g_event_className = []
  g_arry_redDay = []
  g_arry_ngday = []
  g_arry_ngweek = []

  #use when create event
  g_listing_id = ''
  g_event_id = ''
  g_dow = -1
  g_add_week = 0

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
  confirmModal = ->
    $.ajax(
      type: 'GET'
      url: '/ngevents/select_ngdays'
      data: {
        arry_ngday: g_arry_ngday
        arry_ngweek: g_arry_ngweek
      }
    ).done (data) ->
      $("#calendar_confirm table#ngday").html('')
      if data.ngevents != null
        $.each data.ngevents, (index, value) ->
          setConfirm(value['title'], value['id'],value['category'],value['mode'], value['modenum'])
        $('#calendar_confirm').modal()
    return



  ##Confirm Modal for Week
  confirmModalWeek = ->
    $.ajax(
      type: 'GET'
      url: '/ngevent_weeks/set_ngweek_listing'
      data: {
        dow: g_dow
      }
    ).done (data) ->
      $("#calendar_confirm table#ngday").html('')
      if data.ngweeks.length != 0
        $.each data.ngweeks, (index, value) ->
          setConfirm(value['title'], value['id'],value['category'],value['mode'], value['modenum'])
        $('#calendar_confirm').modal()
      else
        $("#calendar_confirm table#ngday").append(
          $("<tr class='ngday-block'></tr>")
            .append($("<th class='col-sm-12 col-md-12'></th>").text(formatWeek(g_dow) + 'が全てNG日に設定されます。'))
        )
        $('#calendar_confirm').find('#ngadd').css('visibility', 'visible')
        $('#calendar_confirm').find('.ngday-remove').css('visibility', 'hidden')
        $('#calendar_confirm').modal()
    return


  setConfirm = (title, id, category, mode, modenum) ->
    if category == 'week'
      $("#calendar_confirm table#ngday").append(
        $("<tr class='ngday-block row'></tr>")
          .append($("<th class='col-sm-12 col-md-12'></th>").text('[' + title + '] ' + formatWeek(g_dow) + mode))
          .append($("<td class='col-sm-12 col-md-2 text-right'><a class='ngday-remove btn bg-gray btn-default' data-remote='true' rel='nofollow' data-method='delete' href='/ngevent_weeks/" + id + "'>解除する</a></td>"))
      )
      if modenum == 1
        $('#calendar_confirm').find('#ngadd').css('visibility', 'hidden')
        $('#calendar_confirm').find('.ngday-remove').css('visibility', 'visible')
        g_modenum = 1
      else
        if g_modenum == 0
          $('#calendar_confirm').find('#ngadd').css('visibility', 'visible')
          $('#calendar_confirm').find('.ngday-remove').css('visibility', 'visible')
    else
      if modenum == 3
        $("#calendar_confirm table#ngday").append(
          $("<tr class='ngday-block row'></tr>")
            .append($("<th class='col-sm-12 col-md-12'></th>").text('[' + title + '] ' + mode))
            .append($("<td class='col-sm-12 col-md-2 text-right'><a class='ngday-remove btn bg-gray btn-default' data-remote='true' rel='nofollow' data-method='delete' href='/ngevents/" + id + "'>解除する</a></td>"))
          )
        $('#calendar_confirm').find('#ngadd').css('visibility', 'hidden')
        $('#calendar_confirm').find('.ngday-remove').css('visibility', 'visible')
        g_modenum = 1
      else if modenum == 1 || modenum == 2
        $("#calendar_confirm table#ngday").append(
          $("<tr class='ngday-block row'></tr>")
            .append($("<th class='col-sm-12 col-md-12'></th>").text('[' + title + '] ' + mode))
          )
        $('#calendar_confirm').find('#ngadd').css('visibility', 'hidden')
        g_modenum = 1
      else
        $("#calendar_confirm table#ngday").append(
          $("<tr class='ngday-block row'></tr>")
            .append($("<th class='col-sm-12 col-md-12'></th>").text('[' + title + '] ' + mode))
            .append($("<td class='col-sm-12 col-md-2 text-right'><a class='ngday-remove btn bg-gray btn-default' data-remote='true' rel='nofollow' data-method='delete' href='/ngevents/" + id + "'>解除する</a></td>"))
          )
        if g_modenum == 0
          $('#calendar_confirm').find('#ngadd').css('visibility', 'visible')
          $('#calendar_confirm').find('.ngday-remove').css('visibility', 'visible')

    $('#calendar_confirm table#ngday .ngday-remove').on 'ajax:complete',  (event, ajax, status) ->
      index = $('#calendar_confirm table#ngday .ngday-remove').index(this)
      if index != -1
        if status == 'success'
          del_elem = $('#calendar_confirm table#ngday .ngday-block').eq(index)
          del_elem.remove()
          ng_elem_length = $('#calendar_confirm table#ngday .ngday-block').length
          if ng_elem_length == 0
            $('#calendar_confirm').modal('hide')
          else
            if ajax.responseJSON.category == 'ngweek'
              g_modenum = 0
              confirmModalWeek()
            else
              g_modenum = 0
              confirmModal()
          clearColor()
          calendar.fullCalendar 'refetchEvents'
        return


  $('#calendar_confirm #ngadd').on 'click' , ->
    if g_add_week == 1
      setWeek()
      return false
    else
      g_addFlag = 1
      g_delFlag = 0
      select(g_start, g_end)
      return false



  #---------------------------------------------------------------------
  # Event Create
  #---------------------------------------------------------------------
  ## Set Event day
  select = (start, end) ->
    if g_delFlag == 0
      if g_addFlag == 1
        startdate = start
        enddate = end
      else
        startdate = start._d
        enddate = end._d

      #Common NGDay
      if g_mode == 3
        ajaxUrl = '/ngevents'
      #listing NGDay
      else
        ajaxUrl = '/listings/' + g_listing_id + '/ngevents'

      data = event:
        start: startdate,
        end: enddate,
        mode: g_mode
      $.ajax(
        type: 'POST'
        url: ajaxUrl
        data: data
        dataType: 'json'
      ).done (data) ->
        if data.status == 'success'
          if g_addFlag == 1
            g_addFlag = 0
            g_arry_ngday.push(data.ngevent.id)
            g_modenum = 0
            confirmModal()
            calendar.fullCalendar 'refetchEvents'
          else
            if $('.fc-highlight').length
              $('.fc-highlight').css('background', 'gray')
            calendar.fullCalendar 'refetchEvents'
        else if data.status == 'exist'
          g_addFlag = 0
          alert $('#calendar_listing option:selected').text()+' は既に設定済みです。'
        else
          g_addFlag = 0
          calendar.fullCalendar 'refetchEvents'
          console.log 'error-select'
        return
      return
    else
      g_delFlag = 0
      return

  ## Set Event each week
  selectWeek = (element) ->
    g_add_week = 1
    g_modenum = 0
    confirmModalWeek()


  setWeek = ->
    if g_mode == 3
      ajaxUrl = '/ngevent_weeks'
      week_mode = 1
    else
      ajaxUrl = '/listings/' + g_listing_id + '/ngevent_weeks'
      week_mode = 0
    data = event:
      dow: g_dow,
      mode: week_mode,
    $.ajax(
      type: 'POST'
      url: ajaxUrl
      data: data
      dataType: 'json'
    ).done (data) ->
      if data.status == 'success'
        if g_add_week == 1
          g_arry_ngday.push(data.ngevent_week.id)
          g_modenum = 0
          confirmModalWeek()
          calendar.fullCalendar 'refetchEvents'
        else
          calendar.fullCalendar 'refetchEvents'
      else if data.status == 'exist'
        alert $('#calendar_listing option:selected').text()+' は既に設定済みです。'
      else
        calendar.fullCalendar 'refetchEvents'
        console.log 'error-select'
      return
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
      redDayflg = 0
      event.className.forEach (val, index, ar) ->
        if val.match(/^listing/) != null
          g_select_listing_week = val.replace(/listing/g,"")

      startDay = new Date(event._start._d)
      $.each g_arry_redDay, (index, elem) ->
        redDay = new Date(elem)
        if formatDate(startDay) == formatDate(redDay)
          redDayflg = 1

      if redDayflg == 0
        $('.fc-day[data-date="' + formatDate(startDay) + '"]').css('background', event.color)
        $('.fc-day-number[data-date="' + formatDate(startDay) + '"]').css('color','white')
      setWeekHeaderElement(event.dow[0],g_select_listing_week).css('background', event.color)

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
    #eventClick: confirmModal,
    eventResize: resizeEvent,
    eventDrop: dropEvent,
    viewRender: setWeekevent,
    eventRender: eventSetting,
    #eventOverlap: disallowOverlap,
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
    dayClick: (date, jsEvent, view) ->
      count = 0
      startDate = new Date(date.year(), date.month(), date.date(), 0, 0, 0)
      endDate = new Date(date.year(), date.month(), date.date(), 23, 59, 59)
      jsEvent.preventDefault()
      events = view.calendar.clientEvents((event) ->
        eventStart = event.start
        eventEnd = event.end
        if eventStart >= startDate && eventStart <= endDate
          true
        else if eventEnd >= startDate && eventEnd >= endDate
          if startDate <= eventStart && endDate <= eventStart
            false
          else
            true
        else
          false
      )
      if events.length != 0
        g_arry_ngday = []
        g_arry_ngweek = []
        $.each events, (index, elem) ->
          if elem.className.indexOf('ng-event-week') != -1
            g_arry_ngweek.push(elem.id)
          else
            g_arry_ngday.push(elem.id)

        g_delFlag = 1
        g_add_week = 0
        g_modenum = 0
        g_start = new Date(date.year(), date.month(), date.date(), 9, 0, 0)
        g_end = new Date(date.year(), date.month(), date.date()+1, 9, 0, 0)
        g_dow = startDate.getDay()
        confirmModal()
      return
  )
