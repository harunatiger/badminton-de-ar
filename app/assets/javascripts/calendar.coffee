$ ->

  delete_mode = false
  listing_id = gon.listing_id
  console.log(listing_id)

  # Create Event
  select = (start, end) ->
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


  dropEvent = (event, revertFunc) ->
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
        console.log 'dropEvent-fail'
    return false


  removeEvent = (event, revertFunc) ->
    if delete_mode == true
      res = confirm '削除します。よろしいですか？'
      if res == false
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
    addSize = (winHeight - calendarPosition - 60) / rowSize
    alert addSize
    $('.fc-body .fc-row').height(addSize)
    return

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
    events: '/listings/' + listing_id + '/ngevents.json',
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
      alert 555
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
      $(this).append("<button id='no_delete'>削除モード動作中</button> <font color='red'>削除したいeventをクリックしてください</font>")
      delete_mode = true
    else
      $(this).append("<button id=‘delete_btn’>削除モードへ</button>")
      delete_mode = false
    console.log delete_mode
    return
  return
