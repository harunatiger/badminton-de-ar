$ ->
  if $('body').hasClass('friends')
    $("#not_friends_list").hide()
    $(document).on 'change', '#search_friends_or_not', ->
      if $("#search_friends_or_not").val() == 'friends'
        $("#not_friends_list").hide()
        $("#friends_list").show()
      else
        $("#not_friends_list").show()
        $("#friends_list").hide()
      return

    #modal for friends request message
    guide_index = 0
    $(document).on 'click', '.message_to_pair_guide_link', ->
      guide_index = $('.message_to_pair_guide_link').index(this)
      $('[id=message_to_pair_guide]').eq(guide_index).modal(
        backdrop: 'static'
      )
      return false

    #search guide
    search = ($search_box) ->
      me = this
      @$oj = $search_box
      @keyup_stack = []
      @bindShowCand = ->
        me.$oj.keyup ->
          me.keyup_stack.push 1
          setTimeout ((me_) ->
            ->
              me_.keyup_stack.pop()
              if me_.keyup_stack.length == 0
                me_.showCandidate()
              return
          )(me), 1000
          return
        return

      @showCandidate = ->
        $('#friends_search').submit()
        return

      me.bindShowCand()
      return
    result = new search($('#search_keyword'))

    #select guide
    guide_index = 0
    $(document).on 'click', '.select_friend_link', ->
      guide_index = $('.select_friend_link').index(this)
      $.ajax(
        type: 'POST'
        url: '/friends/set_selected_guides'
        data: {
          guide_id: $('[id=guide_id]').eq(guide_index).val()
        }
      ).done (result) ->
        if result == 'deleted'
          $('[id=select_friend_link]').eq(guide_index).text '候補にする'
          $('[id=select_friend_link]').eq(guide_index).removeClass 'btn-primary'
          $('[id=select_friend_link]').eq(guide_index).addClass 'btn-default'
        else if result == 'added'
          $('[id=select_friend_link]').eq(guide_index).text '選択中'
          $('[id=select_friend_link]').eq(guide_index).removeClass 'btn-default'
          $('[id=select_friend_link]').eq(guide_index).addClass 'btn-primary'
        else
          alert '1度に選択できるユーザは5名までです'
      return false