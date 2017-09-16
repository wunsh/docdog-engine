export const TranslatorInputForm = (function(){
    "use strict";

    return {
        confirm: function(form) {
            let customSubmitEvent = new Event("submit");
            Object.defineProperty(customSubmitEvent, "target", { value: form });

            document.dispatchEvent(customSubmitEvent);
        }
    }
})();
