#profiles.coffee
(($) ->

  $.fn.zip2adr = (zip, callback) ->
    cb = if arguments.length > 1 then true else false
    if zip == ''
      return false
    target = $(this)
    $.ajax
      type: 'get'
      url: 'http://maps.googleapis.com/maps/api/geocode/json'
      crossDomain: true
      dataType: 'json'
      data:
        address: zip
        language: 'en'
        sensor: false
      success: (resp) ->
        if resp.status == 'OK'
          obj = resp.results[0].address_components
          adrSize = obj.length - 1
          switch cb
            when true
              # コールバック関数があるとき
              respObj = {}
              respObj.pref = obj[adrSize - 1].long_name
              respObj.below = ''
              respObj.below = obj[adrSize - 2].long_name
              callback respObj
            when false
              # コールバック無し
              tmp = ''
              i = adrSize - 1
              while i > 0
                tmp += obj[i].long_name
                i--
              target.val tmp
            else
              return false
        else
          return false
        return
    return

  return
) jQuery

$ ->
  $('input[name=\'profile[zipcode]\']').blur ->
    $.fn.zip2adr $(this).val(), (resp) ->
      $('input[name=\'profile[prefecture]\']').val resp.pref
      $('input[name=\'profile[municipality]\']').val resp.below
      return
    return
  return

$ ->
  #balloon for languages
  $('.balloon').balloon()

  #tag cloud
  $(document).on 'click', '.tag_cloud', (event)->
    event.preventDefault()
    $('#profile_tag_list').tagsinput('add', $(this).text())

  #Draw RadarChart
  if $('body').hasClass('profiles show')
    array_keywords = gon.keywords
    if array_keywords.length != 0
      keywords = []
      rates = []

      $.each array_keywords, (index, data) ->
        keywords.push data.keyword
        rates.push data.level
        return

      $('#canvas').Radarchart(keywords, rates)

  if $('body').hasClass('profile_keywords new') || $('body').hasClass('profile_keywords edit') || $('body').hasClass('profile_keywords update') || $('body').hasClass('profile_keywords create')
    elemTarget = ''
    keywords = []
    rates = []

    setKeyword = ->
      keywords = new Array()
      rates = new Array()

      keyword1 = $("input[name='profile_keyword_collection[profile_keywords_attributes][0][keyword]']").val();
      keyword2 = $("input[name='profile_keyword_collection[profile_keywords_attributes][1][keyword]']").val();
      keyword3 = $("input[name='profile_keyword_collection[profile_keywords_attributes][2][keyword]']").val();
      keyword4 = $("input[name='profile_keyword_collection[profile_keywords_attributes][3][keyword]']").val();
      keyword5 = $("input[name='profile_keyword_collection[profile_keywords_attributes][4][keyword]']").val();

      rate1 = $("[name='profile_keyword_collection[profile_keywords_attributes][0][level]']").val();
      rate2 = $("[name='profile_keyword_collection[profile_keywords_attributes][1][level]']").val();
      rate3 = $("[name='profile_keyword_collection[profile_keywords_attributes][2][level]']").val();
      rate4 = $("[name='profile_keyword_collection[profile_keywords_attributes][3][level]']").val();
      rate5 = $("[name='profile_keyword_collection[profile_keywords_attributes][4][level]']").val();

      keywords.push keyword1, keyword2, keyword3, keyword4, keyword5
      rates.push rate1, rate2, rate3, rate4, rate5

    addKeyword = (target) ->
      keywords = target.val().split(',')
      lastindex = keywords.length - 1
      if keywords.length > 1
        $.each keywords, (index, keyword) ->
          if index == lastindex
            target.tagsinput('add', keyword)
          else
            target.tagsinput('remove', keyword)


    setKeyword()
    $('#canvas').Radarchart(keywords, rates)

    $('.select-level').on 'change', ->
      setKeyword()
      $('#canvas').Radarchart(keywords, rates)
      return

    $('.text-keyword').on 'change', ->
      setKeyword()
      $('#canvas').Radarchart(keywords, rates)
      return

    $('.tag_cloud').on 'click', (event)->
      event.preventDefault()
      if elemTarget == ''
        $('#tagcloud_target_confirm').modal()
      else
        tag = elemTarget.val()
        elemTarget.tagsinput('remove', tag)
        elemTarget.tagsinput('add', $(this).text())
        elemTarget = ''

    $('.text-keyword-wrapper').on 'click', (event)->
      switch $('.text-keyword-wrapper').index($(this))
        when 0
          elemTarget = $('#profile_keyword_collection_profile_keywords_attributes_0_keyword')
        when 1
          elemTarget = $('#profile_keyword_collection_profile_keywords_attributes_1_keyword')
        when 2
          elemTarget = $('#profile_keyword_collection_profile_keywords_attributes_2_keyword')
        when 3
          elemTarget = $('#profile_keyword_collection_profile_keywords_attributes_3_keyword')
        when 4
          elemTarget = $('#profile_keyword_collection_profile_keywords_attributes_4_keyword')
        else
          elemTarget = ''
          break
      return

    $('#profile_keyword_collection_profile_keywords_attributes_0_keyword').on 'change', (event) ->
      addKeyword($(this))
      event.preventDefault()

    $('#profile_keyword_collection_profile_keywords_attributes_1_keyword').on 'change', (event) ->
      addKeyword($(this))
      event.preventDefault()

    $('#profile_keyword_collection_profile_keywords_attributes_2_keyword').on 'change', (event) ->
      addKeyword($(this))
      event.preventDefault()

    $('#profile_keyword_collection_profile_keywords_attributes_3_keyword').on 'change', (event) ->
      addKeyword($(this))
      event.preventDefault()

    $('#profile_keyword_collection_profile_keywords_attributes_4_keyword').on 'change', (event) ->
      addKeyword($(this))
      event.preventDefault()
