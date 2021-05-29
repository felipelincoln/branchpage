import "../css/base.css"

import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"
import Prism from "prismjs"

let Hooks = {}
Hooks.CodeHighlight = {
  mounted(){
    this.handleEvent("highlightAll", () => Prism.highlightAll());
  }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {_csrf_token: csrfToken}})

liveSocket.connect()

window.liveSocket = liveSocket
