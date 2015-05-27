(function (factory) { 
if (typeof define === 'function' && define.amd) { 
 // AMD. Register as an anonymous module. 
 define(['jquery'], factory); 
 } else if (typeof exports === 'object') { 
 // Node/CommonJS 
 factory(require('jquery')); 
 } else { 
 // Browser globals 
 factory(window.jQuery || window.Zepto); 
 } 
 }(function($) { 

/**
 * Private static constants
 */
var CLOSE_EVENT = 'Close',
	BEFORE_CLOSE_EVENT = 'BeforeClose',
	AFTER_CLOSE_EVENT = 'AfterClose',
	BEFORE_APPEND_EVENT = 'BeforeAppend',
	MARKUP_PARSE_EVENT = 'MarkupParse',
	OPEN_EVENT = 'Open',
	CHANGE_EVENT = 'Change',
	NS = 'sldr',
	EVENT_NS = '.' + NS,
	READY_CLASS = 'sldr-ready',
	REMOVING_CLASS = 'sldr-removing',
	PREVENT_CLOSE_CLASS = 'sldr-prevent-close';


/**
 * Private vars 
 */
var sldr,
	ModalSlider = function(){},
	_isJQ = !!(window.jQuery),
	_prevStatus,
	_window = $(window),
	_document,
	_prevContentType,
	_wrapClasses,
	_currPopupType;


/**
 * Private functions
 */
var _sldrOn = function(name, f) {
		sldr.ev.on(NS + name + EVENT_NS, f);
	},
	_getEl = function(className, appendTo, html, raw) {
		var el = document.createElement('div');
		el.className = 'sldr-'+className;
		if(html) {
			el.innerHTML = html;
		}
		if(!raw) {
			el = $(el);
			if(appendTo) {
				el.appendTo(appendTo);
			}
		} else if(appendTo) {
			appendTo.appendChild(el);
		}
		return el;
	},
	_sldrTrigger = function(e, data) {
		sldr.ev.triggerHandler(NS + e, data);

		if(sldr.st.callbacks) {
			// converts "sldrEventName" to "eventName" callback and triggers it if it's present
			e = e.charAt(0).toLowerCase() + e.slice(1);
			if(sldr.st.callbacks[e]) {
				sldr.st.callbacks[e].apply(sldr, $.isArray(data) ? data : [data]);
			}
		}
	},
	_getCloseBtn = function(type) {
		if(type !== _currPopupType || !sldr.currTemplate.closeBtn) {
			sldr.currTemplate.closeBtn = $( sldr.st.closeMarkup.replace('%title%', sldr.st.tClose ) );
			_currPopupType = type;
		}
		return sldr.currTemplate.closeBtn;
	},
	// Initialize Modal Slider only when called at least once
	_checkInstance = function() {
		if(!$.modalSlider.instance) {
			/*jshint -W020 */
			sldr = new ModalSlider();
			sldr.init();
			$.modalSlider.instance = sldr;
		}
	},
	// CSS transition detection, http://stackoverflow.com/questions/7264899/detect-css-transitions-using-javascript-and-without-modernizr
	supportsTransitions = function() {
		var s = document.createElement('p').style, // 's' for style. better to create an element if body yet to exist
			v = ['ms','O','Moz','Webkit']; // 'v' for vendor

		if( s['transition'] !== undefined ) {
			return true; 
		}
			
		while( v.length ) {
			if( v.pop() + 'Transition' in s ) {
				return true;
			}
		}
				
		return false;
	};



/**
 * Public functions
 */
ModalSlider.prototype = {

	constructor: ModalSlider,

	/**
	 * Initializes Modal Slider plugin. 
	 * This function is triggered only once when $.fn.modalSlider or $.modalSlider is executed
	 */
	init: function() {
		var appVersion = navigator.appVersion;
		sldr.isIE7 = appVersion.indexOf("MSIE 7.") !== -1; 
		sldr.isIE8 = appVersion.indexOf("MSIE 8.") !== -1;
		sldr.isLowIE = sldr.isIE7 || sldr.isIE8;
		sldr.isAndroid = (/android/gi).test(appVersion);
		sldr.isIOS = (/iphone|ipad|ipod/gi).test(appVersion);
		sldr.supportsTransition = supportsTransitions();

		// We disable fixed positioned lightbox on devices that don't handle it nicely.
		// If you know a better way of detecting this - let me know.
		sldr.probablyMobile = (sldr.isAndroid || sldr.isIOS || /(Opera Mini)|Kindle|webOS|BlackBerry|(Opera Mobi)|(Windows Phone)|IEMobile/i.test(navigator.userAgent) );
		_document = $(document);

		sldr.popupsCache = {};
	},

	/**
	 * Opens popup
	 * @param  data [description]
	 */
	open: function(data) {

		var i;

		if(data.isObj === false) { 
			// convert jQuery collection to array to avoid conflicts later
			sldr.items = data.items.toArray();

			sldr.index = 0;
			var items = data.items,
				item;
			for(i = 0; i < items.length; i++) {
				item = items[i];
				if(item.parsed) {
					item = item.el[0];
				}
				if(item === data.el[0]) {
					sldr.index = i;
					break;
				}
			}
		} else {
			sldr.items = $.isArray(data.items) ? data.items : [data.items];
			sldr.index = data.index || 0;
		}

		// if popup is already opened - we just update the content
		if(sldr.isOpen) {
			sldr.updateItemHTML();
			return;
		}
		
		sldr.types = []; 
		_wrapClasses = '';
		if(data.mainEl && data.mainEl.length) {
			sldr.ev = data.mainEl.eq(0);
		} else {
			sldr.ev = _document;
		}

		if(data.key) {
			if(!sldr.popupsCache[data.key]) {
				sldr.popupsCache[data.key] = {};
			}
			sldr.currTemplate = sldr.popupsCache[data.key];
		} else {
			sldr.currTemplate = {};
		}



		sldr.st = $.extend(true, {}, $.modalSlider.defaults, data ); 
		sldr.fixedContentPos = sldr.st.fixedContentPos === 'auto' ? !sldr.probablyMobile : sldr.st.fixedContentPos;

		if(sldr.st.modal) {
			sldr.st.closeOnContentClick = false;
			sldr.st.closeOnBgClick = false;
			sldr.st.showCloseBtn = false;
			sldr.st.enableEscapeKey = false;
		}
		

		// Building markup
		// main containers are created only once
		if(!sldr.bgOverlay) {

			// Dark overlay
			sldr.bgOverlay = _getEl('bg').on('click'+EVENT_NS, function() {
				sldr.close();
			});

			sldr.wrap = _getEl('wrap').attr('tabindex', -1).on('click'+EVENT_NS, function(e) {
				if(sldr._checkIfClose(e.target)) {
					sldr.close();
				}
			});

			sldr.container = _getEl('container', sldr.wrap);
		}

		sldr.contentContainer = _getEl('content');
		if(sldr.st.preloader) {
			sldr.preloader = _getEl('preloader', sldr.container, sldr.st.tLoading);
		}


		// Initializing modules
		var modules = $.modalSlider.modules;
		for(i = 0; i < modules.length; i++) {
			var n = modules[i];
			n = n.charAt(0).toUpperCase() + n.slice(1);
			sldr['init'+n].call(sldr);
		}
		_sldrTrigger('BeforeOpen');


		if(sldr.st.showCloseBtn) {
			// Close button
			if(!sldr.st.closeBtnInside) {
				sldr.wrap.append( _getCloseBtn() );
			} else {
				_sldrOn(MARKUP_PARSE_EVENT, function(e, template, values, item) {
					values.close_replaceWith = _getCloseBtn(item.type);
				});
				_wrapClasses += ' sldr-close-btn-in';
			}
		}

		if(sldr.st.alignTop) {
			_wrapClasses += ' sldr-align-top';
		}

	

		if(sldr.fixedContentPos) {
			sldr.wrap.css({
				overflow: sldr.st.overflowY,
				overflowX: 'hidden',
				overflowY: sldr.st.overflowY
			});
		} else {
			sldr.wrap.css({ 
				top: _window.scrollTop(),
				position: 'absolute'
			});
		}
		if( sldr.st.fixedBgPos === false || (sldr.st.fixedBgPos === 'auto' && !sldr.fixedContentPos) ) {
			sldr.bgOverlay.css({
				height: _document.height(),
				position: 'absolute'
			});
		}

		

		if(sldr.st.enableEscapeKey) {
			// Close on ESC key
			_document.on('keyup' + EVENT_NS, function(e) {
				if(e.keyCode === 27) {
					sldr.close();
				}
			});
		}

		_window.on('resize' + EVENT_NS, function() {
			sldr.updateSize();
		});


		if(!sldr.st.closeOnContentClick) {
			_wrapClasses += ' sldr-auto-cursor';
		}
		
		if(_wrapClasses)
			sldr.wrap.addClass(_wrapClasses);


		// this triggers recalculation of layout, so we get it once to not to trigger twice
		var windowHeight = sldr.wH = _window.height();

		
		var windowStyles = {};

		if( sldr.fixedContentPos ) {
            if(sldr._hasScrollBar(windowHeight)){
                var s = sldr._getScrollbarSize();
                if(s) {
                    windowStyles.marginRight = s;
                }
            }
        }

		if(sldr.fixedContentPos) {
			if(!sldr.isIE7) {
				windowStyles.overflow = 'hidden';
			} else {
				// ie7 double-scroll bug
				$('body, html').css('overflow', 'hidden');
			}
		}

		
		
		var classesToadd = sldr.st.mainClass;
		if(sldr.isIE7) {
			classesToadd += ' sldr-ie7';
		}
		if(classesToadd) {
			sldr._addClassTosldr( classesToadd );
		}

		// add content
		sldr.updateItemHTML();

		_sldrTrigger('BuildControls');

		// remove scrollbar, add margin e.t.c
		$('html').css(windowStyles);
		
		// add everything to DOM
		sldr.bgOverlay.add(sldr.wrap).prependTo( sldr.st.prependTo || $(document.body) );

		// Save last focused element
		sldr._lastFocusedEl = document.activeElement;
		
		// Wait for next cycle to allow CSS transition
		setTimeout(function() {
			
			if(sldr.content) {
				sldr._addClassTosldr(READY_CLASS);
				sldr._setFocus();
			} else {
				// if content is not defined (not loaded e.t.c) we add class only for BG
				sldr.bgOverlay.addClass(READY_CLASS);
			}
			
			// Trap the focus in popup
			_document.on('focusin' + EVENT_NS, sldr._onFocusIn);

		}, 16);

		sldr.isOpen = true;
		sldr.updateSize(windowHeight);
		_sldrTrigger(OPEN_EVENT);

		return data;
	},

	/**
	 * Closes the popup
	 */
	close: function() {
		if(!sldr.isOpen) return;
		_sldrTrigger(BEFORE_CLOSE_EVENT);

		sldr.isOpen = false;
		// for CSS3 animation
		if(sldr.st.removalDelay && !sldr.isLowIE && sldr.supportsTransition )  {
			sldr._addClassTosldr(REMOVING_CLASS);
			setTimeout(function() {
				sldr._close();
			}, sldr.st.removalDelay);
		} else {
			sldr._close();
		}
	},

	/**
	 * Helper for close() function
	 */
	_close: function() {
		_sldrTrigger(CLOSE_EVENT);

		var classesToRemove = REMOVING_CLASS + ' ' + READY_CLASS + ' ';

		sldr.bgOverlay.detach();
		sldr.wrap.detach();
		sldr.container.empty();

		if(sldr.st.mainClass) {
			classesToRemove += sldr.st.mainClass + ' ';
		}

		sldr._removeClassFromsldr(classesToRemove);

		if(sldr.fixedContentPos) {
			var windowStyles = {marginRight: ''};
			if(sldr.isIE7) {
				$('body, html').css('overflow', '');
			} else {
				windowStyles.overflow = '';
			}
			$('html').css(windowStyles);
		}
		
		_document.off('keyup' + EVENT_NS + ' focusin' + EVENT_NS);
		sldr.ev.off(EVENT_NS);

		// clean up DOM elements that aren't removed
		sldr.wrap.attr('class', 'sldr-wrap').removeAttr('style');
		sldr.bgOverlay.attr('class', 'sldr-bg');
		sldr.container.attr('class', 'sldr-container');

		// remove close button from target element
		if(sldr.st.showCloseBtn &&
		(!sldr.st.closeBtnInside || sldr.currTemplate[sldr.currItem.type] === true)) {
			if(sldr.currTemplate.closeBtn)
				sldr.currTemplate.closeBtn.detach();
		}


		if(sldr._lastFocusedEl) {
			$(sldr._lastFocusedEl).focus(); // put tab focus back
		}
		sldr.currItem = null;	
		sldr.content = null;
		sldr.currTemplate = null;
		sldr.prevHeight = 0;

		_sldrTrigger(AFTER_CLOSE_EVENT);
	},
	
	updateSize: function(winHeight) {

		if(sldr.isIOS) {
			// fixes iOS nav bars https://github.com/dimsemenov/Modal-Slider/issues/2
			var zoomLevel = document.documentElement.clientWidth / window.innerWidth;
			var height = window.innerHeight * zoomLevel;
			sldr.wrap.css('height', height);
			sldr.wH = height;
		} else {
			sldr.wH = winHeight || _window.height();
		}
		// Fixes #84: popup incorrectly positioned with position:relative on body
		if(!sldr.fixedContentPos) {
			sldr.wrap.css('height', sldr.wH);
		}

		_sldrTrigger('Resize');

	},

	/**
	 * Set content of popup based on current index
	 */
	updateItemHTML: function() {
		var item = sldr.items[sldr.index];
		
		// Detach and perform modifications
		sldr.contentContainer.detach();

		if(sldr.content)
			sldr.content.detach();

		if(!item.parsed) {
			item = sldr.parseEl( sldr.index );
		}

		var type = item.type;	

		_sldrTrigger('BeforeChange', [sldr.currItem ? sldr.currItem.type : '', type]);
		// BeforeChange event works like so:
		// _sldrOn('BeforeChange', function(e, prevType, newType) { });
		
		sldr.currItem = item;

		

		

		if(!sldr.currTemplate[type]) {
			var markup = sldr.st[type] ? sldr.st[type].markup : false;

			// allows to modify markup
			_sldrTrigger('FirstMarkupParse', markup);

			if(markup) {
				sldr.currTemplate[type] = $(markup);
			} else {
				// if there is no markup found we just define that template is parsed
				sldr.currTemplate[type] = true;
			}
		}

		if(_prevContentType && _prevContentType !== item.type) {
			sldr.container.removeClass('sldr-'+_prevContentType+'-holder');
		}
		
		var newContent = sldr['get' + type.charAt(0).toUpperCase() + type.slice(1)](item, sldr.currTemplate[type]);
		sldr.appendContent(newContent, type);

		item.preloaded = true;

		_sldrTrigger(CHANGE_EVENT, item);
		_prevContentType = item.type;
		
		// Append container back after its content changed
		sldr.container.prepend(sldr.contentContainer);
		_sldrTrigger('AfterChange');
	},


	/**
	 * Set HTML content of popup
	 */
	appendContent: function(newContent, type) {
		sldr.content = newContent;

		if(newContent) {
			if(sldr.st.showCloseBtn && sldr.st.closeBtnInside &&
				sldr.currTemplate[type] === true) {
				// if there is no markup, we just append close button element inside
				if(!sldr.content.find('.sldr-close').length) {
					sldr.content.append(_getCloseBtn());
				}
			} else {
				sldr.content = newContent;
			}
		} else {
			sldr.content = '';
		}

		_sldrTrigger(BEFORE_APPEND_EVENT);
		sldr.container.addClass('sldr-'+type+'-holder');

		sldr.contentContainer.append(sldr.content);
	},



	
	/**
	 * Creates Modal Slider data object based on given data
	 * @param  {int} index Index of item to parse
	 */
	parseEl: function(index) {
		var item = sldr.items[index],
			type;

		if(item.tagName) {
			item = { el: $(item) };
		} else {
			type = item.type;
			item = { data: item, src: item.src };
		}

		if(item.el) {
			var types = sldr.types;

			// check for 'sldr-TYPE' class
			for(var i = 0; i < types.length; i++) {
				if( item.el.hasClass('sldr-'+types[i]) ) {
					type = types[i];
					break;
				}
			}

			item.src = item.el.attr('data-sldr-src');
			if(!item.src) {
				item.src = item.el.attr('href');
			}
		}

		item.type = type || sldr.st.type || 'inline';
		item.index = index;
		item.parsed = true;
		sldr.items[index] = item;
		_sldrTrigger('ElementParse', item);

		return sldr.items[index];
	},


	/**
	 * Initializes single popup or a group of popups
	 */
	addGroup: function(el, options) {

		thumbsArry = el;
		
		var eHandler = function(e) {
			e.sldrEl = this;
			sldr._openClick(e, el, options);
		};

		if(!options) {
			options = {};
		} 

		var eName = 'click.modalSlider';
		options.mainEl = el;

		if(options.items) {
			options.isObj = true;
			el.off(eName).on(eName, eHandler);
		} else {
			options.isObj = false;
			if(options.delegate) {
				el.off(eName).on(eName, options.delegate , eHandler);
			} else {
				options.items = el;
				$('.cover-img-container').off(eName).on(eName, eHandler);
			}
		}
	},
	_openClick: function(e, el, options) {
		var midClick = options.midClick !== undefined ? options.midClick : $.modalSlider.defaults.midClick;


		if(!midClick && ( e.which === 2 || e.ctrlKey || e.metaKey ) ) {
			return;
		}

		var disableOn = options.disableOn !== undefined ? options.disableOn : $.modalSlider.defaults.disableOn;

		if(disableOn) {
			if($.isFunction(disableOn)) {
				if( !disableOn.call(sldr) ) {
					return true;
				}
			} else { // else it's number
				if( _window.width() < disableOn ) {
					return true;
				}
			}
		}
		
		if(e.type) {
			e.preventDefault();

			// This will prevent popup from closing if element is inside and popup is already opened
			if(sldr.isOpen) {
				e.stopPropagation();
			}
		}
			

		options.el = $(e.sldrEl);
		if(options.delegate) {
			options.items = el.find(options.delegate);
		}
		sldr.open(options);
	},


	/**
	 * Updates text on preloader
	 */
	updateStatus: function(status, text) {

		if(sldr.preloader) {
			if(_prevStatus !== status) {
				sldr.container.removeClass('sldr-s-'+_prevStatus);
			}

			if(!text && status === 'loading') {
				text = sldr.st.tLoading;
			}

			var data = {
				status: status,
				text: text
			};
			// allows to modify status
			_sldrTrigger('UpdateStatus', data);

			status = data.status;
			text = data.text;

			sldr.preloader.html(text);

			sldr.preloader.find('a').on('click', function(e) {
				e.stopImmediatePropagation();
			});

			sldr.container.addClass('sldr-s-'+status);
			_prevStatus = status;
		}
	},


	/*
		"Private" helpers that aren't private at all
	 */
	// Check to close popup or not
	// "target" is an element that was clicked
	_checkIfClose: function(target) {

		if($(target).hasClass(PREVENT_CLOSE_CLASS)) {
			return;
		}

		var closeOnContent = sldr.st.closeOnContentClick;
		var closeOnBg = sldr.st.closeOnBgClick;

		if(closeOnContent && closeOnBg) {
			return true;
		} else {

			// We close the popup if click is on close button or on preloader. Or if there is no content.
			if(!sldr.content || $(target).hasClass('sldr-close') || (sldr.preloader && target === sldr.preloader[0]) ) {
				return true;
			}

			// if click is outside the content
			if(  (target !== sldr.content[0] && !$.contains(sldr.content[0], target))  ) {
				if(closeOnBg) {
					// last check, if the clicked element is in DOM, (in case it's removed onclick)
					if( $.contains(document, target) ) {
						return true;
					}
				}
			} else if(closeOnContent) {
				return true;
			}

		}
		return false;
	},
	_addClassTosldr: function(cName) {
		sldr.bgOverlay.addClass(cName);
		sldr.wrap.addClass(cName);
	},
	_removeClassFromsldr: function(cName) {
		this.bgOverlay.removeClass(cName);
		sldr.wrap.removeClass(cName);
	},
	_hasScrollBar: function(winHeight) {
		return (  (sldr.isIE7 ? _document.height() : document.body.scrollHeight) > (winHeight || _window.height()) );
	},
	_setFocus: function() {
		(sldr.st.focus ? sldr.content.find(sldr.st.focus).eq(0) : sldr.wrap).focus();
	},
	_onFocusIn: function(e) {
		if( e.target !== sldr.wrap[0] && !$.contains(sldr.wrap[0], e.target) ) {
			sldr._setFocus();
			return false;
		}
	},
	_parseMarkup: function(template, values, item) {
		var arr;

		if(item.data) {
			values = $.extend(item.data, values);
		}
		_sldrTrigger(MARKUP_PARSE_EVENT, [template, values, item] );

		$.each(values, function(key, value) {
			if(value === undefined || value === false) {
				return true;
			}

			arr = key.split('_');

			if(arr.length > 1) {
				var el = template.find(EVENT_NS + '-'+arr[0]);

				if(el.length > 0) {
					var attr = arr[1];
					if(attr === 'replaceWith') {
						if(el[0] !== value[0]) {
							el.replaceWith(value);
						}
					} else if(attr === 'img') {
						if(el.is('img')) {
							el.attr('src', value);
						} else {
							el.replaceWith( '<img src="'+value+'" class="' + el.attr('class') + '" />' );
						}
					} else {
						el.attr(arr[1], value);
					}
				}
			} else {
				template.find(EVENT_NS + '-'+key).html(value);
			}
		});

	},

	_getScrollbarSize: function() {
		// thx David
		if(sldr.scrollbarSize === undefined) {
			var scrollDiv = document.createElement("div");
			scrollDiv.style.cssText = 'width: 99px; height: 99px; overflow: scroll; position: absolute; top: -9999px;';
			document.body.appendChild(scrollDiv);
			sldr.scrollbarSize = scrollDiv.offsetWidth - scrollDiv.clientWidth;
			document.body.removeChild(scrollDiv);
		}
		return sldr.scrollbarSize;
	}

}; /* ModalSlider core prototype end */




/**
 * Public static functions
 */
$.modalSlider = {
	instance: null,
	proto: ModalSlider.prototype,
	modules: [],

	open: function(options, index) {
		_checkInstance();	

		if(!options) {
			options = {};
		} else {
			options = $.extend(true, {}, options);
		}
			

		options.isObj = true;
		options.index = index || 0;
		return this.instance.open(options);
	},

	close: function() {
		return $.modalSlider.instance && $.modalSlider.instance.close();
	},

	registerModule: function(name, module) {
		if(module.options) {
			$.modalSlider.defaults[name] = module.options;
		}
		$.extend(this.proto, module.proto);			
		this.modules.push(name);
	},

	defaults: {   

		// Info about options is in docs:
		// http://dimsemenov.com/plugins/modal-slider/documentation.html#options
		
		disableOn: 0,	

		key: null,

		midClick: false,

		mainClass: '',

		preloader: false,

		focus: '', // CSS selector of input to focus after popup is opened
		
		closeOnContentClick: false,

		closeOnBgClick: true,

		closeBtnInside: true, 

		showCloseBtn: true,

		enableEscapeKey: true,

		modal: false,

		alignTop: false,
	
		removalDelay: 0,

		prependTo: null,
		
		fixedContentPos: 'auto', 
	
		fixedBgPos: 'auto',

		overflowY: 'auto',

		closeMarkup: '<button title="%title%" type="button" class="sldr-close">&times;</button>',

		tClose: 'Close (Esc)',

		tLoading: 'Loading...'

	}
};



$.fn.modalSlider = function(options) {
	_checkInstance();

	var jqEl = $(this);

	// We call some API method of first param is a string
	if (typeof options === "string" ) {

		if(options === 'open') {
			var items,
				itemOpts = _isJQ ? jqEl.data('modalSlider') : jqEl[0].modalSlider,
				index = parseInt(arguments[1], 10) || 0;

			if(itemOpts.items) {
				items = itemOpts.items[index];
			} else {
				items = jqEl;
				if(itemOpts.delegate) {
					items = items.find(itemOpts.delegate);
				}
				items = items.eq( index );
			}
			sldr._openClick({sldrEl:items}, jqEl, itemOpts);
		} else {
			if(sldr.isOpen)
				sldr[options].apply(sldr, Array.prototype.slice.call(arguments, 1));
		}

	} else {
		// clone options obj
		options = $.extend(true, {}, options);

		if(_isJQ) {
			jqEl.data('modalSlider', options);
		} else {
			jqEl[0].modalSlider = options;
		}

		sldr.addGroup(jqEl ,options);

	}
	return jqEl;
};


/*>>image*/
var _imgInterval,
	_getTitle = function(item) {
		if(item.data && item.data.title !== undefined) 
			return item.data.title;

		var src = sldr.st.image.titleSrc;

		if(src) {
			if($.isFunction(src)) {
				return src.call(sldr, item);
			} else if(item.el) {
				return item.el.attr(src) || '';
			}
		}
		return '';
	};

$.modalSlider.registerModule('image', {

	options: {
		markup: '<div class="sldr-figure">'+
					'<div class="sldr-close"></div>'+
					'<figure>'+
						'<div class="sldr-img"></div>'+
					'</figure>'+
					'<figcaption class="sldr-media-caption text-center">'+
						'<div class="sldr-bottom-bar sldr-caption-viewport row-space-4">'+
							'<div class="sldr-caption-container page-container-responsive collapsed">'+
								'<div class="row">'+
                	'<div class="col-lg-9  text-left">'+
                		'<span class="sldr-counter sldr-caption"></span> : '+
										'<span class="sldr-title sldr-caption"></span>'+
									'</div>'+
									'<div class="col-lg-3 text-right sldr-caption">写真リストを見る<i class="fa fa-caret-down"></i></div>'+
								'</div>'+
								'<div class="sldr-thumb-viewport row-space-top-2">' +
									'<ul class="sldr-thumbitem sldr-thumbnails sldr-thumb-slide-panel">'+
									'</ul>'+
								'</div>'+
							'</div>'+
						'</div>'+
					'</figcaption>'+
				'</div>',
		cursor: 'sldr-zoom-out-cur',
		titleSrc: 'title', 
		verticalFit: true,
		tError: '<a href="%url%">The image</a> could not be loaded.'
	},

	proto: {
		initImage: function() {
			var imgSt = sldr.st.image,
				ns = '.image';

			sldr.types.push('image');

			_sldrOn(OPEN_EVENT+ns, function() {
				if(sldr.currItem.type === 'image' && imgSt.cursor) {
					$(document.body).addClass(imgSt.cursor);
				}
			});

			_sldrOn(CLOSE_EVENT+ns, function() {
				if(imgSt.cursor) {
					$(document.body).removeClass(imgSt.cursor);
				}
				_window.off('resize' + EVENT_NS);
			});

			_sldrOn('Resize'+ns, sldr.resizeImage);
			if(sldr.isLowIE) {
				_sldrOn('AfterChange', sldr.resizeImage);
			}
		},
		resizeImage: function() {
			var item = sldr.currItem;
			if(!item || !item.img) return;

			if(sldr.st.image.verticalFit) {
				var decr = 0;
				// fix box-sizing in ie7/8
				if(sldr.isLowIE) {
					decr = parseInt(item.img.css('padding-top'), 10) + parseInt(item.img.css('padding-bottom'),10);
				}
				item.img.css('max-height', sldr.wH-decr);
			}
		},
		_onImageHasSize: function(item) {
			if(item.img) {
				
				item.hasSize = true;

				if(_imgInterval) {
					clearInterval(_imgInterval);
				}
				
				item.isCheckingImgSize = false;

				_sldrTrigger('ImageHasSize', item);

				if(item.imgHidden) {
					if(sldr.content)
						sldr.content.removeClass('sldr-loading');
					
					item.imgHidden = false;
				}

			}
		},

		/**
		 * Function that loops until the image has size to display elements that rely on it asap
		 */
		findImageSize: function(item) {

			var counter = 0,
				img = item.img[0],
				sldrSetInterval = function(delay) {

					if(_imgInterval) {
						clearInterval(_imgInterval);
					}
					// decelerating interval that checks for size of an image
					_imgInterval = setInterval(function() {
						if(img.naturalWidth > 0) {
							sldr._onImageHasSize(item);
							return;
						}

						if(counter > 200) {
							clearInterval(_imgInterval);
						}

						counter++;
						if(counter === 3) {
							sldrSetInterval(10);
						} else if(counter === 40) {
							sldrSetInterval(50);
						} else if(counter === 100) {
							sldrSetInterval(500);
						}
					}, delay);
				};

			sldrSetInterval(1);
		},

		getImage: function(item, template) {

			var guard = 0,

				// image load complete handler
				onLoadComplete = function() {
					if(item) {
						if (item.img[0].complete) {
							item.img.off('.sldrloader');
							
							if(item === sldr.currItem){
								sldr._onImageHasSize(item);

								sldr.updateStatus('ready');
							}

							item.hasSize = true;
							item.loaded = true;

							_sldrTrigger('ImageLoadComplete');
							
						}
						else {
							// if image complete check fails 200 times (20 sec), we assume that there was an error.
							guard++;
							if(guard < 200) {
								setTimeout(onLoadComplete,100);
							} else {
								onLoadError();
							}
						}
					}
				},

				// image error handler
				onLoadError = function() {
					if(item) {
						item.img.off('.sldrloader');
						if(item === sldr.currItem){
							sldr._onImageHasSize(item);
							sldr.updateStatus('error', imgSt.tError.replace('%url%', item.src) );
						}

						item.hasSize = true;
						item.loaded = true;
						item.loadError = true;
					}
				},
				imgSt = sldr.st.image;


			var el = template.find('.sldr-img');
			if(el.length) {
				var img = document.createElement('img');
				img.className = 'sldr-img';
				if(item.el && item.el.find('img').length) {
					img.alt = item.el.find('img').attr('alt');
				}
				item.img = $(img).on('load.sldrloader', onLoadComplete).on('error.sldrloader', onLoadError);
				img.src = item.src;

				// without clone() "error" event is not firing when IMG is replaced by new IMG
				// TODO: find a way to avoid such cloning
				if(el.is('img')) {
					item.img = item.img.clone();
				}

				img = item.img[0];
				if(img.naturalWidth > 0) {
					item.hasSize = true;
				} else if(!img.width) {										
					item.hasSize = false;
				}
			}

			sldr._parseMarkup(template, {
				title: _getTitle(item),
				img_replaceWith: item.img
			}, item);

			sldr.resizeImage();

			if(item.hasSize) {
				if(_imgInterval) clearInterval(_imgInterval);

				if(item.loadError) {
					template.addClass('sldr-loading');
					sldr.updateStatus('error', imgSt.tError.replace('%url%', item.src) );
				} else {
					template.removeClass('sldr-loading');
					sldr.updateStatus('ready');
				}
				return template;
			}

			sldr.updateStatus('loading');
			item.loading = true;

			if(!item.hasSize) {
				item.imgHidden = true;
				template.addClass('sldr-loading');
				sldr.findImageSize(item);
			} 

			return template;
		}
	}
});


/*>>gallery*/
/**
 * Get looped index depending on number of slides
 */
var _getLoopedId = function(index) {
		var numSlides = sldr.items.length;
		if(index > numSlides - 1) {
			return index - numSlides;
		} else  if(index < 0) {
			return numSlides + index;
		}
		return index;
	},
	_replaceCurrTotal = function(text, curr, total) {
		return text.replace(/%curr%/gi, curr + 1).replace(/%total%/gi, total);
	};

$.modalSlider.registerModule('gallery', {

	options: {
		enabled: false,
		arrowMarkup: '<button title="%title%" type="button" class="sldr-arrow sldr-arrow-%dir% fa fa-angle-%dir%"></button>',
		gotoliMarkup: '<li class="thumb_li%thumb_num%"><img id="thumb_%thumb_num2%" src="%thumb_val%" ></li>',
		preload: [0,2],
		navigateByImgClick: true,
		arrows: true,

		tPrev: 'Previous (Left arrow key)',
		tNext: 'Next (Right arrow key)',
		tCounter: '%curr% of %total%'
	},

	proto: {
		initGallery: function() {
			var gSt = sldr.st.gallery,
				ns = '.sldr-gallery',
				supportsFastClick = Boolean($.fn.sldrFastClick);

			sldr.direction = true; // true - next, false - prev
			
			if(!gSt || !gSt.enabled ) return false;

			_wrapClasses += ' sldr-gallery';

			_sldrOn(OPEN_EVENT+ns, function() {

				if(gSt.navigateByImgClick) {
					sldr.wrap.on('click'+ns, '.sldr-img', function() {
						if(sldr.items.length > 1) {
							thumbindex = sldr.index + 1
							$('.sldr-thumbitem').find('.active').removeClass('active');
							$('.sldr-thumbitem').find('.thumb_li'+thumbindex).addClass('active');
							sldr.next();
							return false;
						}
					});
				}

				$('figcaption').hover(function() {
				    sldr.showthumb();
				  }, function() {
				    sldr.showthumb();
				  });

				//class'active' to thumblist
				$('.sldr-thumbitem li').on('click', function () {
						$(this).parent('.sldr-thumbitem').find('.active').removeClass('active');
						$(this).addClass('active');
				});
				$('.sldr-arrow').on('click', function () {
						$('.sldr-thumbitem').find('.active').removeClass('active');
						$('.sldr-thumbitem').find('.thumb_li'+sldr.index).addClass('active');
				});

				_document.on('keydown'+ns, function(e) {
					if (e.keyCode === 37) {
						sldr.prev();
					} else if (e.keyCode === 39) {
						sldr.next();
					}
				});

			});

			_sldrOn('UpdateStatus'+ns, function(e, data) {
				if(data.text) {
					data.text = _replaceCurrTotal(data.text, sldr.currItem.index, sldr.items.length);
				}
			});

			_sldrOn(MARKUP_PARSE_EVENT+ns, function(e, element, values, item) {
				var l = sldr.items.length;
				values.counter = l > 1 ? _replaceCurrTotal(gSt.tCounter, item.index, l) : '';				
			});

			_sldrOn('BuildControls' + ns, function() {
				if(sldr.items.length > 1 && gSt.arrows && !sldr.arrowLeft) {
					//arrowRight & arrowLeft
					var markup = gSt.arrowMarkup,
						arrowLeft = sldr.arrowLeft = $( markup.replace(/%title%/gi, gSt.tPrev).replace(/%dir%/gi, 'left') ).addClass(PREVENT_CLOSE_CLASS),			
						arrowRight = sldr.arrowRight = $( markup.replace(/%add_li%/gi, gSt.tNext).replace(/%dir%/gi, 'right') ).addClass(PREVENT_CLOSE_CLASS);

					var eName = supportsFastClick ? 'sldrFastClick' : 'click';
					arrowLeft[eName](function() {
						sldr.prev();
					});			
					arrowRight[eName](function() {
						sldr.next();
					});	

					//Thumbnail Click
					var gotoliMarkup = gSt.gotoliMarkup;
					var i = 0;
					var thumbsGoTo = [];
					$.each(thumbsArry, function(key, value) {
						if (i == 0){
							thumbsGoTo[i] = $('<li class="thumb_li'+i+' active"><img id="thumb_'+i+'" src="'+ $(value).attr('href') +'" ></li>');
						} else {
							thumbsGoTo[i] = $('<li class="thumb_li'+i+'"><img id="thumb_'+i+'" src="'+ $(value).attr('href') +'" ></li>');
						}
						sldr.content.find('.sldr-thumbitem').append(thumbsGoTo[i]);
						i++;
					});

					$.each(thumbsGoTo, function(i) {
						thumbsGoTo[i][eName](function() {
							sldr.goTo(i);
						});	
					});
						

					// Polyfill for :before and :after (adds elements with classes sldr-a and sldr-b)
					if(sldr.isIE7) {
						_getEl('b', arrowLeft[0], false, true);
						_getEl('a', arrowLeft[0], false, true);
						_getEl('b', arrowRight[0], false, true);
						_getEl('a', arrowRight[0], false, true);
					}

					sldr.content.find('figure').append(arrowLeft.add(arrowRight));

				}
			});

			_sldrOn(CHANGE_EVENT+ns, function() {
				if(sldr._preloadTimeout) clearTimeout(sldr._preloadTimeout);

				sldr._preloadTimeout = setTimeout(function() {
					sldr.preloadNearbyImages();
					sldr._preloadTimeout = null;
				}, 16);		
			});


			_sldrOn(CLOSE_EVENT+ns, function() {
				_document.off(ns);
				sldr.wrap.off('click'+ns);
			
				if(sldr.arrowLeft && supportsFastClick) {
					sldr.arrowLeft.add(sldr.arrowRight).destroysldrFastClick();
				}
				sldr.arrowRight = sldr.arrowLeft = null;
			});

		}, 
		next: function() {
			sldr.direction = true;
			sldr.index = _getLoopedId(sldr.index + 1);
			sldr.updateItemHTML();
		},
		prev: function() {
			sldr.direction = false;
			sldr.index = _getLoopedId(sldr.index - 1);
			sldr.updateItemHTML();
		},
		goTo: function(newIndex) {
			sldr.direction = (newIndex >= sldr.index);
			sldr.index = newIndex;
			sldr.updateItemHTML();
		},
		showthumb: function() {
			var showel = $('figcaption.sldr-media-caption').find('.sldr-caption-container');
			
			if( showel.hasClass('collapsed') ){
				showel.removeClass('collapsed');
			} else {
				showel.addClass('collapsed');
			}
		},
		preloadNearbyImages: function() {
			var p = sldr.st.gallery.preload,
				preloadBefore = Math.min(p[0], sldr.items.length),
				preloadAfter = Math.min(p[1], sldr.items.length),
				i;
			for(i = 1; i <= (sldr.direction ? preloadAfter : preloadBefore); i++) {
				sldr._preloadItem(sldr.index+i);
			}
			for(i = 1; i <= (sldr.direction ? preloadBefore : preloadAfter); i++) {
				sldr._preloadItem(sldr.index-i);
			}
		},
		_preloadItem: function(index) {
			index = _getLoopedId(index);

			if(sldr.items[index].preloaded) {
				return;
			}

			var item = sldr.items[index];
			if(!item.parsed) {
				item = sldr.parseEl( index );
			}

			_sldrTrigger('LazyLoad', item);

			if(item.type === 'image') {
				item.img = $('<img class="sldr-img" />').on('load.sldrloader', function() {
					item.hasSize = true;
				}).on('error.sldrloader', function() {
					item.hasSize = true;
					item.loadError = true;
					_sldrTrigger('LazyLoadError', item);
				}).attr('src', item.src);
			}


			item.preloaded = true;
		}
	}
});


(function() {
	var ghostClickDelay = 1000,
		supportsTouch = 'ontouchstart' in window,
		unbindTouchMove = function() {
			_window.off('touchmove'+ns+' touchend'+ns);
		},
		eName = 'sldrFastClick',
		ns = '.'+eName;


	$.fn.sldrFastClick = function(callback) {

		return $(this).each(function() {

			var elem = $(this),
				lock;

			if( supportsTouch ) {

				var timeout,
					startX,
					startY,
					pointerMoved,
					point,
					numPointers;

				elem.on('touchstart' + ns, function(e) {
					pointerMoved = false;
					numPointers = 1;

					point = e.originalEvent ? e.originalEvent.touches[0] : e.touches[0];
					startX = point.clientX;
					startY = point.clientY;

					_window.on('touchmove'+ns, function(e) {
						point = e.originalEvent ? e.originalEvent.touches : e.touches;
						numPointers = point.length;
						point = point[0];
						if (Math.abs(point.clientX - startX) > 10 ||
							Math.abs(point.clientY - startY) > 10) {
							pointerMoved = true;
							unbindTouchMove();
						}
					}).on('touchend'+ns, function(e) {
						unbindTouchMove();
						if(pointerMoved || numPointers > 1) {
							return;
						}
						lock = true;
						e.preventDefault();
						clearTimeout(timeout);
						timeout = setTimeout(function() {
							lock = false;
						}, ghostClickDelay);
						callback();
					});
				});

			}

			elem.on('click' + ns, function() {
				if(!lock) {
					callback();
				}
			});
		});
	};

	$.fn.destroysldrFastClick = function() {
		$(this).off('touchstart' + ns + ' click' + ns);
		if(supportsTouch) _window.off('touchmove'+ns+' touchend'+ns);
	};
})();

/*>>fastclick*/
 _checkInstance(); }));