/* ============================================================
 * Copyright 2011 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ============================================================ */

/* ============================================================
* bootstrap-dropdown.js v2.0.0
* http://twitter.github.com/bootstrap/javascript.html#dropdown
* ============================================================ */

!function( $ ){

 "use strict"

/* DROPDOWN CLASS DEFINITION
 * ========================= */

 var toggle = '[data-toggle="dropdown"]'
   , Dropdown = function ( element ) {
       $(element).bind('click', this.toggle)
     }

 Dropdown.prototype = {

   constructor: Dropdown

 , toggle: function ( e ) {
     var $this = $(this)
       , selector = $this.attr('data-target') || $this.attr('href')
       , $parent = $(selector)
       , isActive

     $parent.length || ($parent = $this.parent())
     isActive = $parent.hasClass('open')

     clearMenus()

     !isActive && $parent.toggleClass('open')

     return false
   }

 }

 function clearMenus() {
   $(toggle).parent().removeClass('open')
 }


 /* DROPDOWN PLUGIN DEFINITION
  * ========================== */

 $.fn.dropdown = function ( option ) {
   return this.each(function () {
     var $this = $(this)
       , data = $this.data('dropdown')
     if (!data) $this.data('dropdown', (data = new Dropdown(this)))
     if (typeof option == 'string') data[option].call($this)
   })
 }

 $.fn.dropdown.Constructor = Dropdown


 /* APPLY TO STANDARD DROPDOWN ELEMENTS
  * =================================== */

 $(function () {
   $(window).on('click.dropdown.data-api', clearMenus)
   $('body').on('click.dropdown.data-api', toggle, Dropdown.prototype.toggle)
 })

}( window.jQuery )

/* ============================================================
* bootstrap-buttons.js v2.0.0
* http://twitter.github.com/bootstrap/javascript.html#buttons
* ============================================================ */

!function( $ ){

 "use strict"

/* BUTTON PUBLIC CLASS DEFINITION
 * ============================== */

 var Button = function ( element, options ) {
   this.$element = $(element)
   this.options = $.extend({}, $.fn.button.defaults, options)
 }

 Button.prototype = {

     constructor: Button

   , setState: function ( state ) {
       var d = 'disabled'
         , $el = this.$element
         , data = $el.data()
         , val = $el.is('input') ? 'val' : 'html'

       state = state + 'Text'
       data.resetText || $el.data('resetText', $el[val]())

       $el[val](data[state] || this.options[state])

       // push to event loop to allow forms to submit
       setTimeout(function () {
         state == 'loadingText' ?
           $el.addClass(d).attr(d, d) :
           $el.removeClass(d).removeAttr(d)
       }, 0)
     }

   , toggle: function () {
       var $parent = this.$element.parent('[data-toggle="buttons-radio"]')

       $parent && $parent
         .find('.active')
         .removeClass('active')

       this.$element.toggleClass('active')
     }

 }


/* BUTTON PLUGIN DEFINITION
 * ======================== */

 $.fn.button = function ( option ) {
   return this.each(function () {
     var $this = $(this)
       , data = $this.data('button')
       , options = typeof option == 'object' && option
     if (!data) $this.data('button', (data = new Button(this, options)))
     if (option == 'toggle') data.toggle()
     else if (option) data.setState(option)
   })
 }

 $.fn.button.defaults = {
   loadingText: 'loading...'
 }

 $.fn.button.Constructor = Button


/* BUTTON DATA-API
 * =============== */

 $(function () {
   $('body').on('click.button.data-api', '[data-toggle^=button]', function ( e ) {
     $(e.target).button('toggle')
   })
 })

}( window.jQuery )

/* ==========================================================
* bootstrap-alert.js v2.0.0
* http://twitter.github.com/bootstrap/javascript.html#alerts
* ========================================================== */


!function( $ ){

 "use strict"

/* ALERT CLASS DEFINITION
 * ====================== */

 var dismiss = '[data-dismiss="alert"]'
   , Alert = function ( el ) {
       $(el).on('click', dismiss, this.close)
     }

 Alert.prototype = {

   constructor: Alert

 , close: function ( e ) {
     var $this = $(this)
       , selector = $this.attr('data-target') || $this.attr('href')
       , $parent = $(selector)

     $parent.trigger('close')

     e && e.preventDefault()

     $parent.length || ($parent = $this.hasClass('alert-message') ? $this : $this.parent())

     $parent.removeClass('in')

     function removeElement() {
       $parent.remove()

       $parent.trigger('closed')
     }

     $.support.transition && $parent.hasClass('fade') ?
       $parent.on($.support.transition.end, removeElement) :
       removeElement()
   }

 }


/* ALERT PLUGIN DEFINITION
 * ======================= */

 $.fn.alert = function ( option ) {
   return this.each(function () {
     var $this = $(this)
       , data = $this.data('alert')
     if (!data) $this.data('alert', (data = new Alert(this)))
     if (typeof option == 'string') data[option].call($this)
   })
 }

 $.fn.alert.Constructor = Alert


/* ALERT DATA-API
 * ============== */

 $(function () {
   $('body').on('click.alert.data-api', dismiss, Alert.prototype.close)
 })

}( window.jQuery )