const express = require("express");
const fs = require("fs");
const fileUpload = require("express-fileupload");
const app = express();
const port = 3000;

var bodyParser = require("body-parser");
app.use(bodyParser.json());

app.use(
  fileUpload({
    createParentPath: true,
  })
);

const { getSdk } = require("balena-sdk");
const balena = getSdk({
  apiUrl: "https://api.balena-cloud.com/",
  dataDirectory: "/opt/local/balena",
});

app.post("/ipsec", (req, res) => {
  var data = fs.readFileSync("./logs/ipsec.json");
  var logs = JSON.parse(data);
  console.log("Received IPsec log");
  logs.push(req.body);
  var newData = JSON.stringify(logs);
  fs.writeFile("./logs/ipsec.json", newData, (err) => {
    // error checking
    if (err) throw err;
  });
  res.sendStatus(200);
});

app.post("/baseline", (req, res) => {
  var data = fs.readFileSync("./logs/baseline.json");
  var logs = JSON.parse(data);
  console.log("Received Baseline log");
  logs.push(req.body);
  var newData = JSON.stringify(logs);
  fs.writeFile("./logs/baseline.json", newData, (err) => {
    // error checking
    if (err) throw err;
  });
  res.sendStatus(200);
});

app.post("/macsec", (req, res) => {
  var data = fs.readFileSync("./logs/macsec.json");
  var logs = JSON.parse(data);
  console.log("Received MACsec log");
  logs.push(req.body);
  var newData = JSON.stringify(logs);
  fs.writeFile("./logs/macsec.json", newData, (err) => {
    // error checking
    if (err) throw err;
  });
  res.sendStatus(200);
});

app.post("/server/baseline/iperf3", (req, res) => {
  console.log("Iperf3 server log");
  plot = req.files.plot;
  plot.mv(
    "./logs/server/iperf3/plots/" +
      plot.name.split(".png")[0] +
      Date.now() +
      ".png",
    (err) => {
      if (err) {
        res.sendStatus(500);
        return;
      }
    }
  );
  log = req.files.log;
  log.mv(
    "./logs/server/iperf3/logs/" +
      log.name.split(".txt")[0] +
      Date.now() +
      ".txt",
    (err) => {
      if (err) {
        res.sendStatus(500);
        return;
      }
    }
  );
  res.sendStatus(200);
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
