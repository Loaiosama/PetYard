const express =require('express');
const app = express();
const morgan = require('morgan');
const PetOwnerRoutes = require('./Routes/PetOwner');
const ProviderRoutes = require('./Routes/Provider');

app.use(morgan('dev'));
app.use(express.json());

app.use('/PetOwner',PetOwnerRoutes);
app.use('/Provider',ProviderRoutes);

module.exports=app;