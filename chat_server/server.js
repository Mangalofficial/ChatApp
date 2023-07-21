const express = require("express");
const { createServer } = require("http");
const { Server } = require("socket.io");

const app = express();
const httpServer = createServer(app);
const io = new Server(httpServer);

app.route("/").get((req,res,) => {
res.json("Welcome to channel")
})

io.on("connection", (Socket) =>{
  Socket.join("Chat Group");
  console.log("backend Connected");
  Socket.on ("sendMsg", (msg) => {
console.log("msg",msg);
io.to("Chat Group").emit("sendMsgServer",{...msg, type:"otherMsg"});
  });
});

httpServer.listen(3000);