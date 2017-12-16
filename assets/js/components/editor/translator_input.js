import { TranslatorInputForm } from "./translator_input_form";

export const TranslatorInput = (function(){
    "use strict";

    var els = document.getElementsByClassName("translate_line__input");

    const CHROME_ENTER_KEY_CODE = 10;
    const ENTER_KEY_CODE = 13;
    const ESCAPE_KEY_CODE = 27;

    return {
        init: function() {
            console.log("10");
            this.event();
        },

        event: function() {
            let self = this;

            for (var i = 0; i < els.length; i++) {
                let el = els[i];
                let form = el.closest(".translate_line__form");

                el.onfocus = function() {
                    this.classList.add("translate_input--active")
                };

                el.onblur = function() {
                    this.classList.remove("translate_input--active")
                    let initialDigest = this.getAttribute("data-translated-text-digest")
                    let currentDigest =  new md5().update(this.value).digest('hex')

                    if (initialDigest != currentDigest) {
                        this.classList.add("translate_input--changed")
                    } else {
                        this.classList.remove("translate_input--changed")
                    }
                };

                el.onkeydown = self._handleTyping(form);

                window.onbeforeunload = function (evt) {
                    if (document.getElementsByClassName("translate_input--changed").length == 0) {
                        return
                    }

                    let message = "";

                    if (typeof evt == "undefined") {
                        evt = window.event;
                    }
                    if (evt) {
                        evt.returnValue = message;
                    }
                    return message;
                }


            }
        },

        _cancel: function() { alert("cancel") },

        _handleTyping: function(form) {
            let handler = function(e) {
                let inputs = document.getElementsByClassName("translate_input");
                if (e.keyCode == ESCAPE_KEY_CODE) {
                    self._cancel();
                    return false;
                }

                if ((e.ctrlKey || e.metaKey) && (e.keyCode == ENTER_KEY_CODE || e.keyCode == CHROME_ENTER_KEY_CODE)) {
                    let initialDigest = this.getAttribute("data-translated-text-digest")
                    let currentDigest =  new md5().update(this.value).digest('hex')

                    if (initialDigest == currentDigest) {
                        this.classList.remove("translate_input--changed")
                        this.classList.remove("translate_input--confirmed")

                        let nextElementIndex = Array.prototype.indexOf.call(inputs, this ) + 1;
                        let nextElement = inputs[nextElementIndex];

                        if (typeof nextElement == "undefined") {
                            this.blur();
                        } else {
                            nextElement.selectionStart = nextElement.selectionEnd = 10000;
                            nextElement.focus()
                        }

                        return false;
                    }


                    TranslatorInputForm.confirm(form);
                    this.classList.add("translate_input--confirmed")
                    let newDigest =  new md5().update(this.value).digest('hex')
                    this.setAttribute("data-translated-text-digest", newDigest)

                    let foo = this

                    setInterval(function() {
                        foo.classList.remove("translate_input--changed")
                        foo.classList.remove("translate_input--confirmed")
                    }, 5000);

                    this.dispatchEvent(new KeyboardEvent('keypress',{'key':'Tab'}));

                    let nextElementIndex = Array.prototype.indexOf.call(inputs, this ) + 1;


                    let nextElement = inputs[nextElementIndex];

                    if (typeof nextElement == "undefined") {
                        this.blur();
                    } else {
                        nextElement.selectionStart = nextElement.selectionEnd = 10000;
                        nextElement.focus()
                    }

                    return false;
                }


            };

            return handler;
        }
    }
})();