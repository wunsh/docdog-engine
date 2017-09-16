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
                let defaultStyle = el.style;

                el.onfocus = function() {
                  this.style.border = "1px green solid";
                };

                el.onblur = function() {
                  this.style = defaultStyle;
                };

                el.onkeydown = self._handleTyping(form);
            }
        },

        _cancel: function() { alert("cancel") },

        _handleTyping: function(form) {
            let handler = function(e) {
                console.log("FO3");

                if (e.keyCode == ESCAPE_KEY_CODE) {
                    self._cancel();
                    return false;
                }

                if ((e.ctrlKey || e.metaKey) && (e.keyCode == ENTER_KEY_CODE || e.keyCode == CHROME_ENTER_KEY_CODE)) {
                    TranslatorInputForm.confirm(form);
                    return false;
                }
            };

            return handler;
        }
    }
})();