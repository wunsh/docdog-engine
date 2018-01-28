import "phoenix_html"
import "phoenix_ujs"

import Elm from "./main";

const elmDiv = document.querySelector("#elmApp");
if (elmDiv) {
    Elm.Main.embed(elmDiv);
}