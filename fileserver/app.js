const express = require("express");
const fs = require("fs");
const app = express();
const port = 3000;

var bodyParser = require("body-parser");
app.use(bodyParser.json());

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

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
