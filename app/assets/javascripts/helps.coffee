# help_topics
$ ->
  if $('body').hasClass('help_topics for_user') || $('body').hasClass('help_topics for_guide')
    getScrollTarget = (href) ->
      hrefSplit = href.split(/#/)
      target = $('#' + hrefSplit[1])
      position = target.offset().top - 40
      $('body,html').animate(scrollTop:position)
      return false

    setNavScroll = () ->
      navi = $('.help_categories')
      main = $('#help_content')
      navi_parent = $('#help-nav')
      navi_parent.css
        position: 'relative'
        top: '0px'
      footerHeight = $('footer').height() + 100
      target_top = navi.offset().top - parseInt(navi.css('margin-top'), 10)
      sub_top = main.offset().top - parseInt(main.css('margin-top'), 10)
      if navi.outerHeight(true) + target_top < main.outerHeight(true) + sub_top
        $(window).scroll ->
          ws = $(window).scrollTop()
          sub_scroll = main.offset().top + main.outerHeight(true) - navi.outerHeight(true) - parseInt(navi.css('margin-top'), 30)
          if ws > sub_scroll
            navi_parent.css
              position: 'fixed'
              top: sub_scroll - (ws + footerHeight) + 'px'
          else if ws > target_top
            navi_parent.css
              position: 'fixed'
              top: '10px'
          else
            navi_parent.css
              position: 'relative'
              top: '0px'
          return
      return

    if $('#help-nav').css('display') == 'block'
      setNavScroll()

      $('a.help_page_link').on 'click', (e) ->
        setNavScroll()

      $('li.help-category-item.anchor-scroll a').each ->
        $(this).on 'click', (e) ->
          $('li.help-category-item a').removeClass('nav-active')
          $(this).addClass('nav-active')
          if !$(this).parent().hasClass('help-category-item-children')
            $('.collapse.in').collapse('hide')
          getScrollTarget($(this).attr('href'))

      $('li.help-category-item .parent-category a').each ->
        $(this).on 'click', (e) ->
          $('li.help-category-item a').removeClass('nav-active')
          $(this).addClass('nav-active')
          $('.collapse.in').collapse('hide')
          child_first_elem = $(this).parent().next().find('li.help-category-item-children:first').children('a')
          if child_first_elem.length != -1
            child_first_elem.addClass('nav-active')

          if $(this).parent().next().hasClass('collapse in')
            $(this).parent().next().collapse('hide')
          else
            $(this).parent().next().collapse('show')
            $(this).parent().next().css('padding-left','30px')

          getScrollTarget($(this).attr('href'))

      $('li.help-category-item-children.anchor-scroll a').each ->
        $(this).on 'click', (e) ->
          $('li.help-category-item a').removeClass('nav-active')
          $(this).addClass('nav-active')
          $(this).parent().parent().prev('.parent-category').find('a').addClass('nav-active')
          getScrollTarget($(this).attr('href'))


    else if $('#help-nav-sp').css('display') == 'block'
      #return top button
      top_button = $('.return-top')
      navi_sp = $('#help-nav-sp')
      navi_top = navi_sp.offset().top
      footerHeight = $('footer').height() + 150
      $(window).scroll ->
        ws = $(window).scrollTop()
        scrollHeight = $(document).height()
        scrollPosition = $(window).height() + ws
        if ws > navi_top
          top_button.removeClass('hide')
          if scrollHeight - scrollPosition < footerHeight
            top_button.css
              bottom: footerHeight
          else
            top_button.css
              bottom: '50px'
        else
          top_button.addClass('hide')

      top_button.on 'click', (e) ->
        $('body,html').animate(scrollTop: 0)

      $('li.help-category-item.anchor-scroll a').each ->
        $(this).on 'click', (e) ->
          $('li.help-category-item a').removeClass('nav-active')
          $(this).addClass('nav-active')
          if !$(this).parent().hasClass('help-category-item-children')
            $('.collapse.in').collapse('hide')
          getScrollTarget($(this).attr('href'))

      $('li.help-category-item .parent-category a').each ->
        $(this).on 'click', (e) ->
          $('li.help-category-item a').removeClass('nav-active')
          $(this).addClass('nav-active')
          $('.collapse.in').collapse('hide')

          if $(this).parent().next().hasClass('collapse in')
            $(this).parent().next().collapse('hide')
          else
            $(this).parent().next().collapse('show')
            $(this).parent().next().css('padding-left','30px')
          return false

      $('li.help-category-item-children.anchor-scroll a').each ->
        $(this).on 'click', (e) ->
          $('li.help-category-item a').removeClass('nav-active')
          $(this).addClass('nav-active')
          getScrollTarget($(this).attr('href'))
