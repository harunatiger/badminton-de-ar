$ ->
  if $('body').hasClass('friends index')
    $("#not_friends_list").hide()
    $(document).on 'change', '#search_friends_or_not', ->
      if $("#search_friends_or_not").val() == 'friends'
        $("#not_friends_list").hide()
        $("#friends_list").show()
      else
        $("#not_friends_list").show()
        $("#friends_list").hide()
      return

    #$(document).on 'change', '#search_keyword', ->
    #  $('#friends_search').submit()
    #  return

    test = ($search_box) ->
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

    hoge = new test($('#search_keyword'))
