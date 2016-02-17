$ ->
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

  if $('body').hasClass('calendar common_ngdays')
    #---------------------------------------------------------------------
    # fullcalendar setting init
    #---------------------------------------------------------------------
    user_id = gon.user_id
    current_dow = []
    delFlag = 0
    mode = 3

    #---------------------------------------------------------------------
    # Create Event
    #---------------------------------------------------------------------
    ## Set Event day
    select = (start, end) ->
      if delFlag == 0
        if eventExist(start.format()) == false
          return false

        data = event:
          start: start._d,
          end: end._d,
          mode: mode,
        #console.log data
        $.ajax
          type: 'POST'
          url: '/ngevents'
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
        delFlag = 0
        return

    ## Set Event each week
    selectWeek = (dow) ->
      if $.inArray(dow, current_dow) == -1
        res = confirm 'この曜日は全てNG日に設定されます。よろしいですか？'
      else

        res = confirm 'この曜日のNG日を全て解除します。よろしいですか？'

      if res == false
        return false

      data = event:
        dow: dow,
        mode: 1,
      if $.inArray(dow, current_dow) == -1
        $.ajax
          type: 'POST'
          url: '/listings/' + listing_id + '/ngevent_weeks'
          data: data
          dataType: 'json'
          success: ->
            current_dow.push(dow)
            calendar.fullCalendar 'refetchEvents'
            return
          error: (status) ->
            calendar.fullCalendar 'refetchEvents'
            console.log 'error-select'
        return
      else
        removeWeek(dow)

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
      # remove smDick header
      $('.fc-day-number').removeClass('smd-td')
      if event.className.indexOf('ng-event-week') != -1
        return false

      data =
        _method: 'DELETE',
        mode: mode,
      $.ajax
        type: 'DELETE'
        url: '/ngevents/' + event.id
        data: data
        dataType: 'json'
        success: ->
          clearColor()
          calendar.fullCalendar 'refetchEvents'
          return false
        error: ->
          calendar.fullCalendar 'refetchEvents'
          console.log 'removeEvent-fail'

    ## Remove Event each week
    removeWeek = (dow) ->
      data =
        _method: 'put'
        event:
          dow: dow,
          mode: 1,
      $.ajax
        type: 'PUT'
        url: '/ngevent_weeks/unset'
        data: data
        dataType: 'json'
        success: ->
          clearColor()
          i = $.inArray(dow, current_dow)
          if i != -1
            current_dow.splice(i)
          calendar.fullCalendar 'refetchEvents'
          return false
        error: ->
          calendar.fullCalendar 'refetchEvents'
          console.log 'removeEvent-fail'

    ## Week Click Event
    setWeekevent = (event, element) ->
      $('.fc-content-skeleton tbody tr').css('background', '#DF1717')
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
        if $(this).css('background-color') == 'rgb(221, 221, 221)'
          alert '共通カレンダーでは解除できません'
          return false
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
          #arcIndex = Number($(this).index())
          #alert 'smDick'
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
        arry_redDay = []
        if $.inArray(event.dow[0], current_dow) == -1
          current_dow.push(event.dow[0])

        $.each $('#calendar').fullCalendar('clientEvents'), (index, elem) ->
          if elem.color == '#DF1717'
            eventDay = new Date(elem._start._i)
            redWeek = eventDay.getDay()
            if redWeek == event.dow[0]
              arry_redDay.push(elem._start._i)

        setWeekElement(event.dow[0]).css('background', event.color)
        setWeekHeaderElement(event.dow[0]).css('background', '#CCC')
        #setWeekHeaderElement(event.dow[0]).css('color', '#DDD')
        if event.color != '#17aedf'
          setWeekElement(event.dow[0]).css('opacity', '.4')
          setWeekHeaderElement(event.dow[0]).css('background','#DDD')

        $.each arry_redDay, (index, elem) ->
          $('.fc-day[data-date="' + elem + '"]').css('background', '#DF1717')
        return
      else
        #if event.color == 'red'
        startDay = new Date(event._start._i)
        endDay = new Date(event._end._i)
        while startDay < endDay
          $('.fc-day[data-date="' + formatDate(startDay) + '"]').css('background', event.color)
          if event.color == 'red' || event.color == '#F5966D' || event.color == 'gray'
            $('.fc-day[data-date="' + formatDate(startDay) + '"]').css('opacity', '.4')
            #$('.fc-day-number[data-date="' + formatDate(startDay) + '"]').css('color','#DDD')
          newDate = startDay.setDate(startDay.getDate() + 1)
          startDay = new Date(newDate)
        #else
          #alert event._start._i
        #  eventDay = new Date(event._start._i)
        #  if $.inArray(eventDay.getDay(), current_dow) != -1
        #    $('.fc-day[data-date="' + event._start._i + '"]').css('background', event.color)
        #  else
        #    $('.fc-day[data-date="' + event._start._i + '"]').css('background', event.color)
         #   $('.fc-day-number[data-date="' + event._start._i + '"]').css('color','white')
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
      viewRender: setWeekevent,
      eventRender: eventSetting,
      eventOverlap: disallowOverlap,
      eventSources: [
        { url: '/ngevents.json'},
        { url: '/ngevents/reservation_ngdays.json'},
        { url: '/ngevents/request_ngdays.json'},
        { url: '/ngevents/common_ngdays.json'},
        { url: '/ngevent_weeks/common_ngweeks.json' }
        { url: '/ngevent_weeks/except_common_ngweeks.json' }
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
            removeEvent(event)
            delFlag = 1
          else if eventEnd >= startDate && eventEnd >= endDate
            if startDate <= eventStart && endDate <= eventStart
            else
              removeEvent(event)
              delFlag = 1
          else
          return
    )


  if $('body').hasClass('calendar index')
    #---------------------------------------------------------------------
    # fullcalendar setting init
    #---------------------------------------------------------------------
    listing_id = gon.listing_id
    #console.log(listing_id)
    delete_mode = false
    current_dow = []
    #arry_eventDay = []
    delFlag = 0
    mode = 0

    #---------------------------------------------------------------------
    # Create Event
    #---------------------------------------------------------------------
    ## Set Event day
    select = (start, end) ->
      if delFlag == 0
        if eventExist(start.format()) == false
          return false

        data = event:
          start: start._d,
          end: end._d,
          mode: mode,
        $.ajax
          type: 'POST'
          url: '/listings/' + listing_id + '/ngevents'
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
        delFlag = 0
        return

    ## Set Event each week
    selectWeek = (dow) ->
      if $.inArray(dow, current_dow) == -1
        res = confirm 'この曜日は全てNG日に設定されます。よろしいですか？'
      else
        res = confirm 'この曜日のNG日を全て解除します。よろしいですか？'

      if res == false
        return false

      data = event:
        dow: dow,
        mode: 0,
      if $.inArray(dow, current_dow) == -1
        $.ajax
          type: 'POST'
          url: '/listings/' + listing_id + '/ngevent_weeks'
          data: data
          dataType: 'json'
          success: ->
            current_dow.push(dow)
            calendar.fullCalendar 'refetchEvents'
            return
          error: (status) ->
            calendar.fullCalendar 'refetchEvents'
            console.log 'error-select'
        return
      else
        removeWeek(dow)

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
      # remove smDick header
      # alert 'removeEvent'
      $('.fc-day-number').removeClass('smd-td')

      if event.className.indexOf('ng-event-week') != -1
        return false

      data =
        _method: 'DELETE',
        mode: mode,
      $.ajax
        type: 'DELETE'
        url: '/ngevents/' + event.id
        data: data
        dataType: 'json'
        success: ->
          clearColor()
          calendar.fullCalendar 'refetchEvents'
          return false
        error: ->
          calendar.fullCalendar 'refetchEvents'
          console.log 'removeEvent-fail'

    ## Remove Event each week
    removeWeek = (dow) ->
      data =
        _method: 'put'
        event:
          dow: dow,
          mode: 0,
      $.ajax
        type: 'PUT'
        url: '/listings/' + listing_id + '/ngevent_weeks/unset'
        data: data
        dataType: 'json'
        success: ->
          clearColor()
          i = $.inArray(dow, current_dow)
          if i != -1
            current_dow.splice(i)
          calendar.fullCalendar 'refetchEvents'
          return false
        error: ->
          calendar.fullCalendar 'refetchEvents'
          console.log 'removeEvent-fail'

    ## Week Click Event
    setWeekevent = (event, element) ->
      $('.fc-content-skeleton tbody tr').css('background', '#DF1717')
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
        if $(this).css('background-color') == 'rgb(221, 221, 221)'
          alert '共通カレンダーから解除できます'
          return false
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
          #arcIndex = Number($(this).index())
          #alert 'smDick'
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
        arry_redDay = []
        if $.inArray(event.dow[0], current_dow) == -1
          current_dow.push(event.dow[0])

        $.each $('#calendar').fullCalendar('clientEvents'), (index, elem) ->
          if elem.color == '#DF1717'
            eventDay = new Date(elem._start._i)
            redWeek = eventDay.getDay()
            if redWeek == event.dow[0]
              arry_redDay.push(elem._start._i)

        setWeekElement(event.dow[0]).css('background', event.color)
        #setWeekNumElement(event.dow[0]).css('color','white')
        setWeekHeaderElement(event.dow[0]).css('background', event.color)

        if event.color == '#17aedf'
          setWeekElement(event.dow[0]).css('opacity', '.4')
          setWeekHeaderElement(event.dow[0]).css('background','#DDD')

        $.each arry_redDay, (index, elem) ->
          $('.fc-day[data-date="' + elem + '"]').css('background', '#DF1717')
        return
      else
        #if event.color == 'red'
        startDay = new Date(event._start._i)
        endDay = new Date(event._end._i)
        while startDay < endDay
          $('.fc-day[data-date="' + formatDate(startDay) + '"]').css('background', event.color)
          if event.color == 'red' || event.color == '#17aedf' || event.color == '#F5966D'
            $('.fc-day[data-date="' + formatDate(startDay) + '"]').css('opacity', '.4')
            #$('.fc-day-number[data-date="' + formatDate(startDay) + '"]').css('color','#DDD')
          newDate = startDay.setDate(startDay.getDate() + 1)
          startDay = new Date(newDate)
        #else
          #alert event._start._i
        #  eventDay = new Date(event._start._i)
        #  if $.inArray(eventDay.getDay(), current_dow) != -1
        #    $('.fc-day[data-date="' + event._start._i + '"]').css('background', event.color)
        #  else
        #    $('.fc-day[data-date="' + event._start._i + '"]').css('background', event.color)
         #   $('.fc-day-number[data-date="' + event._start._i + '"]').css('color','white')
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
      viewRender: setWeekevent,
      eventRender: eventSetting,
      eventOverlap: disallowOverlap,
      eventSources: [
        { url: '/listings/' + listing_id + '/ngevents/listing_ngdays.json' },
        { url: '/listings/' + listing_id + '/ngevents/listing_reservation_ngdays.json' },
        { url: '/listings/' + listing_id + '/ngevents/listing_request_ngdays.json' },
        { url: '/listings/' + listing_id + '/ngevents/reservation_except_listing_ngdays.json' },
        { url: '/listings/' + listing_id + '/ngevents/request_except_listing_ngdays.json' },
        { url: '/ngevents/common_ngdays.json'},
        { url: '/listings/' + listing_id + '/ngevent_weeks/listing_ngweeks.json' }
        { url: '/ngevent_weeks/common_ngweeks.json' }
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
            removeEvent(event)
            delFlag = 1
          else if eventEnd >= startDate && eventEnd >= endDate
            if startDate <= eventStart && endDate <= eventStart
            else
              removeEvent(event)
              delFlag = 1
          else
          return
    )
