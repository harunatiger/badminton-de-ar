function hasClass(element, className) {
    return (' ' + element.className + ' ').replace(/[\n\t]/g, ' ').indexOf(' ' + className + ' ') !== -1;
}

function displayChamo() {
  client = $('.client').css('content');
  desktop = (client == undefined || client == '');
  if((!hasClass(document.body, 'dashboard') && !hasClass(document.body, 'message_threads') && !hasClass(document.body, 'manage') && !hasClass(document.body, 'new') && !hasClass(document.body, 'create') && !hasClass(document.body, 'update') && !hasClass(document.body, 'edit') && !hasClass(document.body, 'listings') && !hasClass(document.body, 'listing_details') && !hasClass(document.body, 'calendar') && !hasClass(document.body, 'favorite_listings') && !hasClass(document.body, 'favorite_users') && !hasClass(document.body, 'friends') && !hasClass(document.body, 'profiles') && !hasClass(document.body, 'withdraw')) || (desktop && (!hasClass(document.body, 'message_threads show') && hasClass(document.body, 'show'))) || hasClass(document.body, 'sessions') || hasClass(document.body, 'registrations new') || hasClass(document.body, 'registrations create') || hasClass(document.body, 'passwords')){
    return true;
  }else{
    return false;
  };
}

if(displayChamo()){
  var _chaq = _chaq || [];
  _chaq['_accountID']=2079;
  (function(D,s){
      var ca = D.createElement(s)
      ,ss = D.getElementsByTagName(s)[0];
      ca.type = 'text/javascript';
      ca.async = !0;
      ca.setAttribute('charset','utf-8');
      var sr = 'https://v1.chamo-chat.com/chamovps.js';
      ca.src = sr + '?' + parseInt((new Date)/60000);
      ss.parentNode.insertBefore(ca, ss);
  })(document,'script');
}

