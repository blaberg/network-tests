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
    if (err) {
      res.sendStatus(200);
      return;
    }
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
  time = Date.now();
  log = req.files.log;
  log.mv(
    "./logs/server/baseline/iperf3/logs/" +
      log.name.split(".txt")[0] +
      time +
      ".txt",
    (err) => {
      if (err) {
        res.sendStatus(200);
        return;
      }
    }
  );
  res.sendStatus(200);
});

app.post("/server/baseline/cpu", (req, res) => {
  console.log("CPU server log");
  cpu = req.files.cpu;
  time = Date.now();
  cpu.mv(
    "./logs/server/baseline/cpu/" + cpu.name.split(".csv")[0] + time + ".csv",
    (err) => {
      if (err) {
        res.sendStatus(200);
        return;
      }
    }
  );
  net = req.files.net;
  net.mv(
    "./logs/server/baseline/cpu/" + net.name.split(".csv")[0] + time + ".csv",
    (err) => {
      if (err) {
        res.sendStatus(500);
        return;
      }
    }
  );
  res.sendStatus(200);
});

app.post("/server/baseline/sockperf", (req, res) => {
  console.log("Sockperf server baseline log");
  csv = req.files.csv;
  time = Date.now();
  csv.mv(
    "./logs/server/baseline/sockperf/" +
      csv.name.split(".csv")[0] +
      time +
      ".csv",
    (err) => {
      if (err) {
        res.sendStatus(500);
        return;
      }
    }
  );
  res.sendStatus(200);
});

app.post("/server/macsec/iperf3", (req, res) => {
  console.log("Iperf3 server log");
  time = Date.now();
  log = req.files.log;
  log.mv(
    "./logs/server/macsec/iperf3/logs/" +
      log.name.split(".txt")[0] +
      time +
      ".txt",
    (err) => {
      if (err) {
        res.sendStatus(200);
        return;
      }
    }
  );
  res.sendStatus(200);
});

app.post("/server/macsec/sockperf", (req, res) => {
  console.log("Sockperf server MACsec log");
  csv = req.files.csv;
  time = Date.now();
  csv.mv(
    "./logs/server/macsec/sockperf/" +
      csv.name.split(".csv")[0] +
      time +
      ".csv",
    (err) => {
      if (err) {
        res.sendStatus(200);
        return;
      }
    }
  );
  res.sendStatus(200);
});

app.post("/server/macsec/cpu", (req, res) => {
  console.log("CPU server log");
  cpu = req.files.cpu;
  time = Date.now();
  cpu.mv(
    "./logs/server/macsec/cpu/" + cpu.name.split(".csv")[0] + time + ".csv",
    (err) => {
      if (err) {
        res.sendStatus(200);
        return;
      }
    }
  );
  net = req.files.net;
  net.mv(
    "./logs/server/macsec/cpu/" + net.name.split(".csv")[0] + time + ".csv",
    (err) => {
      if (err) {
        res.sendStatus(500);
        return;
      }
    }
  );
  res.sendStatus(200);
});

app.post("/server/ipsec/iperf3", (req, res) => {
  console.log("Iperf3 server log");
  time = Date.now();
  log = req.files.log;
  log.mv(
    "./logs/server/ipsec/iperf3/logs/" +
      log.name.split(".txt")[0] +
      time +
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

app.post("/server/ipsec/sockperf", (req, res) => {
  console.log("Sockperf server IPsec log");
  csv = req.files.csv;
  time = Date.now();
  csv.mv(
    "./logs/server/ipsec/sockperf/" + csv.name.split(".csv")[0] + time + ".csv",
    (err) => {
      if (err) {
        res.sendStatus(200);
        return;
      }
    }
  );
  res.sendStatus(200);
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});

app.post("/server/ipsec/cpu", (req, res) => {
  console.log("CPU server log");
  cpu = req.files.cpu;
  time = Date.now();
  cpu.mv(
    "./logs/server/ipsec/cpu/" + cpu.name.split(".csv")[0] + time + ".csv",
    (err) => {
      if (err) {
        res.sendStatus(200);
        return;
      }
    }
  );
  net = req.files.net;
  net.mv(
    "./logs/server/ipsec/cpu/" + net.name.split(".csv")[0] + time + ".csv",
    (err) => {
      if (err) {
        res.sendStatus(500);
        return;
      }
    }
  );
  res.sendStatus(200);
});
