import "phoenix_html"
import "phoenix_ujs"

import Elm from "./main";

const elmDiv = document.querySelector("#elmApp");
if (elmDiv) {
    Elm.Main.embed(elmDiv);
}

let el = document.getElementById("signInGithub")
if (el) {
	el.addEventListener("click", () => { yaCounter47642428.reachGoal("SIGN_IN-GITHUB"); }, false)
}

el = document.getElementById("projectForm")
if (el) {
	el.addEventListener("submit", () => { yaCounter47642428.reachGoal("ADD_NEW-PROJECT"); }, false)
}

el = document.getElementById("documentForm")
if (el) {
	el.addEventListener("submit", () => { yaCounter47642428.reachGoal("ADD_NEW-DOCUMENT"); }, false)	
}

