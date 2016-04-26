#profiles.coffee
(($) ->

  $.fn.zip2adr = (zip, callback) ->
    cb = if arguments.length > 1 then true else false
    if zip == ''
      return false
    target = $(this)
    $.ajax
      type: 'get'
      url: 'https://maps.googleapis.com/maps/api/geocode/json'
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
  #Favorite ON/OFF
  if $('body').hasClass('favorite_listings index') || $('body').hasClass('favorite_users index')
    $('a.favorite-btn').each (index) ->
      $(this).on 'click' , ->
        ret = confirm('お気に入りを解除します。よろしいですか？')
    $('a.favorite-btn-large').each (index) ->
      $(this).on 'click' , ->
        ret = confirm('お気に入りを解除します。よろしいですか？')
  else
    $('.favorite-btn').each (index) ->
      #balloon for favorites
      if $(window).width() >= 768
        $(this).find('.fav-balloon').balloon(
          contents: 'add to your favorites',
          css:
            border: 'none',
            padding: '8px',
            fontSize: '13px',
            fontWeight: 'bold',
            lineHeight: '1.55',
            backgroundColor: 'rgba(0, 0, 0, .75)',
            borderRadius: '2px'
            color: 'white'
            boxShadow: 'none'
        )
      else
        $(this).on 'click', ->
          if !$(this).find('.fav-balloon').hasClass('hide')
            $(this).find('.fav-balloon').showBalloon(
              contents: 'add to your favorites',
              hideDuration: 1000,
              css:
                border: 'none',
                padding: '8px',
                fontSize: '13px',
                fontWeight: 'bold',
                lineHeight: '1.55',
                backgroundColor: 'rgba(0, 0, 0, .75)',
                borderRadius: '2px'
                color: 'white'
                boxShadow: 'none'
            )

      $(this).find('i.outline').hover (->
        $(this).prev().addClass 'unfavorite-o'
        ), ->
        $(this).prev().removeClass 'unfavorite-o'
      $(this).on 'ajax:complete',  (event, ajax, status) ->
        if status == 'success'
          if ajax.responseJSON.post == 'create'
            $(this).find('i.favorited').removeClass 'hide'
            $(this).find('i.unfavorite').addClass 'hide'
            $(this).find('i.outline').addClass 'hide'
            if $(window).width() < 768
              window.setTimeout (->
                $('body').find('.fav-balloon').showBalloon().hideBalloon()
              ), 1000
          else if ajax.responseJSON.post == 'delete'
            $(this).find('i.favorited').addClass 'hide'
            $(this).find('i.unfavorite').removeClass 'hide'
            $(this).find('i.outline').removeClass 'hide'
          count = ajax.responseJSON.count
          $(this).find('span.favorited-count').text(count)

  #balloon for languages
  if $('html').hasClass('no-touch')
    $('.balloon').balloon(
      css:
        border: 'none',
        padding: '8px',
        fontSize: '13px',
        fontWeight: 'bold',
        lineHeight: '1.55',
        backgroundColor: 'rgba(0, 0, 0, .75)',
        borderRadius: '2px'
        color: 'white'
        boxShadow: 'none'
    )

  #tag cloud
  #$(document).on 'click', '.tag_cloud', (event)->
  #  event.preventDefault()
  #  $('#profile_tag_list').tagsinput('add', $(this).text())

  #$(document).on 'keydown', '.bootstrap-tagsinput input', (event) ->
  #  if event.keyCode == 13
  #    event.preventDefault()
  #    $('.bootstrap-tagsinput input').blur()
  #    $('.bootstrap-tagsinput input').focus()

  #Draw RadarChart
  #if $('body').hasClass('profiles show')
  #  array_keywords = gon.keywords
  #  if array_keywords.length != 0
  #    keywords = []
  #    rates = []

  #    $.each array_keywords, (index, data) ->
  #      keywords.push data.keyword
  #      rates.push data.level
  #      return

  #    $('#canvas').Radarchart(keywords, rates)

  #if $('body').hasClass('profile_keywords new') || $('body').hasClass('profile_keywords edit') || $('body').hasClass('profile_keywords update') || $('body').hasClass('profile_keywords create')
  #  elemTarget = ''
  #  keywords = []
  #  rates = []

  #  setKeyword = ->
  #    keywords = new Array()
  #    rates = new Array()

  #    keyword1 = $("input[name='profile_keyword_collection[profile_keywords_attributes][0][keyword]']").val();
  #    keyword2 = $("input[name='profile_keyword_collection[profile_keywords_attributes][1][keyword]']").val();
  #    keyword3 = $("input[name='profile_keyword_collection[profile_keywords_attributes][2][keyword]']").val();
  #    keyword4 = $("input[name='profile_keyword_collection[profile_keywords_attributes][3][keyword]']").val();
  #    keyword5 = $("input[name='profile_keyword_collection[profile_keywords_attributes][4][keyword]']").val();

  #    rate1 = $("[name='profile_keyword_collection[profile_keywords_attributes][0][level]']").val();
  #    rate2 = $("[name='profile_keyword_collection[profile_keywords_attributes][1][level]']").val();
  #    rate3 = $("[name='profile_keyword_collection[profile_keywords_attributes][2][level]']").val();
  #    rate4 = $("[name='profile_keyword_collection[profile_keywords_attributes][3][level]']").val();
  #    rate5 = $("[name='profile_keyword_collection[profile_keywords_attributes][4][level]']").val();

  #    keywords.push keyword1, keyword2, keyword3, keyword4, keyword5
  #    rates.push rate1, rate2, rate3, rate4, rate5

  #  addKeyword = (target) ->
  #    keywords = target.val().split(',')
  #    lastindex = keywords.length - 1
  #    if keywords.length > 1
  #      $.each keywords, (index, keyword) ->
  #        if index == lastindex
  #          target.tagsinput('add', keyword)
  #        else
  #          target.tagsinput('remove', keyword)


  #  setKeyword()
  #  $('#canvas').Radarchart(keywords, rates)

  #  $('.select-level').on 'change', ->
  #    setKeyword()
  #    $('#canvas').Radarchart(keywords, rates)
  #    return

  #  $('.text-keyword').on 'change', ->
  #    setKeyword()
  #    $('#canvas').Radarchart(keywords, rates)
  #    return

  #  $('.tag_cloud').on 'click', (event)->
  #    event.preventDefault()
  #    if elemTarget == ''
  #      $('#tagcloud_target_confirm').modal()
  #    else
  #      tag = elemTarget.val()
  #      elemTarget.tagsinput('remove', tag)
  #      elemTarget.tagsinput('add', $(this).text())
  #      elemTarget = ''

  #  $('.text-keyword-wrapper').on 'click', (event)->
  #    switch $('.text-keyword-wrapper').index($(this))
  #      when 0
  #        elemTarget = $('#profile_keyword_collection_profile_keywords_attributes_0_keyword')
  #      when 1
  #        elemTarget = $('#profile_keyword_collection_profile_keywords_attributes_1_keyword')
  #      when 2
  #        elemTarget = $('#profile_keyword_collection_profile_keywords_attributes_2_keyword')
  #      when 3
  #        elemTarget = $('#profile_keyword_collection_profile_keywords_attributes_3_keyword')
  #      when 4
  #        elemTarget = $('#profile_keyword_collection_profile_keywords_attributes_4_keyword')
  #      else
  #        elemTarget = ''
  #        break
  #    return

    #$('#profile_keyword_collection_profile_keywords_attributes_0_keyword').on 'change', (event) ->
    #  addKeyword($(this))
    #  event.preventDefault()

    #$('#profile_keyword_collection_profile_keywords_attributes_1_keyword').on 'change', (event) ->
    #  addKeyword($(this))
    #  event.preventDefault()

    #$('#profile_keyword_collection_profile_keywords_attributes_2_keyword').on 'change', (event) ->
    #  addKeyword($(this))
    #  event.preventDefault()

    #$('#profile_keyword_collection_profile_keywords_attributes_3_keyword').on 'change', (event) ->
    #  addKeyword($(this))
    #  event.preventDefault()

    #$('#profile_keyword_collection_profile_keywords_attributes_4_keyword').on 'change', (event) ->
    #  addKeyword($(this))
    #  event.preventDefault()

  $(document).on 'keydown', '.bootstrap-tagsinput input', (event) ->
    if event.keyCode == 13
      event.preventDefault()
      $('.bootstrap-tagsinput input').blur()
      $(this).focus()

  $('.profile-face .item img').each (index) ->
    baseWidth = 273
    baseHeight = 320
    img = new Image()
    img.src = $(this).attr('src')
    width = img.width
    height = img.height
    if height > width
      calcHeight = height * (baseWidth / width)
      if calcHeight > 320
        ih = (calcHeight - 320) / 2
        $(this).css("top", "-"+ih+"px")

  $(document).on 'click', '.select_category_link', (event) ->
    selected = $("input[name*='[tag_list]']")
    array_index = selected.length + 1
    category_index = $('.select_category_link').index(this)
    category_id = $('.select_category_link').eq(category_index).attr("category_id")

    if $('.select_category_link').eq(category_index).hasClass('listing_image_selected')
      user_id = $('#profile_user_id').val()

      if confirm('Are you sure you want to delete this category?')
        $.ajax
          type: 'DELETE'
          url: '/profiles/delete_category'
          data: {category_id: category_id, user_id: user_id}
          success: (data) ->
            $('.select_category_link').eq(category_index).children("i").remove()
            $('.select_category_link').eq(category_index).removeClass 'listing_image_selected'
            $("[class='" + category_id + "']").empty()
            return false
          error: ->
            return false
    else if selected.length == 3
        alert 'You can register a maximum of 3 categories.'
    else
      $('.select_category_link').eq(category_index).append("<i class='fa fa-check'></i>")
      $('.select_category_link').eq(category_index).addClass 'listing_image_selected'

      img_src = $('.select_category_link').eq(category_index).children("img").attr("src")
      tag_list_id = 'tag_list_' + category_id
      placeholder = $('.select_category_link').eq(category_index).attr("placehodler_str")

      $("<div class='" + category_id + "'><img src=" + img_src + " /><input type='hidden' value='" + category_id + "' name='profile[profile_categories_attributes][" + array_index + "][category_id]'/><input value='' data-role='tagsinput' class='string optional form-control' placeholder='" + placeholder + "' type='text' name='profile[profile_categories_attributes][" + array_index + "][tag_list]' id='" + tag_list_id + "'/></div>").insertBefore(".input_categories_space_end")

      $("#" + tag_list_id).tagsinput('refresh')
    return false

  # self_introduction
  if $('body').hasClass('profiles self_introduction')

    # placeholder attr
    placeholder = 'Eg.) Hello, my name is Suzuki.\nI’m a university student, and I live in a town called Kamakura, about an hour away from Tokyo.\nKamakura is famous for the “Daibutsu,” or “Great Buddha,” but I think the real appeal is the traditional Japanese food full of natural goodness, such as fresh vegetables and fish.  I like eating, and I am good at cooking.  One day, I’d like to make my own restaurant abroad to spread the appeal of Japanese food, so I’m studying hard at learning English.\nI’d love to introduce you to some amazing restaurants that aren’t listed in guidebooks.Feel free to message me any time about Japanese food! Let’s be friends!'
    if $('.self_introduction-textarea').val() == ''
      $(this).val(placeholder)
    $('.self_introduction-textarea').focus ->
      if $(this).val() == placeholder
        $(this).val('')
      return
    $('.self_introduction-textarea').blur ->
      if $(this).val() == ''
        $(this).val(placeholder)
      return

    $('.simple_form').on 'submit', ->
      if $('.self_introduction-textarea').val() == placeholder
        $('.self_introduction-textarea').val('')

    # sticky sp nav
    if $('.col-lg-3').css('float') != 'left'
      stickyNav = ->
        scrollTop = $(window).scrollTop()

        if scrollTop >= 47
          $('.sidenav-list-profile').addClass('fixed')
          $('.sidenav-list-profile-dummy').show()
        else
          $('.sidenav-list-profile').removeClass('fixed')
          $('.sidenav-list-profile-dummy').hide()
        return

      stickyNav()

      $(window).scroll ->
        stickyNav()
        return

      timer = false
      $(window).resize ->
        if timer != false
          clearTimeout timer
        timer = setTimeout((->
          stickyNav()
          return
        ), 200)
        return
