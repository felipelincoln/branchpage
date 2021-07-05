import "../css/base.css"

import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"
import Prism from "prismjs"

let scrollAt = () => {
  let scrollTop = document.documentElement.scrollTop || document.body.scrollTop
  let scrollHeight = document.documentElement.scrollHeight || document.body.scrollHeight
  let clientHeight = document.documentElement.clientHeight

  return scrollTop / (scrollHeight - clientHeight) * 100
}

let Hooks = {}

Hooks.CodeHighlight = {
  mounted(){
    this.handleEvent("highlightAll", () => Prism.highlightAll());
  }
}

Hooks.PublishButton = {
  mounted(){
    this.handleEvent("scrollTop", () => window.scrollTo(0, 0));
  }
}

Hooks.InfiniteScroll = {
  mounted(){
    window.addEventListener("scroll", e => {
      if(scrollAt() > 99){
        console.log("chamando evento")
        this.pushEvent("load-more", {})
      }
    })
  }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {_csrf_token: csrfToken}})

liveSocket.connect()

window.liveSocket = liveSocket
