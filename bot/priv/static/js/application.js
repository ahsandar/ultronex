(() => {
  class myWebsocketHandler {
    setupSocket() {
      // this.socket = new WebSocket("ws://localhost:8080/ultronex/ws/slack")
      this.socket = new WebSocket("wss://ultronex.mooo.com/ultronex/ws/slack")

      this.socket.addEventListener("message", (event) => {
        const divTag = document.createElement("div")
        divTag.innerHTML = event.data

        document.getElementById("main").append(divTag)
      })

      this.socket.addEventListener("close", () => {
        this.setupSocket()
      })
    }

  }

  const websocketClass = new myWebsocketHandler()
  websocketClass.setupSocket()
  
})()