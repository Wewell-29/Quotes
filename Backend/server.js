const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const quoteRoutes = require('./routes/quoteRoutes');

const app = express();
app.use(cors());
app.use(bodyParser.json());

mongoose
  .connect('mongodb://localhost:27017/quotesApp', {
    useNewUrlParser: true,
    useUnifiedTopology: true
  })
  .then(() => console.log('MongoDB connected'));

app.use('/api/quotes', quoteRoutes);

app.listen(3000, () => console.log('Backend running: http://localhost:3000'));
