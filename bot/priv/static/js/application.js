(() => {
  class myWebsocketHandler {
    setupSocket() {
      this.socket = new WebSocket("wss://ultronex.mooo.com/ultronex/ws/slack")

      this.socket.addEventListener("message", (event) => {
        const pTag = document.createElement("p")
        pTag.innerHTML = event.data

        document.getElementById("main").append(pTag)
      })

      this.socket.addEventListener("close", () => {
        this.setupSocket()
      })
    }

  }

  const websocketClass = new myWebsocketHandler()
  websocketClass.setupSocket()
  
})()