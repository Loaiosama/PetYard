const express =require('express');
const app = express();
//const cors =require('cors');
const morgan = require('morgan');
const pool = require('./db');

app.use(morgan('dev'));


//Middleware 
//app.use(core());
app.use(express.json());


module.exports=app;