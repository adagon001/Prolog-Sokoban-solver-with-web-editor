const http = require('http');
const express = require('express');
const bodyParser = require('body-parser');
const swipl = require('swipl-stdio');
let ejs = require('ejs');
const fs = require('fs');

const app = express();
app.set('view engine', 'ejs');

const server = http.createServer(app);
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static(__dirname));
DB = [{ name: 'Adam', surname: 'Gonsenica' }];
let engine = new swipl.Engine();

postCreateUser = (req, res, next) => {
  fs.readFile('theory.pl', 'utf8', function (err, data) {
    if (err) throw err;
    let newData = data.replace(/\[bg\]/g, req.body.bg);
    newData = newData.replace(/\[gs\]/g, req.body.gs);
    fs.writeFile('temp-theory.pl', newData, 'utf8', function (err) {
      if (err) throw err;
    });
  });
  engine.close();
  engine = new swipl.Engine();
  const solution = [];
  (async () => {
    try {
      const res = await engine.call(`consult('temp-theory.pl').`);
      console.log(res);
    } catch (error) {
      return res.status(400).send(error);
    }
    const result = await engine.call('test(Plan,1)');
    if (result) {
      let route = result.Plan;
      while (route !== '[]') {
        console.log(route.head.name, route.head.args);
        const { name, args } = route.head;
        solution.push({ name, args });
        route = route.tail;
      }
    } else {
      console.log('Call failed.');
      return res.status(400).send('No solution');
    }
    return res.json({
      solution,
    });
    // Either run more queries or stop the engine.
  })().catch((err) => {
    console.log(err);
    return res.status(400).send('Not enough memory');
  });
};

app.get('/', (req, res) => {
  res.render('index', { db: DB });
});
app.post('/', postCreateUser);

server.listen(9000, () => {
  console.log('Listen on port 9000');
});
